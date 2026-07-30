import { PrismaClient } from '@prisma/client';
import { Pool } from 'pg';
import { PrismaPg } from '@prisma/adapter-pg';
import * as dotenv from 'dotenv';
dotenv.config();

const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const adapter = new PrismaPg(pool);
const prisma = new PrismaClient({ adapter });

const API_URL = 'http://localhost:3000/api/v1';

async function main() {
  // We need an auth token. Let's find a manager or create one for testing.
  let manager = await prisma.manager.findFirst();
  let token = '';
  
  if (!manager) {
    console.log("No manager found. Creating one...");
    manager = await prisma.manager.create({
      data: {
        name: 'Test Manager',
        email: 'test@marammilk.com',
        passwordHash: 'hashed',
        branchName: 'Main'
      }
    });
  }
  
  const jwt = require('jsonwebtoken');
  token = jwt.sign({ managerId: manager.id, email: manager.email, role: manager.role }, process.env.JWT_SECRET || 'secret', { expiresIn: '1d' });
  
  const headers = { Authorization: `Bearer ${token}`, 'Content-Type': 'application/json' };
  const date = '2026-07-30';

  console.log("1. Fetching initial attendance...");
  const res1 = await fetch(`${API_URL}/attendance?date=${date}`, { headers });
  const data1 = await res1.json();
  console.log(`data1:`, data1);
  console.log(`Initial Attendance size: ${JSON.stringify(data1).length} bytes`);
  console.log(`Initial DPs count: ${data1.length}`);

  console.log("\n2. Creating test DP...");
  const createRes = await fetch(`${API_URL}/delivery-persons`, {
    method: 'POST',
    headers,
    body: JSON.stringify({
      name: 'Test DP21',
      dpCode: 'DP21',
      mobileNumber: '7777777777',
      gpayNumber: '7777777777',
      upiId: 'test@upi'
    })
  });
  const createData = await createRes.json();
  if (createData.error) {
    console.error("Create failed:", createData);
    return;
  }
  const testDpId = createData.id;
  console.log(`Created test DP: ${testDpId} (response size: ${JSON.stringify(createData).length} bytes)`);

  console.log("\n3. Fetching attendance after creation...");
  const res2 = await fetch(`${API_URL}/attendance?date=${date}`, { headers });
  const data2 = await res2.json();
  console.log(`Attendance size after creation: ${JSON.stringify(data2).length} bytes`);
  console.log(`DPs count after creation: ${data2.length}`);

  console.log("\n4. Deleting test DP...");
  const delRes = await fetch(`${API_URL}/delivery-persons/${testDpId}`, { method: 'DELETE', headers });
  const delData = await delRes.json();
  console.log(`Deleted test DP (response size: ${JSON.stringify(delData).length} bytes)`);

  console.log("\n5. Fetching attendance after deletion...");
  const res3 = await fetch(`${API_URL}/attendance?date=${date}`, { headers });
  const data3 = await res3.json();
  console.log(`Attendance size after deletion: ${JSON.stringify(data3).length} bytes`);
  console.log(`DPs count after deletion: ${data3.length}`);
  
  console.log("\n6. Fetching DP Performance Report...");
  const repRes = await fetch(`${API_URL}/reports/dp-performance?range=month`, { headers });
  const repData = await repRes.json();
  console.log(`Report DPs count: ${repData.length}`);
  const hasTestDp = repData.some((dp: any) => dp.dpId === testDpId);
  console.log(`Is test DP in report? ${hasTestDp}`);
}

main()
  .catch(e => {
    console.error(e.response ? e.response.data : e.message);
  })
  .finally(async () => {
    await prisma.$disconnect();
    pool.end();
  });
