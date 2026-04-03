
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select shipment_id
from SUPPLYCHAIN360_DB.GOLD.fact_shipments
where shipment_id is null



  
  
      
    ) dbt_internal_test