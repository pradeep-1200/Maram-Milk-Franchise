import { getReportDateRange } from '../modules/reports/reports.service';
import * as assert from 'assert';

function runRegressionTest() {
  console.log('--- Date Filters Regression Test ---');

  // Fixed mock date: 2024-01-18 12:00:00 UTC (Thursday in Jan 2024)
  const mockNow = new Date('2024-01-18T12:00:00.000Z'); 
  
  // 1. TODAY
  const todayRange = getReportDateRange('today', mockNow);
  console.log('Today:', todayRange);
  assert.strictEqual(todayRange.startDate, '2024-01-18');
  assert.strictEqual(todayRange.endDate, '2024-01-18');

  // 2. THIS WEEK (Starts on Monday)
  // 18th is Thursday, so Monday is 15th
  const weekRange = getReportDateRange('week', mockNow);
  console.log('Week:', weekRange);
  assert.strictEqual(weekRange.startDate, '2024-01-15');
  assert.strictEqual(weekRange.endDate, '2024-01-18');

  // 3. THIS MONTH (Starts on 1st)
  const monthRange = getReportDateRange('month', mockNow);
  console.log('Month:', monthRange);
  assert.strictEqual(monthRange.startDate, '2024-01-01');
  assert.strictEqual(monthRange.endDate, '2024-01-18');

  // 4. CUSTOM
  const customRange = getReportDateRange('custom', mockNow, '2024-01-10', '2024-01-12');
  console.log('Custom:', customRange);
  assert.strictEqual(customRange.startDate, '2024-01-10');
  assert.strictEqual(customRange.endDate, '2024-01-12');
  
  console.log('✅ Regression test passed: startDate/endDate windows are correct and distinct per filter.');
}

runRegressionTest();
