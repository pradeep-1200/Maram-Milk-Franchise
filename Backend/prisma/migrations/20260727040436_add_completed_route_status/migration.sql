-- AlterEnum
-- This migration adds more than one value to an enum.
-- With PostgreSQL versions 11 and earlier, this is not possible
-- in a single migration. This can be worked around by creating
-- multiple migrations, each migration adding only one value to
-- the enum.


ALTER TYPE "LedgerTransactionType" ADD VALUE 'SHORTAGE';
ALTER TYPE "LedgerTransactionType" ADD VALUE 'EXTRA_PAID';

-- AlterEnum
ALTER TYPE "RouteAllocationStatus" ADD VALUE 'COMPLETED';

-- AlterTable
ALTER TABLE "DeliveryPerson" ADD COLUMN     "isActive" BOOLEAN NOT NULL DEFAULT true;

-- AlterTable
ALTER TABLE "LedgerTransaction" ADD COLUMN     "routeId" TEXT;

-- AlterTable
ALTER TABLE "RouteAllocation" ADD COLUMN     "petrolAllowanceGiven" INTEGER,
ADD COLUMN     "qty1LBottle" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "qtyHalfLBottle" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "qtyHalfLPacket" INTEGER NOT NULL DEFAULT 0;

-- CreateIndex
CREATE UNIQUE INDEX "EmptyBottleLog_routeId_date_key" ON "EmptyBottleLog"("routeId", "date");

-- AddForeignKey
ALTER TABLE "LedgerTransaction" ADD CONSTRAINT "LedgerTransaction_routeId_fkey" FOREIGN KEY ("routeId") REFERENCES "Route"("id") ON DELETE SET NULL ON UPDATE CASCADE;

