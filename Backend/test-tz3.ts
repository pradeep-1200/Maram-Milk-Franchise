import { startOfWeek, startOfMonth, format } from 'date-fns';
import { toZonedTime } from 'date-fns-tz';

const TIMEZONE = 'Asia/Kolkata';

export const getISTDateString = (dateInput: Date | string | number = new Date()) => {
  const zonedDate = toZonedTime(dateInput, TIMEZONE);
  return format(zonedDate, 'yyyy-MM-dd');
};

export const getISTStartOfWeekString = (dateInput: Date | string | number = new Date()) => {
  const zonedDate = toZonedTime(dateInput, TIMEZONE);
  const weekStart = startOfWeek(zonedDate, { weekStartsOn: 1 });
  return format(weekStart, 'yyyy-MM-dd');
};

export const getISTStartOfMonthString = (dateInput: Date | string | number = new Date()) => {
  const zonedDate = toZonedTime(dateInput, TIMEZONE);
  const monthStart = startOfMonth(zonedDate);
  return format(monthStart, 'yyyy-MM-dd');
};

// Test 2
process.env.TZ = 'UTC'; // simulate UTC server
const now2 = new Date('2024-01-31T23:00:00.000Z'); // 1st Feb 04:30 IST
console.log('Now UTC:', now2.toISOString());
console.log('Today:', getISTDateString(now2));
console.log('Week:', getISTStartOfWeekString(now2));
console.log('Month:', getISTStartOfMonthString(now2));
