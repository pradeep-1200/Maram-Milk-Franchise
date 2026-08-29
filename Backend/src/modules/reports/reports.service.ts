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
    include: { items: { include: { inventoryItem: true } } },
  });

  const report = dps.map(dp => {
    const dpAllocations = allocations.filter(a => a.dpId === dp.id);
    const dpAttendance = attendance.filter(a => a.dpId === dp.id);
    const dpBottles = bottles.filter(b => b.dpId === dp.id);

    const totalLitres = dpAllocations.reduce((sum, a) => {
      const routeBottleLog = dpBottles.find(b => b.routeId === a.routeId && b.date === a.date);
      
      if (a.status === 'COMPLETED' && routeBottleLog) {
        let actualLitres = 0;
        for (const item of routeBottleLog.items) {
          const unit = item.inventoryItem.unit.toLowerCase();
          let litresPerUnit = 0;
          if (unit === '1l') litresPerUnit = 1;
          else if (unit === '500ml') litresPerUnit = 0.5;
          else if (unit === '250ml') litresPerUnit = 0.25;
          
          if (item.inventoryItem.section === 'Milk' && item.actualDelivered) {
            actualLitres += (item.actualDelivered * litresPerUnit);
          }
        }
        if (actualLitres > 0) return sum + actualLitres;
      }
      
      // Fallback to allocated amount
      return sum + a.litresAllocated;
    }, 0);
    const totalRoutes = dpAllocations.length;
    
    const presentCount = dpAttendance.filter(a => a.status === 'PRESENT').length;
    const totalRecordedDays = dpAttendance.length;
    const attendanceRatio = `${presentCount} of ${totalRecordedDays}`;

    let total1LBottles = 0;
    let totalHalfLBottles = 0;
    
    const totalBottles = dpBottles.reduce((sum, b) => {
      let bSum = 0;
      for (const i of b.items) {
        const collected = i.collected ?? 0;
        bSum += collected;
        
        const unit = i.inventoryItem.unit.toLowerCase();
        const material = i.inventoryItem.material?.toLowerCase();
        
        if (material === 'bottle') {
          if (unit === '1l') total1LBottles += collected;
          else if (unit === '500ml') totalHalfLBottles += collected;
        }
      }
      return sum + bSum;
    }, 0);

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
