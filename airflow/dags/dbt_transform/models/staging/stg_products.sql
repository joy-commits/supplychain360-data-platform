with source as (
select
    RAW_DATA:product_id::varchar as product_id,
    RAW_DATA:product_name::varchar as product_name,
    RAW_DATA:brand::varchar as brand_name,
    RAW_DATA:category::varchar as category,
    RAW_DATA:supplier_id::varchar as supplier_id,
    RAW_DATA:unit_price::float as unit_price,
    INSERT_TIMESTAMP as loaded_at
from {{ source('bronze', 'PRODUCTS') }}
)
select * from source