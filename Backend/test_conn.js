const { PrismaClient } = require('@prisma/client');
const { Pool } = require('pg');
const { PrismaPg } = require('@prisma/adapter-pg');

async function main() {
  const connectionString = process.env.DATABASE_URL;
  const pool = new Pool({ 
    connectionString, 
    ssl: { rejectUnauthorized: false },
    connectionTimeoutMillis: 120000,
    idleTimeoutMillis: 120000
  });
  const adapter = new PrismaPg(pool);
  const prisma = new PrismaClient({ adapter });
  try {
    const count = await prisma.manager.count();
    console.log('Connection successful. Manager count:', count);
  } catch (e) {
    console.error('Connection failed:', e);
  } finally {
    await prisma.$disconnect();
    await pool.end();
  }
}
main();
