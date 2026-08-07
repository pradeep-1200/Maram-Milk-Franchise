import { prisma } from '../../config/db';

export const getShopSalesForDate = async (date: string) => {
  return prisma.shopSale.findMany({
    where: { date },
    orderBy: { createdAt: 'desc' },
  });
};

export const createShopSale = async (
  date: string,
  qty1LBottle: number,
  qtyHalfLBottle: number,
  qtyHalfLPacket: number
) => {
  return await prisma.$transaction(async (tx) => {
    // 1. Pre-check Inventory and throw error if insufficient stock
    const inventoryItems = await tx.inventoryItem.findMany();
    const dailyRecords = await tx.inventoryDailyRecord.findMany({ where: { date } });
    
    const inventory = inventoryItems.map(item => {
      const record = dailyRecords.find(r => r.inventoryItemId === item.id);
      return {
        ...item,
        recordId: record?.id,
        currentStock: record?.currentStock ?? 0,
      };
    });

    const item1L = inventory.find(i => i.unit === '1L' && i.material === 'Bottle');
    const itemHalfL = inventory.find(i => i.unit === '500ml' && i.material === 'Bottle');
    const itemHalfLPacket = inventory.find(i => i.unit === '500ml' && i.material === 'Packet');

    if (item1L && qty1LBottle > 0 && item1L.currentStock < qty1LBottle) {
      throw { statusCode: 400, code: 'INSUFFICIENT_STOCK', message: `Only ${item1L.currentStock} × 1L bottles available — reduce the amount.` };
    }
    if (itemHalfL && qtyHalfLBottle > 0 && itemHalfL.currentStock < qtyHalfLBottle) {
      throw { statusCode: 400, code: 'INSUFFICIENT_STOCK', message: `Only ${itemHalfL.currentStock} × 500ml bottles available — reduce the amount.` };
    }
    if (itemHalfLPacket && qtyHalfLPacket > 0 && itemHalfLPacket.currentStock < qtyHalfLPacket) {
      throw { statusCode: 400, code: 'INSUFFICIENT_STOCK', message: `Only ${itemHalfLPacket.currentStock} × 500ml packets available — reduce the amount.` };
    }

    // 2. Decrement inventory (safe decrement on both expected and current)
    if (item1L?.recordId && qty1LBottle > 0) {
      await tx.inventoryDailyRecord.update({
        where: { id: item1L.recordId },
        data: { 
          currentStock: { decrement: qty1LBottle },
          expectedStock: { decrement: qty1LBottle }
        }
      });
    }

    if (itemHalfL?.recordId && qtyHalfLBottle > 0) {
      await tx.inventoryDailyRecord.update({
        where: { id: itemHalfL.recordId },
        data: { 
          currentStock: { decrement: qtyHalfLBottle },
          expectedStock: { decrement: qtyHalfLBottle }
        }
      });
    }
    
    if (itemHalfLPacket?.recordId && qtyHalfLPacket > 0) {
      await tx.inventoryDailyRecord.update({
        where: { id: itemHalfLPacket.recordId },
        data: { 
          currentStock: { decrement: qtyHalfLPacket },
          expectedStock: { decrement: qtyHalfLPacket }
        }
      });
    }

    // 3. Create the Shop Sale record
    const shopSale = await tx.shopSale.create({
      data: {
        date,
        qty1LBottle,
        qtyHalfLBottle,
        qtyHalfLPacket,
      }
    });

    return shopSale;
  });
};
