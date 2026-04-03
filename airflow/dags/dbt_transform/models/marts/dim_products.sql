{{ config(materialized='table') }}

select
    p.product_id,
    p.product_name,
    p.brand_name,
    p.category,
    s.supplier_name,
    s.country as supplier_country,
    p.unit_price
from {{ ref('stg_products') }} p
left join {{ ref('stg_suppliers') }} s on p.supplier_id = s.supplier_id