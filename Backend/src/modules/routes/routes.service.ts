import { prisma } from '../../config/db';
import { RouteAllocationStatus } from '@prisma/client';
import { checkAndUpdateRoutesCompletion } from '../dispatch/dispatch.service';

export const getRoutesWithAllocation = async (date: string) => {
  const routes = await prisma.route.findMany({
    orderBy: { name: 'asc' },
  });

  const allocations = await prisma.routeAllocation.findMany({
    where: { date },
    include: { dp: true },
  });

  const allocationMap = new Map(allocations.map(a => [a.routeId, a]));

  return routes.map(route => {
    const allocation = allocationMap.get(route.id);
    return {
      routeId: route.id,
      routeName: route.name,
      zone: route.zone,
      customerCount: route.customerCount,
      defaultLitres: route.litres,
      fixedPetrolAllowance: route.defaultPetrolAllowance,
      allocationId: allocation ? allocation.id : null,
      assignedDpId: (allocation && allocation.status === 'ASSIGNED') ? allocation.dpId : null,
      assignedDpName: (allocation?.dp && allocation.status === 'ASSIGNED') ? allocation.dp.name : null,
      assignedDpPhotoUrl: (allocation?.dp && allocation.status === 'ASSIGNED') ? allocation.dp.photoUrl : null,
      litresAllocated: allocation ? allocation.litresAllocated : 0,
      qty1LBottle: allocation ? allocation.qty1LBottle : 0,
      qtyHalfLBottle: allocation ? allocation.qtyHalfLBottle : 0,
      qtyHalfLPacket: allocation ? allocation.qtyHalfLPacket : 0,
      status: allocation ? allocation.status : 'UNASSIGNED',
    };
  });
};

import { getInventoryForDate } from '../inventory/inventory.service';

export const updateRouteAllocation = async (
  routeId: string, 
  date: string, 
  dpId: string, 
  litresAllocated: number, 
  status: RouteAllocationStatus,
  qty1LBottle?: number,
  qtyHalfLBottle?: number,
  qtyHalfLPacket?: number,
  petrolAllowanceGiven?: number
) => {
  // 1. Get previous allocation to compute delta
  const previous = await prisma.routeAllocation.findUnique({
    where: { routeId_date: { routeId, date } }
  });

  const old1L = previous?.qty1LBottle ?? 0;
  const oldHalfL = previous?.qtyHalfLBottle ?? 0;
  const oldHalfLPacket = previous?.qtyHalfLPacket ?? 0;
  
  const new1L = qty1LBottle ?? old1L;
  const newHalfL = qtyHalfLBottle ?? oldHalfL;
  const newHalfLPacket = qtyHalfLPacket ?? oldHalfLPacket;

  const delta1L = new1L - old1L;
  const deltaHalfL = newHalfL - oldHalfL;
  const deltaHalfLPacket = newHalfLPacket - oldHalfLPacket;

  // 2. Pre-check Inventory and throw error if insufficient stock
  let item1L = null;
  let itemHalfL = null;
  let itemHalfLPacket = null;

  if (delta1L !== 0 || deltaHalfL !== 0 || deltaHalfLPacket !== 0) {
    const inventory = await getInventoryForDate(date);
    item1L = inventory.find(i => i.unit === '1L' && i.material === 'Bottle');
    itemHalfL = inventory.find(i => i.unit === '500ml' && i.material === 'Bottle');
    itemHalfLPacket = inventory.find(i => i.unit === '500ml' && i.material === 'Packet');

    if (item1L && delta1L > 0) {
      if (item1L.currentStock < delta1L) {
        throw { statusCode: 400, code: 'INSUFFICIENT_STOCK', message: `Only ${item1L.currentStock} × 1L bottles available — reduce the amount.` };
      }
    }
    if (itemHalfL && deltaHalfL > 0) {
      if (itemHalfL.currentStock < deltaHalfL) {
        throw { statusCode: 400, code: 'INSUFFICIENT_STOCK', message: `Only ${itemHalfL.currentStock} × 500ml bottles available — reduce the amount.` };
      }
    }
    if (itemHalfLPacket && deltaHalfLPacket > 0) {
      if (itemHalfLPacket.currentStock < deltaHalfLPacket) {
        throw { statusCode: 400, code: 'INSUFFICIENT_STOCK', message: `Only ${itemHalfLPacket.currentStock} × 500ml packets available — reduce the amount.` };
      }
    }
  }

  // 3. Update Allocation
  const allocation = await prisma.routeAllocation.upsert({
    where: {
      routeId_date: { routeId, date },
    },
    update: {
      dpId,
      litresAllocated,
      status,
      qty1LBottle: new1L,
      qtyHalfLBottle: newHalfL,
      qtyHalfLPacket: newHalfLPacket,
      petrolAllowanceGiven,
    },
    create: {
      routeId,
      date,
      dpId,
      litresAllocated,
      status,
      qty1LBottle: new1L,
      qtyHalfLBottle: newHalfL,
      qtyHalfLPacket: newHalfLPacket,
      petrolAllowanceGiven,
    },
  });

  // 4. Process Inventory decrements
  if (delta1L !== 0 || deltaHalfL !== 0 || deltaHalfLPacket !== 0) {
    if (item1L && delta1L !== 0) {
      await prisma.inventoryDailyRecord.update({
        where: { id: item1L.recordId },
        data: { 
          currentStock: { decrement: delta1L },
          expectedStock: { decrement: delta1L }
        }
      });
    }

    if (itemHalfL && deltaHalfL !== 0) {
      await prisma.inventoryDailyRecord.update({
        where: { id: itemHalfL.recordId },
        data: { 
          currentStock: { decrement: deltaHalfL },
          expectedStock: { decrement: deltaHalfL }
        }
      });
    }
    
    if (itemHalfLPacket && deltaHalfLPacket !== 0) {
      await prisma.inventoryDailyRecord.update({
        where: { id: itemHalfLPacket.recordId },
        data: { 
          currentStock: { decrement: deltaHalfLPacket },
          expectedStock: { decrement: deltaHalfLPacket }
        }
      });
    }
  }

  // 4. Process Petrol Allowance Ledger entries
  if (petrolAllowanceGiven !== undefined && status === 'ASSIGNED') {
    const route = await prisma.route.findUnique({ where: { id: routeId } });
    if (route) {
      const defaultAllowance = route.defaultPetrolAllowance;

      // Clear existing ledger entries for this route and date
      await prisma.ledgerTransaction.deleteMany({
        where: {
          dpId,
          date,
          routeId,
          type: { in: ['PETROL_ALLOWANCE', 'SHORTAGE', 'EXTRA_PAID'] }
        }
      });

      if (petrolAllowanceGiven > 0) {
        await prisma.ledgerTransaction.create({
          data: {
            dpId,
            routeId,
            date,
            type: 'PETROL_ALLOWANCE',
            amount: petrolAllowanceGiven,
            note: `Petrol allowance for ${route.name}`
          }
        });
      }

      if (petrolAllowanceGiven < defaultAllowance) {
        const shortage = defaultAllowance - petrolAllowanceGiven;
        await prisma.ledgerTransaction.create({
          data: {
            dpId,
            routeId,
            date,
            type: 'SHORTAGE',
            amount: shortage,
            note: `Short ₹${shortage} vs route allowance`
          }
        });
      }

      if (petrolAllowanceGiven > defaultAllowance) {
        const extra = petrolAllowanceGiven - defaultAllowance;
        await prisma.ledgerTransaction.create({
          data: {
            dpId,
            routeId,
            date,
            type: 'EXTRA_PAID',
            amount: extra,
            note: `Extra ₹${extra} vs route allowance`
          }
        });
      }
    }
  }

  await checkAndUpdateRoutesCompletion(date);

  return allocation;
};

