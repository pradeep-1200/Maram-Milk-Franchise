import { prisma } from '../src/config/db';
import { getInventoryForDate } from '../src/modules/inventory/inventory.service';
import { createShopSale } from '../src/modules/shop-sale/shop-sale.service';
import { updateRouteAllocation } from '../src/modules/routes/routes.service';

async function runTest() {
  const date = '2027-02-01'; // Mock day
  const routeId = 'test-route-1';
  const dpId = 'test-dp-1';

  // 1. Setup mock data
  const inventoryItems = await getInventoryForDate(date);
  const item1L = inventoryItems.find(i => i.unit === '1L' && i.material === 'Bottle');
  const itemHalfL = inventoryItems.find(i => i.unit === '500ml' && i.material === 'Bottle');
  const itemHalfLPkt = inventoryItems.find(i => i.unit === '500ml' && i.material === 'Packet');
  if (!item1L) throw new Error("1L Bottle item not found in DB");

  // Cleanup old test data
  await prisma.shopSale.deleteMany({ where: { date } });
  await prisma.routeEmptyBottleBalance.deleteMany({ where: { routeId } });
  await prisma.routeAllocation.deleteMany({ where: { routeId, date } });
  await prisma.inventoryDailyRecord.deleteMany({ where: { date } });
  await prisma.route.deleteMany({ where: { id: routeId } });
  await prisma.deliveryPerson.deleteMany({ where: { id: dpId } });

  try {
    await prisma.deliveryPerson.create({
      data: { id: dpId, name: 'Test DP', dpCode: 'DP-TEST', mobileNumber: '123' }
    });
    await prisma.route.create({
      data: { id: routeId, name: 'Test Route', zone: 'Test Zone' }
    });

    // Initial state: 10 bottles for ALL items to prevent mismatch
    for (const item of inventoryItems) {
      await prisma.inventoryDailyRecord.create({
        data: {
          inventoryItemId: item.inventoryItemId,
          date: date,
          expectedStock: 10,
          currentStock: 10,
          carriedOverStock: 10,
          newStockAdded: 0,
        },
      });
    }

    // Grab the specific one we want to track
    let record = await prisma.inventoryDailyRecord.findFirstOrThrow({ 
      where: { inventoryItemId: item1L.inventoryItemId, date } 
    });

    console.log('--- INITIAL STATE ---');
    console.log(`Expected Stock: ${record.expectedStock} | Current Stock: ${record.currentStock}\n`);

    // 2. Simulate Route Allocation (-4)
    console.log('--- SIMULATING ROUTE ALLOCATION (-4) ---');
    await prisma.inventoryDailyRecord.update({
      where: { id: record.id },
      data: {
        expectedStock: { decrement: 4 },
        currentStock: { decrement: 4 }
      }
    });
    
    record = await prisma.inventoryDailyRecord.findFirstOrThrow({ where: { inventoryItemId: item1L.inventoryItemId, date } });
    console.log(`Expected Stock: ${record.expectedStock} | Current Stock: ${record.currentStock}\n`);

    // 3. Simulate Multi-Product Shop Sale OVERSELL Attempt
    console.log('--- SIMULATING MULTI-PRODUCT SHOP SALE OVERSELL ---');
    console.log('Attempting: 2 × 1L (valid), 11 × HalfL (oversell), 2 × HalfLPkt (valid)');
    try {
      await createShopSale(date, 2, 11, 2);
      console.log('ERROR: Oversell was permitted!');
    } catch (e: any) {
      console.log(`BLOCKED: ${e.message}\n`);
    }

    // Check that nothing was deducted
    record = await prisma.inventoryDailyRecord.findFirstOrThrow({ where: { inventoryItemId: item1L.inventoryItemId, date } });
    console.log(`Expected Stock (1L): ${record.expectedStock} | Current Stock (1L): ${record.currentStock}`);
    const recordHalfL = await prisma.inventoryDailyRecord.findFirstOrThrow({ where: { inventoryItemId: itemHalfL!.inventoryItemId, date } });
    console.log(`Expected Stock (HalfL): ${recordHalfL.expectedStock} | Current Stock (HalfL): ${recordHalfL.currentStock}`);
    const recordHalfLPkt = await prisma.inventoryDailyRecord.findFirstOrThrow({ where: { inventoryItemId: itemHalfLPkt!.inventoryItemId, date } });
    console.log(`Expected Stock (HalfLPkt): ${recordHalfLPkt.expectedStock} | Current Stock (HalfLPkt): ${recordHalfLPkt.currentStock}\n`);

    // Check Shop Sale History
    const sales = await prisma.shopSale.findMany({ where: { date } });
    console.log(`Shop Sale History Records: ${sales.length}`);

  } finally {
    // Cleanup
    await prisma.shopSale.deleteMany({ where: { date } });
    await prisma.routeEmptyBottleBalance.deleteMany({ where: { routeId } });
    await prisma.routeAllocation.deleteMany({ where: { routeId, date } });
    await prisma.inventoryDailyRecord.deleteMany({ where: { date } });
    await prisma.route.deleteMany({ where: { id: routeId } });
    await prisma.deliveryPerson.deleteMany({ where: { id: dpId } });
    await prisma.$disconnect();
  }
}

runTest().catch(console.error);
