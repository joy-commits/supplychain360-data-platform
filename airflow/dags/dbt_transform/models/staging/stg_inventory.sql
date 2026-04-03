with source as (
select
    RAW_DATA:product_id::varchar as product_id,
    RAW_DATA:warehouse_id::varchar as warehouse_id,
    RAW_DATA:quantity_available::integer as quantity_available,
    RAW_DATA:reorder_threshold::integer as reorder_threshold,
    RAW_DATA:snapshot_date::date as snapshot_date,
    INSERT_TIMESTAMP as loaded_at
from {{ source('bronze', 'INVENTORY') }}
)
select * from source