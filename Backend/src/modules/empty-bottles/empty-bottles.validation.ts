import { z } from 'zod';

export const dateQuerySchema = z.object({
  date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'Date must be YYYY-MM-DD'),
});

export const updateEmptyBottleSchema = z.object({
  deliveryCompleted: z.boolean(),
  oneLBottlesCollected: z.number().min(0),
  halfLBottlesCollected: z.number().min(0),
  flagIssue: z.boolean(),
});
