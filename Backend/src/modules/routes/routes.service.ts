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

  const previousLogs = await prisma.emptyBottleLog.findMany({
    where: { date: { lt: date } },
    orderBy: { date: 'desc' },
    distinct: ['routeId'],
  });

  const allocationMap = new Map(allocations.map(a => [a.routeId, a]));
  const previousLogMap = new Map(previousLogs.map(l => [l.routeId, l]));

  return routes.map(route => {
    const allocation = allocationMap.get(route.id);
    const previousLog = previousLogMap.get(route.id);
    
    const carriedOver1L = previousLog?.outstanding1L ?? 0;
    const carriedOverHalfL = previousLog?.outstandingHalfL ?? 0;
    
    // Total expected excluding packets
    const expectedEmptyBottles = carriedOver1L + carriedOverHalfL + 
      (allocation?.qty1LBottle ?? 0) + 
      (allocation?.qtyHalfLBottle ?? 0);

    return {
      routeId: route.id,
      routeName: route.name,
      zone: route.zone,
      customerCount: route.customerCount,
      defaultLitres: route.litres,
      fixedPetrolAllowance: route.defaultPetrolAllowance,
      allocationId: allocation ? allocation.id : null,
      assignedDpId: (allocation && (allocation.status === 'ASSIGNED' || allocation.status === 'COMPLETED')) ? allocation.dpId : null,
      assignedDpName: (allocation?.dp && (allocation.status === 'ASSIGNED' || allocation.status === 'COMPLETED')) ? allocation.dp.name : null,
      assignedDpPhotoUrl: (allocation?.dp && (allocation.status === 'ASSIGNED' || allocation.status === 'COMPLETED')) ? allocation.dp.photoUrl : null,
      assignedDpPetrolBalance: (allocation?.dp && (allocation.status === 'ASSIGNED' || allocation.status === 'COMPLETED')) ? allocation.dp.petrolBalance : 0,
      litresAllocated: allocation ? allocation.litresAllocated : 0,
      qty1LBottle: allocation ? allocation.qty1LBottle : 0,
      qtyHalfLBottle: allocation ? allocation.qtyHalfLBottle : 0,
      qtyHalfLPacket: allocation ? allocation.qtyHalfLPacket : 0,
      petrolAllowanceGiven: allocation ? allocation.petrolAllowanceGiven : null,
      isPetrolAllowanceComplete: allocation ? (allocation.petrolAllowanceGiven !== null) : false,
      expectedEmptyBottles,
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
  const result = await prisma.$transaction(async (tx) => {
    // 1. Get previous allocation to compute delta
    const previous = await tx.routeAllocation.findUnique({
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
      // getInventoryForDate equivalent logic using the tx client
      // Since getInventoryForDate reads from the DB, we can just inline the check here 
      // or fetch the daily records.
      const inventoryItems = await tx.inventoryItem.findMany();
      const dailyRecords = await tx.inventoryDailyRecord.findMany({ where: { date } });
      
      const inventory = inventoryItems.map(item => {
        const record = dailyRecords.find(r => r.inventoryItemId === item.id);
        return {
          ...item,
          recordId: record?.id,
          currentStock: record?.currentStock ?? 0,
        };
      });

      item1L = inventory.find(i => i.unit === '1L' && i.material === 'Bottle');
      itemHalfL = inventory.find(i => i.unit === '500ml' && i.material === 'Bottle');
      itemHalfLPacket = inventory.find(i => i.unit === '500ml' && i.material === 'Packet');

      if (item1L && delta1L > 0 && item1L.currentStock < delta1L) {
        throw { statusCode: 400, code: 'INSUFFICIENT_STOCK', message: `Only ${item1L.currentStock} × 1L bottles available — reduce the amount.` };
      }
      if (itemHalfL && deltaHalfL > 0 && itemHalfL.currentStock < deltaHalfL) {
        throw { statusCode: 400, code: 'INSUFFICIENT_STOCK', message: `Only ${itemHalfL.currentStock} × 500ml bottles available — reduce the amount.` };
      }
      if (itemHalfLPacket && deltaHalfLPacket > 0 && itemHalfLPacket.currentStock < deltaHalfLPacket) {
        throw { statusCode: 400, code: 'INSUFFICIENT_STOCK', message: `Only ${itemHalfLPacket.currentStock} × 500ml packets available — reduce the amount.` };
      }
    }

    // Determine the PA to save in the allocation
    // If undefined is passed, it means "no intent to change". We fallback to previous PA.
    // If status is UNASSIGNED, PA must be null.
    const newPA = status === 'UNASSIGNED' ? null : (petrolAllowanceGiven !== undefined ? petrolAllowanceGiven : (previous?.petrolAllowanceGiven ?? null));

    // 3. Update Allocation
    const allocation = await tx.routeAllocation.upsert({
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
        petrolAllowanceGiven: newPA,
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
        petrolAllowanceGiven: newPA,
      },
    });

    // 4. Process Inventory decrements
    if (delta1L !== 0 || deltaHalfL !== 0 || deltaHalfLPacket !== 0) {
      if (item1L?.recordId && delta1L !== 0) {
        await tx.inventoryDailyRecord.update({
          where: { id: item1L.recordId },
          data: { 
            currentStock: { decrement: delta1L },
            expectedStock: { decrement: delta1L }
          }
        });
      }

      if (itemHalfL?.recordId && deltaHalfL !== 0) {
        await tx.inventoryDailyRecord.update({
          where: { id: itemHalfL.recordId },
          data: { 
            currentStock: { decrement: deltaHalfL },
            expectedStock: { decrement: deltaHalfL }
          }
        });
      }
      
      if (itemHalfLPacket?.recordId && deltaHalfLPacket !== 0) {
        await tx.inventoryDailyRecord.update({
          where: { id: itemHalfLPacket.recordId },
          data: { 
            currentStock: { decrement: deltaHalfLPacket },
            expectedStock: { decrement: deltaHalfLPacket }
          }
        });
      }
    }

    // 5. Process Petrol Allowance Ledger entries and DP Balance
    // If petrolAllowanceGiven is strictly undefined, it means the frontend is intentionally omitting it
    // (e.g. from assignRoute or updateRouteAllocationLitres) because it is a partial update and the user 
    // does not intend to touch the PA ledger. We must skip all ledger clearing/creation UNLESS the route 
    // is being UNASSIGNED (in which case we must clear everything).
    const skipLedgerUpdate = petrolAllowanceGiven === undefined && status !== 'UNASSIGNED';

    if (!skipLedgerUpdate) {
      const route = await tx.route.findUnique({ where: { id: routeId } });
      if (route) {
        const defaultAllowance = route.defaultPetrolAllowance;

        // First, clear out old ledger entries & reverse old balance impact
        if (previous && (previous.status === 'ASSIGNED' || previous.status === 'COMPLETED')) {
          const oldDpId = previous.dpId;
          const oldPA = previous.petrolAllowanceGiven;

          if (oldPA !== null && oldPA !== undefined) {
            const oldDelta = oldPA - defaultAllowance;
            // Reverse balance
            await tx.deliveryPerson.update({
              where: { id: oldDpId },
              data: { petrolBalance: { decrement: oldDelta } }
            });
          }

          // Delete old ledger entries for the OLD DP on this route and date
          await tx.ledgerTransaction.deleteMany({
            where: {
              dpId: oldDpId,
              date,
              routeId,
              type: { in: ['PETROL_ALLOWANCE', 'SHORTAGE', 'EXTRA_PAID'] }
            }
          });
        }

        // Now apply new ledger entries & new balance impact (if not UNASSIGNED)
        if (status === 'ASSIGNED' || status === 'COMPLETED') {
          if (newPA !== null && newPA !== undefined) {
            const newDelta = newPA - defaultAllowance;

            // Apply new balance
            await tx.deliveryPerson.update({
              where: { id: dpId },
              data: { petrolBalance: { increment: newDelta } }
            });

            let type: 'PETROL_ALLOWANCE' | 'SHORTAGE' | 'EXTRA_PAID' = 'PETROL_ALLOWANCE';
            let note = `Petrol allowance for ${route.name}`;

            if (newPA < defaultAllowance) {
              type = 'SHORTAGE';
              note = `Short ₹${defaultAllowance - newPA} vs route allowance`;
            } else if (newPA > defaultAllowance) {
              type = 'EXTRA_PAID';
              note = `Extra ₹${newPA - defaultAllowance} vs route allowance`;
            }

            await tx.ledgerTransaction.create({
              data: {
                dpId,
                routeId,
                date,
                type,
                amount: newPA,
                note
              }
            });
          }
        }
      }
    }

    return allocation;
  });

  await checkAndUpdateRoutesCompletion(date);

  return result;
};

