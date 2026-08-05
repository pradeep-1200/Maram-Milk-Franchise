import { prisma } from '../config/db';
import { updateRouteAllocation } from '../modules/routes/routes.service';

async function run() {
  console.log('Starting Ledger Intent Regression Test...');

  // 1. Setup test data
  const dp = await prisma.deliveryPerson.create({
    data: { name: 'Test DP', dpCode: 'TDP01', mobileNumber: '1234567890', petrolBalance: 0 }
  });
  
  const route = await prisma.route.create({
    data: { name: 'Test Route', zone: 'Test Zone', litres: 10, defaultPetrolAllowance: 50 }
  });

  const date = new Date().toISOString().split('T')[0];

  try {
    console.log('Test 1: Assign Route (No PA given) - Should NOT create ledger entry');
    await updateRouteAllocation(
      route.id,
      date,
      dp.id,
      10,
      'ASSIGNED',
      undefined, undefined, undefined,
      undefined // Explicitly undefined PA
    );

    let ledgers = await prisma.ledgerTransaction.findMany({ where: { routeId: route.id, date } });
    if (ledgers.length !== 0) throw new Error(`Test 1 Failed: Expected 0 ledgers, found ${ledgers.length}`);
    console.log('Test 1 Passed.');

    console.log('Test 2: Mark Petrol Allowance Complete - Should create 1 ledger entry');
    await updateRouteAllocation(
      route.id,
      date,
      dp.id,
      10,
      'ASSIGNED',
      undefined, undefined, undefined,
      80 // Explicit PA given
    );

    ledgers = await prisma.ledgerTransaction.findMany({ where: { routeId: route.id, date } });
    if (ledgers.length !== 1) throw new Error(`Test 2 Failed: Expected 1 ledger, found ${ledgers.length}`);
    if (ledgers[0].amount !== 80) throw new Error(`Test 2 Failed: Expected ledger amount 80, found ${ledgers[0].amount}`);
    console.log('Test 2 Passed.');

    console.log('Test 3: Edit Allocation (No PA passed in edit) - Should preserve 1 ledger entry with 80');
    await updateRouteAllocation(
      route.id,
      date,
      dp.id,
      15, // Changed litres
      'ASSIGNED',
      undefined, undefined, undefined,
      undefined // Explicitly undefined PA
    );

    ledgers = await prisma.ledgerTransaction.findMany({ where: { routeId: route.id, date } });
    if (ledgers.length !== 1) throw new Error(`Test 3 Failed: Expected 1 ledger, found ${ledgers.length}`);
    if (ledgers[0].amount !== 80) throw new Error(`Test 3 Failed: Expected ledger amount 80, found ${ledgers[0].amount}`);
    console.log('Test 3 Passed.');

    console.log('Test 4: Edit PA again - Should replace with new PA amount, still exactly 1 ledger');
    await updateRouteAllocation(
      route.id,
      date,
      dp.id,
      15,
      'ASSIGNED',
      undefined, undefined, undefined,
      30 // Changed PA given
    );

    ledgers = await prisma.ledgerTransaction.findMany({ where: { routeId: route.id, date } });
    if (ledgers.length !== 1) throw new Error(`Test 4 Failed: Expected 1 ledger, found ${ledgers.length}`);
    if (ledgers[0].amount !== 30) throw new Error(`Test 4 Failed: Expected ledger amount 30, found ${ledgers[0].amount}`);
    console.log('Test 4 Passed.');

    console.log('Test 5: Unassign Route - Should delete ledger entry');
    await updateRouteAllocation(
      route.id,
      date,
      dp.id,
      0,
      'UNASSIGNED',
      undefined, undefined, undefined,
      undefined
    );

    ledgers = await prisma.ledgerTransaction.findMany({ where: { routeId: route.id, date } });
    if (ledgers.length !== 0) throw new Error(`Test 5 Failed: Expected 0 ledgers, found ${ledgers.length}`);
    console.log('Test 5 Passed.');

  } finally {
    // Cleanup
    await prisma.routeAllocation.deleteMany({ where: { routeId: route.id } });
    await prisma.ledgerTransaction.deleteMany({ where: { routeId: route.id } });
    await prisma.route.delete({ where: { id: route.id } });
    await prisma.deliveryPerson.delete({ where: { id: dp.id } });
    await prisma.$disconnect();
  }
}

run().catch(console.error);
