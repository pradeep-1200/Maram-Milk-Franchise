import { startOfWeek, startOfMonth, format } from 'date-fns';
import { toZonedTime } from 'date-fns-tz';

const TIMEZONE = 'Asia/Kolkata';

export const getISTDateString = (dateInput: Date | string | number = new Date()) => {
  const zonedDate = toZonedTime(dateInput, TIMEZONE);
  const shiftedDate = new Date(zonedDate.getTime() + 5 * 60 * 60 * 1000);
  return format(shiftedDate, 'yyyy-MM-dd');
};

export const getISTStartOfWeekString = (dateInput: Date | string | number = new Date()) => {
  const zonedDate = toZonedTime(dateInput, TIMEZONE);
  const shiftedDate = new Date(zonedDate.getTime() + 5 * 60 * 60 * 1000);
  const weekStart = startOfWeek(shiftedDate, { weekStartsOn: 1 });
  return format(weekStart, 'yyyy-MM-dd');
};

export const getISTStartOfMonthString = (dateInput: Date | string | number = new Date()) => {
  const zonedDate = toZonedTime(dateInput, TIMEZONE);
  const shiftedDate = new Date(zonedDate.getTime() + 5 * 60 * 60 * 1000);
  const monthStart = startOfMonth(shiftedDate);
  return format(monthStart, 'yyyy-MM-dd');
};
