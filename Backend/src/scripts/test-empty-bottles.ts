import { prisma } from '../config/db';
import { updateEmptyBottleLog, getEmptyBottleStatus } from '../modules/empty-bottles/empty-bottles.service';

async function main() {
  const testRouteId = 'test-route-' + Date.now();
  const testDpId = 'test-dp-' + Date.now();
  const date = '2026-08-06';

  // 1. Create a dummy route and dp
  const route = await prisma.route.create({
    data: { id: testRouteId, name: 'Test Route', zone: 'Test Zone' }
  });
  const dp = await prisma.deliveryPerson.create({
    data: { id: testDpId, dpCode: 'T' + Date.now(), name: 'Test DP', mobileNumber: '1234567890' }
  });
  const alloc = await prisma.routeAllocation.create({
    data: { id: 'alloc' + Date.now(), routeId: testRouteId, dpId: testDpId, date, litresAllocated: 50, status: 'ASSIGNED', qty1LBottle: 0, qtyHalfLBottle: 0, qtyHalfLPacket: 0 }
  });

  // 2. Start at balance = 10
  await prisma.routeEmptyBottleBalance.create({
    data: { routeId: testRouteId, bottleType: '1L', balance: 10 }
  });

  console.log('--- Initial State ---');
  let balances = await prisma.routeEmptyBottleBalance.findMany({ where: { routeId: testRouteId } });
  console.log('Initial balance (1L):', balances.find(b => b.bottleType === '1L')?.balance);

  // 3. Save Return Check with collected = 3, broken = 2
  console.log('\n--- Return Check: collected = 3, broken = 2 ---');
  await updateEmptyBottleLog(testRouteId, date, {
    deliveryCompleted: true,
    oneLBottlesCollected: 3,
    halfLBottlesCollected: 0,
    halfLPacketCollected: 0,
    actualDelivered1L: 0,
    actualDeliveredHalfL: 0,
    actualDeliveredPacket: 0,
    flagIssue: true,
    brokenBottleCount1L: 2,
    brokenBottleCountHalfL: 0,
  });

  balances = await prisma.routeEmptyBottleBalance.findMany({ where: { routeId: testRouteId } });
  console.log('Balance (1L):', balances.find(b => b.bottleType === '1L')?.balance);

  // Check expected reconstruction
  const status1 = await getEmptyBottleStatus(date);
  const myStatus1 = status1.find(s => s.routeId === testRouteId);
  console.log('Re-open Expected (1L):', myStatus1?.expected1LBottles, '(should be 10)');

  // 4. Edit to collected = 3, broken = 5
  console.log('\n--- Return Check Edit: collected = 3, broken = 5 ---');
  await updateEmptyBottleLog(testRouteId, date, {
    deliveryCompleted: true,
    oneLBottlesCollected: 3,
    halfLBottlesCollected: 0,
    halfLPacketCollected: 0,
    actualDelivered1L: 0,
    actualDeliveredHalfL: 0,
    actualDeliveredPacket: 0,
    flagIssue: true,
    brokenBottleCount1L: 5,
    brokenBottleCountHalfL: 0,
  });

  balances = await prisma.routeEmptyBottleBalance.findMany({ where: { routeId: testRouteId } });
  console.log('Balance (1L):', balances.find(b => b.bottleType === '1L')?.balance);

  // 5. Edit to collected = 3, broken = 1
  console.log('\n--- Return Check Edit: collected = 3, broken = 1 ---');
  await updateEmptyBottleLog(testRouteId, date, {
    deliveryCompleted: true,
    oneLBottlesCollected: 3,
    halfLBottlesCollected: 0,
    halfLPacketCollected: 0,
    actualDelivered1L: 0,
    actualDeliveredHalfL: 0,
    actualDeliveredPacket: 0,
    flagIssue: true,
    brokenBottleCount1L: 1,
    brokenBottleCountHalfL: 0,
  });

  balances = await prisma.routeEmptyBottleBalance.findMany({ where: { routeId: testRouteId } });
  console.log('Final Balance (1L):', balances.find(b => b.bottleType === '1L')?.balance);

  // 6. Over-collect + broken test
  console.log('\n--- Over-collect + Broken Edge Case ---');
  // Reset balance to 5 for new test, clear log
  await prisma.emptyBottleLog.deleteMany({ where: { routeId: testRouteId } });
  await prisma.routeEmptyBottleBalance.update({
    where: { routeId_bottleType: { routeId: testRouteId, bottleType: '1L' } },
    data: { balance: 5 }
  });
  
  console.log('New Initial Balance (1L): 5');
  
  await updateEmptyBottleLog(testRouteId, date, {
    deliveryCompleted: true,
    oneLBottlesCollected: 4,
    halfLBottlesCollected: 0,
    halfLPacketCollected: 0,
    actualDelivered1L: 0,
    actualDeliveredHalfL: 0,
    actualDeliveredPacket: 0,
    flagIssue: true,
    brokenBottleCount1L: 3,
    brokenBottleCountHalfL: 0,
  });

  balances = await prisma.routeEmptyBottleBalance.findMany({ where: { routeId: testRouteId } });
  console.log('Balance after over-collect (should be -2):', balances.find(b => b.bottleType === '1L')?.balance);
  const status2 = await getEmptyBottleStatus(date);
  const myStatus2 = status2.find(s => s.routeId === testRouteId);
  console.log('UI Expected (1L) (should be 5):', myStatus2?.expected1LBottles);
  // Wait, expected on reopen should be: live_balance(-2) + collected(4) + broken(3) = 5. UI expected doesn't go below 0 unless expected itself goes below 0. 

  await updateEmptyBottleLog(testRouteId, date, {
    deliveryCompleted: true,
    oneLBottlesCollected: 2,
    halfLBottlesCollected: 0,
    halfLPacketCollected: 0,
    actualDelivered1L: 0,
    actualDeliveredHalfL: 0,
    actualDeliveredPacket: 0,
    flagIssue: true,
    brokenBottleCount1L: 1,
    brokenBottleCountHalfL: 0,
  });

  balances = await prisma.routeEmptyBottleBalance.findMany({ where: { routeId: testRouteId } });
  console.log('Final Balance after correction (should be 2):', balances.find(b => b.bottleType === '1L')?.balance);

  // Cleanup
  await prisma.emptyBottleLog.deleteMany({ where: { routeId: testRouteId } });
  await prisma.routeAllocation.deleteMany({ where: { routeId: testRouteId } });
  await prisma.routeEmptyBottleBalance.deleteMany({ where: { routeId: testRouteId } });
  await prisma.route.delete({ where: { id: testRouteId } });
  await prisma.deliveryPerson.delete({ where: { id: testDpId } });
}

main().catch(console.error).finally(() => prisma.$disconnect());
