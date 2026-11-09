/*
================================================================================
PROBLEM-2: ORDER PROCESSING DATABASE APPLICATION
Relations:
  CUSTOMER (CID: int, CNAME: varchar, CITY: varchar)
  ORDERTAB (ONO: int, ODATE: date, CID: int, ORD_AMT: int)
  ITEMTAB (INO: int, PRICE: int)
  ORDER_ITEM (ONO: int, INO: int, QTY: int)
  WAREHOUSE (WARENO: int, CITY: varchar)
  SHIPMENT (ONO: int, WARENO: int, SHIPDATE: date)
================================================================================
*/

CREATE DATABASE IF NOT EXISTS QUESTION2;
USE QUESTION2;

-- (i) Create the above tables by properly specifying the primary keys and the foreign keys.

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

CREATE TABLE ORDER_ITEM (
    ONO INT,
    INO INT NULL,
    QTY INT NOT NULL,
    PRIMARY KEY (ONO, INO),
    FOREIGN KEY (ONO) REFERENCES ORDERTAB(ONO) ON DELETE CASCADE,
    FOREIGN KEY (INO) REFERENCES ITEMTAB(INO) ON DELETE SET NULL
);

CREATE TABLE WAREHOUSE (
    WARENO INT PRIMARY KEY,
    CITY VARCHAR(20) NOT NULL
);

CREATE TABLE SHIPMENT (
    ONO INT,
    WARENO INT,
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

-- CUSTOMER
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

-- SHIPMENT
INSERT INTO SHIPMENT (ONO, WARENO, SHIPDATE) VALUES 
    (1000, 15, '2002-06-16'),
    (2000, 25, '2003-07-17'),
    (3000, 35, '2002-08-18'),
    (4000, 45, '2003-09-19'),
    (5000, 55, '2002-10-20');

SELECT * FROM SHIPMENT;


-- (iii) Produce a listing: CUSTNAME, NO_OF_ORDERS, AVG_ORDER_AMT, where the middle column is the total number of orders by the customer and the last column is the average order amount for that customer.
SELECT C.CID, C.CNAME, COUNT(*) AS NO_OF_ORDERS, AVG(OI.QTY * I.PRICE) AS AVG_ORDER_AMT
FROM CUSTOMER C, ORDERTAB OT, ITEMTAB I, ORDER_ITEM OI
WHERE C.CID = OT.CID 
  AND OT.ONO = OI.ONO 
  AND OI.INO = I.INO
GROUP BY C.CID, C.CNAME;


-- (iv) List the Order# for the orders that were shipped from all the warehouses that the company has in a specific city.
SELECT S.ONO
FROM SHIPMENT S, WAREHOUSE W
WHERE S.WARENO = W.WARENO 
  AND W.CITY = 'SYD';


-- (v) Demonstrate the deletion of an item from the ITEM table and demonstrate a method of handling the rows in the ORDER_ITEM table that contain this particular item.
DELETE FROM ITEMTAB 
WHERE INO = 10;

-- Display ITEMTAB and ORDER_ITEM to inspect the effect of deletion
SELECT * FROM ITEMTAB;
SELECT * FROM ORDER_ITEM;


-- (vi) Generation of suitable reports.

-- Report 1: Order numbers of all orders placed by customers who belong to a particular city (e.g., 'BAN')
SELECT O.ONO
FROM CUSTOMER C, ORDERTAB O
WHERE C.CID = O.CID 
  AND C.CITY = 'BAN';

-- Report 2: Details of all orders that the company has received
SELECT *
FROM ORDERTAB;
