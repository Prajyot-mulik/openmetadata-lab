CREATE TABLE catalog.categories (
    category_id     SERIAL PRIMARY KEY,
    parent_id       INT REFERENCES catalog.categories(category_id),
    name            TEXT NOT NULL UNIQUE
);
COMMENT ON TABLE catalog.categories IS 'Product category tree (parent_id = NULL for top level)';

CREATE TABLE catalog.suppliers (
    supplier_id     SERIAL PRIMARY KEY,
    name            TEXT NOT NULL UNIQUE,
    country_code    CHAR(2) NOT NULL,
    contact_email   TEXT
);
COMMENT ON TABLE catalog.suppliers IS 'Vendors we buy products from';

CREATE TABLE catalog.products (
    product_id      SERIAL PRIMARY KEY,
    sku             TEXT NOT NULL UNIQUE,
    name            TEXT NOT NULL,
    category_id     INT NOT NULL REFERENCES catalog.categories(category_id),
    supplier_id     INT NOT NULL REFERENCES catalog.suppliers(supplier_id),
    unit_cost       NUMERIC(10,2) NOT NULL CHECK (unit_cost >= 0),
    list_price      NUMERIC(10,2) NOT NULL CHECK (list_price >= 0),
    is_discontinued BOOLEAN NOT NULL DEFAULT false
);
COMMENT ON TABLE  catalog.products            IS 'Sellable products (one row per SKU)';
COMMENT ON COLUMN catalog.products.unit_cost  IS 'Purchase cost from supplier in USD';
COMMENT ON COLUMN catalog.products.list_price IS 'Default selling price in USD';
