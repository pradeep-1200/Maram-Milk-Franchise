const { PrismaClient } = require('@prisma/client');
const { Pool } = require('pg');
const { PrismaPg } = require('@prisma/adapter-pg');
require('dotenv').config();

const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const adapter = new PrismaPg(pool);
const prisma = new PrismaClient({ adapter });

const { getAttendanceForDate } = require('./dist/modules/attendance/attendance.service');
const { getDpPerformance } = require('./dist/modules/reports/reports.service');
const { createDeliveryPerson } = require('./dist/modules/delivery-persons/delivery-persons.service');
const { deleteDeliveryPerson } = require('./dist/modules/delivery-persons/delivery-persons.service');

async function main() {
  const date = '2026-07-30';
  
  // 1. Initial size
  const att1 = await getAttendanceForDate(date);
  console.log(`Initial Attendance size: ${JSON.stringify(att1).length} bytes, DPs: ${att1.length}`);

  // 2. Create a test DP
  const testDp = await prisma.deliveryPerson.create({
    data: {
      name: 'Test DP19',
      dpCode: 'DP19',
      mobileNumber: '9999999999',
      isActive: true,
    }
  });
  console.log(`Created test DP: ${testDp.id}`);

  // 3. Size after creation
  const att2 = await getAttendanceForDate(date);
  console.log(`Attendance size after creation: ${JSON.stringify(att2).length} bytes, DPs: ${att2.length}`);

  // 4. Delete the test DP
  await deleteDeliveryPerson(testDp.id);
  console.log(`Deleted test DP: ${testDp.id}`);

  // 5. Size after deletion
  const att3 = await getAttendanceForDate(date);
  console.log(`Attendance size after deletion: ${JSON.stringify(att3).length} bytes, DPs: ${att3.length}`);

  // Let's verify DB state of this DP
  const dpInDb = await prisma.deliveryPerson.findUnique({ where: { id: testDp.id } });
  console.log(`Test DP isActive in DB: ${dpInDb.isActive}`);
}

main()
  .catch(console.error)
  .finally(async () => {
    await prisma.$disconnect();
    pool.end();
  });
