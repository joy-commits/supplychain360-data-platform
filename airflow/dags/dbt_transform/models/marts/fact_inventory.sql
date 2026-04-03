{{ config(materialized='table') }}

SELECT
    i.product_id,
    i.warehouse_id,
    p.supplier_id,
    p.product_name,
    p.category,
    p.brand_name,
    w.city as warehouse_city,
    w.state as warehouse_state,
    i.quantity_available,
    i.reorder_threshold,
    case
        when i.quantity_available = 0 then 'Out of stock'
        when i.quantity_available <= i.reorder_threshold then 'Low stock'
        else 'In stock'
    end as stock_status,
    i.snapshot_date
from {{ ref('stg_inventory') }} i
left join {{ ref('stg_products') }} p on i.product_id = p.product_id
left join {{ ref('stg_warehouses') }} w on i.warehouse_id = w.warehouse_id