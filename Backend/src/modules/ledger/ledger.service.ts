import { prisma } from '../../config/db';
import { Prisma, LedgerTransactionType } from '@prisma/client';
import { getReportDateRange } from '../reports/reports.service';

export const getLedger = async (dpId?: string, range?: 'today'|'yesterday'|'week'|'month'|'custom', from?: string, to?: string, type?: string) => {
  const where: Prisma.LedgerTransactionWhereInput = {
    // Only return petrol transactions since this is the petrol ledger
    type: { in: ['PETROL_ALLOWANCE', 'SHORTAGE', 'EXTRA_PAID'] }
  };
  
  if (dpId) where.dpId = dpId;
  
  if (range) {
    const { startDate, endDate } = getReportDateRange(range, new Date(), from, to);
    if (startDate && endDate) {
      where.date = { gte: startDate, lte: endDate };
    }
  } else if (from || to) {
    where.date = {};
    if (from) where.date.gte = from;
    if (to) where.date.lte = to;
  }

  // Filter by type if provided
  if (type && type.toLowerCase() !== 'all') {
    if (type.toLowerCase() === 'fully_paid') where.type = 'PETROL_ALLOWANCE';
    else if (type.toLowerCase() === 'short_paid') where.type = 'SHORTAGE';
    else if (type.toLowerCase() === 'extra_paid') where.type = 'EXTRA_PAID';
  }

  const transactions = await prisma.ledgerTransaction.findMany({
    where,
    orderBy: [
      { date: 'desc' },
      { createdAt: 'desc' },
    ],
    include: { dp: true, route: true },
  });

  const ledgerEntries = transactions.map(tx => {
    return {
      id: tx.id,
      dpId: tx.dpId,
      dp: tx.dp,
      routeId: tx.routeId,
      route: tx.route,
      date: tx.date,
      type: tx.type,
      amount: tx.amount,
      note: tx.note,
      // For backwards compatibility or frontend usage, we can calculate the defaultAllowance
      defaultAllowance: tx.route ? tx.route.defaultPetrolAllowance : 0,
    };
  });

  return ledgerEntries;
};

export const createLedgerTransaction = async (data: Prisma.LedgerTransactionUncheckedCreateInput) => {
  return await prisma.ledgerTransaction.create({
    data,
  });
};
