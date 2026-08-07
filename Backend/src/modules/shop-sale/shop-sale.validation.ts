import { z } from 'zod';

const dateRegex = /^\d{4}-\d{2}-\d{2}$/;

export const getShopSalesSchema = z.object({
  date: z.string().regex(dateRegex, 'Date must be YYYY-MM-DD'),
});

export const createShopSaleSchema = z.object({
  date: z.string().regex(dateRegex, 'Date must be YYYY-MM-DD'),
  qty1LBottle: z.number().int().min(0).default(0),
  qtyHalfLBottle: z.number().int().min(0).default(0),
  qtyHalfLPacket: z.number().int().min(0).default(0),
}).refine(data => {
  return data.qty1LBottle > 0 || data.qtyHalfLBottle > 0 || data.qtyHalfLPacket > 0;
}, {
  message: "At least one quantity must be greater than 0",
});
