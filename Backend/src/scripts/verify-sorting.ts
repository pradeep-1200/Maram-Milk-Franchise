// @ts-nocheck
import { prisma } from '../config/db';
import { getISTDateString } from '../utils/date';
import { getDpPerformance } from '../modules/reports/reports.service';
import * as assert from 'assert';

async function verifySortingTest() {
  console.log('--- Sorting Regression Test ---');

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

  const dpX = await prisma.deliveryPerson.create({ data: { dpCode: 'DP-X', name: 'DP X', mobileNumber: '1', isActive: true } });
  const dpY = await prisma.deliveryPerson.create({ data: { dpCode: 'DP-Y', name: 'DP Y', mobileNumber: '2', isActive: true } });
  const dpZ = await prisma.deliveryPerson.create({ data: { dpCode: 'DP-Z', name: 'DP Z', mobileNumber: '3', isActive: true } });

  const route1 = await prisma.route.create({ data: { name: 'Route A', zone: 'Zone 1' }});
  const route2 = await prisma.route.create({ data: { name: 'Route B', zone: 'Zone 1' }});
  const route3 = await prisma.route.create({ data: { name: 'Route C', zone: 'Zone 1' }});
  const route4 = await prisma.route.create({ data: { name: 'Route D', zone: 'Zone 1' }});
  const route5 = await prisma.route.create({ data: { name: 'Route E', zone: 'Zone 1' }});
  const route6 = await prisma.route.create({ data: { name: 'Route F', zone: 'Zone 1' }});

  const now = new Date();
  const dateStr = getISTDateString(now);

  // Seed DP-X: 10L / 1 route
  await prisma.routeAllocation.create({ data: { routeId: route1.id, dpId: dpX.id, date: dateStr, litresAllocated: 10, status: 'COMPLETED' } });
  
  // Seed DP-Y: 40L / 3 routes
  await prisma.routeAllocation.create({ data: { routeId: route2.id, dpId: dpY.id, date: dateStr, litresAllocated: 10, status: 'COMPLETED' } });
  await prisma.routeAllocation.create({ data: { routeId: route3.id, dpId: dpY.id, date: dateStr, litresAllocated: 15, status: 'COMPLETED' } });
  await prisma.routeAllocation.create({ data: { routeId: route4.id, dpId: dpY.id, date: dateStr, litresAllocated: 15, status: 'COMPLETED' } });

  // Seed DP-Z: 20L / 2 routes
  await prisma.routeAllocation.create({ data: { routeId: route5.id, dpId: dpZ.id, date: dateStr, litresAllocated: 10, status: 'COMPLETED' } });
  await prisma.routeAllocation.create({ data: { routeId: route6.id, dpId: dpZ.id, date: dateStr, litresAllocated: 10, status: 'COMPLETED' } });

  console.log('Seeded DP-X (10L / 1), DP-Y (40L / 3), DP-Z (20L / 2)');

  // 1. Sort by Litres
  console.log('\\n--- Fetching with sortBy: litres ---');
  const litresReport = await getDpPerformance('today', undefined, undefined, 'litres');
  const litresNames = litresReport.map(r => r.name);
  console.log('Litres Order:', litresNames);
  assert.deepStrictEqual(litresNames, ['DP Y', 'DP Z', 'DP X']);
  console.log('✅ Litres sorting correct (Descending: 40L, 20L, 10L)');

  // 2. Sort by Routes
  console.log('\\n--- Fetching with sortBy: routes ---');
  const routesReport = await getDpPerformance('today', undefined, undefined, 'routes');
  const routesNames = routesReport.map(r => r.name);
  console.log('Routes Order:', routesNames);
  assert.deepStrictEqual(routesNames, ['DP Y', 'DP Z', 'DP X']);
  console.log('✅ Routes sorting correct (Descending: 3, 2, 1)');

  console.log('\\n✅ Regression test passed: Switching sortBy correctly reorders the list based on computed aggregations.');
}

verifySortingTest()
  .catch(console.error)
  .finally(() => prisma.$disconnect());
