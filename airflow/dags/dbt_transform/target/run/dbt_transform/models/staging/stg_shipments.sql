
  create or replace   view SUPPLYCHAIN360_DB.SILVER.stg_shipments
  
  
  
  
  as (
    with source as (
select
    RAW_DATA:shipment_id::varchar as shipment_id,
    RAW_DATA:product_id::varchar as product_id,
    RAW_DATA:warehouse_id::varchar as warehouse_id,
    RAW_DATA:store_id::varchar as store_id,
    RAW_DATA:carrier::varchar as carrier,
    RAW_DATA:quantity_shipped::integer as quantity_shipped,
    RAW_DATA:shipment_date::timestamp as shipment_date,
    RAW_DATA:expected_delivery_date::timestamp as expected_delivery_date,
    RAW_DATA:actual_delivery_date::timestamp as actual_delivery_date,
    INSERT_TIMESTAMP as loaded_at
from SUPPLYCHAIN360_DB.BRONZE.SHIPMENTS
)
select * from source
  );

