import { Request, Response, NextFunction } from 'express';
import { prisma } from '../../config/db';
import { z } from 'zod';
import { getOrCreateDispatchDay } from './dispatch.service';

const dateSchema = z.object({
  date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'Date must be YYYY-MM-DD'),
});

export const getDispatchSummary = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { date } = dateSchema.parse(req.query);

    // Get the base dispatch day stats
    const dispatchDay = await getOrCreateDispatchDay(date);

    // 1. Attendance Stats
    const totalDps = await prisma.deliveryPerson.count();
    const attendanceRecords = await prisma.attendanceRecord.findMany({ where: { date } });
    
    // We need route allocations to compute standby dynamically
    const allocationsForAttendance = await prisma.routeAllocation.findMany({ where: { date, status: { in: ['ASSIGNED', 'COMPLETED'] } } });
    const assignedDpIds = new Set(allocationsForAttendance.map(a => a.dpId));

    let presentCount = 0;
    let absentCount = 0;
    let standbyCount = 0;

    for (const r of attendanceRecords) {
      if (r.status === 'ABSENT') {
        absentCount++;
      } else if (r.status === 'PRESENT') {
        if (assignedDpIds.has(r.dpId)) {
          presentCount++;
        } else {
          standbyCount++;
        }
      } else if (r.status === 'STANDBY') {
        if (assignedDpIds.has(r.dpId)) {
          presentCount++;
        } else {
          standbyCount++;
        }
      }
    }
    const markedCount = attendanceRecords.length;

    // 2. Route Stats
    const totalRoutes = await prisma.route.count();
    const allocations = await prisma.routeAllocation.findMany({ where: { date } });
    const assignedCount = allocations.filter(a => a.status === 'ASSIGNED').length;
    const totalLitresAllocated = allocations
      .filter(a => a.status === 'ASSIGNED')
      .reduce((sum, a) => sum + a.litresAllocated, 0);
    const petrolAllowanceTotal = allocations
      .filter(a => a.status === 'ASSIGNED')
      .reduce((sum, a) => sum + (a.petrolAllowanceGiven || 0), 0);

    // 3. Inventory Stats
    const totalItems = await prisma.inventoryItem.count();
    const inventoryRecords = await prisma.inventoryDailyRecord.findMany({ where: { date } });
    const matchCount = inventoryRecords.filter(r => r.currentStock === r.expectedStock).length;

    res.json({
      date,
      attendance: {
        totalDps,
        marked: markedCount,
        present: presentCount,
        absent: absentCount,
        standby: standbyCount,
        completedAt: dispatchDay.attendanceCompletedAt,
      },
      routes: {
        totalRoutes,
        assigned: assignedCount,
        unassigned: totalRoutes - assignedCount,
        totalLitresAllocated,
        completedAt: dispatchDay.routesCompletedAt,
      },
      inventory: {
        totalItems,
        counted: inventoryRecords.length,
        matched: matchCount,
        completedAt: dispatchDay.inventoryCompletedAt,
      },
      petrolAllowanceTotal,
    });
  } catch (error: any) {
    if (error.name === 'ZodError') {
      return res.status(400).json({ error: { message: 'Validation failed', code: 'VALIDATION_ERROR', details: error.errors } });
    }
    next(error);
  }
};
