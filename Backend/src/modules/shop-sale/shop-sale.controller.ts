import { Request, Response, NextFunction } from 'express';
import * as shopSaleService from './shop-sale.service';
import { getShopSalesSchema, createShopSaleSchema } from './shop-sale.validation';

export const getShopSales = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { date, range, from, to } = getShopSalesSchema.parse(req.query);
    const sales = await shopSaleService.getShopSalesForDate(date, range, from, to);
    res.json(sales);
  } catch (error: any) {
    if (error.name === 'ZodError') {
      return res.status(400).json({ error: { message: 'Validation failed', code: 'VALIDATION_ERROR', details: error.errors } });
    }
    next(error);
  }
};

export const createShopSale = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { date, items } = createShopSaleSchema.parse(req.body);

    const sale = await shopSaleService.createShopSale(
      date,
      items
    );

    res.status(201).json(sale);
  } catch (error: any) {
    if (error.name === 'ZodError') {
      return res.status(400).json({ error: { message: 'Validation failed', code: 'VALIDATION_ERROR', details: error.errors } });
    }
    if (error.code === 'INSUFFICIENT_STOCK') {
      return res.status(400).json({ error });
    }
    next(error);
  }
};
