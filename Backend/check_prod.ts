import { prisma } from './src/config/db';
async function main() {
  const items = await prisma.inventoryItem.findMany();
  console.log('Total items:', items.length);
  items.forEach(i => console.log(i.name, '| Section:', i.section));
  
  const oldItems = items.filter(i => ['1L Bottle', '500ml Packet', 'Half Litre Bottle'].includes(i.name));
  console.log('\nChecking relations for old items:', oldItems.map(i => i.name));
  
  for (const item of oldItems) {
    const allocations = await prisma.routeAllocationItem.count({ where: { inventoryItemId: item.id } });
    const collections = await prisma.emptyBottleLogItem.count({ where: { inventoryItemId: item.id } });
    const shopSales = await prisma.shopSaleItem.count({ where: { inventoryItemId: item.id } });
    const daily = await prisma.inventoryDailyRecord.count({ where: { inventoryItemId: item.id } });
    console.log(item.name, '-> RouteAllocations:', allocations, 'EmptyBottleLogs:', collections, 'ShopSales:', shopSales, 'Daily:', daily);
  }
}
main().finally(() => prisma.$disconnect());
