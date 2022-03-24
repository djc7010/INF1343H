


CREATE SCHEMA LAO_Cases;
USE LAO_Cases;

DROP TABLE IF EXISTS CASES;
CREATE TABLE Cases (
  Case_ID VARCHAR(9) NOT NULL,
  Client_ID VARCHAR(9) NOT NULL,
  Staff_ID VARCHAR(9) NOT NULL, 
  Court_ID VARCHAR(9) NOT NULL,
  Vendor_ID VARCHAR(9) NOT NULL, 
  Locatoin_ID VARCHAR(9) NOT NULL,
  Case_Managed CHAR(1),
  Case_Status CHAR(1),
  Creation_Date DATETIME,
  Case_Type CHAR(2),
  Court_Date DATE,
  Court_Decision VARCHAR(25),
  Decistion_Date DATE,
  PRIMARY KEY (Case_ID)
);

TRUNCATE TABLE CASES;
INSERT INTO Cases 

(Case_ID, Client_ID, Staff_ID, Court_ID, Vendor_ID, Locatoin_ID, Case_Managed , Case_Status , Creation_Date          , Case_Type , Court_Date, Court_Decision, Decistion_Date)
VALUES 
 (1     ,''        ,''       ,''       ,'1'        ,''          ,'Y'           ,'A'           ,'2015-01-01 15:10:31'  ,'CR'       ,'2019-09-01','GUILTY'      ,'2019-09-10' ),
 (2     ,''        ,''       ,''       ,'1'        ,''          ,'Y'           ,'A'           ,'2019-09-01 09:00:00'  ,'FA'       ,'2022-05-01',''            ,NULL ),
 (3     ,''        ,''       ,''       ,'2'        ,''          ,'N'           ,'A'           ,'2019-10-01 11:11:11'  ,'CR'       ,'2022-10-05',''            ,NULL )
;
SELECT * from Cases;

/*DROP TABLE Vendor; */
CREATE TABLE Vendor (
Vendor_ID VARCHAR(9) NOT NULL,
Vendor_Name VARCHAR(25),
Tier_Rate CHAR(1),
Gender  CHAR(1),
Private_Bar Char(1),
Effective_Date  DATETIME,
Effective_Status CHAR(1),
Unit_Number  VARCHAR(3),
Street_Number VARCHAR(10),
Street_Name VARCHAR(25),
City VARCHAR(25),
Province  VARCHAR(25),
Country VARCHAR(25),
Postal_Code CHAR(6),
Phone_Number CHAR(10),
PRIMARY KEY (VENDOR_ID)
);

INSERT INTO VENDOR
(Vendor_ID, Vendor_Name , Tier_Rate , Gender , Private_Bar, Effective_Date , Effective_Status ,Unit_Number ,Street_Number , Street_Name ,City     ,Province , Country ,Postal_Code ,Phone_Number)
 VALUES
 (1       ,'John Smith' , '1'        ,'M'     ,'Y'          ,'2001-01-10'   , 'A'              , '10'       ,'1010'        ,'Young'      ,'Toronto','Ontario', 'Canada' ,'M4Y3C1'   ,'6477777771'),
 (2       ,'Roger Major', '2'        ,'M'     ,'Y'          ,'2001-01-10'   , 'A'              , '11'       ,'1011'        ,'Young'      ,'Toronto','Ontario', 'Canada' ,'M4Y3C1'   ,'6471234567'),
 (3       ,'Amy Smith'  , '3'        ,'F'     ,'Y'          ,'2001-01-10'   , 'A'              , '12'       ,'1012'        ,'Young'      ,'Toronto','Ontario', 'Canada' ,'M4Y3C1'   ,'6473217654')
;

SELECT * FROM VENDOR;



/*DROP TABLE Area_Office; */
CREATE TABLE Area_Office  (
Office_ID VARCHAR(9) NOT NULL,
Office_Name VARCHAR(25),
Unit_Number VARCHAR(3),
Street_Number VARCHAR(10),
Street_Name VARCHAR(25),
City VARCHAR(25),
Province VARCHAR(25),
Country VARCHAR(25),
Postal_Code CHAR(6),
PRIMARY KEY (OFFICE_ID)
);

INSERT INTO Area_Office
(Office_ID, Office_Name           , Unit_Number,Street_Number, Street_Name, City    , Province, Country, Postal_Code )
VALUES
(1        ,'Toronto Office'       ,'10'        ,'1010'       ,'North York','Toronto','Ontario','Canada','M1M1M1'),
(2        ,'North Ontarion Office','10'        ,'1011'       ,'North Ontario','Ottowa','Ontario','Canada','N1N2R1'),
(3        ,'South Ontarion Office','10'        ,'1012'       ,'West Ontario','Windsor','Ontario','Canada','S1S1W1')
;

SELECT * FROM Area_Office;

CREATE TABLE COS (
Case_ID VARCHAR(9),
Termination_Date DATETIME,
COS_Reason VARCHAR(25),
Case_Manager_Note VARCHAR(256),
Vendor_Note VARCHAR(256),
Client_Note VARCHAR(256)
);
TRUNCATE TABLE COS;
INSERT INTO COS
(Case_ID, Termination_Date, COS_Reason, Case_Manager_Note , Vendor_Note, Client_Note)
VALUES
(1      ,'2015-02-01'     ,'not satisfied client', 'aggreed to change','very busy to care','not satisfied at all'),
(1      ,'2015-05-01'     ,'not satisfied vendor', 'aggreed to change','not able to help the client','unhappy with this vendor'),
(2      ,'2015-02-01'     ,'status changed', 'Lawyer address changed','far away from the cilent ','aggreed to change')
;
SELECT * FROM COS;


/************ QUERIES **********************/

SELECT A.CASE_ID,
	   A.CLIENT_ID,
       A.VENDOR_ID,
       A.CASE_MANAGED,
       B.TERMINATION_DATE
FROM CASES A,COS B WHERE A.CASE_ID = B.CASE_ID AND A.VENDOR_ID = '1';

SELECT * FROM VENDOR WHERE GENDER = 'M';

/*
SELECT * 
FROM CASES A, VENDOR B, COURT C
WHERE A.VENDOR_ID = B.VENDOR_ID AND A.COURT_ID = C.COURT_ID
  */            

/************************* VIEWS *************************/
DROP VIEW IF EXISTS CASES_OF_VENDOR_1;
CREATE VIEW CASES_OF_VENDOR_1 AS
SELECT A.CASE_ID,
	   A.CLIENT_ID,
       A.VENDOR_ID,
       A.CASE_MANAGED,
       B.TERMINATION_DATE
FROM CASES A,COS B WHERE A.CASE_ID = B.CASE_ID AND A.VENDOR_ID = '1'
;

DROP VIEW IF EXISTS MALE_VENDORS;
CREATE VIEW MALE_VENDORS AS
SELECT Vendor_Name, TIER_RATE FROM VENDOR WHERE GENDER = 'M'
;

DROP VIEW IF EXISTS VIEW3;
CREATE VIEW TORONTO_OFFICES AS
SELECT OFFICE_ID,OFFICE_NAME FROM AREA_OFFICE WHERE CITY = 'Toronto';

/********************************* TRIGGER *******************************/

DROP TRIGGER IF EXISTS CASE_STATUS;
CREATE TRIGGER CASE_STATUS
AFTER INSERT ON COS
FOR EACH ROW
UPDATE CASES
	SET CASE_STATUS = 'I'
WHERE CASE_ID = NEW.CASE_ID;

/************************ FOREIGN KEYS **************************************/
ALTER TABLE `lao_cases`.`cases` 
ADD CONSTRAINT `FK_VENDOR_ID`
  FOREIGN KEY (`Vendor_ID`)
  REFERENCES `lao_cases`.`vendor` (`Vendor_ID`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  
  
