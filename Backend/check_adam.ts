import { PrismaClient } from '@prisma/client';
import { Pool } from 'pg';
import { PrismaPg } from '@prisma/adapter-pg';
import * as dotenv from 'dotenv';
dotenv.config();

const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const adapter = new PrismaPg(pool);
const prisma = new PrismaClient({ adapter });

async function main() {
  const allDps = await prisma.deliveryPerson.findMany();
  console.log(`Total DPs in DB: ${allDps.length}`);
  
  const adam = allDps.find(dp => dp.name.includes('Adam') || dp.dpCode === 'DP18');
  if (adam) {
    console.log(`Found Adam:`, adam);
  } else {
    console.log(`Adam not found.`);
  }

  const activeDps = await prisma.deliveryPerson.findMany({ where: { isActive: true } });
  console.log(`Active DPs: ${activeDps.length}`);
}

main()
  .catch(console.error)
  .finally(async () => {
    await prisma.$disconnect();
    pool.end();
  });
