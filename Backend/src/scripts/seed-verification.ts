import { prisma } from '../config/db';
import { getISTStartOfMonthString, getISTDateString } from '../utils/date';

async function seedAndVerify() {
  const now = new Date();
  const today = getISTDateString(now);
  const startOfMonth = getISTStartOfMonthString(now);
  console.log(`Generating data from ${startOfMonth} to ${today}`);

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

  // 1. DP with ONLY ASSIGNED routes
  const dpAssigned = await prisma.deliveryPerson.create({
    data: { dpCode: 'DP-A', name: 'Assigned Only', mobileNumber: '111', isActive: true }
  });

  // 2. DP with ONLY COMPLETED routes
  const dpCompleted = await prisma.deliveryPerson.create({
    data: { dpCode: 'DP-C', name: 'Completed Only', mobileNumber: '222', isActive: true }
  });

  // 3. DP with a MIX of ASSIGNED and COMPLETED routes
  const dpMixed = await prisma.deliveryPerson.create({
    data: { dpCode: 'DP-M', name: 'Mixed Routes', mobileNumber: '333', isActive: true }
  });

  const route1 = await prisma.route.create({ data: { name: 'Route A', zone: 'Zone 1' }});
  const route2 = await prisma.route.create({ data: { name: 'Route B', zone: 'Zone 2' }});
  const route3 = await prisma.route.create({ data: { name: 'Route C', zone: 'Zone 3' }});
  const route4 = await prisma.route.create({ data: { name: 'Route D', zone: 'Zone 4' }});
  const route5 = await prisma.route.create({ data: { name: 'Route E', zone: 'Zone 5' }});
  const route6 = await prisma.route.create({ data: { name: 'Route F', zone: 'Zone 6' }});

  // --- Insert Data ---
  
  // DP-A: 2 ASSIGNED routes
  await prisma.routeAllocation.create({ data: { routeId: route1.id, dpId: dpAssigned.id, date: startOfMonth, litresAllocated: 10, status: 'ASSIGNED' }});
  await prisma.routeAllocation.create({ data: { routeId: route2.id, dpId: dpAssigned.id, date: today, litresAllocated: 15, status: 'ASSIGNED' }});
  await prisma.attendanceRecord.create({ data: { dpId: dpAssigned.id, date: startOfMonth, status: 'PRESENT', markedByManagerId: manager.id }});

  // DP-C: 2 COMPLETED routes (with empty bottle logs showing actuals)
  await prisma.routeAllocation.create({ data: { routeId: route3.id, dpId: dpCompleted.id, date: startOfMonth, litresAllocated: 20, status: 'COMPLETED' }});
  await prisma.emptyBottleLog.create({ 
    data: { routeId: route3.id, dpId: dpCompleted.id, date: startOfMonth, deliveryCompleted: true, oneLBottlesCollected: 5, halfLBottlesCollected: 10, actualDelivered1L: 10, actualDeliveredHalfL: 20 } // Actual: 10*1 + 20*0.5 = 20L
  });
  
  await prisma.routeAllocation.create({ data: { routeId: route4.id, dpId: dpCompleted.id, date: today, litresAllocated: 30, status: 'COMPLETED' }});
  await prisma.emptyBottleLog.create({ 
    data: { routeId: route4.id, dpId: dpCompleted.id, date: today, deliveryCompleted: true, oneLBottlesCollected: 10, halfLBottlesCollected: 0, actualDelivered1L: 15, actualDeliveredHalfL: 10 } // Actual: 15*1 + 10*0.5 = 20L (Partial delivery, allocated was 30L)
  });
  await prisma.attendanceRecord.create({ data: { dpId: dpCompleted.id, date: startOfMonth, status: 'PRESENT', markedByManagerId: manager.id }});
  await prisma.attendanceRecord.create({ data: { dpId: dpCompleted.id, date: today, status: 'ABSENT', markedByManagerId: manager.id }});

  // DP-M: 1 ASSIGNED, 1 COMPLETED
  await prisma.routeAllocation.create({ data: { routeId: route5.id, dpId: dpMixed.id, date: startOfMonth, litresAllocated: 50, status: 'COMPLETED' }});
  await prisma.emptyBottleLog.create({ 
    data: { routeId: route5.id, dpId: dpMixed.id, date: startOfMonth, deliveryCompleted: true, oneLBottlesCollected: 25, halfLBottlesCollected: 0, actualDelivered1L: 25, actualDeliveredHalfL: 0 } // Actual: 25L (Partial delivery, allocated was 50L)
  });
  
  await prisma.routeAllocation.create({ data: { routeId: route6.id, dpId: dpMixed.id, date: today, litresAllocated: 10, status: 'ASSIGNED' }});
  
  console.log('Seed data created. Fetching DP Performance for This Month...');
  const { getDpPerformance } = require('../modules/reports/reports.service');
  const report = await getDpPerformance('month');
  
  console.log('--- DP Performance Report ---');
  report.forEach((r: any) => {
    console.log(`DP Code: ${r.dpCode} | Name: ${r.name}`);
    console.log(`Litres: ${r.totalLitres}L | Routes: ${r.totalRoutes} | Attd: ${r.attendanceRatio} | Bottles: ${r.totalBottles}`);
    console.log('-----------------------------');
  });
}

seedAndVerify()
  .catch(console.error)
  .finally(() => prisma.$disconnect());
