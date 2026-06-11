select 
    sc.customer_id as customer_id, 
    sc.customer_name as customer_name,
    count(so.customer_id) as total_orders,
    min(so.ordered_at) as first_ordered_at, 
    max(so.ordered_at) as last_ordered_at, 
    coalesce(sum(so.order_total), 0) as lifetime_order_total
from 
    {{ ref('stg_customers') }} sc left join 
    {{ ref('stg_orders') }} so using (customer_id)
group by 
    sc.customer_id, 
    sc.customer_name