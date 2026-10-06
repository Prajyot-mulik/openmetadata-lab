CREATE TABLE crm.customers (
    customer_id     SERIAL PRIMARY KEY,
    customer_code   TEXT NOT NULL UNIQUE,
    full_name       TEXT NOT NULL,
    email           TEXT NOT NULL UNIQUE,
    phone           TEXT,
    segment         TEXT NOT NULL CHECK (segment IN ('consumer', 'small_business', 'enterprise')),
    account_manager_id INT REFERENCES hr.employees(employee_id),
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);
COMMENT ON TABLE  crm.customers         IS 'Every customer who has an account with Acme Retail';
COMMENT ON COLUMN crm.customers.email   IS 'Customer email address (PII)';
COMMENT ON COLUMN crm.customers.phone   IS 'Customer phone number (PII)';
COMMENT ON COLUMN crm.customers.segment IS 'Marketing segment: consumer, small_business or enterprise';

CREATE TABLE crm.addresses (
    address_id      SERIAL PRIMARY KEY,
    customer_id     INT NOT NULL REFERENCES crm.customers(customer_id) ON DELETE CASCADE,
    address_type    TEXT NOT NULL CHECK (address_type IN ('billing', 'shipping')),
    line1           TEXT NOT NULL,
    city            TEXT NOT NULL,
    state           TEXT,
    postal_code     TEXT NOT NULL,
    country_code    CHAR(2) NOT NULL
);
COMMENT ON TABLE crm.addresses IS 'Billing and shipping addresses of customers (PII)';
CREATE INDEX ON crm.addresses (customer_id);
