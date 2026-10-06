CREATE TABLE sales.orders (
    order_id        SERIAL PRIMARY KEY,
    order_number    TEXT NOT NULL UNIQUE,
    customer_id     INT NOT NULL REFERENCES crm.customers(customer_id),
    shipping_address_id INT REFERENCES crm.addresses(address_id),
    sales_rep_id    INT REFERENCES hr.employees(employee_id),
    status          TEXT NOT NULL CHECK (status IN ('pending', 'paid', 'shipped', 'delivered', 'cancelled')),
    ordered_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    currency        CHAR(3) NOT NULL DEFAULT 'USD'
);
COMMENT ON TABLE  sales.orders        IS 'Customer orders (header level)';
COMMENT ON COLUMN sales.orders.status IS 'Lifecycle: pending -> paid -> shipped -> delivered, or cancelled';
CREATE INDEX ON sales.orders (customer_id);
CREATE INDEX ON sales.orders (ordered_at);

CREATE TABLE sales.order_items (
    order_item_id   SERIAL PRIMARY KEY,
    order_id        INT NOT NULL REFERENCES sales.orders(order_id) ON DELETE CASCADE,
    product_id      INT NOT NULL REFERENCES catalog.products(product_id),
    quantity        INT NOT NULL CHECK (quantity > 0),
    unit_price      NUMERIC(10,2) NOT NULL,
    discount_pct    NUMERIC(5,2) NOT NULL DEFAULT 0 CHECK (discount_pct BETWEEN 0 AND 100)
);
COMMENT ON TABLE  sales.order_items            IS 'Order line items (one row per product per order)';
COMMENT ON COLUMN sales.order_items.unit_price IS 'Price actually charged per unit, before discount';

CREATE TABLE sales.payments (
    payment_id      SERIAL PRIMARY KEY,
    order_id        INT NOT NULL REFERENCES sales.orders(order_id),
    method          TEXT NOT NULL CHECK (method IN ('card', 'bank_transfer', 'wallet')),
    amount          NUMERIC(12,2) NOT NULL CHECK (amount >= 0),
    paid_at         TIMESTAMPTZ NOT NULL DEFAULT now()
);
COMMENT ON TABLE sales.payments IS 'Payments received against orders';
