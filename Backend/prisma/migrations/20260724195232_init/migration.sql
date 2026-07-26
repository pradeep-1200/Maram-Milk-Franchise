-- CreateEnum
CREATE TYPE "Role" AS ENUM ('MANAGER', 'ADMIN');

-- CreateEnum
CREATE TYPE "AttendanceStatus" AS ENUM ('PRESENT', 'ABSENT', 'STANDBY');

-- CreateEnum
CREATE TYPE "RouteAllocationStatus" AS ENUM ('ASSIGNED', 'UNASSIGNED');

-- CreateEnum
CREATE TYPE "LedgerTransactionType" AS ENUM ('SALARY', 'ADVANCE', 'PETROL_ALLOWANCE', 'MISC');

-- CreateTable
CREATE TABLE "Manager" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "passwordHash" TEXT NOT NULL,
    "role" "Role" NOT NULL DEFAULT 'MANAGER',
    "branchName" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Manager_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DeliveryPerson" (
    "id" TEXT NOT NULL,
    "dpCode" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "mobileNumber" TEXT NOT NULL,
    "alternativeMobile" TEXT,
    "whatsappNumber" TEXT,
    "dateOfBirth" TEXT,
    "address" TEXT,
    "zone" TEXT,
    "parentNameAndAddress" TEXT,
    "parentOrSpouseMobile" TEXT,
    "alternativeAddress" TEXT,
    "aadharNumber" TEXT,
    "licenseNumber" TEXT,
    "vehicleNumber" TEXT,
    "aadharCopyUrl" TEXT,
    "licenseCopyUrl" TEXT,
    "photoUrl" TEXT,
    "dateOfJoining" TEXT,
    "gpayNumber" TEXT,
    "upiId" TEXT,
    "bankAccountDetails" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "DeliveryPerson_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Route" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "zone" TEXT NOT NULL,
    "customerCount" INTEGER NOT NULL DEFAULT 0,
    "litres" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "assignedDpId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Route_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AttendanceRecord" (
    "id" TEXT NOT NULL,
    "dpId" TEXT NOT NULL,
    "date" TEXT NOT NULL,
    "status" "AttendanceStatus" NOT NULL,
    "markedByManagerId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AttendanceRecord_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RouteAllocation" (
    "id" TEXT NOT NULL,
    "routeId" TEXT NOT NULL,
    "dpId" TEXT NOT NULL,
    "date" TEXT NOT NULL,
    "litresAllocated" DOUBLE PRECISION NOT NULL,
    "status" "RouteAllocationStatus" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "RouteAllocation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "InventoryItem" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "unit" TEXT NOT NULL,
    "material" TEXT,

    CONSTRAINT "InventoryItem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "InventoryDailyRecord" (
    "id" TEXT NOT NULL,
    "inventoryItemId" TEXT NOT NULL,
    "date" TEXT NOT NULL,
    "expectedStock" DOUBLE PRECISION NOT NULL,
    "currentStock" DOUBLE PRECISION NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "InventoryDailyRecord_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EmptyBottleLog" (
    "id" TEXT NOT NULL,
    "routeId" TEXT NOT NULL,
    "dpId" TEXT NOT NULL,
    "date" TEXT NOT NULL,
    "deliveryCompleted" BOOLEAN NOT NULL DEFAULT false,
    "oneLBottlesCollected" INTEGER NOT NULL DEFAULT 0,
    "halfLBottlesCollected" INTEGER NOT NULL DEFAULT 0,
    "flagIssue" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "EmptyBottleLog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DispatchDay" (
    "id" TEXT NOT NULL,
    "date" TEXT NOT NULL,
    "attendanceCompletedAt" TIMESTAMP(3),
    "inventoryCompletedAt" TIMESTAMP(3),
    "routesCompletedAt" TIMESTAMP(3),
    "petrolAllowanceTotal" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "DispatchDay_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LedgerTransaction" (
    "id" TEXT NOT NULL,
    "dpId" TEXT,
    "type" "LedgerTransactionType" NOT NULL,
    "amount" DOUBLE PRECISION NOT NULL,
    "note" TEXT,
    "date" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "LedgerTransaction_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Manager_email_key" ON "Manager"("email");

-- CreateIndex
CREATE UNIQUE INDEX "DeliveryPerson_dpCode_key" ON "DeliveryPerson"("dpCode");

-- CreateIndex
CREATE UNIQUE INDEX "AttendanceRecord_dpId_date_key" ON "AttendanceRecord"("dpId", "date");

-- CreateIndex
CREATE UNIQUE INDEX "RouteAllocation_routeId_date_key" ON "RouteAllocation"("routeId", "date");

-- CreateIndex
CREATE UNIQUE INDEX "InventoryDailyRecord_inventoryItemId_date_key" ON "InventoryDailyRecord"("inventoryItemId", "date");

-- CreateIndex
CREATE UNIQUE INDEX "DispatchDay_date_key" ON "DispatchDay"("date");

-- AddForeignKey
ALTER TABLE "Route" ADD CONSTRAINT "Route_assignedDpId_fkey" FOREIGN KEY ("assignedDpId") REFERENCES "DeliveryPerson"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AttendanceRecord" ADD CONSTRAINT "AttendanceRecord_dpId_fkey" FOREIGN KEY ("dpId") REFERENCES "DeliveryPerson"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AttendanceRecord" ADD CONSTRAINT "AttendanceRecord_markedByManagerId_fkey" FOREIGN KEY ("markedByManagerId") REFERENCES "Manager"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RouteAllocation" ADD CONSTRAINT "RouteAllocation_routeId_fkey" FOREIGN KEY ("routeId") REFERENCES "Route"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RouteAllocation" ADD CONSTRAINT "RouteAllocation_dpId_fkey" FOREIGN KEY ("dpId") REFERENCES "DeliveryPerson"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "InventoryDailyRecord" ADD CONSTRAINT "InventoryDailyRecord_inventoryItemId_fkey" FOREIGN KEY ("inventoryItemId") REFERENCES "InventoryItem"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EmptyBottleLog" ADD CONSTRAINT "EmptyBottleLog_routeId_fkey" FOREIGN KEY ("routeId") REFERENCES "Route"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EmptyBottleLog" ADD CONSTRAINT "EmptyBottleLog_dpId_fkey" FOREIGN KEY ("dpId") REFERENCES "DeliveryPerson"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LedgerTransaction" ADD CONSTRAINT "LedgerTransaction_dpId_fkey" FOREIGN KEY ("dpId") REFERENCES "DeliveryPerson"("id") ON DELETE SET NULL ON UPDATE CASCADE;
