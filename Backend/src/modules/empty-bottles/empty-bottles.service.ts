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

  const allocationMap = new Map(allocations.map(a => [a.routeId, a]));
  const logMap = new Map(emptyBottleLogs.map(l => [l.routeId, l]));

  return routes.map(route => {
    const allocation = allocationMap.get(route.id);
    const log = logMap.get(route.id);

    return {
      routeId: route.id,
      routeName: route.name,
      dpId: allocation?.dpId || null,
      dpName: allocation?.dp?.name || null,
      deliveryCompleted: log?.deliveryCompleted || false,
      oneLBottlesCollected: log?.oneLBottlesCollected || 0,
      halfLBottlesCollected: log?.halfLBottlesCollected || 0,
      expected1LBottles: allocation?.qty1LBottle || 0,
      expectedHalfLBottles: allocation?.qtyHalfLBottle || 0,
      flagIssue: log?.flagIssue || false,
      status: log?.deliveryCompleted ? 'Delivered' : (allocation ? 'Pending' : 'Unassigned'),
    };
  });
};

export const updateEmptyBottleLog = async (
  routeId: string,
  date: string,
  data: { deliveryCompleted: boolean; oneLBottlesCollected: number; halfLBottlesCollected: number; flagIssue: boolean }
) => {
  const allocation = await prisma.routeAllocation.findUnique({
    where: { routeId_date: { routeId, date } },
  });

  if (!allocation || (allocation.status !== 'ASSIGNED' && allocation.status !== 'COMPLETED')) {
    throw new Error('Cannot update empty bottles for an unassigned route.');
  }

  const existingLog = await prisma.emptyBottleLog.findFirst({
    where: { routeId, date },
  });

  if (existingLog) {
    await prisma.emptyBottleLog.update({
      where: { id: existingLog.id },
      data: {
        dpId: allocation.dpId,
        ...data,
      },
    });
  } else {
    await prisma.emptyBottleLog.create({
      data: {
        routeId,
        dpId: allocation.dpId,
        date,
        ...data,
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
