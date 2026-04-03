
  create or replace   view SUPPLYCHAIN360_DB.SILVER.stg_warehouses
  
  
  
  
  as (
    with source as (
select
    RAW_DATA:warehouse_id::varchar as warehouse_id,
    RAW_DATA:city::varchar as city,
    RAW_DATA:state::varchar as state,
    INSERT_TIMESTAMP as loaded_at
from SUPPLYCHAIN360_DB.BRONZE.WAREHOUSES
)
select * from source
  );

