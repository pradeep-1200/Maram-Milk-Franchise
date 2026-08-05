import { getISTDateString, getISTStartOfWeekString, getISTStartOfMonthString } from './src/utils/date';

const now = new Date('2024-01-01T23:00:00.000Z'); // 1st Jan 2024 23:00 UTC = 2nd Jan 2024 04:30 IST (Tuesday)
console.log('Now UTC:', now.toISOString());
console.log('Today:', getISTDateString(now));
console.log('Week:', getISTStartOfWeekString(now));
console.log('Month:', getISTStartOfMonthString(now));
