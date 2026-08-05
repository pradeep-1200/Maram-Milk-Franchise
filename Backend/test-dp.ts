import { prisma } from './src/config/db';
import { getDpPerformance } from './src/modules/reports/reports.service';
import { getISTDateString } from './src/utils/date';

async function runTest() {
  const now = new Date();
  const dateStr = getISTDateString(now);

  console.log('Creating test data for date:', dateStr);

  // Clear relevant test data
  await prisma.routeAllocation.deleteMany({});
  await prisma.attendanceRecord.deleteMany({});
  await prisma.emptyBottleLog.deleteMany({});
  await prisma.route.deleteMany({});
  await prisma.deliveryPerson.deleteMany({});

  // Create DP 1
  const dp1 = await prisma.deliveryPerson.create({
    data: {
      dpCode: 'DP001',
      name: 'Test DP 1',
      mobileNumber: '1234567890',
      isActive: true,
    }
  });

  // Create DP 2
  const dp2 = await prisma.deliveryPerson.create({
    data: {
      dpCode: 'DP002',
      name: 'Test DP 2',
      mobileNumber: '0987654321',
      isActive: true,
    }
  });

  // Create Route 1 & 2
  const route1 = await prisma.route.create({
    data: {
      name: 'Route 1',
      zone: 'Zone A',
    }
  });
  
  const route2 = await prisma.route.create({
    data: {
      name: 'Route 2',
      zone: 'Zone B',
    }
  });

  // Create Route Allocations for DP 1
  await prisma.routeAllocation.create({
    data: {
      routeId: route1.id,
      dpId: dp1.id,
      date: dateStr,
      litresAllocated: 50,
      status: 'ASSIGNED',
    }
  });

  await prisma.routeAllocation.create({
    data: {
      routeId: route2.id,
      dpId: dp1.id,
      date: dateStr,
      litresAllocated: 60,
      status: 'ASSIGNED',
    }
  });

  const route3 = await prisma.route.create({
    data: {
      name: 'Route 3',
      zone: 'Zone C',
    }
  });

  // Create Route Allocation for DP 2
  await prisma.routeAllocation.create({
    data: {
      routeId: route3.id,
      dpId: dp2.id,
      date: dateStr,
      litresAllocated: 30,
      status: 'ASSIGNED',
    }
  });


  // Fetch report
  const report = await getDpPerformance('today');
  console.log('Report output:', JSON.stringify(report, null, 2));

  // Clean up
  // await prisma.routeAllocation.deleteMany({});
  // await prisma.route.deleteMany({});
  // await prisma.deliveryPerson.deleteMany({});
}

runTest()
  .catch(console.error)
  .finally(() => prisma.$disconnect());
