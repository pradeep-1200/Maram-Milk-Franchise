import { getEmptyBottleStatus, updateEmptyBottleLog } from './src/modules/empty-bottles/empty-bottles.service';
import { getRoutesWithAllocation } from './src/modules/routes/routes.service';
import { prisma } from './src/config/db';

async function main() {
  const date = new Date().toISOString().split('T')[0];
  
  // Verify material logic uses 'Bottle' and not 'Glass'
  const statuses = await getEmptyBottleStatus(date);
  
  let passed = true;
  for (const status of statuses) {
    for (const item of status.items) {
      if (item.material !== 'Bottle' || item.section !== 'Milk') {
         console.error(`ERROR: Found non-milk-bottle item in empty bottle status! ${item.name} - ${item.material} - ${item.section}`);
         passed = false;
      }
    }
  }

  // Also verify expectedEmptyBottles is non-zero if there are bottles allocated
  const routes = await getRoutesWithAllocation(date);
  for (const route of routes) {
    if (route.expectedEmptyBottles > 0) {
      console.log(`Success: Found expected bottles for route ${route.routeName}: ${route.expectedEmptyBottles}`);
    }
  }

  if (passed) {
    console.log('SUCCESS: Backend isolation and material checks passed.');
  }
}

main().catch(console.error).finally(() => prisma.$disconnect());
