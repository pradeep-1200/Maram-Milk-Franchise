import { prisma } from '../src/config/db';
import { updateRouteAllocation } from '../src/modules/routes/routes.service';

async function main() {
  const routes = await prisma.route.findMany();
  const dps = await prisma.deliveryPerson.findMany();
  const items = await prisma.inventoryItem.findMany();

  if (routes.length === 0 || dps.length === 0 || items.length === 0) {
    console.log("Not enough data to test");
    return;
  }

  const routeId = routes[0].id;
  const dpId = dps[0].id;
  const date = '2026-08-29';
  const item1 = items[0].id;
  const item2 = items[1].id;

  await prisma.inventoryDailyRecord.upsert({
    where: { inventoryItemId_date: { inventoryItemId: item1, date } },
    update: { currentStock: 100, expectedStock: 100 },
    create: { inventoryItemId: item1, date, currentStock: 100, expectedStock: 100 }
  });
  await prisma.inventoryDailyRecord.upsert({
    where: { inventoryItemId_date: { inventoryItemId: item2, date } },
    update: { currentStock: 100, expectedStock: 100 },
    create: { inventoryItemId: item2, date, currentStock: 100, expectedStock: 100 }
  });
  
  console.log("--- BEFORE UPDATE (WITH ITEMS) ---");
  await updateRouteAllocation(
    routeId, 
    date, 
    dpId, 
    10, 
    'ASSIGNED', 
    [{ inventoryItemId: item1, quantity: 5 }, { inventoryItemId: item2, quantity: 10 }]
  );

  let allocs = await prisma.routeAllocation.findMany({ where: { routeId, dpId, date } });
  let allocItems = await prisma.routeAllocationItem.findMany({ where: { routeAllocationId: allocs[0].id } });
  console.log(`Route Allocation Items count: ${allocItems.length}`);
  console.dir(allocItems);

  console.log("\n--- AFTER UPDATE (OMITTED ITEMS) ---");
  // Simulating an update like Petrol Allowance which omits items
  await updateRouteAllocation(
    routeId, 
    date, 
    dpId, 
    10, 
    'ASSIGNED', 
    undefined,
    90
  );

  allocs = await prisma.routeAllocation.findMany({ where: { routeId, dpId, date } });
  allocItems = await prisma.routeAllocationItem.findMany({ where: { routeAllocationId: allocs[0].id } });
  console.log(`Route Allocation Items count: ${allocItems.length}`);
  console.dir(allocItems);
}

main().catch(console.error).finally(() => prisma.$disconnect());
