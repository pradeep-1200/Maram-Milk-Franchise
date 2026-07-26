import { prisma } from '../../config/db';
import { checkAndUpdateInventoryCompletion } from '../dispatch/dispatch.service';

/**
 * Retrieves the most recent previous record for an item before a given date.
 */
const getPreviousRecord = async (inventoryItemId: string, date: string) => {
  return await prisma.inventoryDailyRecord.findFirst({
    where: {
      inventoryItemId,
      date: { lt: date },
    },
    orderBy: { date: 'desc' },
  });
};

/**
 * Fetches inventory for a date, auto-creating records with carry-forward logic if missing.
 */
export const getInventoryForDate = async (date: string) => {
  const items = await prisma.inventoryItem.findMany({
    orderBy: { name: 'asc' },
  });

  const records = await prisma.inventoryDailyRecord.findMany({
    where: { date },
  });

  const recordMap = new Map(records.map(r => [r.inventoryItemId, r]));

  const results = [];
  for (const item of items) {
    let record = recordMap.get(item.id);
    
    if (!record) {
      // Carry-forward logic
      const previous = await getPreviousRecord(item.id, date);
      const carriedExpected = previous ? previous.currentStock : 0;
      
      // Auto-create on the fly
      record = await prisma.inventoryDailyRecord.create({
        data: {
          inventoryItemId: item.id,
          date,
          expectedStock: carriedExpected,
          currentStock: carriedExpected, // Default to expected until manager edits
          carriedOverStock: carriedExpected,
          newStockAdded: 0,
        },
      });
    }
    
    results.push({
      inventoryItemId: item.id,
      name: item.name,
      unit: item.unit,
      material: item.material,
      recordId: record.id,
      expectedStock: record.expectedStock,
      currentStock: record.currentStock,
      carriedOverStock: record.carriedOverStock,
      newStockAdded: record.newStockAdded,
    });
  }

  return results;
};

/**
 * Bulk updates the counted inventory by the manager.
 */
export const bulkUpdateInventory = async (date: string, records: { inventoryItemId: string; currentStock: number }[]) => {
  const results = await prisma.$transaction(
    records.map(r =>
      prisma.inventoryDailyRecord.upsert({
        where: {
          inventoryItemId_date: {
            inventoryItemId: r.inventoryItemId,
            date,
          },
        },
        update: {
          currentStock: r.currentStock,
        },
        create: {
          inventoryItemId: r.inventoryItemId,
          date,
          expectedStock: r.currentStock, // Fallback if created directly here
          currentStock: r.currentStock,
          carriedOverStock: 0,
          newStockAdded: 0,
        },
      })
    )
  );

  await checkAndUpdateInventoryCompletion(date);
  return results;
};

/**
 * Admin logic: Adds new stock to the day's expected balance.
 */
export const addAdminStock = async (date: string, inventoryItemId: string, newStockAdded: number) => {
  // Guarantee the record exists by invoking our getter first
  await getInventoryForDate(date);

  const record = await prisma.inventoryDailyRecord.update({
    where: {
      inventoryItemId_date: { inventoryItemId, date },
    },
    data: {
      expectedStock: { increment: newStockAdded },
      currentStock: { increment: newStockAdded },
      newStockAdded: { increment: newStockAdded },
    },
  });

  return record;
};
