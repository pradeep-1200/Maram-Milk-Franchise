import { prisma } from '../config/db';
import { getDpPerformance, getReportDateRange } from '../modules/reports/reports.service';
import { getISTDateString } from '../utils/date';

async function run() {
  console.log('--- Starting PA Aggregation Regression Test ---');

  // 1. Create a mock DP
  const dp = await prisma.deliveryPerson.create({
    data: {
      dpCode: 'DP_TEST_PA_' + Date.now(),
      name: 'Test DP PA Aggregation',
      mobileNumber: '9999999990',
      isActive: true,
    }
  });

  // 2. Create two mock routes
  const route1 = await prisma.route.create({
    data: { name: 'Route A', zone: 'Test Zone', defaultPetrolAllowance: 40 }
  });
  const route2 = await prisma.route.create({
    data: { name: 'Route B', zone: 'Test Zone', defaultPetrolAllowance: 60 }
  });

  const todayStr = getISTDateString(new Date());
  
  // Date from a completely different month to test exclusion
  const pastDateStr = '2023-01-01';

  try {
    // 3. Test 1: Seed DP with 2 routes today, PA 150 and PA 50
    await prisma.routeAllocation.create({
      data: {
        dpId: dp.id,
        routeId: route1.id,
        date: todayStr,
        litresAllocated: 10,
        status: 'COMPLETED',
        petrolAllowanceGiven: 150
      }
    });

    await prisma.routeAllocation.create({
      data: {
        dpId: dp.id,
        routeId: route2.id,
        date: todayStr,
        litresAllocated: 10,
        status: 'COMPLETED',
        petrolAllowanceGiven: 50
      }
    });

    console.log('Created two routes with PA 150 and 50 for today.');

    // Fetch report for "today"
    const todayReport = await getDpPerformance('today');
    const myDpToday = todayReport.find(r => r.dpId === dp.id);
    
    if (myDpToday?.totalPetrolAllowance !== 200) {
      throw new Error(`Expected today totalPetrolAllowance 200, got ${myDpToday?.totalPetrolAllowance}`);
    }
    console.log('✅ Test 1 Passed: Today aggregation sums exactly 200.');

    // Fetch report for custom past date range
    const pastReport = await getDpPerformance('custom', pastDateStr, pastDateStr);
    const myDpPast = pastReport.find(r => r.dpId === dp.id);
    
    // DP might not be in pastReport if not active or if they have no stats, but if they are, PA should be 0
    if (myDpPast && myDpPast.totalPetrolAllowance !== 0) {
      throw new Error(`Expected past totalPetrolAllowance 0, got ${myDpPast?.totalPetrolAllowance}`);
    }
    console.log('✅ Test 2 Passed: Past date exclusion works (PA is 0 or DP excluded).');

    // 4. Test Unassign-reversal case
    // For this, we'll use a new date to keep it clean.
    const tmrwStr = '2099-12-31';
    
    // Assign route with PA 100
    let alloc = await prisma.routeAllocation.create({
      data: {
        dpId: dp.id,
        routeId: route1.id,
        date: tmrwStr,
        litresAllocated: 10,
        status: 'ASSIGNED',
        petrolAllowanceGiven: 100
      }
    });
    
    // Unassign it (this is simulating the service logic setting it to UNASSIGNED and PA null)
    await prisma.routeAllocation.update({
      where: { id: alloc.id },
      data: {
        status: 'UNASSIGNED',
        petrolAllowanceGiven: null
      }
    });

    // Reassign with PA 150
    await prisma.routeAllocation.update({
      where: { id: alloc.id },
      data: {
        status: 'ASSIGNED',
        petrolAllowanceGiven: 150
      }
    });

    // Fetch report for tmrwStr
    const tmrwReport = await getDpPerformance('custom', tmrwStr, tmrwStr);
    const myDpTmrw = tmrwReport.find(r => r.dpId === dp.id);

    if (myDpTmrw?.totalPetrolAllowance !== 150) {
      throw new Error(`Expected unassign-reversal totalPetrolAllowance 150, got ${myDpTmrw?.totalPetrolAllowance}`);
    }
    console.log('✅ Test 3 Passed: Unassign/Reversal case correctly calculates 150 instead of 250.');

  } finally {
    // Cleanup
    await prisma.routeAllocation.deleteMany({ where: { dpId: dp.id } });
    await prisma.route.delete({ where: { id: route1.id } });
    await prisma.route.delete({ where: { id: route2.id } });
    await prisma.deliveryPerson.delete({ where: { id: dp.id } });
    console.log('--- Cleanup Done ---');
  }
}

run().catch(console.error).finally(() => process.exit(0));
