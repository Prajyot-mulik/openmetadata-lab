CREATE TABLE hr.departments (
    department_id   SERIAL PRIMARY KEY,
    name            TEXT NOT NULL UNIQUE,
    cost_center     TEXT NOT NULL,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);
COMMENT ON TABLE hr.departments IS 'Organizational departments';

CREATE TABLE hr.employees (
    employee_id     SERIAL PRIMARY KEY,
    department_id   INT NOT NULL REFERENCES hr.departments(department_id),
    manager_id      INT REFERENCES hr.employees(employee_id),
    first_name      TEXT NOT NULL,
    last_name       TEXT NOT NULL,
    email           TEXT NOT NULL UNIQUE,
    job_title       TEXT NOT NULL,
    hire_date       DATE NOT NULL,
    salary          NUMERIC(12,2) NOT NULL CHECK (salary >= 0),
    is_active       BOOLEAN NOT NULL DEFAULT true
);
COMMENT ON TABLE  hr.employees        IS 'Company employees. Contains PII and salary data';
COMMENT ON COLUMN hr.employees.email  IS 'Work email address (PII)';
COMMENT ON COLUMN hr.employees.salary IS 'Annual gross salary in USD (confidential)';
COMMENT ON COLUMN hr.employees.manager_id IS 'Direct manager; NULL for the CEO';
