-- Acme Retail: one schema per business domain
CREATE SCHEMA IF NOT EXISTS crm;
CREATE SCHEMA IF NOT EXISTS catalog;
CREATE SCHEMA IF NOT EXISTS sales;
CREATE SCHEMA IF NOT EXISTS inventory;
CREATE SCHEMA IF NOT EXISTS hr;
CREATE SCHEMA IF NOT EXISTS finance;
CREATE SCHEMA IF NOT EXISTS analytics;

COMMENT ON SCHEMA crm       IS 'Customer relationship management: customers and their addresses';
COMMENT ON SCHEMA catalog   IS 'Product catalog: categories, suppliers and products';
COMMENT ON SCHEMA sales     IS 'Order-to-cash: orders, line items and payments';
COMMENT ON SCHEMA inventory IS 'Warehouses and stock levels';
COMMENT ON SCHEMA hr        IS 'Departments and employees';
COMMENT ON SCHEMA finance   IS 'Invoices and accounting';
COMMENT ON SCHEMA analytics IS 'Reporting views built on top of the operational schemas';
