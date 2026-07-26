import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcrypt';
import { Pool } from 'pg';
import { PrismaPg } from '@prisma/adapter-pg';

const connectionString = process.env.DATABASE_URL;
const pool = new Pool({ connectionString });
const adapter = new PrismaPg(pool);
const prisma = new PrismaClient({ adapter });

async function main() {
  console.log('Starting seed...');
  
  // 1. Manager
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
        branchName: 'Maram Milk - Royapettah Branch',
      },
    });
    console.log(`Test Manager seeded: ${email} / password123`);
  } else {
    console.log(`Test Manager already exists: ${email}`);
  }

  // 2. Routes
  const routesData = [
    { name: 'Alwarpet', defaultPetrolAllowance: 60, zone: 'Zone A', customerCount: 0, litres: 0 },
    { name: 'Egmore', defaultPetrolAllowance: 80, zone: 'Zone A', customerCount: 0, litres: 0 },
    { name: 'Mandaveli 1', defaultPetrolAllowance: 50, zone: 'Zone A', customerCount: 0, litres: 0 },
    { name: 'Mandaveli 2', defaultPetrolAllowance: 50, zone: 'Zone A', customerCount: 0, litres: 0 },
    { name: 'MRC Ngr', defaultPetrolAllowance: 60, zone: 'Zone A', customerCount: 0, litres: 0 },
    { name: 'Mylapore 1', defaultPetrolAllowance: 60, zone: 'Zone A', customerCount: 0, litres: 0 },
    { name: 'Mylapore 2', defaultPetrolAllowance: 70, zone: 'Zone A', customerCount: 0, litres: 0 },
    { name: 'Nungambakkam', defaultPetrolAllowance: 80, zone: 'Zone A', customerCount: 0, litres: 0 },
    { name: 'Royapettah', defaultPetrolAllowance: 50, zone: 'Zone A', customerCount: 0, litres: 0 },
    { name: 'T-Nagar', defaultPetrolAllowance: 60, zone: 'Zone A', customerCount: 0, litres: 0 },
    { name: 'Teynampet', defaultPetrolAllowance: 70, zone: 'Zone A', customerCount: 0, litres: 0 },
    { name: 'Triplicane', defaultPetrolAllowance: 50, zone: 'Zone A', customerCount: 0, litres: 0 },
    { name: 'West Mambalam 1', defaultPetrolAllowance: 50, zone: 'Zone A', customerCount: 0, litres: 0 },
    { name: 'West Mambalam 2', defaultPetrolAllowance: 80, zone: 'Zone A', customerCount: 0, litres: 0 },
  ];

  for (const r of routesData) {
    const existing = await prisma.route.findFirst({ where: { name: r.name } });
    if (!existing) {
      await prisma.route.create({ data: r });
      console.log(`Seeded Route: ${r.name}`);
    }
  }

  // 3. Delivery Persons
  const dpsList = [
    "Ansar", "Arun", "Avinash", "Dinesh", "Junaid", "Nagarjunaa", 
    "Nandagopal", "Noorullah", "Prabhu", "Samsudeen", "Santhosh", 
    "Shabeer", "Shanmugam", "Suresh", "Sri Ram", "Uma Shankar", "Vignesh"
  ];

  for (let i = 0; i < dpsList.length; i++) {
    const name = dpsList[i];
    const dpCode = `DP${String(i + 1).padStart(3, '0')}`;
    const existing = await prisma.deliveryPerson.findUnique({ where: { dpCode } });
    if (!existing) {
      await prisma.deliveryPerson.create({
        data: {
          dpCode,
          name,
          mobileNumber: '0000000000',
        }
      });
      console.log(`Seeded Delivery Person: ${name}`);
    }
  }

  console.log('Seed completed.');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
