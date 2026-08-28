import { prisma } from './src/config/db';

async function main() {
  const oldItemNames = ['1L Bottle', '500ml Packet', 'Half Litre Bottle'];
  
  // Find old items
  const itemsToDelete = await prisma.inventoryItem.findMany({
    where: { name: { in: oldItemNames } }
  });
  
  console.log(`Found ${itemsToDelete.length} old items to delete.`);
  
  for (const item of itemsToDelete) {
    // 1. Delete associated InventoryDailyRecord
    const deletedRecords = await prisma.inventoryDailyRecord.deleteMany({
      where: { inventoryItemId: item.id }
    });
    console.log(`Deleted ${deletedRecords.count} daily records for ${item.name}`);
    
    // 2. Delete the item itself
    await prisma.inventoryItem.delete({
      where: { id: item.id }
    });
    console.log(`Deleted InventoryItem: ${item.name}`);
  }
  
  console.log('\n--- VERIFICATION ---');
  // Fetch remaining items
  const remainingItems = await prisma.inventoryItem.findMany({
    orderBy: { section: 'asc' }
  });
  console.log(`Total Remaining Products: ${remainingItems.length}`);
  
  const sections = new Set();
  remainingItems.forEach(i => {
    console.log(`[${i.section}] ${i.name}`);
    sections.add(i.section);
  });
  
  console.log(`\nUnique Sections Found: ${Array.from(sections).join(', ')}`);
}

main().finally(() => prisma.$disconnect());
