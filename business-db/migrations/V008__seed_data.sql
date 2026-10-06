-- Small, fictional sample data so OpenMetadata's profiler and sample-data features have something to show
INSERT INTO hr.departments (name, cost_center) VALUES
  ('Executive', 'CC-100'), ('Sales', 'CC-200'), ('Operations', 'CC-300'), ('Finance', 'CC-400');

INSERT INTO hr.employees (department_id, manager_id, first_name, last_name, email, job_title, hire_date, salary) VALUES
  (1, NULL, 'Dana',  'Reyes',  'dana.reyes@acme.example',  'CEO',               '2018-01-15', 250000),
  (2, 1,    'Omar',  'Haddad', 'omar.haddad@acme.example', 'Head of Sales',     '2019-03-01', 160000),
  (2, 2,    'Lena',  'Park',   'lena.park@acme.example',   'Account Executive', '2021-06-10',  90000),
  (3, 1,    'Ravi',  'Iyer',   'ravi.iyer@acme.example',   'Ops Manager',       '2020-02-20', 120000),
  (4, 1,    'Grace', 'Okafor', 'grace.okafor@acme.example','Controller',        '2019-09-05', 140000);

INSERT INTO crm.customers (customer_code, full_name, email, phone, segment, account_manager_id) VALUES
  ('C-0001', 'Brightline Studios', 'ap@brightline.example', '+1-555-0101', 'small_business', 3),
  ('C-0002', 'Jordan Miles',       'jordan@mail.example',   '+1-555-0102', 'consumer',       NULL),
  ('C-0003', 'Northpeak Logistics','buy@northpeak.example', '+1-555-0103', 'enterprise',     2),
  ('C-0004', 'Priya Nair',         'priya@mail.example',    NULL,          'consumer',       NULL);

INSERT INTO crm.addresses (customer_id, address_type, line1, city, state, postal_code, country_code) VALUES
  (1, 'shipping', '12 Market St',  'Austin',  'TX', '73301', 'US'),
  (2, 'shipping', '8 Elm Ave',     'Denver',  'CO', '80014', 'US'),
  (3, 'billing',  '500 Harbor Rd', 'Seattle', 'WA', '98101', 'US'),
  (3, 'shipping', '502 Harbor Rd', 'Seattle', 'WA', '98101', 'US'),
  (4, 'shipping', '21 Lake View',  'Pune',    NULL, '411001','IN');

INSERT INTO catalog.categories (parent_id, name) VALUES
  (NULL, 'Electronics'), (1, 'Laptops'), (1, 'Accessories'), (NULL, 'Office');

INSERT INTO catalog.suppliers (name, country_code, contact_email) VALUES
  ('Volt Components', 'TW', 'sales@volt.example'), ('PaperWorks', 'US', 'orders@paperworks.example');

INSERT INTO catalog.products (sku, name, category_id, supplier_id, unit_cost, list_price) VALUES
  ('LAP-14-PRO', '14" Pro Laptop',  2, 1, 820.00, 1299.00),
  ('ACC-MOUSE',  'Wireless Mouse',  3, 1,   9.50,   29.00),
  ('ACC-DOCK',   'USB-C Dock',      3, 1,  45.00,  119.00),
  ('OFF-PAPER',  'A4 Paper (500)',  4, 2,   3.20,    7.99);

INSERT INTO inventory.warehouses (code, city, country_code) VALUES ('WH-AUS', 'Austin', 'US'), ('WH-SEA', 'Seattle', 'US');

INSERT INTO inventory.stock_levels (warehouse_id, product_id, quantity_on_hand, reorder_point) VALUES
  (1, 1, 25, 10), (1, 2, 300, 50), (1, 3, 8, 15), (2, 1, 5, 10), (2, 4, 1200, 200);

INSERT INTO sales.orders (order_number, customer_id, shipping_address_id, sales_rep_id, status, ordered_at) VALUES
  ('SO-1001', 1, 1, 3,    'delivered', '2026-09-01 10:15+00'),
  ('SO-1002', 2, 2, NULL, 'shipped',   '2026-09-03 14:02+00'),
  ('SO-1003', 3, 4, 2,    'paid',      '2026-09-05 09:30+00'),
  ('SO-1004', 4, 5, NULL, 'cancelled', '2026-09-06 18:45+00');

INSERT INTO sales.order_items (order_id, product_id, quantity, unit_price, discount_pct) VALUES
  (1, 1, 2, 1299.00, 5), (1, 3, 2, 119.00, 0),
  (2, 2, 1,   29.00, 0),
  (3, 1, 10, 1250.00, 10), (3, 4, 50, 7.99, 0),
  (4, 2, 3,   29.00, 0);

INSERT INTO sales.payments (order_id, method, amount, paid_at) VALUES
  (1, 'card',          2706.10, '2026-09-01 10:16+00'),
  (2, 'wallet',          29.00, '2026-09-03 14:03+00'),
  (3, 'bank_transfer', 11649.50,'2026-09-07 08:00+00');

INSERT INTO finance.invoices (invoice_number, order_id, issued_on, due_on, subtotal, tax_amount, status) VALUES
  ('INV-5001', 1, '2026-09-01', '2026-10-01', 2706.10, 216.49, 'paid'),
  ('INV-5002', 2, '2026-09-03', '2026-10-03',   29.00,   2.32, 'paid'),
  ('INV-5003', 3, '2026-09-05', '2026-10-05', 11649.50, 931.96, 'open');
