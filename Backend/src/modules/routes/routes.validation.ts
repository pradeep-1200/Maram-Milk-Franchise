import { z } from 'zod';
import { RouteAllocationStatus } from '@prisma/client';

const dateRegex = /^\d{4}-\d{2}-\d{2}$/;

export const routeQuerySchema = z.object({
  date: z.string().regex(dateRegex, 'Date must be YYYY-MM-DD'),
});

export const updateAllocationSchema = z.object({
  dpId: z.string().uuid(),
  litresAllocated: z.number().min(0),
  items: z.record(z.string().uuid(), z.number().int().min(0)).optional().default({}),
  petrolAllowanceGiven: z.number().int().optional(),
  status: z.nativeEnum(RouteAllocationStatus),
});
