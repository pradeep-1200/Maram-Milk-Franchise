import { prisma } from '../src/config/db';

const newCatalog = [
  { section: 'Milk', name: 'Milk 1L', unit: '1L', material: 'Bottle' },
  { section: 'Milk', name: 'Milk 500mL', unit: '500ml', material: 'Bottle' },
  { section: 'Milk', name: 'Milk 500mL', unit: '500ml', material: 'Packet' },
  { section: 'Dairy', name: 'Curd', unit: '500ml', material: 'Packet' },
  { section: 'Dairy', name: 'Paneer', unit: '150gm', material: 'Bottle' },
  { section: 'Dairy', name: 'Butter', unit: '250gm', material: 'Packet' },
  { section: 'Dairy', name: 'Cow Ghee 500gm', unit: '500gm', material: 'Bottle' },
  { section: 'Dairy', name: 'Cow Ghee 250gm', unit: '250gm', material: 'Bottle' },
  { section: 'Oils', name: 'Coconut Oil', unit: '1L', material: 'Bottle' },
  { section: 'Oils', name: 'Groundnut Oil', unit: '1L', material: 'Bottle' },
  { section: 'Oils', name: 'Sesame Oil', unit: '1L', material: 'Bottle' },
  { section: 'Sweeteners', name: 'Honey', unit: '350gm', material: 'Bottle' },
  { section: 'Sweeteners', name: 'Cane Sugar', unit: '500gm', material: 'Packet' },
  { section: 'Sweeteners', name: 'Karupatti', unit: '1kg', material: 'Packet' },
  { section: 'Snacks / Grocery', name: 'Appalam', unit: '200gm', material: 'Packet' },
];

async function main() {
  console.log('Wiping all existing InventoryDailyRecord entries...');
  await prisma.inventoryDailyRecord.deleteMany({});
  
  console.log('Wiping all existing InventoryItem entries...');
  await prisma.inventoryItem.deleteMany({});
  
  console.log('Seeding new product catalog...');
  for (const item of newCatalog) {
    await prisma.inventoryItem.create({
      data: item,
    });
  }
  
  console.log('Done!');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
