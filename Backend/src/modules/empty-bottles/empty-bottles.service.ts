import { prisma } from '../../config/db';

const getPreviousEmptyBottleLog = async (dpId: string, date: string) => {
  return await prisma.emptyBottleLog.findFirst({
    where: {
      dpId,
      date: { lt: date },
    },
    include: { items: true },
    orderBy: { date: 'desc' },
  });
};

export const getEmptyBottleStatus = async (date: string) => {
  const routes = await prisma.route.findMany({
    orderBy: { name: 'asc' },
  });

  const allocations = await prisma.routeAllocation.findMany({
    where: { date, status: { in: ['ASSIGNED', 'COMPLETED'] } },
    include: { dp: true, items: { include: { inventoryItem: true } } },
  });

  const emptyBottleLogs = await prisma.emptyBottleLog.findMany({
    where: { date },
    include: { items: { include: { inventoryItem: true } } }
  });

  const logMap = new Map(emptyBottleLogs.map(l => [`${l.routeId}_${l.dpId}`, l]));
  const routeMap = new Map(routes.map(r => [r.id, r]));

  const statuses = [];
  const processedRouteIds = new Set<string>();

  // Process all active allocations
  for (const allocation of allocations) {
    const route = routeMap.get(allocation.routeId);
    if (!route) continue;
    
    processedRouteIds.add(route.id);
    const log = logMap.get(`${route.id}_${allocation.dpId}`);

    let previousLog = null;
    if (!log) {
      previousLog = await getPreviousEmptyBottleLog(allocation.dpId, date);
    }

    const itemsStatus = [];
    let expectedEmptyBottles = 0;

    for (const allocItem of allocation.items) {
      const inventoryItem = allocItem.inventoryItem;
      const logItem = log?.items.find(i => i.inventoryItemId === inventoryItem.id);
      const prevLogItem = previousLog?.items.find(i => i.inventoryItemId === inventoryItem.id);

      const carriedOver = logItem?.carriedOver ?? (prevLogItem?.outstanding ?? 0);
      const expected = carriedOver + (allocItem.quantity || 0);

      // Only milk bottles are expected to be returned empty. 
      // The frontend uses "expectedEmptyBottles" for total UI count.
      if (inventoryItem.section === 'Milk' && inventoryItem.material === 'Glass') {
        expectedEmptyBottles += expected;
      }

      itemsStatus.push({
        inventoryItemId: inventoryItem.id,
        name: inventoryItem.name,
        unit: inventoryItem.unit,
        section: inventoryItem.section,
        material: inventoryItem.material,
        
        carriedOver,
        allocated: allocItem.quantity,
        expected,
        
        actualDelivered: logItem?.actualDelivered ?? allocItem.quantity,
        collected: logItem?.collected ?? 0,
        broken: logItem?.broken ?? 0,
        outstanding: logItem?.outstanding ?? 0
      });
    }

    statuses.push({
      routeId: route.id,
      routeName: route.name,
      dpId: allocation.dpId,
      dpName: allocation.dp.name,
      deliveryCompleted: log?.deliveryCompleted || false,
      
      expectedEmptyBottles,
      
      flagIssue: log?.flagIssue || false,
      reason: log?.reason || null,
      notes: log?.notes || null,
      status: log?.deliveryCompleted ? 'Delivered' : 'Pending',

      items: itemsStatus
    });
  }

  // Add unassigned routes
  for (const route of routes) {
    if (!processedRouteIds.has(route.id)) {
      statuses.push({
        routeId: route.id,
        routeName: route.name,
        dpId: null,
        dpName: null,
        deliveryCompleted: false,
        
        expectedEmptyBottles: 0,
        
        flagIssue: false,
        reason: null,
        notes: null,
        status: 'Unassigned',
        items: []
      });
    }
  }

  // Sort by route name, then dp name
  return statuses.sort((a, b) => {
    if (a.routeName === b.routeName) {
      return (a.dpName || '').localeCompare(b.dpName || '');
    }
    return a.routeName.localeCompare(b.routeName);
  });
};

export const updateEmptyBottleLog = async (
  routeId: string,
  dpId: string,
  date: string,
  data: { 
    deliveryCompleted: boolean; 
    flagIssue: boolean;
    reason?: string | null;
    notes?: string | null;
    items: {
      inventoryItemId: string;
      actualDelivered: number;
      collected: number;
      broken: number;
    }[]
  }
) => {
  return await prisma.$transaction(async (tx) => {
    const allocation = await tx.routeAllocation.findUnique({
      where: { routeId_dpId_date: { routeId, dpId, date } },
      include: { items: true }
    });

    if (!allocation) {
      throw new Error('Cannot update empty bottles for an unassigned route/dp.');
    }

    const existingLog = await tx.emptyBottleLog.findUnique({
      where: { routeId_dpId_date: { routeId, dpId, date } },
      include: { items: true }
    });

    let previousLog = null;
    if (!existingLog) {
      previousLog = await tx.emptyBottleLog.findFirst({
        where: { dpId, date: { lt: date } },
        orderBy: { date: 'desc' },
        include: { items: true }
      });
    }

    let logId = existingLog?.id;

    if (existingLog) {
      await tx.emptyBottleLog.update({
        where: { id: existingLog.id },
        data: {
          deliveryCompleted: data.deliveryCompleted,
          flagIssue: data.flagIssue,
          reason: data.reason,
          notes: data.notes,
        },
      });
    } else {
      const newLog = await tx.emptyBottleLog.create({
        data: {
          routeId,
          dpId,
          date,
          deliveryCompleted: data.deliveryCompleted,
          flagIssue: data.flagIssue,
          reason: data.reason,
          notes: data.notes,
        },
      });
      logId = newLog.id;
    }

    for (const inputItem of data.items) {
      const allocItem = allocation.items.find(i => i.inventoryItemId === inputItem.inventoryItemId);
      if (!allocItem) continue;

      let carriedOver = 0;
      if (existingLog) {
        const currentLogItem = existingLog.items.find(i => i.inventoryItemId === inputItem.inventoryItemId);
        carriedOver = currentLogItem?.carriedOver ?? 0;
      } else if (previousLog) {
        const prevLogItem = previousLog.items.find(i => i.inventoryItemId === inputItem.inventoryItemId);
        carriedOver = prevLogItem?.outstanding ?? 0;
      }

      let finalActualDelivered = inputItem.actualDelivered;
      if (!data.deliveryCompleted && data.reason !== 'Partial delivery completed') {
        finalActualDelivered = 0;
      }

      const expected = carriedOver + finalActualDelivered;
      const outstanding = Math.max(0, expected - inputItem.collected - inputItem.broken);

      await tx.emptyBottleLogItem.upsert({
        where: {
          emptyBottleLogId_inventoryItemId: {
            emptyBottleLogId: logId!,
            inventoryItemId: inputItem.inventoryItemId
          }
        },
        update: {
          actualDelivered: finalActualDelivered,
          expected,
          outstanding,
          collected: inputItem.collected,
          broken: inputItem.broken
        },
        create: {
          emptyBottleLogId: logId!,
          inventoryItemId: inputItem.inventoryItemId,
          actualDelivered: finalActualDelivered,
          carriedOver,
          expected,
          outstanding,
          collected: inputItem.collected,
          broken: inputItem.broken
        }
      });
    }

    // Update RouteAllocation status based on deliveryCompleted
    await tx.routeAllocation.update({
      where: { routeId_dpId_date: { routeId, dpId, date } },
      data: { status: data.deliveryCompleted ? 'COMPLETED' : 'ASSIGNED' },
    });

    return { success: true };
  });
};
