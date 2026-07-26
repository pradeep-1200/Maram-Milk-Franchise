import { Request, Response, NextFunction } from 'express';
import * as inventoryService from './inventory.service';
import { inventoryQuerySchema, updateInventorySchema, adminStockSchema } from './inventory.validation';

export const getInventory = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { date } = inventoryQuerySchema.parse(req.query);
    const inventory = await inventoryService.getInventoryForDate(date);
    res.json(inventory);
  } catch (error: any) {
    if (error.name === 'ZodError') {
      return res.status(400).json({ error: { message: 'Validation failed', code: 'VALIDATION_ERROR', details: error.errors } });
    }
    next(error);
  }
};

export const updateInventory = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { date } = inventoryQuerySchema.parse(req.query);
    const { records } = updateInventorySchema.parse(req.body);

    const results = await inventoryService.bulkUpdateInventory(date, records);
    res.json({ success: true, updatedCount: results.length });
  } catch (error: any) {
    if (error.name === 'ZodError') {
      return res.status(400).json({ error: { message: 'Validation failed', code: 'VALIDATION_ERROR', details: error.errors } });
    }
    next(error);
  }
};

export const addAdminStock = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { date } = inventoryQuerySchema.parse(req.query);
    const { inventoryItemId, newStockAdded } = adminStockSchema.parse(req.body);

    const record = await inventoryService.addAdminStock(date, inventoryItemId, newStockAdded);
    res.json(record);
  } catch (error: any) {
    if (error.name === 'ZodError') {
      return res.status(400).json({ error: { message: 'Validation failed', code: 'VALIDATION_ERROR', details: error.errors } });
    }
    next(error);
  }
};
