
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  -- You cannot have -5 (for instance) physical items in a warehouse

SELECT
    product_id,
    quantity_available
FROM SUPPLYCHAIN360_DB.GOLD.fact_inventory
WHERE quantity_available < 0
  
  
      
    ) dbt_internal_test