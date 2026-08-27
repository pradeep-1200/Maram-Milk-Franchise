// @ts-nocheck
import { prisma } from '../config/db';
import * as crypto from 'crypto';

async function main() {
  console.log('--- STARTING SEED TEST DATA SCRIPT ---');
  
  // 1. Clear transactional tables
  console.log('Clearing old transactional data...');
  await prisma.emptyBottleLog.deleteMany({});
  await prisma.routeAllocation.deleteMany({});
  await prisma.attendanceRecord.deleteMany({});
  await prisma.ledgerTransaction.deleteMany({});
  await prisma.inventoryDailyRecord.deleteMany({});
  await prisma.dispatchDay.deleteMany({});
  
  console.log('Cleared transactional data successfully.');

  // 2. Fetch base data (DPs, Routes, Inventory Items)
  const dps = await prisma.deliveryPerson.findMany();
  const routes = await prisma.route.findMany();
  const items = await prisma.inventoryItem.findMany();
  
  if (dps.length === 0 || routes.length === 0 || items.length === 0) {
    console.error('Missing base data (DPs, Routes, Inventory Items). Please run base seed first.');
    process.exit(1);
  }
  
  // 3. Generate 30 days of data ending *yesterday* (so today is fresh)
  const today = new Date();
  today.setHours(0, 0, 0, 0); // start of day local time
  
  // Helper to get YYYY-MM-DD
  const formatDate = (date: Date) => {
    const d = new Date(date);
    d.setMinutes(d.getMinutes() - d.getTimezoneOffset());
    return d.toISOString().split('T')[0];
  };

  const days = [];
  for (let i = 30; i > 0; i--) {
    const d = new Date(today);
    d.setDate(d.getDate() - i);
    days.push(formatDate(d));
  }
  
  console.log(`Generating data for ${days.length} days: ${days[0]} to ${days[days.length - 1]}`);

  // Fetch the manager to mark attendance
  const manager = await prisma.manager.findFirst();
  if (!manager) {
    console.error('No manager found.');
    process.exit(1);
  }

  // Generate data per day
  let carriedExpected = new Map<string, number>(); // Item ID -> expected stock
  items.forEach(i => carriedExpected.set(i.id, 500)); // Start with 500

  for (const date of days) {
    console.log(`Processing day: ${date}...`);
    
    // A. Attendance
    // DP attendance logic: Mostly present
    const presentDps = [];
    for (const dp of dps) {
      const rand = Math.random();
      let status: 'PRESENT' | 'ABSENT' | 'STANDBY' = 'PRESENT';
      if (rand > 0.9) status = 'ABSENT';
      else if (rand > 0.85) status = 'STANDBY';
      
      await prisma.attendanceRecord.create({
        data: {
          dpId: dp.id,
          date,
          status,
          markedByManagerId: manager.id,
        }
      });
      
      if (status === 'PRESENT' || status === 'STANDBY') {
        presentDps.push(dp);
      }
    }
    
    // B. Inventory
    let totalLitersUsed = 0;
    
    for (const item of items) {
      let expected = carriedExpected.get(item.id) || 0;
      // Add random new stock every few days
      let newStock = 0;
      if (Math.random() > 0.7) {
        newStock = 200; 
      }
      expected += newStock;
      
      let variance = 0;
      if (Math.random() > 0.95) variance = -1; // 1 short
      
      const current = expected + variance;
      
      await prisma.inventoryDailyRecord.create({
        data: {
          inventoryItemId: item.id,
          date,
          expectedStock: expected,
          currentStock: current,
          carriedOverStock: expected - newStock,
          newStockAdded: newStock,
        }
      });
      
      // we'll subtract routes allocation later from carriedExpected for tomorrow
    }
    
    // C. Route Allocation
    // Assign routes to present DPs
    let assignedDpIndex = 0;
    let dayTotalPetrol = 0;
    
    for (const route of routes) {
      if (assignedDpIndex >= presentDps.length) break; // Out of DPs
      const dp = presentDps[assignedDpIndex];
      
      // Math.random() for assigned or unassigned
      const isAssigned = Math.random() > 0.1; // 90% assigned
      if (!isAssigned) continue;
      
      const litresAllocated = route.litres;
      const qty1LBottle = Math.floor(litresAllocated * 0.7);
      const qtyHalfLBottle = Math.floor((litresAllocated * 0.3) * 2);
      
      await prisma.routeAllocation.create({
        data: {
          routeId: route.id,
          dpId: dp.id,
          date,
          litresAllocated,
          qty1LBottle,
          qtyHalfLBottle,
          petrolAllowanceGiven: route.defaultPetrolAllowance,
          status: 'ASSIGNED',
        }
      });
      
      dayTotalPetrol += route.defaultPetrolAllowance;
      
      // Update inventory subtract for next day
      for (const item of items) {
        let current = carriedExpected.get(item.id) || 0;
        if (item.unit === '1L') {
          current -= qty1LBottle;
        } else if (item.unit === '500ml') {
          current -= qtyHalfLBottle;
        }
        carriedExpected.set(item.id, Math.max(0, current));
      }
      
      // D. Empty Bottle Log
      const isCompleted = Math.random() > 0.1; // 90% completed
      if (isCompleted) {
        let flagIssue = Math.random() > 0.9;
        await prisma.emptyBottleLog.create({
          data: {
            routeId: route.id,
            dpId: dp.id,
            date,
            deliveryCompleted: true,
            oneLBottlesCollected: qty1LBottle - (flagIssue ? 1 : 0),
            halfLBottlesCollected: qtyHalfLBottle,
            flagIssue,
          }
        });
      }
      
      // E. Ledger Transaction (Petrol)
      // Mostly Fully Paid, some short, some extra
      const r = Math.random();
      let ledgerType: 'PETROL_ALLOWANCE' | 'SHORTAGE' | 'EXTRA_PAID' = 'PETROL_ALLOWANCE';
      let amount = route.defaultPetrolAllowance;
      
      if (r > 0.9) {
        ledgerType = 'SHORTAGE';
        amount = amount - 50;
      } else if (r > 0.8) {
        ledgerType = 'EXTRA_PAID';
        amount = amount + 50;
      }
      
      if (amount > 0) {
        await prisma.ledgerTransaction.create({
          data: {
            dpId: dp.id,
            type: ledgerType,
            amount,
            date,
            routeId: route.id,
            note: 'Test data seed',
          }
        });
      }
      
      assignedDpIndex++;
    }
    
    // F. DispatchDay
    // Use an index based on the date difference from today
    const currentDayDate = new Date(date);
    const dayDiff = Math.floor((today.getTime() - currentDayDate.getTime()) / (24 * 60 * 60 * 1000));
    
    await prisma.dispatchDay.create({
      data: {
        date,
        attendanceCompletedAt: new Date(today.getTime() - dayDiff * 24 * 60 * 60 * 1000 + 6 * 60 * 60 * 1000), // 6 AM
        inventoryCompletedAt: new Date(today.getTime() - dayDiff * 24 * 60 * 60 * 1000 + 6.5 * 60 * 60 * 1000),
        routesCompletedAt: new Date(today.getTime() - dayDiff * 24 * 60 * 60 * 1000 + 7 * 60 * 60 * 1000),
        petrolAllowanceTotal: dayTotalPetrol,
      }
    });
  }

  console.log('--- SEED SCRIPT COMPLETED SUCCESSFULLY ---');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
