import { Request, Response, NextFunction } from 'express';
import * as emptyBottleService from './empty-bottles.service';
import { dateQuerySchema, updateEmptyBottleSchema } from './empty-bottles.validation';

export const getEmptyBottles = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { date } = dateQuerySchema.parse(req.query);
    const result = await emptyBottleService.getEmptyBottleStatus(date);
    res.json(result);
  } catch (error: any) {
    if (error.name === 'ZodError') {
      return res.status(400).json({ error: { message: 'Validation failed', code: 'VALIDATION_ERROR', details: error.errors } });
    }
    next(error);
  }
};

export const updateEmptyBottle = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { date } = dateQuerySchema.parse(req.query);
    const data = updateEmptyBottleSchema.parse(req.body);
    const routeId = req.params.routeId as string;
    const dpId = data.dpId;

    const result = await emptyBottleService.updateEmptyBottleLog(routeId, dpId, date, data);
    res.json(result);
  } catch (error: any) {
    if (error.name === 'ZodError') {
      return res.status(400).json({ error: { message: 'Validation failed', code: 'VALIDATION_ERROR', details: error.errors } });
    }
    if (error.message.includes('unassigned route')) {
      return res.status(400).json({ error: { message: error.message, code: 'BAD_REQUEST' } });
    }
    next(error);
  }
};
