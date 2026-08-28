import { prisma } from './src/config/db';

async function main() {
  const id = '92db6d93-3829-4dfb-9e53-b13e2bf31974';
  
  const result = await prisma.inventoryItem.update({
    where: { id },
    data: { unit: '500ml' }
  });

  console.log('Successfully updated Coconut Oil unit to 500ml:', result);
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
