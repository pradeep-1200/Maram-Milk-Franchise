import { startOfWeek, startOfMonth, format } from 'date-fns';
import { toZonedTime } from 'date-fns-tz';

const TIMEZONE = 'Asia/Kolkata';

export const getISTStartOfWeekString = (dateInput: Date | string | number = new Date()) => {
  const zonedDate = toZonedTime(dateInput, TIMEZONE);
  const weekStart = startOfWeek(zonedDate, { weekStartsOn: 1 });
  return format(weekStart, 'yyyy-MM-dd');
};

// Test with server in NY (America/New_York)
process.env.TZ = 'America/New_York';
// Jan 1st, 2024, 02:00 AM IST = Dec 31st, 2023, 20:30 UTC
const now = new Date('2023-12-31T20:30:00.000Z'); 
console.log('Now UTC:', now.toISOString());
console.log('IST Time:', toZonedTime(now, TIMEZONE).toISOString());
console.log('Week Start:', getISTStartOfWeekString(now));
