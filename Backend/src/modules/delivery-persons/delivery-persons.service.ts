import { prisma } from '../../config/db';
import { Prisma } from '@prisma/client';

import { getISTDateString } from '../../utils/date';

export const getDeliveryPersons = async (search?: string) => {
  let where: Prisma.DeliveryPersonWhereInput = {};
  if (search) {
    where = {
      ...where,
      OR: [
        { name: { contains: search, mode: 'insensitive' } },
        { dpCode: { contains: search, mode: 'insensitive' } },
      ],
    };
  }

  return await prisma.deliveryPerson.findMany({
    where,
    orderBy: { createdAt: 'desc' },
  });
};

export const getDeliveryPersonById = async (id: string) => {
  return await prisma.deliveryPerson.findUnique({
    where: { id },
  });
};

export const createDeliveryPerson = async (data: Omit<Prisma.DeliveryPersonCreateInput, 'dpCode'>) => {
  return await prisma.$transaction(
    async (tx) => {
      const allDps = await tx.deliveryPerson.findMany({ select: { dpCode: true } });
      let maxNumber = 0;
      for (const dp of allDps) {
        if (dp.dpCode.startsWith('DP')) {
          const currentNumber = parseInt(dp.dpCode.replace('DP', ''), 10);
          if (!isNaN(currentNumber) && currentNumber > maxNumber) {
            maxNumber = currentNumber;
          }
        }
      }
      const nextNumber = maxNumber > 0 ? maxNumber + 1 : 1001;
      const dpCode = `DP${nextNumber}`;

      return await tx.deliveryPerson.create({
        data: {
          ...data,
          dpCode,
        },
      });
    },
    {
      isolationLevel: Prisma.TransactionIsolationLevel.Serializable,
    }
  );
};

export const updateDeliveryPerson = async (id: string, data: Prisma.DeliveryPersonUpdateInput) => {
  return await prisma.deliveryPerson.update({
    where: { id },
    data,
  });
};

export const deactivateDeliveryPerson = async (id: string) => {
  const today = getISTDateString(new Date());

  const activeAllocation = await prisma.routeAllocation.findFirst({
    where: {
      dpId: id,
      date: today,
      status: 'ASSIGNED',
    },
  });

  if (activeAllocation) {
    throw { statusCode: 400, code: 'HAS_ACTIVE_ROUTE', message: 'Delivery Person has an active route assignment for today. Unassign their route before deactivating.' };
  }

  return await prisma.deliveryPerson.update({
    where: { id },
    data: { isActive: false },
  });
};

export const reactivateDeliveryPerson = async (id: string) => {
  return await prisma.deliveryPerson.update({
    where: { id },
    data: { isActive: true },
  });
};

export const getDeletePreview = async (id: string) => {
  const attendanceRecords = await prisma.attendanceRecord.count({ where: { dpId: id } });
  const routeAllocations = await prisma.routeAllocation.count({ where: { dpId: id } });
  const ledgerEntries = await prisma.ledgerTransaction.count({ where: { dpId: id } });
  const bottleLogs = await prisma.emptyBottleLog.count({ where: { dpId: id } });

  return {
    attendanceRecords,
    routeAllocations,
    ledgerEntries,
    bottleLogs,
  };
};

export const hardDeleteDeliveryPerson = async (id: string) => {
  return await prisma.$transaction(async (tx) => {
    // Unassign routes
    await tx.route.updateMany({
      where: { assignedDpId: id },
      data: { assignedDpId: null },
    });

    // Delete related records
    await tx.attendanceRecord.deleteMany({ where: { dpId: id } });
    await tx.routeAllocation.deleteMany({ where: { dpId: id } }); 
    await tx.ledgerTransaction.deleteMany({ where: { dpId: id } });
    await tx.emptyBottleLog.deleteMany({ where: { dpId: id } }); 

    // Finally delete DP
    return await tx.deliveryPerson.delete({
      where: { id },
    });
  });
};
