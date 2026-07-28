import { z } from 'zod';

export const createDpSchema = z.object({
  name: z.string().min(1, 'Name is required'),
  mobileNumber: z.string().min(10, 'Mobile number is required'),
  alternativeMobile: z.string().optional().nullable(),
  whatsappNumber: z.string().optional().nullable(),
  dateOfBirth: z.string().optional().nullable(),
  address: z.string().optional().nullable(),
  zone: z.string().optional().nullable(),
  parentNameAndAddress: z.string().optional().nullable(),
  parentOrSpouseMobile: z.string().optional().nullable(),
  alternativeAddress: z.string().optional().nullable(),
  aadharNumber: z.string().optional().nullable(),
  licenseNumber: z.string().optional().nullable(),
  vehicleNumber: z.string().optional().nullable(),
  dateOfJoining: z.string().optional().nullable(),
  gpayNumber: z.string().min(1, 'GPAY Number is required'),
  upiId: z.string().min(1, 'UPI ID is required'),
  bankAccountDetails: z.string().optional().nullable(),
});

export const updateDpSchema = createDpSchema.partial().extend({
  gpayNumber: z.string().min(1, 'GPAY Number is required'),
  upiId: z.string().min(1, 'UPI ID is required'),
});
