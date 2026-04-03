
  create or replace   view SUPPLYCHAIN360_DB.SILVER.stg_store_locations
  
  
  
  
  as (
    with source as (
select
    RAW_DATA:store_id::varchar as store_id,
    RAW_DATA:store_name::varchar as store_name,
    RAW_DATA:city::varchar as city,
    RAW_DATA:state::varchar as state,
    RAW_DATA:region::varchar as region,
    to_date(RAW_DATA:store_open_date::varchar, 'DD/MM/YYYY') as store_open_date,
    INSERT_TIMESTAMP as loaded_at
from SUPPLYCHAIN360_DB.BRONZE.STORE_LOCATIONS
)
select * from source
  );

