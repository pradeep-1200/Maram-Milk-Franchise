import { prisma } from '../../config/db';
import { getISTDateString, getISTStartOfWeekString, getISTStartOfMonthString } from '../../utils/date';

export const getDpPerformance = async (range: 'today'|'week'|'month'|'custom', from?: string, to?: string, sortBy: 'litres'|'routes'|'attendance'|'bottles' = 'litres') => {
  let startDate = '';
  let endDate = '';

  const now = new Date();

  if (range === 'today') {
    startDate = getISTDateString(now);
    endDate = startDate;
  } else if (range === 'week') {
    startDate = getISTStartOfWeekString(now);
    endDate = getISTDateString(now);
  } else if (range === 'month') {
    startDate = getISTStartOfMonthString(now);
    endDate = getISTDateString(now);
  } else if (range === 'custom') {
    startDate = from!;
    endDate = to!;
  }

  console.log('[DEBUG] getDpPerformance - Querying DPs with filter: { isActive: true }');
  const dps = await prisma.deliveryPerson.findMany({
    where: { isActive: true },
    orderBy: { dpCode: 'asc' },
  });
  console.log(`[DEBUG] getDpPerformance - DB returned ${dps.length} DPs.`);

  const allocations = await prisma.routeAllocation.findMany({
    where: {
      status: 'ASSIGNED',
      date: { gte: startDate, lte: endDate },
    },
  });

  const attendance = await prisma.attendanceRecord.findMany({
    where: {
      date: { gte: startDate, lte: endDate },
    },
  });

  const bottles = await prisma.emptyBottleLog.findMany({
    where: {
      date: { gte: startDate, lte: endDate },
    },
  });

  const report = dps.map(dp => {
    const dpAllocations = allocations.filter(a => a.dpId === dp.id);
    const dpAttendance = attendance.filter(a => a.dpId === dp.id);
    const dpBottles = bottles.filter(b => b.dpId === dp.id);

    const totalLitres = dpAllocations.reduce((sum, a) => sum + a.litresAllocated, 0);
    const totalRoutes = dpAllocations.length;
    
    const presentCount = dpAttendance.filter(a => a.status === 'PRESENT').length;
    const totalRecordedDays = dpAttendance.length;
    const attendanceRatio = `${presentCount} of ${totalRecordedDays}`;

    const totalBottles = dpBottles.reduce((sum, b) => sum + b.oneLBottlesCollected + b.halfLBottlesCollected, 0);

    const attendancePercent = totalRecordedDays > 0 ? (presentCount / totalRecordedDays) : 0;

    return {
      dpId: dp.id,
      dpCode: dp.dpCode,
      name: dp.name,
      photoUrl: dp.photoUrl,
      totalLitres,
      totalRoutes,
      attendanceRatio,
      attendancePercent,
      totalBottles,
    };
  });

  report.sort((a, b) => {
    if (sortBy === 'litres') return b.totalLitres - a.totalLitres;
    if (sortBy === 'routes') return b.totalRoutes - a.totalRoutes;
    if (sortBy === 'bottles') return b.totalBottles - a.totalBottles;
    if (sortBy === 'attendance') return b.attendancePercent - a.attendancePercent;
    return 0;
  });

  return report.map(({ attendancePercent, ...rest }) => rest);
};
