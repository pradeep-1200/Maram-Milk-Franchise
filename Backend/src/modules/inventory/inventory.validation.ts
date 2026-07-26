import { z } from 'zod';

const dateRegex = /^\d{4}-\d{2}-\d{2}$/;

export const inventoryQuerySchema = z.object({
  date: z.string().regex(dateRegex, 'Date must be YYYY-MM-DD'),
});

export const updateInventorySchema = z.object({
  records: z.array(
    z.object({
      inventoryItemId: z.string().uuid(),
      currentStock: z.number().min(0),
    })
  ).min(1, 'At least one record is required'),
});

export const adminStockSchema = z.object({
  inventoryItemId: z.string().uuid(),
  newStockAdded: z.number().min(0),
});
