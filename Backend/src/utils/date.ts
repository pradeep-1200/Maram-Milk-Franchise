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
