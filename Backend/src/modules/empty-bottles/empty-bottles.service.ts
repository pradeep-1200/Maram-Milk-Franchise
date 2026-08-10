import { prisma } from '../../config/db';

export const getEmptyBottleStatus = async (date: string) => {
  const routes = await prisma.route.findMany({
    orderBy: { name: 'asc' },
  });

  const allocations = await prisma.routeAllocation.findMany({
    where: { date, status: { in: ['ASSIGNED', 'COMPLETED'] } },
    include: { dp: true },
  });

  const emptyBottleLogs = await prisma.emptyBottleLog.findMany({
    where: { date },
  });

  const routeBalances = await prisma.routeEmptyBottleBalance.findMany();
  const balanceMap = new Map();
  for (const b of routeBalances) {
    if (!balanceMap.has(b.routeId)) {
      balanceMap.set(b.routeId, { '1L': 0, 'HalfL': 0 });
    }
    balanceMap.get(b.routeId)[b.bottleType] = b.balance;
  }

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
    const balances = balanceMap.get(route.id) || { '1L': 0, 'HalfL': 0 };
    const currentBalance1L = balances['1L'];
    const currentBalanceHalfL = balances['HalfL'];

    const expected1L = Math.max(0, currentBalance1L + (log?.oneLBottlesCollected || 0) + (log?.brokenBottleCount1L || 0));
    const expectedHalfL = Math.max(0, currentBalanceHalfL + (log?.halfLBottlesCollected || 0) + (log?.brokenBottleCountHalfL || 0));
    const expectedPacket = (allocation?.qtyHalfLPacket || 0);

    const expectedEmptyBottles = expected1L + expectedHalfL;

    statuses.push({
      routeId: route.id,
      routeName: route.name,
      dpId: allocation.dpId,
      dpName: allocation.dp.name,
      deliveryCompleted: log?.deliveryCompleted || false,
      
      oneLBottlesCollected: log?.oneLBottlesCollected || 0,
      halfLBottlesCollected: log?.halfLBottlesCollected || 0,
      halfLPacketCollected: log?.halfLPacketCollected || 0,
      
      expected1LBottles: expected1L,
      expectedHalfLBottles: expectedHalfL,
      expectedHalfLPacket: expectedPacket,
      expectedEmptyBottles,
      
      actualDelivered1L: log?.actualDelivered1L ?? (allocation.qty1LBottle || 0),
      actualDeliveredHalfL: log?.actualDeliveredHalfL ?? (allocation.qtyHalfLBottle || 0),
      actualDeliveredPacket: log?.actualDeliveredPacket ?? (allocation.qtyHalfLPacket || 0),
      
      flagIssue: log?.flagIssue || false,
      reason: log?.reason || null,
      brokenBottleCount: log?.brokenBottleCount || null,
      brokenBottleCount1L: log?.brokenBottleCount1L || null,
      brokenBottleCountHalfL: log?.brokenBottleCountHalfL || null,
      notes: log?.notes || null,
      status: log?.deliveryCompleted ? 'Delivered' : 'Pending',
    });
  }

  // Add unassigned routes
  for (const route of routes) {
    if (!processedRouteIds.has(route.id)) {
      const balances = balanceMap.get(route.id) || { '1L': 0, 'HalfL': 0 };
      const currentBalance1L = balances['1L'];
      const currentBalanceHalfL = balances['HalfL'];
      const expectedEmptyBottles = currentBalance1L + currentBalanceHalfL;

      statuses.push({
        routeId: route.id,
        routeName: route.name,
        dpId: null,
        dpName: null,
        deliveryCompleted: false,
        
        oneLBottlesCollected: 0,
        halfLBottlesCollected: 0,
        halfLPacketCollected: 0,
        
        expected1LBottles: currentBalance1L,
        expectedHalfLBottles: currentBalanceHalfL,
        expectedHalfLPacket: 0,
        expectedEmptyBottles,
        
        actualDelivered1L: 0,
        actualDeliveredHalfL: 0,
        actualDeliveredPacket: 0,
        
        flagIssue: false,
        reason: null,
        brokenBottleCount: null,
        brokenBottleCount1L: null,
        brokenBottleCountHalfL: null,
        notes: null,
        status: 'Unassigned',
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

const getPreviousEmptyBottleLog = async (routeId: string, dpId: string, date: string) => {
  return await prisma.emptyBottleLog.findFirst({
    where: {
      routeId,
      dpId,
      date: { lt: date },
    },
    orderBy: { date: 'desc' },
  });
};

export const updateEmptyBottleLog = async (
  routeId: string,
  date: string,
  data: { 
    deliveryCompleted: boolean; 
    oneLBottlesCollected: number; 
    halfLBottlesCollected: number; 
    halfLPacketCollected: number;
    actualDelivered1L: number;
    actualDeliveredHalfL: number;
    actualDeliveredPacket: number;
    flagIssue: boolean;
    reason?: string | null;
    brokenBottleCount?: number | null;
    brokenBottleCount1L?: number | null;
    brokenBottleCountHalfL?: number | null;
    notes?: string | null;
  }
) => {
  const allocation = await prisma.routeAllocation.findFirst({
    where: { 
      routeId, 
      date,
      status: { in: ['ASSIGNED', 'COMPLETED'] }
    }
  });

  if (!allocation) {
    throw new Error('Cannot update empty bottles for an unassigned route.');
  }

  const dpId = allocation.dpId;

  const existingLog = await prisma.emptyBottleLog.findUnique({
    where: { routeId_dpId_date: { routeId, dpId, date } }
  });

  // Calculate deltas for RouteEmptyBottleBalance update
  const oldCollected1L = existingLog?.oneLBottlesCollected || 0;
  const oldBroken1L = existingLog?.brokenBottleCount1L || 0;
  const newCollected1L = data.oneLBottlesCollected;
  const newBroken1L = data.brokenBottleCount1L || 0;
  const delta1L = (newCollected1L + newBroken1L) - (oldCollected1L + oldBroken1L);

  const oldCollectedHalfL = existingLog?.halfLBottlesCollected || 0;
  const oldBrokenHalfL = existingLog?.brokenBottleCountHalfL || 0;
  const newCollectedHalfL = data.halfLBottlesCollected;
  const newBrokenHalfL = data.brokenBottleCountHalfL || 0;
  const deltaHalfL = (newCollectedHalfL + newBrokenHalfL) - (oldCollectedHalfL + oldBrokenHalfL);

  // Update RouteEmptyBottleBalance
  if (delta1L !== 0) {
    const current1L = await prisma.routeEmptyBottleBalance.findUnique({
      where: { routeId_bottleType: { routeId, bottleType: '1L' } }
    });
    if (current1L) {
      await prisma.routeEmptyBottleBalance.update({
        where: { id: current1L.id },
        data: { balance: current1L.balance - delta1L }
      });
    }
  }

  if (deltaHalfL !== 0) {
    const currentHalfL = await prisma.routeEmptyBottleBalance.findUnique({
      where: { routeId_bottleType: { routeId, bottleType: 'HalfL' } }
    });
    if (currentHalfL) {
      await prisma.routeEmptyBottleBalance.update({
        where: { id: currentHalfL.id },
        data: { balance: currentHalfL.balance - deltaHalfL }
      });
    }
  }

  // Calculate expected/outstanding for history logs
  const newBalance1L = await prisma.routeEmptyBottleBalance.findUnique({ where: { routeId_bottleType: { routeId, bottleType: '1L' } }});
  const newBalanceHalfL = await prisma.routeEmptyBottleBalance.findUnique({ where: { routeId_bottleType: { routeId, bottleType: 'HalfL' } }});

  const expected1L = Math.max(0, (newBalance1L?.balance || 0) + newCollected1L + newBroken1L);
  const expectedHalfL = Math.max(0, (newBalanceHalfL?.balance || 0) + newCollectedHalfL + newBrokenHalfL);

  const outstanding1L = Math.max(0, newBalance1L?.balance || 0);
  const outstandingHalfL = Math.max(0, newBalanceHalfL?.balance || 0);

  // For packets, we still need previous log logic
  const previousLog = await getPreviousEmptyBottleLog(routeId, dpId, date);
  const carriedOverPacket = previousLog?.outstandingPacket ?? 0;

  // Handle actual delivered logic for "Not Delivered" scenarios
  let finalActualDelivered1L = data.actualDelivered1L;
  let finalActualDeliveredHalfL = data.actualDeliveredHalfL;
  let finalActualDeliveredPacket = data.actualDeliveredPacket;

  if (!data.deliveryCompleted && data.reason !== 'Partial delivery completed') {
    finalActualDelivered1L = 0;
    finalActualDeliveredHalfL = 0;
    finalActualDeliveredPacket = 0;
  }

  const expectedPacket = carriedOverPacket + finalActualDeliveredPacket;
  const outstandingPacket = expectedPacket - data.halfLPacketCollected;

  if (existingLog) {
    await prisma.emptyBottleLog.update({
      where: { id: existingLog.id },
      data: {
        dpId,
        deliveryCompleted: data.deliveryCompleted,
        oneLBottlesCollected: data.oneLBottlesCollected,
        halfLBottlesCollected: data.halfLBottlesCollected,
        halfLPacketCollected: data.halfLPacketCollected,
        flagIssue: data.flagIssue,
        reason: data.reason,
        brokenBottleCount: data.brokenBottleCount,
        brokenBottleCount1L: data.brokenBottleCount1L,
        brokenBottleCountHalfL: data.brokenBottleCountHalfL,
        notes: data.notes,
        actualDelivered1L: finalActualDelivered1L,
        actualDeliveredHalfL: finalActualDeliveredHalfL,
        actualDeliveredPacket: finalActualDeliveredPacket,
        expected1L,
        expectedHalfL,
        expectedPacket,
        outstanding1L,
        outstandingHalfL,
        outstandingPacket,
      },
    });
  } else {
    await prisma.emptyBottleLog.create({
      data: {
        routeId,
        dpId,
        date,
        deliveryCompleted: data.deliveryCompleted,
        oneLBottlesCollected: data.oneLBottlesCollected,
        halfLBottlesCollected: data.halfLBottlesCollected,
        halfLPacketCollected: data.halfLPacketCollected,
        flagIssue: data.flagIssue,
        reason: data.reason,
        brokenBottleCount: data.brokenBottleCount,
        brokenBottleCount1L: data.brokenBottleCount1L,
        brokenBottleCountHalfL: data.brokenBottleCountHalfL,
        notes: data.notes,
        actualDelivered1L: finalActualDelivered1L,
        actualDeliveredHalfL: finalActualDeliveredHalfL,
        actualDeliveredPacket: finalActualDeliveredPacket,
        expected1L,
        expectedHalfL,
        expectedPacket,
        outstanding1L,
        outstandingHalfL,
        outstandingPacket,
      },
    });
  }

  // Update RouteAllocation status based on deliveryCompleted
  await prisma.routeAllocation.update({
    where: { routeId_dpId_date: { routeId, dpId, date } },
    data: { status: data.deliveryCompleted ? 'COMPLETED' : 'ASSIGNED' },
  });

  return { success: true };
};
