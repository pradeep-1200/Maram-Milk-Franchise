import { prisma } from '../../config/db';
import { getISTDateString, getISTStartOfWeekString, getISTStartOfMonthString } from '../../utils/date';

export const getReportDateRange = (range: 'today'|'yesterday'|'week'|'month'|'custom', now: Date, from?: string, to?: string) => {
  let startDate = '';
  let endDate = '';

  if (range === 'today') {
    startDate = getISTDateString(now);
    endDate = startDate;
  } else if (range === 'yesterday') {
    const yesterday = new Date(now);
    yesterday.setDate(now.getDate() - 1);
    startDate = getISTDateString(yesterday);
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
  
  return { startDate, endDate };
};

export const getDpPerformance = async (range: 'today'|'yesterday'|'week'|'month'|'custom', from?: string, to?: string, sortBy: 'litres'|'routes'|'attendance'|'bottles' = 'litres') => {
  const { startDate, endDate } = getReportDateRange(range, new Date(), from, to);

  console.log('[DEBUG] getDpPerformance - Querying DPs with filter: { isActive: true }');
  const dps = await prisma.deliveryPerson.findMany({
    where: { isActive: true },
    orderBy: { dpCode: 'asc' },
  });
  console.log(`[DEBUG] getDpPerformance - DB returned ${dps.length} DPs.`);

  const allocations = await prisma.routeAllocation.findMany({
    where: {
      status: { in: ['ASSIGNED', 'COMPLETED'] },
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

    const totalLitres = dpAllocations.reduce((sum, a) => {
      const routeBottleLog = dpBottles.find(b => b.routeId === a.routeId && b.date === a.date);
      
      // If completed and we have actual delivered logs, use actuals
      if (a.status === 'COMPLETED' && routeBottleLog) {
        const actual1L = routeBottleLog.actualDelivered1L || 0;
        const actualHalfL = routeBottleLog.actualDeliveredHalfL || 0;
        const actualPacket = routeBottleLog.actualDeliveredPacket || 0;
        
        // Sum actuals (1L = 1, HalfL = 0.5, Packet = 0.5)
        if (actual1L > 0 || actualHalfL > 0 || actualPacket > 0) {
           return sum + (actual1L * 1) + (actualHalfL * 0.5) + (actualPacket * 0.5);
        }
      }
      
      // Fallback to allocated amount
      return sum + a.litresAllocated;
    }, 0);
    const totalRoutes = dpAllocations.length;
    
    const presentCount = dpAttendance.filter(a => a.status === 'PRESENT').length;
    const totalRecordedDays = dpAttendance.length;
    const attendanceRatio = `${presentCount} of ${totalRecordedDays}`;

    const total1LBottles = dpBottles.reduce((sum, b) => sum + b.oneLBottlesCollected, 0);
    const totalHalfLBottles = dpBottles.reduce((sum, b) => sum + b.halfLBottlesCollected, 0);
    const totalPackets = dpBottles.reduce((sum, b) => sum + b.halfLPacketCollected, 0);
    const totalBottles = total1LBottles + totalHalfLBottles + totalPackets;

    const attendancePercent = totalRecordedDays > 0 ? (presentCount / totalRecordedDays) : 0;

    const totalPetrolAllowance = dpAllocations.reduce((sum, a) => sum + (a.petrolAllowanceGiven ?? 0), 0);

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
      total1LBottles,
      totalHalfLBottles,
      totalPackets,
      totalPetrolAllowance,
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
