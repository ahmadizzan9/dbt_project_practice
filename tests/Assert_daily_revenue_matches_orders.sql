with
    daily_revenue as (
        select 
            mdr.ordered_date, 
            mdr.store_id, 
            mdr.total_orders, 
            mdr.subtotal_revenue, 
            mdr.tax_revenue, 
            mdr.total_revenue
        from {{ ref('mart_daily_revenue') }} mdr
    ),
    orders_revenue as (
        select
            so.ordered_date,
            so.store_id,
            count(so.order_id) as total_orders,
            sum(subtotal) as subtotal_revenue,
            sum(tax_paid) as tax_revenue,
            sum(order_total) as total_revenue
        from {{ ref('stg_orders') }} so
        group by
            so.ordered_date,
            so.store_id
    )
select
    ordered_date,
    store_id,
    coalesce(drv.total_orders, 0) as daily_total_orders,
    coalesce(drv.subtotal_revenue, 0) as daily_subtotal_revenue,
    coalesce(drv.tax_revenue, 0) as daily_tax_revenue,
    coalesce(drv.total_revenue, 0) as daily_total_revenue,
    coalesce(orv.total_orders, 0) as staging_total_orders,
    coalesce(orv.subtotal_revenue, 0) as staging_subtotal_revenue,
    coalesce(orv.tax_revenue, 0) as staging_tax_revenue,
    coalesce(orv.total_revenue, 0) as staging_total_revenue
from
    daily_revenue drv
    full outer join orders_revenue orv using (ordered_date, store_id)
where
    coalesce(drv.total_orders, 0) <> coalesce(orv.total_orders, 0)
    or coalesce(drv.subtotal_revenue, 0) <> coalesce(orv.subtotal_revenue, 0)
    or coalesce(drv.tax_revenue, 0) <> coalesce(orv.tax_revenue, 0)
    or coalesce(drv.total_revenue, 0) <> coalesce(orv.total_revenue, 0)