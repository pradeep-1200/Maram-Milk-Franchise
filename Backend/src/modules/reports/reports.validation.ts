import { z } from 'zod';

export const reportQuerySchema = z.object({
  range: z.enum(['today', 'week', 'month', 'custom']),
  from: z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'Must be YYYY-MM-DD').optional(),
  to: z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'Must be YYYY-MM-DD').optional(),
  sortBy: z.enum(['litres', 'routes', 'attendance', 'bottles']).default('litres'),
}).refine(data => {
  if (data.range === 'custom') {
    return !!data.from && !!data.to;
  }
  return true;
}, {
  message: "Both 'from' and 'to' are required when range is 'custom'",
  path: ['from', 'to'],
});
