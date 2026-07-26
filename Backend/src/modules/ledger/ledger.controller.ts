import { Request, Response, NextFunction } from 'express';
import * as ledgerService from './ledger.service';
import { ledgerQuerySchema, createLedgerSchema } from './ledger.validation';

export const getLedger = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { dpId, from, to, type } = ledgerQuerySchema.parse(req.query);
    const transactions = await ledgerService.getLedger(dpId, from, to, type);
    res.json(transactions);
  } catch (error: any) {
    if (error.name === 'ZodError') {
      return res.status(400).json({ error: { message: 'Validation failed', code: 'VALIDATION_ERROR', details: error.errors } });
    }
    next(error);
  }
};

export const createTransaction = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const data = createLedgerSchema.parse(req.body);
    const transaction = await ledgerService.createLedgerTransaction(data as any);
    res.status(201).json(transaction);
  } catch (error: any) {
    if (error.name === 'ZodError') {
      return res.status(400).json({ error: { message: 'Validation failed', code: 'VALIDATION_ERROR', details: error.errors } });
    }
    next(error);
  }
};
