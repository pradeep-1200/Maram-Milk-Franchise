const { PrismaClient } = require('@prisma/client');
const { Pool } = require('pg');
const { PrismaPg } = require('@prisma/adapter-pg');
require('dotenv').config();

const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const adapter = new PrismaPg(pool);
const prisma = new PrismaClient({ adapter });

async function resetAndSeed() {
  console.log('Starting database reset...');
  await prisma.inventoryDailyRecord.deleteMany({});
  console.log('Cleared InventoryDailyRecord');
  
  await prisma.emptyBottleLog.deleteMany({});
  console.log('Cleared EmptyBottleLog');
  
  await prisma.routeAllocation.deleteMany({});
  console.log('Cleared RouteAllocation');
  
  await prisma.ledgerTransaction.deleteMany({});
  console.log('Cleared LedgerTransaction');
  
  await prisma.dispatchDay.deleteMany({});
  console.log('Cleared DispatchDay');
  
  await prisma.attendanceRecord.deleteMany({});
  console.log('Cleared AttendanceRecord');

  const dps = await prisma.deliveryPerson.findMany();
  const manager = await prisma.manager.findFirst();

  if (!manager) {
    console.error('No manager found, cannot seed attendance');
    return;
  }

  if (dps.length === 0) {
    console.error('No DPs found, cannot seed attendance');
    return;
  }

  console.log('Seeding attendance for July 1 to July 26...');
  const dates = [];
  for (let i = 1; i <= 26; i++) {
    const day = i.toString().padStart(2, '0');
    dates.push(`2026-07-${day}`);
  }

  let totalSeeded = 0;
  for (const date of dates) {
    for (const dp of dps) {
      await prisma.attendanceRecord.create({
        data: {
          dpId: dp.id,
          date: date,
          status: 'PRESENT',
          markedByManagerId: manager.id,
        }
      });
      totalSeeded++;
    }
    await prisma.dispatchDay.create({
      data: {
        date: date,
        attendanceCompletedAt: new Date(`${date}T08:00:00Z`),
      }
    });
  }
  console.log(`Finished seeding ${totalSeeded} attendance records across ${dates.length} days.`);
}

resetAndSeed()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
    pool.end();
  });
