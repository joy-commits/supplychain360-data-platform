-- Can the discount be too high such that the net sale amount is negative?
-- (Net sale amount should never be greater than gross sale amount)

SELECT
    transaction_id,
    net_sale_amount
FROM {{ ref('fact_sales') }}
WHERE net_sale_amount < 0