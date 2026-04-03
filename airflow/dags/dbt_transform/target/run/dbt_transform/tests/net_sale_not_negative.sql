
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  -- Can the discount be too high such that the net sale amount is negative?
-- (Net sale amount should never be greater than gross sale amount)

SELECT
    transaction_id,
    net_sale_amount
FROM SUPPLYCHAIN360_DB.GOLD.fact_sales
WHERE net_sale_amount < 0
  
  
      
    ) dbt_internal_test