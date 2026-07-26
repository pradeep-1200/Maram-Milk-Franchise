import { Request, Response, NextFunction } from 'express';
import * as reportsService from './reports.service';
import { reportQuerySchema } from './reports.validation';

export const getDpPerformance = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { range, from, to, sortBy } = reportQuerySchema.parse(req.query);
    const report = await reportsService.getDpPerformance(range, from, to, sortBy);
    res.json(report);
  } catch (error: any) {
    if (error.name === 'ZodError') {
      return res.status(400).json({ error: { message: 'Validation failed', code: 'VALIDATION_ERROR', details: error.errors } });
    }
    next(error);
  }
};
