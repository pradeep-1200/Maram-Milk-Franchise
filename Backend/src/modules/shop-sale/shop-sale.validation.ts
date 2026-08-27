import { z } from 'zod';

const dateRegex = /^\d{4}-\d{2}-\d{2}$/;

export const getShopSalesSchema = z.object({
  date: z.string().regex(dateRegex, 'Date must be YYYY-MM-DD').optional(),
  range: z.enum(['today', 'yesterday', 'week', 'month', 'custom']).optional(),
  from: z.string().regex(dateRegex, 'From must be YYYY-MM-DD').optional(),
  to: z.string().regex(dateRegex, 'To must be YYYY-MM-DD').optional(),
});

export const createShopSaleSchema = z.object({
  date: z.string().regex(dateRegex, 'Date must be YYYY-MM-DD'),
  items: z.array(
    z.object({
      inventoryItemId: z.string().uuid(),
      quantity: z.number().int().nonnegative(),
    })
  ).default([]),
});
