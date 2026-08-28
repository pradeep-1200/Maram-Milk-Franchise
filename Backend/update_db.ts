import { prisma } from './src/config/db';
async function main() {
  const result = await prisma.inventoryItem.updateMany({
    where: { section: 'Snacks / Grocery' },
    data: { section: 'Grocery' }
  });
  console.log('Updated rows:', result.count);
}
main().finally(() => prisma.$disconnect());
