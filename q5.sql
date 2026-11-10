/*
================================================================================
PROBLEM 5: BANKING ENTERPRISE DATABASE
Relations:
  BRANCH (branch_name: varchar, branch_city: varchar, assets: real)
  ACCOUNT (accno: int, branch_name: varchar, balance: real)
  CUSTOMER (customer_name: varchar, customer_street: varchar, customer_city: varchar)
  DEPOSITOR (customer_name: varchar, accno: int)
  LOAN (loan_number: int, branch_name: varchar, amount: real)
  BORROWER (customer_name: varchar, loan_number: int)
================================================================================
*/

CREATE DATABASE IF NOT EXISTS QUESTION5;
USE QUESTION5;

-- (i) Create the above tables by properly specifying the primary keys and the foreign keys.

CREATE TABLE BRANCH (
    branch_name VARCHAR(25) PRIMARY KEY,
    branch_city VARCHAR(20) NOT NULL,
    assets DECIMAL(12, 2) NOT NULL
);

CREATE TABLE ACCOUNT (
    accno INT PRIMARY KEY,
    branch_name VARCHAR(25) NOT NULL,
    balance DECIMAL(12, 2) NOT NULL,
    FOREIGN KEY (branch_name) REFERENCES BRANCH(branch_name) ON DELETE CASCADE
);

CREATE TABLE CUSTOMER (
    customer_name VARCHAR(25) PRIMARY KEY,
    customer_street VARCHAR(30) NOT NULL,
    customer_city VARCHAR(20) NOT NULL
);

CREATE TABLE DEPOSITOR (
    customer_name VARCHAR(25) NOT NULL,
    accno INT NOT NULL,
    PRIMARY KEY (customer_name, accno),
    FOREIGN KEY (customer_name) REFERENCES CUSTOMER(customer_name) ON DELETE CASCADE,
    FOREIGN KEY (accno) REFERENCES ACCOUNT(accno) ON DELETE CASCADE
);

CREATE TABLE LOAN (
    loan_number INT PRIMARY KEY,
    branch_name VARCHAR(25) NOT NULL,
    amount DECIMAL(12, 2) NOT NULL,
    FOREIGN KEY (branch_name) REFERENCES BRANCH(branch_name) ON DELETE CASCADE
);

CREATE TABLE BORROWER (
    customer_name VARCHAR(25) NOT NULL,
    loan_number INT NOT NULL,
    PRIMARY KEY (customer_name, loan_number),
    FOREIGN KEY (customer_name) REFERENCES CUSTOMER(customer_name) ON DELETE CASCADE,
    FOREIGN KEY (loan_number) REFERENCES LOAN(loan_number) ON DELETE CASCADE
);

-- View schema structures
DESCRIBE BRANCH;
DESCRIBE ACCOUNT;
DESCRIBE CUSTOMER;
DESCRIBE DEPOSITOR;
DESCRIBE LOAN;
DESCRIBE BORROWER;


-- (ii) Enter at least five tuples for each relation.

-- BRANCH
INSERT INTO BRANCH (branch_name, branch_city, assets) VALUES
    ('Main', 'Bangalore', 500000.00),
    ('Citibank', 'Bangalore', 10000.23),
    ('HDFC', 'Mumbai', 25675.98),
    ('SBI', 'Bangalore', 35000.00),
    ('Gandhi Bazar', 'Bangalore', 15000.00),
    ('Town Hall', 'Sydney', 45000.00);

SELECT * FROM BRANCH;

-- CUSTOMER
INSERT INTO CUSTOMER (customer_name, customer_street, customer_city) VALUES
    ('Smith', 'Lincoln Street', 'Bangalore'),
    ('John', 'Mount Street', 'Mumbai'),
    ('Tom', 'MG Road', 'Bangalore'),
    ('Eliza', 'Brigade Road', 'Bangalore'),
    ('Aaa', 'Residency Road', 'Bangalore'),
    ('Bbb', 'Koramangala', 'Bangalore'),
    ('Ccc', 'Indiranagar', 'Bangalore');

SELECT * FROM CUSTOMER;

-- ACCOUNT
INSERT INTO ACCOUNT (accno, branch_name, balance) VALUES
    (100, 'Citibank', 8000.23),
    (122, 'Citibank', 4556.98),
    (201, 'Main', 15000.00),
    (202, 'Main', 25000.00),
    (456, 'Citibank', 3000.00),
    (457, 'Main', 7000.00),
    (458, 'SBI', 9000.00),
    (459, 'Gandhi Bazar', 11000.00),
    (601, 'Town Hall', 12000.00);

SELECT * FROM ACCOUNT;

-- DEPOSITOR
INSERT INTO DEPOSITOR (customer_name, accno) VALUES
    ('Smith', 100),
    ('John', 122),
    ('Tom', 201),
    ('Tom', 202),
    ('Eliza', 456),
    ('Eliza', 457),
    ('Eliza', 458),
    ('Eliza', 459);

SELECT * FROM DEPOSITOR;

-- LOAN
INSERT INTO LOAN (loan_number, branch_name, amount) VALUES
    (877, 'Citibank', 7887.09),
    (901, 'HDFC', 23455.22),
    (902, 'Gandhi Bazar', 3434.34),
    (903, 'Gandhi Bazar', 889.91),
    (904, 'Main', 4334.16);

SELECT * FROM LOAN;

-- BORROWER
INSERT INTO BORROWER (customer_name, loan_number) VALUES
    ('Smith', 877),
    ('John', 901),
    ('Aaa', 902),
    ('Bbb', 903),
    ('Ccc', 904);

SELECT * FROM BORROWER;


-- (iii) Find all the customers who have at least two accounts at the Main branch.
SELECT a.branch_name, d.customer_name, COUNT(a.accno) AS no_of_accounts
FROM ACCOUNT a, DEPOSITOR d
WHERE a.accno = d.accno 
  AND a.branch_name = 'Main'
GROUP BY a.branch_name, d.customer_name
HAVING COUNT(a.accno) >= 2;


-- (iv) Find all the customers who have an account at all the branches located in a specific city.
SELECT d.customer_name
FROM DEPOSITOR d, ACCOUNT a, BRANCH b
WHERE d.accno = a.accno 
  AND a.branch_name = b.branch_name 
  AND b.branch_city = 'Bangalore'
GROUP BY d.customer_name
HAVING COUNT(DISTINCT b.branch_name) = (
    SELECT COUNT(branch_name)
    FROM BRANCH
    WHERE branch_city = 'Bangalore'
);

-- all my answers here: 
--https://github.com/pretsolomi/DBMS_PRACTICE

-- (v) Demonstrate how you delete tuples in ACCOUNT relation at every branch located in a specific city.
DELETE FROM ACCOUNT
WHERE branch_name IN (
    SELECT branch_name
    FROM BRANCH
    WHERE branch_city = 'Sydney'
);

-- Display ACCOUNT relation after deletion
SELECT * FROM ACCOUNT;


-- (vi) Generate suitable reports.

-- Report 1: Display the names of all the customers who have taken a loan, count of the number of loans taken, and the total amount taken by each customer.
SELECT b.customer_name, COUNT(l.loan_number) AS no_of_loans, SUM(l.amount) AS total_amount_taken
FROM BORROWER b, LOAN l
WHERE l.loan_number = b.loan_number
GROUP BY b.customer_name;

-- Report 2: Find the names of all the customers who have taken a loan in a particular branch (e.g., 'Gandhi Bazar').
SELECT b.customer_name
FROM BORROWER b, LOAN l
WHERE l.loan_number = b.loan_number 
  AND l.branch_name = 'Gandhi Bazar';

-- Report 3: Update the balance for the customer with a given customer name to 10000 (demonstrating account balance update for a specific customer).
UPDATE ACCOUNT
SET balance = 10000.00
WHERE accno IN (
    SELECT accno 
    FROM DEPOSITOR 
    WHERE customer_name = 'Smith'
);

-- Display ACCOUNT table after the balance update
SELECT * FROM ACCOUNT;
