import { prisma } from '../config/db';

async function main() {
  const nullAllocations = await prisma.routeAllocation.findMany({
    where: { dpId: null as any },
  });
  console.log('Null DP in RouteAllocation:', nullAllocations.length);

  const nullLogs = await prisma.emptyBottleLog.findMany({
    where: { dpId: null as any },
  });
  console.log('Null DP in EmptyBottleLog:', nullLogs.length);
}

main()
  .catch(e => console.error(e))
  .finally(async () => await prisma.$disconnect());
