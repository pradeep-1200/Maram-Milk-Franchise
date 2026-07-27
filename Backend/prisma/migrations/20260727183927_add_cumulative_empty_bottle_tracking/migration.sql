-- AlterTable
ALTER TABLE "EmptyBottleLog" ADD COLUMN     "actualDelivered1L" INTEGER,
ADD COLUMN     "actualDeliveredHalfL" INTEGER,
ADD COLUMN     "actualDeliveredPacket" INTEGER,
ADD COLUMN     "carriedOver1L" INTEGER,
ADD COLUMN     "carriedOverHalfL" INTEGER,
ADD COLUMN     "carriedOverPacket" INTEGER,
ADD COLUMN     "expected1L" INTEGER,
ADD COLUMN     "expectedHalfL" INTEGER,
ADD COLUMN     "expectedPacket" INTEGER,
ADD COLUMN     "halfLPacketCollected" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "outstanding1L" INTEGER,
ADD COLUMN     "outstandingHalfL" INTEGER,
ADD COLUMN     "outstandingPacket" INTEGER;
