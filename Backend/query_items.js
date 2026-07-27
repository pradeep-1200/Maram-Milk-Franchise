require('ts-node').register();
const { prisma } = require('./src/config/db');

async function main() {
  const items = await prisma.inventoryItem.findMany();
  console.log(JSON.stringify(items, null, 2));
}

main().catch(console.error).finally(() => process.exit(0));
