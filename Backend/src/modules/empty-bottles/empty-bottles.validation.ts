import { z } from 'zod';

export const dateQuerySchema = z.object({
  date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'Date must be YYYY-MM-DD'),
});

export const updateEmptyBottleSchema = z.object({
  dpId: z.string().uuid(),
  deliveryCompleted: z.boolean(),
  flagIssue: z.boolean(),
  reason: z.string().nullable().optional(),
  notes: z.string().nullable().optional(),
  items: z.array(z.object({
    inventoryItemId: z.string().uuid(),
    actualDelivered: z.number().min(0),
    collected: z.number().min(0).default(0),
    broken: z.number().min(0).default(0),
  })).optional().default([]),
});
