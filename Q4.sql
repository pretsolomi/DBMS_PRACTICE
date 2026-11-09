/*
================================================================================
PROGRAM 4: BOOK DEALER DATABASE
Relations:
  AUTHOR (author_id: int, author_name: varchar, city: varchar, country: varchar)
  PUBLISHER (publisher_id: int, publisher_name: varchar, city: varchar, country: varchar)
  CATEGORY (category_id: int, description: varchar)
  CATALOG (book_id: int, title: varchar, author_id: int, publisher_id: int, category_id: int, year: int, price: int)
  ORDER_DETAILS (order_no: int, book_id: int, quantity: int)
================================================================================
*/

CREATE DATABASE IF NOT EXISTS QUESTION4;
USE QUESTION4;

-- (i) Create the above tables by properly specifying the primary keys and the foreign keys.

CREATE TABLE AUTHOR (
    author_id INT PRIMARY KEY,
    author_name VARCHAR(25) NOT NULL,
    city VARCHAR(25),
    country VARCHAR(25)
);

CREATE TABLE PUBLISHER (
    publisher_id INT PRIMARY KEY,
    publisher_name VARCHAR(25) NOT NULL,
    city VARCHAR(25),
    country VARCHAR(25)
);

CREATE TABLE CATEGORY (
    category_id INT PRIMARY KEY,
    description VARCHAR(25) NOT NULL
);

CREATE TABLE CATALOG (
    book_id INT PRIMARY KEY,
    title VARCHAR(30) NOT NULL,
    author_id INT,
    publisher_id INT,
    category_id INT,
    year INT,
    price INT,
    FOREIGN KEY (author_id) REFERENCES AUTHOR(author_id) ON DELETE CASCADE,
    FOREIGN KEY (publisher_id) REFERENCES PUBLISHER(publisher_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES CATEGORY(category_id) ON DELETE CASCADE
);

CREATE TABLE ORDER_DETAILS (
    order_no INT PRIMARY KEY,
    book_id INT,
    quantity INT,
    FOREIGN KEY (book_id) REFERENCES CATALOG(book_id) ON DELETE CASCADE
);

-- Inspect table structures
SHOW TABLES;
DESCRIBE AUTHOR;
DESCRIBE PUBLISHER;
DESCRIBE CATEGORY;
DESCRIBE CATALOG;
DESCRIBE ORDER_DETAILS;


-- (ii) Enter at least five tuples for each relation.

-- AUTHOR
INSERT INTO AUTHOR (author_id, author_name, city, country) VALUES
    (1001, 'navathe', 'bangalore', 'india'),
    (1002, 'beck', 'rome', 'italy'),
    (1003, 'o-broien', 'paris', 'france'),
    (1999, 'godse', 'bangalore', 'india'),
    (9999, 'grewal', 'delhi', 'india');

SELECT * FROM AUTHOR;

-- PUBLISHER
INSERT INTO PUBLISHER (publisher_id, publisher_name, city, country) VALUES
    (123, 'Mcgraw', 'london', 'england'),
    (345, 'shubhas', 'mangalore', 'india'),
    (567, 'shiva', 'bangalore', 'india'),
    (789, 'manu', 'manipur', 'india'),
    (990, 'aaa', 'delhi', 'india');

SELECT * FROM PUBLISHER;

-- CATEGORY
INSERT INTO CATEGORY (category_id, description) VALUES
    (100, 'aaa'),
    (200, 'bbb'),
    (300, 'ccc'),
    (400, 'eee'),
    (500, 'ddd');

SELECT * FROM CATEGORY;

-- CATALOG
INSERT INTO CATALOG (book_id, title, author_id, publisher_id, category_id, year, price) VALUES
    (10, 'rdbms', 1001, 123, 100, 1990, 890),
    (20, 'c++', 1001, 345, 200, 2003, 240),
    (30, 'let us c', 1003, 567, 300, 2004, 600),
    (40, 'java2', 1999, 990, 400, 2002, 860),
    (50, 'linux', 1999, 789, 500, 2001, 780),
    (60, 'oops with c++', 1002, 990, 400, 2000, 200);

SELECT * FROM CATALOG;

-- ORDER_DETAILS
INSERT INTO ORDER_DETAILS (order_no, book_id, quantity) VALUES
    (111, 10, 3),
    (222, 20, 4),
    (333, 30, 9),
    (999, 30, 7),
    (888, 50, 8),
    (666, 60, 1);

SELECT * FROM ORDER_DETAILS;


-- (iii) Give the details of the authors who have 2 or more books in the catalog and the price of the books is greater than the average price of the books in the catalog and the year of publication is after 2000.
SELECT a.author_id AS AI, a.author_name AS NAM, a.city, COUNT(*) AS CNT
FROM AUTHOR a, CATALOG c
WHERE a.author_id = c.author_id
  AND c.year > 2000
  AND a.author_id IN (
      SELECT author_id 
      FROM CATALOG 
      WHERE price > (SELECT AVG(price) FROM CATALOG)
  )
GROUP BY a.author_id, a.author_name, a.city
HAVING COUNT(*) >= 2;


-- (iv) Find the author of the book which has maximum sales.
SELECT DISTINCT a.author_name
FROM AUTHOR a, CATALOG c, ORDER_DETAILS odm
WHERE a.author_id = c.author_id 
  AND odm.book_id = c.book_id
  AND EXISTS (
      SELECT od.book_id, SUM(od.quantity)
      FROM ORDER_DETAILS od
      WHERE od.book_id = odm.book_id
      GROUP BY od.book_id
      HAVING SUM(od.quantity) >= ALL (
          SELECT SUM(quantity)
          FROM ORDER_DETAILS
          GROUP BY book_id
      )
  );


-- (v) Demonstrate how you increase the price of books published by a specific publisher by 10%.
-- Query to compute and view the new 10% increased price:
SELECT p.publisher_id, p.publisher_name, 1.1 * c.price AS new_price
FROM PUBLISHER p, CATALOG c
WHERE p.publisher_id = c.publisher_id 
  AND p.publisher_name = 'aaa';

-- Permanent update statement:
UPDATE CATALOG c, PUBLISHER p
SET c.price = c.price * 1.1
WHERE c.publisher_id = p.publisher_id 
  AND p.publisher_name = 'aaa';

-- Display CATALOG table after updating the price:
SELECT * FROM CATALOG;


-- (vi) Generate suitable reports.

-- Report 1: Author Report (Author ID, Name, Book Title, Category Description, Book ID, Year, Price)
SELECT a.author_id, a.author_name, c.title, cat.description, c.book_id, c.year, c.price
FROM AUTHOR a, CATALOG c, CATEGORY cat
WHERE a.author_id = c.author_id 
  AND cat.category_id = c.category_id
ORDER BY a.author_id;

-- Report 2: Publisher Report (Publisher ID, Author Name, Book Title, Category Description, Publisher Name, Year, Price)
SELECT p.publisher_id, a.author_name, c.title, cat.description, p.publisher_name, c.year, c.price
FROM AUTHOR a, CATALOG c, CATEGORY cat, PUBLISHER p
WHERE p.publisher_id = c.publisher_id 
  AND cat.category_id = c.category_id 
  AND a.author_id = c.author_id
ORDER BY p.publisher_id;
