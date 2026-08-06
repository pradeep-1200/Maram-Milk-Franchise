-- CreateTable
CREATE TABLE "RouteEmptyBottleBalance" (
    "id" TEXT NOT NULL,
    "routeId" TEXT NOT NULL,
    "bottleType" TEXT NOT NULL,
    "balance" INTEGER NOT NULL DEFAULT 0,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "RouteEmptyBottleBalance_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "RouteEmptyBottleBalance_routeId_bottleType_key" ON "RouteEmptyBottleBalance"("routeId", "bottleType");

-- AddForeignKey
ALTER TABLE "RouteEmptyBottleBalance" ADD CONSTRAINT "RouteEmptyBottleBalance_routeId_fkey" FOREIGN KEY ("routeId") REFERENCES "Route"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
