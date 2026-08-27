import { prisma } from '../../config/db';
import { RouteAllocationStatus } from '@prisma/client';
import { checkAndUpdateRoutesCompletion } from '../dispatch/dispatch.service';
import { getInventoryForDate } from '../inventory/inventory.service';

export const getRoutesWithAllocation = async (date: string) => {
  const routes = await prisma.route.findMany({
    orderBy: { name: 'asc' },
  });

  const allocations = await prisma.routeAllocation.findMany({
    where: { date },
    include: { 
      dp: true,
      items: {
        include: { inventoryItem: true }
      }
    },
  });

  // Calculate expectedEmptyBottles per DP from previous EmptyBottleLog
  const dpIds = [...new Set(allocations.map(a => a.dpId))];
  const dpCarryOver = new Map<string, number>();

  for (const dpId of dpIds) {
    const previousLog = await prisma.emptyBottleLog.findFirst({
      where: { dpId, date: { lt: date } },
      orderBy: { date: 'desc' },
      include: {
        items: {
          include: { inventoryItem: true }
        }
      }
    });

    let carriedOver = 0;
    if (previousLog) {
      for (const item of previousLog.items) {
        if (item.inventoryItem.section === 'Milk' && item.inventoryItem.material === 'Bottle') {
          carriedOver += item.outstanding || 0;
        }
      }
    }
    dpCarryOver.set(dpId, carriedOver);
  }

  const allocationMap = new Map<string, typeof allocations>();
  for (const a of allocations) {
    if (!allocationMap.has(a.routeId)) {
      allocationMap.set(a.routeId, []);
    }
    allocationMap.get(a.routeId)!.push(a);
  }

  return routes.map(route => {
    const routeAllocations = allocationMap.get(route.id) || [];
    
    let expectedEmptyBottles = 0;
    for (const alloc of routeAllocations) {
      // Add DP carry over
      expectedEmptyBottles += dpCarryOver.get(alloc.dpId) || 0;
      
      // Add today's allocations for this DP
      for (const item of alloc.items) {
        if (item.inventoryItem.section === 'Milk' && item.inventoryItem.material === 'Bottle') {
          expectedEmptyBottles += item.quantity;
        }
      }
    }

    return {
      routeId: route.id,
      routeName: route.name,
      zone: route.zone,
      customerCount: route.customerCount,
      defaultLitres: route.litres,
      fixedPetrolAllowance: route.defaultPetrolAllowance,
      expectedEmptyBottles,
      allocations: routeAllocations
        .filter(allocation => allocation.status === 'ASSIGNED' || allocation.status === 'COMPLETED')
        .map(allocation => {
          const itemMap: Record<string, number> = {};
          for (const item of allocation.items) {
            itemMap[item.inventoryItemId] = item.quantity;
          }
          return {
            allocationId: allocation.id,
            dpId: allocation.dpId,
            dpName: allocation.dp?.name,
            dpPhotoUrl: allocation.dp?.photoUrl,
            dpPetrolBalance: allocation.dp?.petrolBalance || 0,
            litresAllocated: allocation.litresAllocated,
            items: itemMap,
            petrolAllowanceGiven: allocation.petrolAllowanceGiven,
            isPetrolAllowanceComplete: allocation.petrolAllowanceGiven !== null,
            status: allocation.status,
          };
        }),
    };
  });
};

export const updateRouteAllocation = async (
  routeId: string, 
  date: string, 
  dpId: string, 
  litresAllocated: number, 
  status: RouteAllocationStatus,
  items: { inventoryItemId: string; quantity: number }[],
  petrolAllowanceGiven?: number
) => {
  const result = await prisma.$transaction(async (tx) => {
    // 1. Get previous allocation to compute delta
    const previous = await tx.routeAllocation.findUnique({
      where: { routeId_dpId_date: { routeId, dpId, date } },
      include: { items: true }
    });

    const oldItemMap = new Map<string, number>();
    if (previous) {
      for (const oldItem of previous.items) {
        oldItemMap.set(oldItem.inventoryItemId, oldItem.quantity);
      }
    }

    const itemDeltas = new Map<string, number>();
    for (const item of items) {
      const oldQty = oldItemMap.get(item.inventoryItemId) || 0;
      const delta = item.quantity - oldQty;
      if (delta !== 0) itemDeltas.set(item.inventoryItemId, delta);
    }
    for (const [oldId, oldQty] of oldItemMap.entries()) {
      if (!items.find(i => i.inventoryItemId === oldId)) {
        itemDeltas.set(oldId, -oldQty);
      }
    }

    // 2. Pre-check Inventory and throw error if insufficient stock
    if (itemDeltas.size > 0) {
      const inventoryItems = await tx.inventoryItem.findMany();
      const dailyRecords = await tx.inventoryDailyRecord.findMany({ where: { date } });
      
      for (const [itemId, delta] of itemDeltas.entries()) {
        if (delta > 0) {
          const invItem = inventoryItems.find(i => i.id === itemId);
          const record = dailyRecords.find(r => r.inventoryItemId === itemId);
          const currentStock = record?.currentStock ?? 0;
          if (currentStock < delta) {
            throw { 
              statusCode: 400, 
              code: 'INSUFFICIENT_STOCK', 
              message: `Only ${currentStock} × ${invItem?.name} available — reduce the amount.` 
            };
          }
        }
      }
    }

    // Determine the PA to save in the allocation
    const newPA = status === 'UNASSIGNED' ? null : (petrolAllowanceGiven !== undefined ? petrolAllowanceGiven : (previous?.petrolAllowanceGiven ?? null));

    // 3. Update Allocation
    const allocation = await tx.routeAllocation.upsert({
      where: {
        routeId_dpId_date: { routeId, dpId, date },
      },
      update: {
        dpId,
        litresAllocated,
        status,
        petrolAllowanceGiven: newPA,
      },
      create: {
        routeId,
        date,
        dpId,
        litresAllocated,
        status,
        petrolAllowanceGiven: newPA,
      },
    });

    // Delete old items and insert new ones
    await tx.routeAllocationItem.deleteMany({
      where: { routeAllocationId: allocation.id }
    });
    
    if (items.length > 0) {
      await tx.routeAllocationItem.createMany({
        data: items.map(i => ({
          routeAllocationId: allocation.id,
          inventoryItemId: i.inventoryItemId,
          quantity: i.quantity
        }))
      });
    }

    // 4. Process Inventory decrements
    for (const [itemId, delta] of itemDeltas.entries()) {
      const record = await tx.inventoryDailyRecord.findUnique({
        where: { inventoryItemId_date: { inventoryItemId: itemId, date } }
      });
      if (record) {
        await tx.inventoryDailyRecord.update({
          where: { id: record.id },
          data: { 
            currentStock: { decrement: delta },
            expectedStock: { decrement: delta }
          }
        });
      }
    }

    // 5. Process Petrol Allowance Ledger entries and DP Balance
    const skipLedgerUpdate = petrolAllowanceGiven === undefined && status !== 'UNASSIGNED';

    if (!skipLedgerUpdate) {
      const route = await tx.route.findUnique({ where: { id: routeId } });
      if (route) {
        const defaultAllowance = route.defaultPetrolAllowance;

        if (previous && (previous.status === 'ASSIGNED' || previous.status === 'COMPLETED')) {
          const oldDpId = previous.dpId;
          const oldPA = previous.petrolAllowanceGiven;

          if (oldPA !== null && oldPA !== undefined) {
            const oldDelta = oldPA - defaultAllowance;
            await tx.deliveryPerson.update({
              where: { id: oldDpId },
              data: { petrolBalance: { decrement: oldDelta } }
            });
          }

          await tx.ledgerTransaction.deleteMany({
            where: {
              dpId: oldDpId,
              date,
              routeId,
              type: { in: ['PETROL_ALLOWANCE', 'SHORTAGE', 'EXTRA_PAID'] }
            }
          });
        }

        if (status === 'ASSIGNED' || status === 'COMPLETED') {
          if (newPA !== null && newPA !== undefined) {
            const newDelta = newPA - defaultAllowance;

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
