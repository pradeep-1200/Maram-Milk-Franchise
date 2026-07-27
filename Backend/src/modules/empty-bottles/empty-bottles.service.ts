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

  const previousLogs = await prisma.emptyBottleLog.findMany({
    where: { date: { lt: date } },
    orderBy: { date: 'desc' },
    distinct: ['routeId'],
  });

  const allocationMap = new Map(allocations.map(a => [a.routeId, a]));
  const logMap = new Map(emptyBottleLogs.map(l => [l.routeId, l]));
  const previousLogMap = new Map(previousLogs.map(l => [l.routeId, l]));

  return routes.map(route => {
    const allocation = allocationMap.get(route.id);
    const log = logMap.get(route.id);
    const previousLog = previousLogMap.get(route.id);

    const carriedOver1L = previousLog?.outstanding1L ?? 0;
    const carriedOverHalfL = previousLog?.outstandingHalfL ?? 0;
    const carriedOverPacket = previousLog?.outstandingPacket ?? 0;

    return {
      routeId: route.id,
      routeName: route.name,
      dpId: allocation?.dpId || null,
      dpName: allocation?.dp?.name || null,
      deliveryCompleted: log?.deliveryCompleted || false,
      
      oneLBottlesCollected: log?.oneLBottlesCollected || 0,
      halfLBottlesCollected: log?.halfLBottlesCollected || 0,
      halfLPacketCollected: log?.halfLPacketCollected || 0,
      
      expected1LBottles: log?.expected1L ?? (carriedOver1L + (allocation?.qty1LBottle || 0)),
      expectedHalfLBottles: log?.expectedHalfL ?? (carriedOverHalfL + (allocation?.qtyHalfLBottle || 0)),
      expectedHalfLPacket: log?.expectedPacket ?? (carriedOverPacket + (allocation?.qtyHalfLPacket || 0)),
      
      actualDelivered1L: log?.actualDelivered1L ?? (allocation?.qty1LBottle || 0),
      actualDeliveredHalfL: log?.actualDeliveredHalfL ?? (allocation?.qtyHalfLBottle || 0),
      actualDeliveredPacket: log?.actualDeliveredPacket ?? (allocation?.qtyHalfLPacket || 0),
      
      flagIssue: log?.flagIssue || false,
      status: log?.deliveryCompleted ? 'Delivered' : (allocation ? 'Pending' : 'Unassigned'),
    };
  });
};

const getPreviousEmptyBottleLog = async (routeId: string, date: string) => {
  return await prisma.emptyBottleLog.findFirst({
    where: {
      routeId,
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
    flagIssue: boolean 
  }
) => {
  const allocation = await prisma.routeAllocation.findUnique({
    where: { routeId_date: { routeId, date } },
  });

  if (!allocation || (allocation.status !== 'ASSIGNED' && allocation.status !== 'COMPLETED')) {
    throw new Error('Cannot update empty bottles for an unassigned route.');
  }

  // Calculate carry over from previous log
  const previousLog = await getPreviousEmptyBottleLog(routeId, date);
  const carriedOver1L = previousLog?.outstanding1L ?? 0;
  const carriedOverHalfL = previousLog?.outstandingHalfL ?? 0;
  const carriedOverPacket = previousLog?.outstandingPacket ?? 0;

  // Calculate expected
  const expected1L = carriedOver1L + data.actualDelivered1L;
  const expectedHalfL = carriedOverHalfL + data.actualDeliveredHalfL;
  const expectedPacket = carriedOverPacket + data.actualDeliveredPacket;

  // Calculate outstanding
  const outstanding1L = expected1L - data.oneLBottlesCollected;
  const outstandingHalfL = expectedHalfL - data.halfLBottlesCollected;
  const outstandingPacket = expectedPacket - data.halfLPacketCollected;

  const existingLog = await prisma.emptyBottleLog.findFirst({
    where: { routeId, date },
  });

  if (existingLog) {
    await prisma.emptyBottleLog.update({
      where: { id: existingLog.id },
      data: {
        dpId: allocation.dpId,
        deliveryCompleted: data.deliveryCompleted,
        oneLBottlesCollected: data.oneLBottlesCollected,
        halfLBottlesCollected: data.halfLBottlesCollected,
        halfLPacketCollected: data.halfLPacketCollected,
        flagIssue: data.flagIssue,
        actualDelivered1L: data.actualDelivered1L,
        actualDeliveredHalfL: data.actualDeliveredHalfL,
        actualDeliveredPacket: data.actualDeliveredPacket,
        carriedOver1L,
        carriedOverHalfL,
        carriedOverPacket,
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
        dpId: allocation.dpId,
        date,
        deliveryCompleted: data.deliveryCompleted,
        oneLBottlesCollected: data.oneLBottlesCollected,
        halfLBottlesCollected: data.halfLBottlesCollected,
        halfLPacketCollected: data.halfLPacketCollected,
        flagIssue: data.flagIssue,
        actualDelivered1L: data.actualDelivered1L,
        actualDeliveredHalfL: data.actualDeliveredHalfL,
        actualDeliveredPacket: data.actualDeliveredPacket,
        carriedOver1L,
        carriedOverHalfL,
        carriedOverPacket,
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
    where: { routeId_date: { routeId, date } },
    data: { status: data.deliveryCompleted ? 'COMPLETED' : 'ASSIGNED' },
  });

  return { success: true };
};
