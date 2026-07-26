import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcrypt';
import { Pool } from 'pg';
import { PrismaPg } from '@prisma/adapter-pg';

const connectionString = process.env.DATABASE_URL;
const pool = new Pool({ connectionString });
const adapter = new PrismaPg(pool);
const prisma = new PrismaClient({ adapter });

async function main() {
  const email = 'imran@marammilk.com';
  const existingManager = await prisma.manager.findUnique({
    where: { email }
  });

  if (!existingManager) {
    const passwordHash = await bcrypt.hash('password123', 10);
    await prisma.manager.create({
      data: {
        name: 'Imran',
        email,
        passwordHash,
        role: 'MANAGER',
        branchName: 'Maram Milk - Downtown Branch',
      },
    });
    console.log(`Test Manager seeded: ${email} / password123`);
  } else {
    console.log(`Test Manager already exists: ${email}`);
  }
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
