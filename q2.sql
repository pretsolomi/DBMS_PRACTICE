/*
================================================================================
PROBLEM-2: ORDER PROCESSING DATABASE APPLICATION (CORRECTED)
Relations:
  CUSTOMER (CID: int, CNAME: varchar, CITY: varchar)
  ORDERTAB (ONO: int, ODATE: date, CID: int, ORD_AMT: int)
  ITEMTAB (INO: int, PRICE: int)
  ORDER_ITEM (ONO: int, INO: int, QTY: int)
  WAREHOUSE (WARENO: int, CITY: varchar)
  SHIPMENT (ONO: int, WARENO: int, SHIPDATE: date)
-- all my answers here: 
--https://github.com/pretsolomi/DBMS_PRACTICE

================================================================================
*/

CREATE DATABASE IF NOT EXISTS QUESTION2;
USE QUESTION2;

-- (i) Create the tables with proper primary and foreign keys

CREATE TABLE CUSTOMER (
    CID INT PRIMARY KEY,
    CNAME VARCHAR(20) NOT NULL,
    CITY VARCHAR(20) NOT NULL
);

CREATE TABLE ORDERTAB (
    ONO INT PRIMARY KEY,
    ODATE DATE NOT NULL,
    CID INT NOT NULL,
    ORD_AMT INT NOT NULL,
    FOREIGN KEY (CID) REFERENCES CUSTOMER(CID) ON DELETE CASCADE
);

CREATE TABLE ITEMTAB (
    INO INT PRIMARY KEY,
    PRICE INT NOT NULL
);

-- FIXED: Primary key columns cannot be NULL; changed ON DELETE SET NULL to ON DELETE CASCADE
CREATE TABLE ORDER_ITEM (
    ONO INT NOT NULL,
    INO INT NOT NULL,
    QTY INT NOT NULL,
    PRIMARY KEY (ONO, INO),
    FOREIGN KEY (ONO) REFERENCES ORDERTAB(ONO) ON DELETE CASCADE,
    FOREIGN KEY (INO) REFERENCES ITEMTAB(INO) ON DELETE CASCADE
);

CREATE TABLE WAREHOUSE (
    WARENO INT PRIMARY KEY,
    CITY VARCHAR(20) NOT NULL
);

CREATE TABLE SHIPMENT (
    ONO INT NOT NULL,
    WARENO INT NOT NULL,
    SHIPDATE DATE NOT NULL,
    PRIMARY KEY (ONO, WARENO),
    FOREIGN KEY (ONO) REFERENCES ORDERTAB(ONO) ON DELETE CASCADE,
    FOREIGN KEY (WARENO) REFERENCES WAREHOUSE(WARENO) ON DELETE CASCADE
);

-- View created schema structures
DESCRIBE CUSTOMER;
DESCRIBE ORDERTAB;
DESCRIBE ITEMTAB;
DESCRIBE ORDER_ITEM;
DESCRIBE WAREHOUSE;
DESCRIBE SHIPMENT;


-- (ii) Enter at least five tuples for each relation.

-- CUSTOMER LOMI
INSERT INTO CUSTOMER (CID, CNAME, CITY) VALUES 
    (100, 'A', 'BAN'), 
    (200, 'B', 'MAD'),
    (300, 'C', 'DEL'),
    (400, 'D', 'LUC'),
    (500, 'E', 'BOM');

SELECT * FROM CUSTOMER;

-- ORDERTAB
INSERT INTO ORDERTAB (ONO, ODATE, CID, ORD_AMT) VALUES 
    (1000, '2002-05-10', 100, 10000),
    (2000, '2003-05-11', 200, 30000),
    (3000, '2002-05-12', 100, 12500),
    (4000, '2003-05-13', 200, 35000),
    (5000, '2002-05-14', 500, 7500);

SELECT * FROM ORDERTAB;

-- ITEMTAB
INSERT INTO ITEMTAB (INO, PRICE) VALUES 
    (10, 2000),
    (20, 3000),
    (30, 2500),
    (40, 3500),
    (50, 1500);

SELECT * FROM ITEMTAB;

-- ORDER_ITEM
INSERT INTO ORDER_ITEM (ONO, INO, QTY) VALUES 
    (1000, 10, 5),
    (2000, 20, 10),
    (3000, 30, 5),
    (4000, 40, 10),
    (5000, 50, 5);

SELECT * FROM ORDER_ITEM;

-- WAREHOUSE
INSERT INTO WAREHOUSE (WARENO, CITY) VALUES 
    (15, 'SYD'),
    (25, 'SYD'),
    (35, 'BOM'),
    (45, 'BOM'),
    (55, 'DEL');

SELECT * FROM WAREHOUSE;

-- SHIPMENT (Includes an order shipped from multiple warehouses to test query iv)
INSERT INTO SHIPMENT (ONO, WARENO, SHIPDATE) VALUES 
    (1000, 15, '2002-06-16'),
    (1000, 25, '2002-06-18'),
    (2000, 25, '2003-07-17'),
    (3000, 35, '2002-08-18'),
    (4000, 45, '2003-09-19'),
    (5000, 55, '2002-10-20');

SELECT * FROM SHIPMENT;


-- (iii) Produce a listing: CUSTNAME, NO_OF_ORDERS, AVG_ORDER_AMT
SELECT C.CNAME AS CUSTNAME, 
       COUNT(DISTINCT OT.ONO) AS NO_OF_ORDERS, 
       AVG(OT.ORD_AMT) AS AVG_ORDER_AMT
FROM CUSTOMER C
JOIN ORDERTAB OT ON C.CID = OT.CID
GROUP BY C.CID, C.CNAME;


-- (iv) List the Order# for orders shipped from ALL warehouses the company has in a specific city (e.g., 'SYD')
SELECT S.ONO
FROM SHIPMENT S
JOIN WAREHOUSE W ON S.WARENO = W.WARENO
WHERE W.CITY = 'SYD'
GROUP BY S.ONO
HAVING COUNT(DISTINCT S.WARENO) = (
    SELECT COUNT(*) 
    FROM WAREHOUSE 
    WHERE CITY = 'SYD'
);


-- (v) Demonstrate the deletion of an item from the ITEM table and inspect ORDER_ITEM
DELETE FROM ITEMTAB 
WHERE INO = 10;

-- Displays deletion from ITEMTAB and automatic cascade removal from ORDER_ITEM
SELECT * FROM ITEMTAB;
SELECT * FROM ORDER_ITEM;


-- (vi) Generation of suitable reports.

-- Report 1: Order numbers of all orders placed by customers belonging to 'BAN'
SELECT O.ONO
FROM CUSTOMER C
JOIN ORDERTAB O ON C.CID = O.CID
WHERE C.CITY = 'BAN';

-- Report 2: Details of all orders that the company has received
SELECT * FROM ORDERTAB;
