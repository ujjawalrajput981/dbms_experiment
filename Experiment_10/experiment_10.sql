-- 1. Create Database and Table
CREATE DATABASE IF NOT EXISTS QueryLabDB;
USE QueryLabDB;

DROP TABLE IF EXISTS EmployeeData;

CREATE TABLE EmployeeData (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(60) NOT NULL,
    department VARCHAR(30) NOT NULL,
    salary INT NOT NULL,
    city VARCHAR(40) NOT NULL,
    hire_date DATE NOT NULL,
    performance_score DECIMAL(4,2) NOT NULL
);

-- 2. Generate at Least 10,000 Rows
SET SESSION cte_max_recursion_depth = 10001;

INSERT INTO EmployeeData
    (emp_id, emp_name, department, salary, city, hire_date, performance_score)
WITH RECURSIVE numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 10000
)
SELECT
    n,
    CONCAT('Employee_', n),
    ELT((n MOD 5) + 1, 'IT', 'HR', 'Finance', 'Sales', 'Operations'),
    30000 + ((n * 137) MOD 90001),
    ELT((n MOD 6) + 1, 'Lucknow', 'Delhi', 'Mumbai', 'Pune', 'Jaipur', 'Chennai'),
    DATE_ADD('2015-01-01', INTERVAL (n MOD 3500) DAY),
    1.00 + ((n MOD 50) / 10.0)
FROM numbers;

SELECT COUNT(*) AS total_rows FROM EmployeeData;

-- 3. Query 1 - Function Applied to a Column
-- Slow query
EXPLAIN
SELECT emp_id, emp_name, hire_date
FROM EmployeeData
WHERE YEAR(hire_date) = 2022;

SELECT emp_id, emp_name, hire_date
FROM EmployeeData
WHERE YEAR(hire_date) = 2022;

-- Optimized version
CREATE INDEX idx_hire_date ON EmployeeData(hire_date);

EXPLAIN
SELECT emp_id, emp_name, hire_date
FROM EmployeeData
WHERE hire_date >= '2022-01-01'
  AND hire_date < '2023-01-01';

SELECT emp_id, emp_name, hire_date
FROM EmployeeData
WHERE hire_date >= '2022-01-01'
  AND hire_date < '2023-01-01';

-- 4. Query 2 - Leading Wildcard in LIKE
-- Slow query
SELECT emp_id, emp_name
FROM EmployeeData
WHERE emp_name LIKE '%999%';

SELECT emp_id, emp_name
FROM EmployeeData
WHERE emp_name LIKE '%999%';

-- Optimized version
CREATE INDEX idx_emp_name ON EmployeeData(emp_name);

EXPLAIN
SELECT emp_id, emp_name
FROM EmployeeData
WHERE emp_name LIKE 'Employee_999%';

SELECT emp_id, emp_name
FROM EmployeeData
WHERE emp_name LIKE 'Employee_999%';

-- 5. Query 3 - Filter on an Unindexed Column
-- Slow query
SELECT emp_id, emp_name, salary
FROM EmployeeData
WHERE department = 'Finance';

SELECT emp_id, emp_name, salary
FROM EmployeeData
WHERE department = 'Finance';

-- Optimized version
CREATE INDEX idx_department ON EmployeeData(department);

EXPLAIN
SELECT emp_id, emp_name, salary
FROM EmployeeData
WHERE department = 'Finance';

SELECT emp_id, emp_name, salary
FROM EmployeeData
WHERE department = 'Finance';

-- 6. Query 4 - Correlated Subquery
-- Slow query
SELECT e.emp_id, e.emp_name, e.department, e.salary
FROM EmployeeData e
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM EmployeeData e2
    WHERE e2.department = e.department
);

SELECT e.emp_id, e.emp_name, e.department, e.salary
FROM EmployeeData e
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM EmployeeData e2
    WHERE e2.department = e.department
);

-- Optimized version
CREATE INDEX idx_department_salary ON EmployeeData(department, salary);

EXPLAIN
SELECT e.emp_id, e.emp_name, e.department, e.salary
FROM EmployeeData e
JOIN (
    SELECT department, AVG(salary) AS avg_salary
    FROM EmployeeData
    GROUP BY department
) AS d ON d.department = e.department
WHERE e.salary > d.avg_salary;

SELECT e.emp_id, e.emp_name, e.department, e.salary
FROM EmployeeData e
JOIN (
    SELECT department, AVG(salary) AS avg_salary
    FROM EmployeeData
    GROUP BY department
) AS d ON d.department = e.department
WHERE e.salary > d.avg_salary;

-- 7. Query 5 - OR Condition Rewritten as UNION
-- Slow query
EXPLAIN
SELECT emp_id, emp_name, department, city
FROM EmployeeData
WHERE department = 'IT' OR city = 'Lucknow';

SELECT emp_id, emp_name, department, city
FROM EmployeeData
WHERE department = 'IT' OR city = 'Lucknow';

-- Optimized version
CREATE INDEX idx_city ON EmployeeData(city);

EXPLAIN
SELECT emp_id, emp_name, department, city
FROM EmployeeData
WHERE department = 'IT'
UNION
SELECT emp_id, emp_name, department, city
FROM EmployeeData
WHERE city = 'Lucknow';

SELECT emp_id, emp_name, department, city
FROM EmployeeData
WHERE department = 'IT'
UNION
SELECT emp_id, emp_name, department, city
FROM EmployeeData
WHERE city = 'Lucknow';