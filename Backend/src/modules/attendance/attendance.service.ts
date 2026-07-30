import { prisma } from '../../config/db';
import { AttendanceStatus } from '@prisma/client';
import { checkAndUpdateAttendanceCompletion } from '../dispatch/dispatch.service';

export const getAttendanceForDate = async (date: string) => {
  const dps = await prisma.deliveryPerson.findMany({
    where: { isActive: true },
    orderBy: { dpCode: 'asc' },
  });
  
  const records = await prisma.attendanceRecord.findMany({
    where: { date },
  });

  const recordMap = new Map(records.map(r => [r.dpId, r]));

  const allocations = await prisma.routeAllocation.findMany({
    where: { date, status: { in: ['ASSIGNED', 'COMPLETED'] } }
  });
  const assignedDpIds = new Set(allocations.map(a => a.dpId));

  const ledgerTxs = await prisma.ledgerTransaction.findMany({
    where: {
      date,
      type: { in: ['PETROL_ALLOWANCE', 'SHORTAGE', 'EXTRA_PAID'] },
    },
  });

  return dps.map(dp => {
    const record = recordMap.get(dp.id);
    // The correct condition must be strictly: attendanceStatus === 'PRESENT' AND no RouteAllocation exists.
    // Unmarked ('NOT_MARKED') or 'ABSENT' are ignored for standby.
    let originalStatus = record ? record.status : 'NOT_MARKED';
    let status = originalStatus;

    if (originalStatus === 'PRESENT') {
      if (!assignedDpIds.has(dp.id)) {
        status = 'STANDBY';
      }
    } else if (originalStatus === 'STANDBY') {
      // If DB somehow has STANDBY explicitly, correct it dynamically
      status = assignedDpIds.has(dp.id) ? 'PRESENT' : 'STANDBY';
    }

    const dpTxs = ledgerTxs.filter(tx => tx.dpId === dp.id);
    const sumPA = dpTxs.reduce((sum, tx) => sum + tx.amount, 0);

    return {
      dpId: dp.id,
      dpCode: dp.dpCode,
      name: dp.name,
      photoUrl: dp.photoUrl,
      status,
      recordId: record ? record.id : null,
      markedAt: record ? record.createdAt : null,
      petrolAllowanceGivenToday: sumPA > 0 ? sumPA : null,
    };
  });
};

export const updateAttendance = async (dpId: string, date: string, status: AttendanceStatus, managerId: string) => {
  const record = await prisma.attendanceRecord.upsert({
    where: {
      dpId_date: { dpId, date },
    },
    update: {
      status,
      markedByManagerId: managerId,
    },
    create: {
      dpId,
      date,
      status,
      markedByManagerId: managerId,
    },
  });

  await checkAndUpdateAttendanceCompletion(date);

  return record;
};

export const bulkUpdateAttendance = async (date: string, records: { dpId: string; status: AttendanceStatus }[], managerId: string) => {
  const results = await prisma.$transaction(
    records.map(r =>
      prisma.attendanceRecord.upsert({
        where: {
          dpId_date: { dpId: r.dpId, date },
        },
        update: {
          status: r.status,
          markedByManagerId: managerId,
        },
        create: {
          dpId: r.dpId,
          date,
          status: r.status,
          markedByManagerId: managerId,
        },
      })
    )
  );

  await checkAndUpdateAttendanceCompletion(date);

  return results;
};
