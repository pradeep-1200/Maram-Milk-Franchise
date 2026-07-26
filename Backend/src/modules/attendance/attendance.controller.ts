import { Request, Response, NextFunction } from 'express';
import * as attendanceService from './attendance.service';
import { attendanceQuerySchema, updateAttendanceSchema, bulkAttendanceSchema } from './attendance.validation';

export const getAttendance = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { date } = attendanceQuerySchema.parse(req.query);
    const records = await attendanceService.getAttendanceForDate(date);
    res.json(records);
  } catch (error: any) {
    if (error.name === 'ZodError') {
      return res.status(400).json({ error: { message: 'Validation failed', code: 'VALIDATION_ERROR', details: error.errors } });
    }
    next(error);
  }
};

export const updateSingleAttendance = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { date } = attendanceQuerySchema.parse(req.query);
    const { status } = updateAttendanceSchema.parse(req.body);
    const dpId = req.params.dpId as string;
    
    // Auth middleware attaches `manager` to req
    const managerId = (req as any).manager.id;

    const record = await attendanceService.updateAttendance(dpId, date, status, managerId);
    res.json(record);
  } catch (error: any) {
    if (error.name === 'ZodError') {
      return res.status(400).json({ error: { message: 'Validation failed', code: 'VALIDATION_ERROR', details: error.errors } });
    }
    next(error);
  }
};

export const updateBulkAttendance = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { date } = attendanceQuerySchema.parse(req.query);
    const { records } = bulkAttendanceSchema.parse(req.body);
    
    const managerId = (req as any).manager.id;

    const results = await attendanceService.bulkUpdateAttendance(date, records, managerId);
    res.json({ success: true, updatedCount: results.length });
  } catch (error: any) {
    if (error.name === 'ZodError') {
      return res.status(400).json({ error: { message: 'Validation failed', code: 'VALIDATION_ERROR', details: error.errors } });
    }
    next(error);
  }
};
