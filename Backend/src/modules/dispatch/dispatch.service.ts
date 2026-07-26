import { prisma } from '../../config/db';

export const getOrCreateDispatchDay = async (date: string) => {
  let dispatchDay = await prisma.dispatchDay.findUnique({ where: { date } });
  if (!dispatchDay) {
    dispatchDay = await prisma.dispatchDay.create({ data: { date } });
  }
  return dispatchDay;
};

export const checkAndUpdateAttendanceCompletion = async (date: string) => {
  const totalDps = await prisma.deliveryPerson.count();
  const markedAttendanceCount = await prisma.attendanceRecord.count({
    where: { date },
  });

  const isCompleted = totalDps > 0 && markedAttendanceCount >= totalDps;
  const dispatchDay = await getOrCreateDispatchDay(date);

  if (isCompleted && !dispatchDay.attendanceCompletedAt) {
    await prisma.dispatchDay.update({
      where: { date },
      data: { attendanceCompletedAt: new Date() },
    });
  } else if (!isCompleted && dispatchDay.attendanceCompletedAt) {
    // If someone is deleted or un-marked (if that's a feature later), revert completion
    await prisma.dispatchDay.update({
      where: { date },
      data: { attendanceCompletedAt: null },
    });
  }
};

export const checkAndUpdateRoutesCompletion = async (date: string) => {
  const totalRoutes = await prisma.route.count();
  const assignedRoutesCount = await prisma.routeAllocation.count({
    where: { 
      date,
      status: 'ASSIGNED',
    },
  });

  const isCompleted = totalRoutes > 0 && assignedRoutesCount >= totalRoutes;
  const dispatchDay = await getOrCreateDispatchDay(date);

  if (isCompleted && !dispatchDay.routesCompletedAt) {
    await prisma.dispatchDay.update({
      where: { date },
      data: { routesCompletedAt: new Date() },
    });
  } else if (!isCompleted && dispatchDay.routesCompletedAt) {
    await prisma.dispatchDay.update({
      where: { date },
      data: { routesCompletedAt: null },
    });
  }
};

export const checkAndUpdateInventoryCompletion = async (date: string) => {
  const totalItems = await prisma.inventoryItem.count();
  const savedRecordsCount = await prisma.inventoryDailyRecord.count({
    where: { date },
  });

  const isCompleted = totalItems > 0 && savedRecordsCount >= totalItems;
  const dispatchDay = await getOrCreateDispatchDay(date);

  if (isCompleted && !dispatchDay.inventoryCompletedAt) {
    await prisma.dispatchDay.update({
      where: { date },
      data: { inventoryCompletedAt: new Date() },
    });
  } else if (!isCompleted && dispatchDay.inventoryCompletedAt) {
    await prisma.dispatchDay.update({
      where: { date },
      data: { inventoryCompletedAt: null },
    });
  }
};

