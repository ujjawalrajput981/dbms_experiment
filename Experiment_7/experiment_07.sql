-- Create database
CREATE DATABASE IF NOT EXISTS SalesDB;
USE SalesDB;

-- Create denormalized table
DROP TABLE IF EXISTS Sales;

CREATE TABLE Sales (
    sale_id INT,
    sale_date DATE,
    customer_id INT,
    customer_name VARCHAR(50),
    salesperson_id INT,
    salesperson_name VARCHAR(50),
    product_id INT,
    product_name VARCHAR(50),
    quantity INT
);

-- Insert sample records
INSERT INTO Sales VALUES
(1001, '2026-01-10', 1, 'Aarav', 101, 'Rahul', 201, 'Laptop', 1),
(1001, '2026-01-10', 1, 'Aarav', 101, 'Rahul', 202, 'Mouse', 2),
(1002, '2026-01-11', 2, 'Diya', 102, 'Priya', 201, 'Laptop', 1),
(1002, '2026-01-11', 2, 'Diya', 102, 'Priya', 203, 'Keyboard', 1),
(1003, '2026-01-12', 1, 'Aarav', 101, 'Rahul', 202, 'Mouse', 3),
(1003, '2026-01-12', 1, 'Aarav', 101, 'Rahul', 204, 'Monitor', 1);

-- Display denormalized data

-- Display 1NF records
SELECT sale_id, sale_date, customer_id, customer_name,
       salesperson_id, salesperson_name,
       product_id, product_name, quantity
FROM Sales
ORDER BY sale_id, product_id;

-- Create sale header table
CREATE TABLE Sale_Header AS
SELECT DISTINCT sale_id, sale_date, customer_id, customer_name,
                salesperson_id, salesperson_name
FROM Sales;

-- Create product table
CREATE TABLE Product AS
SELECT DISTINCT product_id, product_name
FROM Sales;

-- Create sale item table
CREATE TABLE Sale_Item AS
SELECT sale_id, product_id, quantity
FROM Sales;

-- Display normalized tables
SELECT * FROM Sale_Header ORDER BY sale_id;
SELECT * FROM Product ORDER BY product_id;

CREATE TABLE Customer AS
SELECT DISTINCT customer_id, customer_name
FROM Sale_Header;

-- Create salesperson table
CREATE TABLE Salesperson AS
SELECT DISTINCT salesperson_id, salesperson_name
FROM Sale_Header;

-- Create normalized sale header
CREATE TABLE Sale_Header_3NF AS
SELECT sale_id, sale_date, customer_id, salesperson_id
FROM Sale_Header;

-- Display 3NF tables
SELECT * FROM Customer ORDER BY customer_id;
SELECT * FROM Salesperson ORDER BY salesperson_id;
SELECT * FROM Sale_Header_3NF ORDER BY sale_id;

-- Verify customer records
SELECT customer_id, customer_name
FROM Customer;

-- Verify salesperson records
SELECT salesperson_id, salesperson_name
FROM Salesperson;

-- Verify product records
SELECT product_id, product_name
FROM Product;

-- Verify sale header
SELECT sale_id, sale_date, customer_id, salesperson_id
FROM Sale_Header_3NF;

-- Verify sale items
SELECT sale_id, product_id, quantity
FROM Sale_Item;

-- Reconstruct original sales data
SELECT
    H.sale_id,
    H.sale_date,
    H.customer_id,
    C.customer_name,
    H.salesperson_id,
    SP.salesperson_name,
    P.product_id,
    P.product_name,
    I.quantity
FROM Sale_Header_3NF H
JOIN Customer C
    ON H.customer_id = C.customer_id
JOIN Salesperson SP
    ON H.salesperson_id = SP.salesperson_id
JOIN Sale_Item I
    ON H.sale_id = I.sale_id
JOIN Product P
    ON I.product_id = P.product_id
ORDER BY H.sale_id, P.product_id;

-- Compare original and reconstructed row counts
SELECT
    (SELECT COUNT(*) FROM Sales) AS original_rows,
    (
        SELECT COUNT(*)
        FROM Sale_Header_3NF H
        JOIN Customer C ON H.customer_id = C.customer_id
        JOIN Salesperson SP ON H.salesperson_id = SP.salesperson_id
        JOIN Sale_Item I ON H.sale_id = I.sale_id
        JOIN Product P ON I.product_id = P.product_id
    ) AS reconstructed_rows;

-- Check customer dependency
SELECT customer_id, COUNT(DISTINCT customer_name) AS name_count
FROM Customer
GROUP BY customer_id;

-- Check salesperson dependency
SELECT salesperson_id, COUNT(DISTINCT salesperson_name) AS name_count
FROM Salesperson
GROUP BY salesperson_id;

-- Check product dependency
SELECT product_id, COUNT(DISTINCT product_name) AS name_count
FROM Product
GROUP BY product_id;