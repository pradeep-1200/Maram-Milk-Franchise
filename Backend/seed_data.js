const { PrismaClient } = require('@prisma/client');
const { Pool } = require('pg');
const { PrismaPg } = require('@prisma/adapter-pg');
require('dotenv').config();

const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const adapter = new PrismaPg(pool);
const prisma = new PrismaClient({ adapter });

async function clearDB() {
  await prisma.emptyBottleLog.deleteMany();
  await prisma.routeAllocation.deleteMany();
  await prisma.attendanceRecord.deleteMany();
  await prisma.ledgerTransaction.deleteMany();
  await prisma.route.deleteMany();
  await prisma.deliveryPerson.deleteMany();
  await prisma.inventoryDailyRecord.deleteMany();
  await prisma.inventoryItem.deleteMany();
  await prisma.dispatchDay.deleteMany();
}

async function seedRoutes() {
  const routesData = [
    { name: 'Alwarpet', defaultPetrolAllowance: 60 },
    { name: 'Egmore', defaultPetrolAllowance: 80 },
    { name: 'Mandaveli 1', defaultPetrolAllowance: 50 },
    { name: 'Mandaveli 2', defaultPetrolAllowance: 50 },
    { name: 'MRC Ngr', defaultPetrolAllowance: 60 },
    { name: 'Mylapore 1', defaultPetrolAllowance: 60 },
    { name: 'Mylapore 2', defaultPetrolAllowance: 70 },
    { name: 'Nungambakkam', defaultPetrolAllowance: 80 },
    { name: 'Royapettah', defaultPetrolAllowance: 50 },
    { name: 'T-Nagar', defaultPetrolAllowance: 60 },
    { name: 'Teynampet', defaultPetrolAllowance: 70 },
    { name: 'Triplicane', defaultPetrolAllowance: 50 },
    { name: 'West Mambalam 1', defaultPetrolAllowance: 50 },
    { name: 'West Mambalam 2', defaultPetrolAllowance: 80 },
  ];

  for (const r of routesData) {
    await prisma.route.create({
      data: {
        name: r.name,
        zone: '', // left blank/TODO for now
        defaultPetrolAllowance: r.defaultPetrolAllowance,
        customerCount: Math.floor(Math.random() * 20) + 10,
        litres: Math.floor(Math.random() * 50) + 20,
      }
    });
  }
}

async function seedDPs() {
  const dpsData = [
    { name: 'Ansar', role: 'Delivery Person', mobileNumber: '9000000001', dpCode: 'DP01' },
    { name: 'Arun', role: 'Delivery Person', mobileNumber: '9000000002', dpCode: 'DP02' },
    { name: 'Avinash', role: 'Delivery Person', mobileNumber: '9000000003', dpCode: 'DP03' },
    { name: 'Dinesh', role: 'Delivery Person', mobileNumber: '9000000004', dpCode: 'DP04' },
    { name: 'Imran', role: 'Shop Manager', mobileNumber: '9000000005', dpCode: 'DP05' },
  ];

  for (const dp of dpsData) {
    await prisma.deliveryPerson.create({
      data: {
        name: dp.name,
        role: dp.role,
        mobileNumber: dp.mobileNumber,
        dpCode: dp.dpCode,
      }
    });
  }
}

async function seedInventory() {
  const today = new Date().toISOString().split('T')[0];

  const item1L = await prisma.inventoryItem.create({
    data: { name: '1L Bottle', unit: 'Bottles' }
  });

  const item500ml = await prisma.inventoryItem.create({
    data: { name: '500ml Bottle', unit: 'Bottles' }
  });

  await prisma.inventoryDailyRecord.create({
    data: {
      inventoryItemId: item1L.id,
      date: today,
      expectedStock: 100,
      currentStock: 100,
      carriedOverStock: 0,
    }
  });

  await prisma.inventoryDailyRecord.create({
    data: {
      inventoryItemId: item500ml.id,
      date: today,
      expectedStock: 50,
      currentStock: 50,
      carriedOverStock: 0,
    }
  });
}

async function run() {
  console.log('Clearing database...');
  await clearDB();

  console.log('Seeding routes...');
  await seedRoutes();

  console.log('Seeding DPs...');
  await seedDPs();

  console.log('Seeding inventory...');
  await seedInventory();

  console.log('Database seeded successfully.');
}

run()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
    pool.end();
  });
