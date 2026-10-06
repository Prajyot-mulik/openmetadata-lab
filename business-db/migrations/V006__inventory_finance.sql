CREATE TABLE inventory.warehouses (
    warehouse_id    SERIAL PRIMARY KEY,
    code            TEXT NOT NULL UNIQUE,
    city            TEXT NOT NULL,
    country_code    CHAR(2) NOT NULL
);
COMMENT ON TABLE inventory.warehouses IS 'Physical warehouses that hold stock';

CREATE TABLE inventory.stock_levels (
    warehouse_id    INT NOT NULL REFERENCES inventory.warehouses(warehouse_id),
    product_id      INT NOT NULL REFERENCES catalog.products(product_id),
    quantity_on_hand INT NOT NULL DEFAULT 0 CHECK (quantity_on_hand >= 0),
    reorder_point   INT NOT NULL DEFAULT 10,
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (warehouse_id, product_id)
);
COMMENT ON TABLE inventory.stock_levels IS 'Current stock per product per warehouse';

CREATE TABLE finance.invoices (
    invoice_id      SERIAL PRIMARY KEY,
    invoice_number  TEXT NOT NULL UNIQUE,
    order_id        INT NOT NULL UNIQUE REFERENCES sales.orders(order_id),
    issued_on       DATE NOT NULL,
    due_on          DATE NOT NULL,
    subtotal        NUMERIC(12,2) NOT NULL,
    tax_amount      NUMERIC(12,2) NOT NULL,
    total_amount    NUMERIC(12,2) GENERATED ALWAYS AS (subtotal + tax_amount) STORED,
    status          TEXT NOT NULL CHECK (status IN ('open', 'paid', 'overdue', 'void'))
);
COMMENT ON TABLE finance.invoices IS 'One invoice per order, used for revenue recognition';
