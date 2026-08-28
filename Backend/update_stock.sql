DO $$
DECLARE
    today TEXT := to_char(CURRENT_DATE, 'YYYY-MM-DD');
    item RECORD;
BEGIN
    FOR item IN SELECT id FROM "InventoryItem"
    LOOP
        INSERT INTO "InventoryDailyRecord" (
            id, 
            "inventoryItemId", 
            date, 
            "expectedStock", 
            "currentStock", 
            "newStockAdded", 
            "carriedOverStock", 
            "brokenStock",
            "updatedAt"
        )
        VALUES (
            gen_random_uuid()::text, 
            item.id, 
            today, 
            100, 
            100, 
            100, 
            0,
            0,
            CURRENT_TIMESTAMP
        )
        ON CONFLICT ("inventoryItemId", date) 
        DO UPDATE SET 
            "expectedStock" = 100,
            "currentStock" = 100,
            "newStockAdded" = 100,
            "updatedAt" = CURRENT_TIMESTAMP;
    END LOOP;
END $$;
