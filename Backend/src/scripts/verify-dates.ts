// @ts-nocheck
import { prisma } from '../config/db';
import { getISTDateString } from '../utils/date';
import { getDpPerformance } from '../modules/reports/reports.service';

async function verifyManualTest() {
  console.log('--- Manual Verification Test ---');

  // Clean DB
  await prisma.routeAllocation.deleteMany({});
  await prisma.attendanceRecord.deleteMany({});
  await prisma.emptyBottleLog.deleteMany({});
  await prisma.route.deleteMany({});
  await prisma.deliveryPerson.deleteMany({});
  await prisma.manager.deleteMany({});
  
  const manager = await prisma.manager.create({
    data: { name: 'Test Manager', email: 'test@example.com', passwordHash: 'hash', branchName: 'Branch 1' }
  });

  const dp = await prisma.deliveryPerson.create({
    data: { dpCode: 'DP-TEST', name: 'Test DP', mobileNumber: '111', isActive: true }
  });

  const route1 = await prisma.route.create({ data: { name: 'Route A', zone: 'Zone 1' }});

  // Calculate dates
  const now = new Date();
  const todayStr = getISTDateString(now);
  
  // Create 3 different days spanning this week but not today
  // Let's assume today is Thursday (2024-01-18 for the sake of example, but we'll dynamically subtract days)
  const daysInWeek = [1, 2, 3].map(daysAgo => {
    const d = new Date(now);
    d.setDate(d.getDate() - daysAgo);
    return getISTDateString(d);
  });

  console.log('Today:', todayStr);
  console.log('Days in Week (not today):', daysInWeek);

  // Insert routes for the 3 days
  for (const date of daysInWeek) {
    await prisma.routeAllocation.create({ 
      data: { routeId: route1.id, dpId: dp.id, date, litresAllocated: 10, status: 'COMPLETED' }
    });
    // Add bottle logs so litres are counted
    await prisma.emptyBottleLog.create({ 
      data: { routeId: route1.id, dpId: dp.id, date, deliveryCompleted: true, actualDelivered1L: 10 }
    });
  }

  // Add one route for custom test (e.g. 10 days ago)
  const dCustom = new Date(now);
  dCustom.setDate(dCustom.getDate() - 10);
  const customStr = getISTDateString(dCustom);
  await prisma.routeAllocation.create({ 
    data: { routeId: route1.id, dpId: dp.id, date: customStr, litresAllocated: 20, status: 'COMPLETED' }
  });
  await prisma.emptyBottleLog.create({ 
    data: { routeId: route1.id, dpId: dp.id, date: customStr, deliveryCompleted: true, actualDelivered1L: 20 }
  });
  console.log('Custom Date:', customStr);

  // 1. "Today"
  const todayReport = await getDpPerformance('today');
  console.log('Today Report Litres:', todayReport.find(r => r.dpId === dp.id)?.totalLitres); // Expected 0

  // 2. "This Week"
  const weekReport = await getDpPerformance('week');
  console.log('Week Report Litres:', weekReport.find(r => r.dpId === dp.id)?.totalLitres); // Expected 30 if all 3 days are within this week. (Wait, if one day was Sunday, it might not be in this week! But we'll see.)

  // 3. "This Month"
  const monthReport = await getDpPerformance('month');
  console.log('Month Report Litres:', monthReport.find(r => r.dpId === dp.id)?.totalLitres); // Expected 30 + 20 = 50 (if custom date is in same month)

  // 4. "Custom"
  const customReport = await getDpPerformance('custom', customStr, customStr);
  console.log('Custom Report Litres:', customReport.find(r => r.dpId === dp.id)?.totalLitres); // Expected 20
}

verifyManualTest()
  .catch(console.error)
  .finally(() => prisma.$disconnect());
