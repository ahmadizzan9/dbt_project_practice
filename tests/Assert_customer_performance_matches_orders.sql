with
    customer_performance as (
        select 
            mcp.customer_id, 
            mcp.total_orders, 
            mcp.lifetime_order_total as lifetime_revenue
        from {{ ref('mart_customer_performance') }} mcp
    ),
    orders as (
        select
            so.customer_id,
            count(so.order_id) as total_orders,
            sum(so.order_total) as lifetime_revenue
        from {{ ref('stg_orders') }} so
        group by
            so.customer_id
    )
select
    customer_id,
    coalesce(cm.total_orders, 0) as performance_total_order,
    coalesce(o.total_orders, 0) as staging_total_order,
    coalesce(cm.lifetime_revenue, 0) as performance_lifetime_revenue,
    coalesce(o.lifetime_revenue, 0) as staging_lifetime_revenue
from
    customer_performance cm
    full outer join orders o using (customer_id)
where
    cm.total_orders <> o.total_orders
    or cm.lifetime_revenue <> o.lifetime_revenue