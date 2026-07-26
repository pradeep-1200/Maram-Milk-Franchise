import { prisma } from '../../config/db';
import { Prisma } from '@prisma/client';

import { getISTDateString } from '../../utils/date';

export const getDeliveryPersons = async (search?: string) => {
  let where: Prisma.DeliveryPersonWhereInput = { isActive: true };
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
      const maxDp = await tx.deliveryPerson.findFirst({
        orderBy: { dpCode: 'desc' },
        select: { dpCode: true },
      });

      let nextNumber = 1001;
      if (maxDp && maxDp.dpCode.startsWith('DP')) {
        const currentNumber = parseInt(maxDp.dpCode.replace('DP', ''), 10);
        if (!isNaN(currentNumber)) {
          nextNumber = currentNumber + 1;
        }
      }
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

export const deleteDeliveryPerson = async (id: string) => {
  const today = getISTDateString(new Date());

  const activeAllocation = await prisma.routeAllocation.findFirst({
    where: {
      dpId: id,
      date: today,
      status: 'ASSIGNED',
    },
  });

  if (activeAllocation) {
    throw { statusCode: 400, code: 'HAS_ACTIVE_ROUTE', message: 'Delivery Person has an active route assignment for today. Unassign their route before deleting.' };
  }

  return await prisma.deliveryPerson.update({
    where: { id },
    data: { isActive: false },
  });
};
