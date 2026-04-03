with source as (
select
    RAW_DATA:supplier_id::varchar as supplier_id,
    RAW_DATA:supplier_name::varchar as supplier_name,
    RAW_DATA:category::varchar as category,
    RAW_DATA:country::varchar as country,
    INSERT_TIMESTAMP as loaded_at
from SUPPLYCHAIN360_DB.BRONZE.SUPPLIERS
)
select * from source