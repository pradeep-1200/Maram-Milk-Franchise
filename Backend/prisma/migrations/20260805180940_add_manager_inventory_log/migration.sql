-- CreateTable
CREATE TABLE "ManagerInventoryLog" (
    "id" TEXT NOT NULL,
    "date" TEXT NOT NULL,
    "product" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL,
    "managerId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ManagerInventoryLog_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "ManagerInventoryLog_date_product_managerId_key" ON "ManagerInventoryLog"("date", "product", "managerId");

-- AddForeignKey
ALTER TABLE "ManagerInventoryLog" ADD CONSTRAINT "ManagerInventoryLog_managerId_fkey" FOREIGN KEY ("managerId") REFERENCES "Manager"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
