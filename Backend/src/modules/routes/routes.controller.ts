import { Request, Response, NextFunction } from 'express';
import * as routesService from './routes.service';
import { routeQuerySchema, updateAllocationSchema } from './routes.validation';

export const getRoutes = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { date } = routeQuerySchema.parse(req.query);
    const routes = await routesService.getRoutesWithAllocation(date);
    res.json(routes);
  } catch (error: any) {
    if (error.name === 'ZodError') {
      return res.status(400).json({ error: { message: 'Validation failed', code: 'VALIDATION_ERROR', details: error.errors } });
    }
    next(error);
  }
};

export const updateAllocation = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { date } = routeQuerySchema.parse(req.query);
    const { dpId, litresAllocated, status, items, petrolAllowanceGiven } = updateAllocationSchema.parse(req.body);
    const routeId = req.params.routeId as string;

    if (status === 'ASSIGNED' && litresAllocated <= 0) {
      return res.status(400).json({ error: { message: 'Allocated litres must be greater than 0 to assign a route.', code: 'INVALID_LITRES' } });
    }

    const itemArray = Object.entries(items).map(([id, quantity]) => ({ inventoryItemId: id, quantity }));
    const allocation = await routesService.updateRouteAllocation(routeId, date, dpId, litresAllocated, status, itemArray, petrolAllowanceGiven);
    res.json(allocation);
  } catch (error: any) {
    if (error.name === 'ZodError') {
      return res.status(400).json({ error: { message: 'Validation failed', code: 'VALIDATION_ERROR', details: error.errors } });
    }
    next(error);
  }
};
