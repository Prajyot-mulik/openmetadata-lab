CREATE VIEW analytics.daily_revenue AS
SELECT
    date_trunc('day', o.ordered_at)::date                          AS order_date,
    count(DISTINCT o.order_id)                                     AS orders,
    sum(oi.quantity * oi.unit_price * (1 - oi.discount_pct / 100)) AS net_revenue
FROM sales.orders o
JOIN sales.order_items oi ON oi.order_id = o.order_id
WHERE o.status <> 'cancelled'
GROUP BY 1;
COMMENT ON VIEW analytics.daily_revenue IS 'Net revenue per day, excluding cancelled orders';

CREATE VIEW analytics.customer_lifetime_value AS
SELECT
    c.customer_id,
    c.full_name,
    c.segment,
    count(DISTINCT o.order_id)                                                 AS total_orders,
    coalesce(sum(oi.quantity * oi.unit_price * (1 - oi.discount_pct / 100)), 0) AS lifetime_value
FROM crm.customers c
LEFT JOIN sales.orders o       ON o.customer_id = c.customer_id AND o.status <> 'cancelled'
LEFT JOIN sales.order_items oi ON oi.order_id = o.order_id
GROUP BY c.customer_id, c.full_name, c.segment;
COMMENT ON VIEW analytics.customer_lifetime_value IS 'Total orders and net spend per customer';

CREATE VIEW analytics.low_stock AS
SELECT w.code AS warehouse, p.sku, p.name, s.quantity_on_hand, s.reorder_point
FROM inventory.stock_levels s
JOIN inventory.warehouses w ON w.warehouse_id = s.warehouse_id
JOIN catalog.products p     ON p.product_id = s.product_id
WHERE s.quantity_on_hand <= s.reorder_point;
COMMENT ON VIEW analytics.low_stock IS 'Products at or below their reorder point';
