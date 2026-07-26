-- AlterTable
ALTER TABLE "DeliveryPerson" ADD COLUMN     "role" TEXT NOT NULL DEFAULT 'Delivery Person';

-- AlterTable
ALTER TABLE "Route" ADD COLUMN     "defaultPetrolAllowance" INTEGER NOT NULL DEFAULT 0;
