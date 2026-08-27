import { prisma } from '../../config/db';
import { getReportDateRange } from '../reports/reports.service';

export const getShopSalesForDate = async (date?: string, range?: 'today'|'yesterday'|'week'|'month'|'custom', from?: string, to?: string) => {
  const where: any = {};
  
  if (range) {
    const { startDate, endDate } = getReportDateRange(range, new Date(), from, to);
    if (startDate && endDate) {
      where.date = { gte: startDate, lte: endDate };
    }
  } else if (from || to) {
    where.date = {};
    if (from) where.date.gte = from;
    if (to) where.date.lte = to;
  } else if (date) {
    where.date = date;
  }

  return prisma.shopSale.findMany({
    where,
    include: {
      items: {
        include: {
          inventoryItem: true
        }
      }
    },
    orderBy: [
      { date: 'desc' },
      { createdAt: 'desc' },
    ],
  });
};

export const createShopSale = async (
  date: string,
  items: { inventoryItemId: string; quantity: number }[]
) => {
  return await prisma.$transaction(async (tx) => {
    // 1. Pre-check Inventory and throw error if insufficient stock
    const inventoryItems = await tx.inventoryItem.findMany();
    const dailyRecords = await tx.inventoryDailyRecord.findMany({ where: { date } });
    
    for (const item of items) {
      if (item.quantity > 0) {
        const invItem = inventoryItems.find(i => i.id === item.inventoryItemId);
        const record = dailyRecords.find(r => r.inventoryItemId === item.inventoryItemId);
        const currentStock = record?.currentStock ?? 0;
        
        if (currentStock < item.quantity) {
          throw { 
            statusCode: 400, 
            code: 'INSUFFICIENT_STOCK', 
            message: `Only ${currentStock} × ${invItem?.name} available — reduce the amount.` 
          };
        }
      }
    }

    // 2. Decrement inventory (safe decrement on both expected and current)
    for (const item of items) {
      if (item.quantity > 0) {
        const record = dailyRecords.find(r => r.inventoryItemId === item.inventoryItemId);
        if (record) {
          await tx.inventoryDailyRecord.update({
            where: { id: record.id },
            data: { 
              currentStock: { decrement: item.quantity },
              expectedStock: { decrement: item.quantity }
            }
          });
        }
      }
    }

    // 3. Create the Shop Sale record and items
    // If shop sale already exists for today, we could upsert, but let's assume one big save or multiple sales per day.
    // The previous code used `create`, but had `@unique` on `[date, product, managerId]`... wait, the old schema was just `date` for ShopSale but it didn't have `@unique` on `date`. Now I added `@unique` on `date`.
    // Let's use upsert so they can update it, or if it's unique by date, upsert is best.
    const shopSale = await tx.shopSale.upsert({
      where: { date },
      update: {},
      create: { date }
    });

    // Delete existing items to replace with new ones
    await tx.shopSaleItem.deleteMany({
      where: { shopSaleId: shopSale.id }
    });

    if (items.length > 0) {
      await tx.shopSaleItem.createMany({
        data: items.map(i => ({
          shopSaleId: shopSale.id,
          inventoryItemId: i.inventoryItemId,
          quantity: i.quantity,
        }))
      });
    }

    return await tx.shopSale.findUnique({
      where: { id: shopSale.id },
      include: {
        items: {
          include: { inventoryItem: true }
        }
      }
    });
  });
};
