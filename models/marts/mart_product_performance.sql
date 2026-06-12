with
    product_sales as (
        select
            foi.product_sku,
            count(foi.order_item_id) as total_items_sold,
            count(distinct foi.order_id) as total_orders,
            sum(foi.item_price) as gross_revenue
        from {{ ref('fact_order_items') }} foi
        group by
            foi.product_sku
    )
select
    dp.product_sku,
    dp.product_name,
    dp.product_type,
    dp.price,
    dp.supply_count,
    dp.total_supply_cost,
    dp.has_perishable_supply,
    coalesce(total_items_sold, 0) as total_items_sold,
    coalesce(total_orders, 0) as total_orders,
    coalesce(gross_revenue, 0) as gross_revenue
from {{ ref('dim_products') }} dp
    left join product_sales using (product_sku)