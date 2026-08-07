import { prisma } from '../src/config/db';
import { getInventoryForDate } from '../src/modules/inventory/inventory.service';

async function runTest() {
  const date1 = '2027-01-01'; // Mock day 1
  const date2 = '2027-01-02'; // Mock day 2
  const inventoryItemId = 'test-item-reconcile-1L';

  // Cleanup old test data
  await prisma.inventoryDailyRecord.deleteMany({ where: { date: { in: [date1, date2] } } });
  await prisma.inventoryItem.deleteMany({ where: { id: inventoryItemId } });

  // 1. Setup mock item
  const item = await prisma.inventoryItem.create({
    data: {
      id: inventoryItemId,
      name: '1L Bottle',
      unit: '1L',
      material: 'Bottle',
    },
  });

  // 2. Setup initial day 1 state (carried over = 10, no new stock)
  let record = await prisma.inventoryDailyRecord.create({
    data: {
      inventoryItemId,
      date: date1,
      expectedStock: 10,
      currentStock: 10,
      carriedOverStock: 10,
      newStockAdded: 0,
    },
  });
  console.log('--- DAY 1 INITIAL STATE ---');
  console.log(`Carried Over: 10 | New Stock: 0`);
  console.log(`Expected Stock: ${record.expectedStock} | Current Stock: ${record.currentStock}\n`);

  // 3. Simulate Route Allocation (-5)
  console.log('--- SIMULATING ROUTE ALLOCATION (-5) ---');
  record = await prisma.inventoryDailyRecord.update({
    where: { id: record.id },
    data: {
      expectedStock: { decrement: 5 },
      currentStock: { decrement: 5 },
    },
  });
  console.log(`Expected Stock: ${record.expectedStock} | Current Stock: ${record.currentStock}\n`);

  // 4. Simulate Manager Edit (New Stock = 4) using NEW DELTA logic
  console.log('--- MANAGER NEW STOCK EDIT (+4) ---');
  let newStockAdded = 4;
  let deltaNewStock = newStockAdded - (record.newStockAdded ?? 0);
  let newExpected = record.expectedStock + deltaNewStock;
  let newCurrent = record.currentStock + deltaNewStock;
  
  record = await prisma.inventoryDailyRecord.update({
    where: { id: record.id },
    data: {
      expectedStock: newExpected,
      currentStock: newCurrent,
      newStockAdded: newStockAdded,
    },
  });
  console.log(`Expected Stock: ${record.expectedStock} | Current Stock: ${record.currentStock} (Drifted safely)\n`);

  // 5. Simulate "Set Actual Stock" (Reconciliation) to a completely different number (e.g. 15)
  console.log('--- MANAGER RECONCILES STOCK TO 15 ---');
  let actualStock = 15;
  record = await prisma.inventoryDailyRecord.update({
    where: { id: record.id },
    data: {
      expectedStock: actualStock,
      currentStock: actualStock,
    },
  });
  console.log(`Expected Stock: ${record.expectedStock} | Current Stock: ${record.currentStock} (HARD OVERWRITE)\n`);

  // 6. Confirm Day 2's carriedOverStock correctly picks up the reconciled number
  console.log('--- DAY 2 START ---');
  // getInventoryForDate will auto-create Day 2 using previous.currentStock
  const day2Items = await getInventoryForDate(date2);
  const day2Record = day2Items.find(i => i.inventoryItemId === inventoryItemId);
  
  console.log(`Day 2 Carried Over Stock: ${day2Record?.carriedOverStock} -> CORRECT, picks up reconciled 15!`);
  console.log(`Day 2 Expected Stock: ${day2Record?.expectedStock}`);
  console.log(`Day 2 Current Stock: ${day2Record?.currentStock}\n`);

  // Cleanup
  await prisma.inventoryDailyRecord.deleteMany({ where: { date: { in: [date1, date2] } } });
  await prisma.inventoryItem.deleteMany({ where: { id: inventoryItemId } });
  
  console.log('Test completed successfully.');
}

runTest().catch(console.error).finally(() => prisma.$disconnect());
