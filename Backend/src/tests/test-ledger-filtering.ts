// @ts-nocheck
import { prisma } from '../config/db';
import { getLedger } from '../modules/ledger/ledger.service';
import { getISTDateString } from '../utils/date';

async function run() {
  console.log('--- Starting Ledger Server-side Filter Regression Test ---');

  // Create mock DP
  const dp = await prisma.deliveryPerson.create({
    data: {
      dpCode: 'DP_LEDGER_TEST_' + Date.now(),
      name: 'Ledger Filter Test DP',
      mobileNumber: '8888888880',
      isActive: true,
    }
  });

  const now = new Date();
  
  const today = new Date(now);
  const yesterday = new Date(now);
  yesterday.setDate(now.getDate() - 1);
  const twoDaysAgo = new Date(now);
  twoDaysAgo.setDate(now.getDate() - 2);

  const todayStr = getISTDateString(today);
  const yesterdayStr = getISTDateString(yesterday);
  const twoDaysAgoStr = getISTDateString(twoDaysAgo);

  try {
    // 1. Seed Transactions
    await prisma.ledgerTransaction.create({
      data: { dpId: dp.id, type: 'EXTRA_PAID', amount: 150, date: todayStr }
    });
    
    await prisma.ledgerTransaction.create({
      data: { dpId: dp.id, type: 'SHORTAGE', amount: 50, date: yesterdayStr }
    });
    
    await prisma.ledgerTransaction.create({
      data: { dpId: dp.id, type: 'PETROL_ALLOWANCE', amount: 100, date: twoDaysAgoStr }
    });

    console.log(`Seeded 3 transactions: Today (Extra), Yesterday (Short), 2 Days Ago (Fully Paid).`);

    // 2. Query: Today + Extra Paid
    const todayExtra = await getLedger(dp.id, 'today', undefined, undefined, 'extra_paid');
    if (todayExtra.length !== 1 || todayExtra[0].type !== 'EXTRA_PAID') {
      throw new Error(`Expected 1 EXTRA_PAID transaction today, got ${todayExtra.length}`);
    }
    console.log('✅ Query 1 Passed: Today + Extra returns exact subset.');

    // 3. Query: This Week + All
    const weekAll = await getLedger(dp.id, 'week');
    if (weekAll.length !== 3) {
      throw new Error(`Expected 3 transactions for this week, got ${weekAll.length}`);
    }
    console.log('✅ Query 2 Passed: This Week + All returns all 3 recent transactions.');

    // 4. Query: Custom Range + Short Paid (Original)
    const customShort = await getLedger(dp.id, 'custom', yesterdayStr, yesterdayStr, 'short_paid');
    if (customShort.length !== 1 || customShort[0].type !== 'SHORTAGE') {
      throw new Error(`Expected 1 SHORTAGE transaction in custom range, got ${customShort.length}`);
    }
    console.log('✅ Query 3 Passed: Custom Range + Short Paid returns exact subset.');

    // 5. Query: Yesterday Alone
    const yesterdayAll = await getLedger(dp.id, 'yesterday');
    if (yesterdayAll.length !== 1 || yesterdayAll[0].type !== 'SHORTAGE') {
      throw new Error(`Expected 1 SHORTAGE transaction for yesterday, got ${yesterdayAll.length}`);
    }
    console.log('✅ Query 4 Passed: Yesterday range returns exact subset.');

    // 6. Query: Custom Single Date
    // Using twoDaysAgoStr for both from and to
    const customSingle = await getLedger(dp.id, 'custom', twoDaysAgoStr, twoDaysAgoStr);
    if (customSingle.length !== 1 || customSingle[0].type !== 'PETROL_ALLOWANCE') {
      throw new Error(`Expected 1 PETROL_ALLOWANCE transaction in custom single date, got ${customSingle.length}`);
    }
    console.log('✅ Query 5 Passed: Custom Single Date (start == end) returns exact subset.');

  } finally {
    // Cleanup
    await prisma.ledgerTransaction.deleteMany({ where: { dpId: dp.id } });
    await prisma.deliveryPerson.delete({ where: { id: dp.id } });
    console.log('--- Cleanup Done ---');
  }
}

run().catch(console.error).finally(() => process.exit(0));
