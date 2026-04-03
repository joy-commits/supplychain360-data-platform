-- You cannot have -5 (for instance) physical items in a warehouse

SELECT
    product_id,
    quantity_available
FROM SUPPLYCHAIN360_DB.GOLD.fact_inventory
WHERE quantity_available < 0