import { z } from 'zod';
import { AttendanceStatus } from '@prisma/client';

const dateRegex = /^\d{4}-\d{2}-\d{2}$/;

export const attendanceQuerySchema = z.object({
  date: z.string().regex(dateRegex, 'Date must be YYYY-MM-DD'),
});

export const updateAttendanceSchema = z.object({
  status: z.nativeEnum(AttendanceStatus),
});

export const bulkAttendanceSchema = z.object({
  records: z.array(
    z.object({
      dpId: z.string().uuid(),
      status: z.nativeEnum(AttendanceStatus),
    })
  ).min(1, 'At least one record is required'),
});
