with
    unique_orders as (
        select
            foi.ordered_date,
            foi.store_id,
            foi.store_name,
            foi.order_id,
            count(foi.order_item_id) as items_sold,
            sum(foi.item_price) as item_revenue,
            max(foi.subtotal) as subtotal,
            max(foi.tax_paid) as tax_paid,
            max(foi.order_total) as total
        from {{ ref('fact_order_items') }} foi
        group by
            foi.ordered_date,
            foi.store_id,
            foi.store_name,
            foi.order_id
    )
select
    ordered_date,
    store_id,
    store_name,
    count(order_id) as total_orders,
    sum(items_sold) as total_items_sold,
    sum(item_revenue) as gross_item_revenue,
    sum(subtotal) as subtotal_revenue,
    sum(tax_paid) as tax_revenue,
    sum(total) as total_revenue
from unique_orders
group by
    ordered_date,
    store_id,
    store_name