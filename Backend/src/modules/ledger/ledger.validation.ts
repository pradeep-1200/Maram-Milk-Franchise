import { z } from 'zod';
import { LedgerTransactionType } from '@prisma/client';

export const ledgerQuerySchema = z.object({
  dpId: z.string().uuid().optional(),
  range: z.enum(['today', 'yesterday', 'week', 'month', 'custom']).optional(),
  from: z.string().regex(/^\d{4}-\d{2}-\d{2}$/).optional(),
  to: z.string().regex(/^\d{4}-\d{2}-\d{2}$/).optional(),
  type: z.string().optional(),
});

export const createLedgerSchema = z.object({
  dpId: z.string().uuid().optional().nullable(),
  type: z.nativeEnum(LedgerTransactionType),
  amount: z.number().min(0.01),
  note: z.string().optional().nullable(),
  date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/),
});
