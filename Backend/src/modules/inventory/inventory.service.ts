import { prisma } from '../../config/db';
import { checkAndUpdateInventoryCompletion } from '../dispatch/dispatch.service';
import { parseUnitToLitres } from '../../utils/unit';

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
      
      // Auto-create on the fly using upsert to prevent race conditions
      record = await prisma.inventoryDailyRecord.upsert({
        where: {
          inventoryItemId_date: {
            inventoryItemId: item.id,
            date,
          },
        },
        update: {}, // Do nothing if it exists
        create: {
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
      litresPerUnit: parseUnitToLitres(item.unit),
    });
  }

  return results;
};

/**
 * Bulk updates the counted inventory by the manager.
 */
export const bulkUpdateInventory = async (date: string, records: { inventoryItemId: string; currentStock: number; newStockAdded?: number }[]) => {
  const existingRecords = await getInventoryForDate(date);

  const results = await prisma.$transaction(
    records.map(r => {
      const currentRecord = existingRecords.find(i => i.inventoryItemId === r.inventoryItemId);
      
      let updateData: any = {
        currentStock: r.currentStock,
      };
      
      let expectedStock = r.currentStock; // fallback
      if (currentRecord) {
        expectedStock = currentRecord.carriedOverStock ?? 0;
        if (r.newStockAdded !== undefined) {
          updateData.newStockAdded = r.newStockAdded;
          expectedStock += r.newStockAdded;
        } else {
          expectedStock += currentRecord.newStockAdded ?? 0;
        }
        updateData.expectedStock = expectedStock;
      }

      return prisma.inventoryDailyRecord.upsert({
        where: {
          inventoryItemId_date: {
            inventoryItemId: r.inventoryItemId,
            date,
          },
        },
        update: updateData,
        create: {
          inventoryItemId: r.inventoryItemId,
          date,
          expectedStock: expectedStock,
          currentStock: r.currentStock,
          carriedOverStock: 0,
          newStockAdded: r.newStockAdded ?? 0,
        },
      });
    })
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

// TEMPORARY_MANUAL_STOCK_ENTRY
/**
 * Manager temporary logic: Set new stock directly (overwriting any previous value).
 */
export const setManagerStock = async (date: string, inventoryItemId: string, newStockAdded: number) => {
  // Guarantee the record exists
  const items = await getInventoryForDate(date);
  const currentRecord = items.find(i => i.inventoryItemId === inventoryItemId);
  if (!currentRecord) throw new Error('Item not found');

  // We are setting newStockAdded, so expected becomes carriedOver + newStockAdded
  const newExpected = (currentRecord.carriedOverStock ?? 0) + newStockAdded;
  
  // If the manager hasn't recorded a variance yet (current == expected), keep them in sync
  const variance = currentRecord.currentStock - currentRecord.expectedStock;
  const newCurrent = newExpected + variance;

  const record = await prisma.inventoryDailyRecord.update({
    where: {
      inventoryItemId_date: { inventoryItemId, date },
    },
    data: {
      expectedStock: newExpected,
      currentStock: newCurrent,
      newStockAdded: newStockAdded,
    },
  });

  return record;
};
