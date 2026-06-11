select
    sp.product_sku,
    sp.product_name,
    sp.product_type,
    sp.price,
    sp.description,
    count(ss.product_sku) as supply_count,
    sum(ss.cost) as total_supply_cost,
    bool_or(ss.perishable) as has_perishable_supply
from
    {{ ref('stg_products') }} sp
    join {{ ref('stg_supplies') }} ss using (product_sku)
group by
    sp.product_sku,
    sp.product_name,
    sp.product_type,
    sp.price,
    sp.description