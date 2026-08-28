import { prisma } from './src/config/db';
import { format } from 'date-fns';

async function main() {
  // Use today's date in YYYY-MM-DD
  const today = format(new Date(), 'yyyy-MM-dd');
  console.log(`Updating stock for date: ${today}`);

  // Fetch all items
  const items = await prisma.inventoryItem.findMany();
  
  for (const item of items) {
    await prisma.inventoryDailyRecord.upsert({
      where: {
        inventoryItemId_date: {
          inventoryItemId: item.id,
          date: today,
        },
      },
      update: {
        expectedStock: 100,
        currentStock: 100,
        newStockAdded: 100,
      },
      create: {
        inventoryItemId: item.id,
        date: today,
        expectedStock: 100,
        currentStock: 100,
        newStockAdded: 100,
      },
    });
  }

  console.log(`Successfully added 100 stock to all ${items.length} products!`);
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
