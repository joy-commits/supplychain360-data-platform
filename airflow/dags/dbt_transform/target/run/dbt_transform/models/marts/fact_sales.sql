
  
    

create or replace transient table SUPPLYCHAIN360_DB.GOLD.fact_sales
    
    
    
    as (

select
    s.transaction_id,
    s.store_id,
    s.product_id,
    p.supplier_id,
    p.product_name,
    p.category,
    p.brand_name,
    sl.city as store_city,
    sl.state as store_state,
    sl.region as store_region,
    s.quantity_sold,
    s.unit_price,
    s.sale_amount as gross_sale_amount,
    s.discount_percent,
    round(s.sale_amount * (1 - s.discount_percent), 2)  as net_sale_amount,
    s.transaction_timestamp as sold_at
from SUPPLYCHAIN360_DB.SILVER.stg_store_sales s
left join SUPPLYCHAIN360_DB.SILVER.stg_products p ON s.product_id = p.product_id
left join SUPPLYCHAIN360_DB.SILVER.stg_store_locations sl on s.store_id = sl.store_id
    )
;


  