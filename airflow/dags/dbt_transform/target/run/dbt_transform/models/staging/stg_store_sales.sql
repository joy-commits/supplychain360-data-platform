
  create or replace   view SUPPLYCHAIN360_DB.SILVER.stg_store_sales
  
  
  
  
  as (
    with source as (
select
    RAW_DATA:transaction_id::varchar as transaction_id,
    RAW_DATA:product_id::varchar as product_id,
    RAW_DATA:store_id::varchar as store_id,
    RAW_DATA:quantity_sold::integer as quantity_sold,
    RAW_DATA:unit_price::float as unit_price,
    RAW_DATA:sale_amount::float as sale_amount,
    RAW_DATA:discount_pct::float as discount_percent,
    RAW_DATA:transaction_timestamp::timestamp as transaction_timestamp,
    INSERT_TIMESTAMP as loaded_at
from SUPPLYCHAIN360_DB.BRONZE.STORE_SALES
)
select * from source
where transaction_id is not null
  );

