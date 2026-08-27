// @ts-nocheck
import { prisma } from '../config/db';
import { getDpPerformance } from '../modules/reports/reports.service';
import { getISTDateString } from '../utils/date';
import * as assert from 'assert';

async function runTest() {
  const now = new Date();
  const dateStr = getISTDateString(now);

  console.log('--- Starting DP Performance Unit Test ---');
  console.log('Testing date:', dateStr);

  // Clean up
  await prisma.routeAllocation.deleteMany({});
  await prisma.attendanceRecord.deleteMany({});
  await prisma.emptyBottleLog.deleteMany({});
  await prisma.route.deleteMany({});
  await prisma.deliveryPerson.deleteMany({});

  // 1. Create a single DP
  const dp = await prisma.deliveryPerson.create({
    data: {
      dpCode: 'UNIT_DP',
      name: 'Test DP Performance',
      mobileNumber: '1111111111',
      isActive: true,
    }
  });

  // 2. Create 2 known routes
  const route1 = await prisma.route.create({
    data: { name: 'Unit Route 1', zone: 'Test Zone' }
  });
  const route2 = await prisma.route.create({
    data: { name: 'Unit Route 2', zone: 'Test Zone' }
  });

  // 3. Assign the 2 routes to the DP on the known day.
  // One is ASSIGNED and one is COMPLETED to test the query logic correctly sums both.
  await prisma.routeAllocation.create({
    data: {
      routeId: route1.id,
      dpId: dp.id,
      date: dateStr,
      litresAllocated: 45.5,
      status: 'ASSIGNED',
    }
  });

  await prisma.routeAllocation.create({
    data: {
      routeId: route2.id,
      dpId: dp.id,
      date: dateStr,
      litresAllocated: 54.5, // Will be overridden by actuals
      status: 'COMPLETED',
    }
  });

  // Since it's COMPLETED, create the corresponding EmptyBottleLog with actuals
  await prisma.emptyBottleLog.create({
    data: {
      routeId: route2.id,
      dpId: dp.id,
      date: dateStr,
      deliveryCompleted: true,
      actualDelivered1L: 40,
      actualDeliveredHalfL: 15,
      // actuals = 40*1 + 15*0.5 = 47.5L
    }
  });

  // 4. Fetch the report
  const report = await getDpPerformance('today');
  
  // 5. Assert the exact matching Litres and Routes count from Route Allocation data
  const testDpReport = report.find(r => r.dpId === dp.id);
  
  assert.ok(testDpReport, 'Test DP not found in report');
  assert.strictEqual(testDpReport.totalRoutes, 2, `Expected 2 routes, got ${testDpReport.totalRoutes}`);
  // ASSIGNED route has 45.5L allocated. COMPLETED route has 47.5L actuals. Total = 93L
  assert.strictEqual(testDpReport.totalLitres, 93, `Expected 93 litres, got ${testDpReport.totalLitres}`);
  
  console.log('✅ Unit test passed: Litres and Routes perfectly match the underlying route allocation data per DP.');
}

runTest()
  .catch(err => {
    console.error('❌ Unit test failed:', err);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
