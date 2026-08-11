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
  // Custom sort order requested by the user
  const orderMap: Record<string, number> = {
    '1L Bottle': 1,
    'Half Litre Bottle': 2,
    '500ml Packet': 3,
  };

  return results.sort((a, b) => {
    const orderA = orderMap[a.name] ?? 99;
    const orderB = orderMap[b.name] ?? 99;
    return orderA - orderB;
  });
};

/**
 * Bulk updates the counted inventory by the manager.
 * Now stops echoing back currentStock as a silent pass-through. 
 * Only marks the inventory step as completed.
 */
export const bulkUpdateInventory = async (date: string, records: { inventoryItemId: string; currentStock?: number; newStockAdded?: number }[]) => {
  const items = await getInventoryForDate(date);
  
  for (const rec of records) {
    if (rec.newStockAdded !== undefined) {
      const currentRecord = items.find(i => i.inventoryItemId === rec.inventoryItemId);
      if (currentRecord) {
        const deltaNewStock = rec.newStockAdded - (currentRecord.newStockAdded ?? 0);
        if (deltaNewStock !== 0) {
          const newExpected = currentRecord.expectedStock + deltaNewStock;
          const newCurrent = currentRecord.currentStock + deltaNewStock;

          await prisma.inventoryDailyRecord.update({
            where: {
              inventoryItemId_date: { inventoryItemId: rec.inventoryItemId, date },
            },
            data: {
              expectedStock: newExpected,
              currentStock: newCurrent,
              newStockAdded: rec.newStockAdded,
            },
          });
        }
      }
    }
  }

  await checkAndUpdateInventoryCompletion(date);
  return []; // Return empty or a success signal
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

  // Instead of recalculating newExpected from scratch (which wipes out Route Allocation decrements),
  // we calculate the delta of the new stock being added/removed, and apply that delta directly.
  const deltaNewStock = newStockAdded - (currentRecord.newStockAdded ?? 0);
  const newExpected = currentRecord.expectedStock + deltaNewStock;
  const newCurrent = currentRecord.currentStock + deltaNewStock;

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
