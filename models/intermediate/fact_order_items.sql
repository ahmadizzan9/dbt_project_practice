select
    soi.order_item_id,
    soi.order_id,
    so.ordered_at,
    so.ordered_date,
    sc.customer_id,
    sc.customer_name,
    ss.store_id,
    ss.store_name,
    soi.product_sku,
    sp.product_name,
    sp.product_type,
    sp.price as item_price,
    so.subtotal,
    so.tax_paid,
    so.order_total
from
    {{ ref('stg_order_items') }} soi
    join {{ ref('stg_orders') }} so on soi.order_id = so.order_id
    join {{ ref('stg_customers') }} sc on so.customer_id = sc.customer_id
    join {{ ref('stg_stores') }} ss on so.store_id = ss.store_id
    join {{ ref('stg_products') }} sp on soi.product_sku = sp.product_sku