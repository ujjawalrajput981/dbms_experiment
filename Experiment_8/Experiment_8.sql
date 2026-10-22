-- PART A: CREATE TABLE AND INSERT INITIAL DATA

DROP TABLE IF EXISTS bank_accounts;

CREATE TABLE bank_accounts (
    account_id INT PRIMARY KEY,
    account_holder VARCHAR(50),
    balance DECIMAL(12,2) CHECK (balance >= 0)
);

INSERT INTO bank_accounts
VALUES
(101, 'Rahul', 10000.00),
(102, 'Aman', 5000.00);

SELECT * FROM bank_accounts;


-- PART B: DEMONSTRATE BEGIN AND COMMIT

START TRANSACTION;

UPDATE bank_accounts
SET balance = balance - 2000
WHERE account_id = 101;

UPDATE bank_accounts
SET balance = balance + 2000
WHERE account_id = 102;

COMMIT;

SELECT * FROM bank_accounts;


-- PART C: DEMONSTRATE ROLLBACK

START TRANSACTION;

UPDATE bank_accounts
SET balance = balance - 1000
WHERE account_id = 101;

-- Check the temporary balance if required
-- SELECT * FROM bank_accounts;

ROLLBACK;

SELECT * FROM bank_accounts;


-- PART D: DEMONSTRATE SAVEPOINT

START TRANSACTION;

-- Deduct 500 from Rahul
UPDATE bank_accounts
SET balance = balance - 500
WHERE account_id = 101;

-- Create a savepoint
SAVEPOINT sp1;

-- Perform another valid update
UPDATE bank_accounts
SET balance = balance - 1000
WHERE account_id = 101;

-- Undo only the update after the savepoint
ROLLBACK TO SAVEPOINT sp1;

-- Add 500 to Aman's account
UPDATE bank_accounts
SET balance = balance + 500
WHERE account_id = 102;

COMMIT;

SELECT * FROM bank_accounts;


-- PART E: DEMONSTRATE TRANSACTION ISOLATION

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

START TRANSACTION;

SELECT * FROM bank_accounts;

COMMIT;


-- PART F: DEMONSTRATE CONCURRENCY AND ISOLATION

-- SESSION 1: UPDATE ACCOUNT BALANCE


START TRANSACTION;

UPDATE bank_accounts
SET balance = 9000
WHERE account_id = 101;

COMMIT;


-- SESSION 2: READ COMMITTED ISOLATION


SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

START TRANSACTION;

SELECT balance
FROM bank_accounts
WHERE account_id = 101;

COMMIT;


-- FINAL OUTPUT: DISPLAY ALL ACCOUNT BALANCES

SELECT * FROM bank_accounts;