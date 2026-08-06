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

  const allocationMap = new Map(allocations.map(a => [a.routeId, a]));
  const logMap = new Map(emptyBottleLogs.map(l => [l.routeId, l]));

  return routes.map(route => {
    const allocation = allocationMap.get(route.id);
    const log = logMap.get(route.id);
    const balances = balanceMap.get(route.id) || { '1L': 0, 'HalfL': 0 };
    const currentBalance1L = balances['1L'];
    const currentBalanceHalfL = balances['HalfL'];

    // If log exists, the balance has already been reduced by today's collection/broken,
    // so we reconstruct the pre-collection expected value.
    // If log doesn't exist, log is null, so we just use the current balance.
    const expected1L = Math.max(0, currentBalance1L + (log?.oneLBottlesCollected || 0) + (log?.brokenBottleCount1L || 0));
    const expectedHalfL = Math.max(0, currentBalanceHalfL + (log?.halfLBottlesCollected || 0) + (log?.brokenBottleCountHalfL || 0));
    const expectedPacket = (allocation?.qtyHalfLPacket || 0); // Packets don't have running balance

    const expectedEmptyBottles = expected1L + expectedHalfL;

    return {
      routeId: route.id,
      routeName: route.name,
      dpId: allocation?.dpId || null,
      dpName: allocation?.dp?.name || null,
      deliveryCompleted: log?.deliveryCompleted || false,
      
      oneLBottlesCollected: log?.oneLBottlesCollected || 0,
      halfLBottlesCollected: log?.halfLBottlesCollected || 0,
      halfLPacketCollected: log?.halfLPacketCollected || 0,
      
      expected1LBottles: expected1L,
      expectedHalfLBottles: expectedHalfL,
      expectedHalfLPacket: expectedPacket,
      expectedEmptyBottles,
      
      actualDelivered1L: log?.actualDelivered1L ?? (allocation?.qty1LBottle || 0),
      actualDeliveredHalfL: log?.actualDeliveredHalfL ?? (allocation?.qtyHalfLBottle || 0),
      actualDeliveredPacket: log?.actualDeliveredPacket ?? (allocation?.qtyHalfLPacket || 0),
      
      flagIssue: log?.flagIssue || false,
      reason: log?.reason || null,
      brokenBottleCount: log?.brokenBottleCount || null,
      brokenBottleCount1L: log?.brokenBottleCount1L || null,
      brokenBottleCountHalfL: log?.brokenBottleCountHalfL || null,
      notes: log?.notes || null,
      status: log?.deliveryCompleted ? 'Delivered' : (allocation ? 'Pending' : 'Unassigned'),
    };
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
  dpId: string,
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
    reason?: string;
    brokenBottleCount?: number;
    brokenBottleCount1L?: number;
    brokenBottleCountHalfL?: number;
    notes?: string;
  }
) => {
  const allocation = await prisma.routeAllocation.findUnique({
    where: { routeId_dpId_date: { routeId, dpId, date } }
  });

  if (!allocation || (allocation.status !== 'ASSIGNED' && allocation.status !== 'COMPLETED')) {
    throw new Error('Cannot update empty bottles for an unassigned route.');
  }

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
