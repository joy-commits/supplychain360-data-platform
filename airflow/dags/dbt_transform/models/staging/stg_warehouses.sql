with source as (
select
    RAW_DATA:warehouse_id::varchar as warehouse_id,
    RAW_DATA:city::varchar as city,
    RAW_DATA:state::varchar as state,
    INSERT_TIMESTAMP as loaded_at
from {{ source('bronze', 'WAREHOUSES') }}
)
select * from source