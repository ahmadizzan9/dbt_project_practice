select
    dc.customer_id,
    dc.customer_name,
    dc.total_orders,
    dc.first_ordered_at,
    dc.last_ordered_at,
    dc.lifetime_order_total,
    case
        when dc.total_orders = 0 then 0
        else round( dc.lifetime_order_total * 1.0 / dc.total_orders, 2 )
    end as average_order_value
from {{ ref('dim_customers') }} dc