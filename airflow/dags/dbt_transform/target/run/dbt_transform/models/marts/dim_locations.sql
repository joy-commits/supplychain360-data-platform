
  
    

create or replace transient table SUPPLYCHAIN360_DB.GOLD.dim_locations
    
    
    
    as (

select 
    store_id as location_id,
    store_name as location_name,
    'STORE' as location_type,
    city,
    state,
    region
from SUPPLYCHAIN360_DB.SILVER.stg_store_locations

union all

select 
    warehouse_id as location_id,
    null as location_name,
    'WAREHOUSE' as location_type,
    city as city,
    state as state,
    null as region
from SUPPLYCHAIN360_DB.SILVER.stg_warehouses
    )
;


  