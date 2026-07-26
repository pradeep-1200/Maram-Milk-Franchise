import { z } from 'zod';
import { RouteAllocationStatus } from '@prisma/client';

const dateRegex = /^\d{4}-\d{2}-\d{2}$/;

export const routeQuerySchema = z.object({
  date: z.string().regex(dateRegex, 'Date must be YYYY-MM-DD'),
});

export const updateAllocationSchema = z.object({
  dpId: z.string().uuid(),
  litresAllocated: z.number().min(0),
  qty1LBottle: z.number().min(0).optional(),
  qtyHalfLBottle: z.number().min(0).optional(),
  petrolAllowanceGiven: z.number().min(0).optional(),
  status: z.nativeEnum(RouteAllocationStatus),
});
