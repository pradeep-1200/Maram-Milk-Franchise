import { prisma } from './src/config/db';

async function main() {
  const sales = await prisma.shopSale.findMany({
    include: { items: { include: { inventoryItem: true } } }
  });
  console.log(JSON.stringify(sales, null, 2));
}

main()
  .catch(console.error)
  .finally(() => prisma.$disconnect());
