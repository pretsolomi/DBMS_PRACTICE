/*
1. Consider the Insurance database given below. The primary keys are underlined and the 
data types are specified: 
PERSON (driver – id #: String, name: string, address: string) 
CAR (regno: string, model: string, year: int) 
ACCIDENT (report-number: int, accd-date: date, location: string) 
OWNS (driver-id #:string, Regno:string) 
PARTICIPATED (driver-id: string, Regno:string, report-number:int, damage amount:int) 
(i) Create the above tables by properly specifying the primary keys and the foreign keys. 
(ii) Enter at least five tuples for each relation. 
(iii) Demonstrate how you 
		a. Update the damage amount to 25000 for the car with a specific 
			Regno in the ACCIDENT table with report number 12. 
		b. Add a new accident to the database. 
(iv) Find the total number of people who owned cars that were involved in accidents in 2008. 
(v) Find the number of accidents in which cars belonging to a specific model were involved. 
(vi) Generate suitable reports. 
(vii) Create suitable front end for querying and displaying the results. 
*/
CREATE DATABASE QUESTION1;
USE QUESTION1;
SHOW TABLES;
CREATE TABLE PERSON (
    DRIVER_ID VARCHAR(10) PRIMARY KEY,
    NAME VARCHAR(20) NOT NULL,
    ADDRESS VARCHAR(30)
);

CREATE TABLE CAR (
    REG_NO VARCHAR(10) PRIMARY KEY,
    MODEL VARCHAR(20) NOT NULL,
    YEAR INT
);

CREATE TABLE ACCIDENT (
    REPORT_NO INT PRIMARY KEY,
    DDATE DATE,
    LOCATION VARCHAR(30) NOT NULL
);

CREATE TABLE OWNS (
    DRIVER_ID VARCHAR(10),
    REG_NO VARCHAR(10),
    PRIMARY KEY (DRIVER_ID, REG_NO),
    FOREIGN KEY (DRIVER_ID) REFERENCES PERSON(DRIVER_ID) ON DELETE CASCADE,
    FOREIGN KEY (REG_NO) REFERENCES CAR(REG_NO) ON DELETE CASCADE
);

CREATE TABLE PARTICIPATED (
    DRIVER_ID VARCHAR(10),
    REG_NO VARCHAR(10),
    REPORT_NO INT,
    DAMAGE_AMOUNT INT,
    PRIMARY KEY (DRIVER_ID, REG_NO, REPORT_NO),
    FOREIGN KEY (DRIVER_ID) REFERENCES PERSON(DRIVER_ID) ON DELETE CASCADE,
    FOREIGN KEY (REG_NO) REFERENCES CAR(REG_NO) ON DELETE CASCADE,
    FOREIGN KEY (REPORT_NO) REFERENCES ACCIDENT(REPORT_NO) ON DELETE CASCADE
);

SHOW TABLES;
-- PERSON
INSERT INTO PERSON VALUES ('D001', 'ADARSH', 'JPNAGAR');
INSERT INTO PERSON VALUES ('D002', 'ANOOP', 'JAYANAGAR');
INSERT INTO PERSON VALUES ('D003', 'KIRAN', 'JAYANAGAR');
INSERT INTO PERSON VALUES ('D004', 'ABHISHEK', 'PEENYA');
INSERT INTO PERSON VALUES ('D005', 'SANJAY', 'RAJAJINAGAR');

SELECT * FROM PERSON;

-- CAR
INSERT INTO CAR VALUES ('KA01M1001', 'SKODA', 2002),
                       ('KA02B2002', 'BMW', 2008),
                        ('KA03M3003', 'MARUTI', 2008),
                        ('KA04H4004', 'HYUNDAI', 2001), 
                        ('KA05A5005', 'AUDI', 2008);

-- ACCIDENT
INSERT INTO ACCIDENT VALUES (1, '2002-01-01', 'RJNGR'),
							(2, '2003-02-03', 'JNGR'),
							(3, '2003-04-05', 'PEENYA'),
							(12, '2008-05-15', 'MGROAD'),
							(15, '2008-08-20', 'JPNGR');

-- OWNS
INSERT INTO OWNS VALUES ('D001', 'KA01M1001'),
						('D002', 'KA02B2002'),
						('D003', 'KA03M3003'),
						('D004', 'KA04H4004'),
						('D005', 'KA05A5005');

-- PARTICIPATED
INSERT INTO PARTICIPATED VALUES ('D001', 'KA01M1001', 1, 9000),
								('D002', 'KA02B2002', 12, 15000),
                                ('D003', 'KA03M3003', 12, 10000),
                                ('D004', 'KA04H4004', 3, 67800), 
                                ('D005', 'KA05A5005', 15, 20000);

-- View all tables separately in one run
SELECT * FROM PERSON;
SELECT * FROM CAR;
SELECT * FROM ACCIDENT;
SELECT * FROM OWNS;
SELECT * FROM PARTICIPATED;

-- 3
-- a. Update the damage amount to 25000 for a car with a specific REG_NO in the accident with report number 12:
UPDATE PARTICIPATED 
SET DAMAGE_AMOUNT = 25000 
WHERE REG_NO = 'KA02B2002' AND REPORT_NO = 12;

SELECT * FROM PARTICIPATED;

-- b. Add a new accident to the database:

INSERT INTO ACCIDENT VALUES (20, '2008-11-25', 'INDIRANAGAR');
SELECT * FROM ACCIDENT;

-- (iv) Total Number of People Who Owned Cars Involved in Accidents in 2008
SELECT COUNT(DISTINCT O.DRIVER_ID) AS TOTAL_PEOPLE
FROM OWNS O, PARTICIPATED P, ACCIDENT A
WHERE O.REG_NO = P.REG_NO 
  AND P.REPORT_NO = A.REPORT_NO
  AND YEAR(A.DDATE) = 2008;

-- (v) Number of Accidents Involving Cars of a Specific Model (e.g., 'MARUTI')
SELECT COUNT(DISTINCT P.REPORT_NO) AS ACCIDENT_COUNT
FROM PARTICIPATED P, CAR C
WHERE P.REG_NO = C.REG_NO 
  AND C.MODEL = 'MARUTI';
  
 -- (vi) Suitable Reports 
  SELECT P.NAME, C.MODEL, C.REG_NO, C.YEAR
FROM PERSON P, CAR C, OWNS O
WHERE P.DRIVER_ID = O.DRIVER_ID 
  AND O.REG_NO = C.REG_NO;
  
  
  -- 7 Complete accident history with driver name, car model, location, and damage amount

  SELECT P.NAME, C.MODEL, A.REPORT_NO, A.DDATE, A.LOCATION, PA.DAMAGE_AMOUNT
FROM PERSON P, CAR C, ACCIDENT A, PARTICIPATED PA
WHERE P.DRIVER_ID = PA.DRIVER_ID 
  AND C.REG_NO = PA.REG_NO 
  AND A.REPORT_NO = PA.REPORT_NO;

-- all my answers here: 
--https://github.com/pretsolomi/DBMS_PRACTICE



