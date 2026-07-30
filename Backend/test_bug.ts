import { PrismaClient } from '@prisma/client';
import { Pool } from 'pg';
import { PrismaPg } from '@prisma/adapter-pg';
import * as dotenv from 'dotenv';
dotenv.config();

const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const adapter = new PrismaPg(pool);
const prisma = new PrismaClient({ adapter });

import { getAttendanceForDate } from './src/modules/attendance/attendance.service';
import { getDpPerformance } from './src/modules/reports/reports.service';
import { deleteDeliveryPerson } from './src/modules/delivery-persons/delivery-persons.service';

async function main() {
  const date = '2026-07-30';
  
  // 1. Initial size
  const att1 = await getAttendanceForDate(date);
  console.log(`Initial Attendance DPs: ${att1.length}`);

  // 2. Create a test DP
  const testDp = await prisma.deliveryPerson.create({
    data: {
      name: 'Test DP20',
      dpCode: 'DP20',
      mobileNumber: '8888888888',
      isActive: true,
    }
  });
  console.log(`Created test DP: ${testDp.id}`);

  // 3. Size after creation
  const att2 = await getAttendanceForDate(date);
  console.log(`Attendance DPs after creation: ${att2.length}`);
  const isInAtt2 = att2.some(dp => dp.dpId === testDp.id);
  console.log(`Is Test DP in attendance list? ${isInAtt2}`);

  // 4. Delete the test DP
  await deleteDeliveryPerson(testDp.id);
  console.log(`Deleted test DP: ${testDp.id}`);

  // 5. Size after deletion
  const att3 = await getAttendanceForDate(date);
  console.log(`Attendance DPs after deletion: ${att3.length}`);
  const isInAtt3 = att3.some(dp => dp.dpId === testDp.id);
  console.log(`Is Test DP in attendance list? ${isInAtt3}`);

  // Verify DB state
  const dpInDb = await prisma.deliveryPerson.findUnique({ where: { id: testDp.id } });
  console.log(`Test DP isActive in DB: ${dpInDb?.isActive}`);

  // 6. Test Reports
  const report1 = await getDpPerformance('month');
  console.log(`Is Test DP in Reports list? ${report1.some(dp => dp.dpId === testDp.id)}`);
}

main()
  .catch(console.error)
  .finally(async () => {
    await prisma.$disconnect();
    pool.end();
  });
