const { PrismaClient } = require('@prisma/client');
const { Pool } = require('pg');
const { PrismaPg } = require('@prisma/adapter-pg');

async function main() {
  const connectionString = process.env.DATABASE_URL;
  if (!connectionString) {
    throw new Error('DATABASE_URL is not set');
  }

  const pool = new Pool({
    connectionString,
    ssl: { rejectUnauthorized: false }
  });
  const adapter = new PrismaPg(pool);
  const prisma = new PrismaClient({ adapter });

  console.log('Initiating production transaction data wipe...');

  try {
    const [
      ledger, 
      bottles, 
      allocations, 
      attendance, 
      inventory, 
      dispatch
    ] = await prisma.$transaction([
      prisma.ledgerTransaction.deleteMany(),
      prisma.emptyBottleLog.deleteMany(),
      prisma.routeAllocation.deleteMany(),
      prisma.attendanceRecord.deleteMany(),
      prisma.inventoryDailyRecord.deleteMany(),
      prisma.dispatchDay.deleteMany()
    ], {
      maxWait: 15000,
      timeout: 30000
    });

    console.log(`Wipe completed successfully:
    - LedgerTransaction: deleted ${ledger.count} rows
    - EmptyBottleLog: deleted ${bottles.count} rows
    - RouteAllocation: deleted ${allocations.count} rows
    - AttendanceRecord: deleted ${attendance.count} rows
    - InventoryDailyRecord: deleted ${inventory.count} rows
    - DispatchDay: deleted ${dispatch.count} rows`);
  } catch (e) {
    console.error('Error during wipe:', e);
    process.exit(1);
  } finally {
    await prisma.$disconnect();
    await pool.end();
  }
}

main();
