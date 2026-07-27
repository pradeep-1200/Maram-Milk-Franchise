import { prisma } from '../../config/db';
import { Prisma, LedgerTransactionType } from '@prisma/client';

export const getLedger = async (dpId?: string, from?: string, to?: string, type?: string) => {
  const where: Prisma.RouteAllocationWhereInput = {
    petrolAllowanceGiven: { not: null },
    status: { in: ['ASSIGNED', 'COMPLETED'] }
  };
  
  if (dpId) where.dpId = dpId;
  
  if (from || to) {
    where.date = {};
    if (from) where.date.gte = from;
    if (to) where.date.lte = to;
  }

  const allocations = await prisma.routeAllocation.findMany({
    where,
    orderBy: [
      { date: 'desc' },
      { createdAt: 'desc' },
    ],
    include: { dp: true, route: true },
  });

  let ledgerEntries = allocations.map(a => {
    const given = a.petrolAllowanceGiven ?? 0;
    const allowance = a.route.defaultPetrolAllowance;
    let status = 'fully_paid';
    if (given < allowance) status = 'short_paid';
    else if (given > allowance) status = 'extra_paid';

    return {
      id: a.id,
      dpId: a.dpId,
      dp: a.dp,
      routeId: a.routeId,
      route: a.route,
      date: a.date,
      givenAllowance: given,
      defaultAllowance: allowance,
      status
    };
  });

  if (type && type.toLowerCase() !== 'all') {
    ledgerEntries = ledgerEntries.filter(entry => entry.status === type.toLowerCase());
  }

  return ledgerEntries;
};

export const createLedgerTransaction = async (data: Prisma.LedgerTransactionUncheckedCreateInput) => {
  return await prisma.ledgerTransaction.create({
    data,
  });
};
