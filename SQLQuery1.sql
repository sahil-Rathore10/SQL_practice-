create database SQLBATCH

use SQLBATCH

create table Table1 (Id int, Name varchar(30), Department varchar(25), Location varchar(40), Salary int) 

select * from Table1;

-- insert the values into the table
INSERT INTO Table1 (Id, Name, Department, Location, Salary)
VALUES
(101, 'SAKSHI','HR','DELHI',25000),
(102, 'PARUL','MARKETING','GURGAON',28000),
(103, 'NEHA','FINANCE','PUNE',22000),
(104, 'ROHAN','IT','MUMBAI',21000),
(105, 'RAHUL','IT','GURGAON',33000),
(106, 'SANDEEP','HR','DELHI',20000),
(107, 'SAMARIA','MARKETING','GURGAON',40000);
  
  SELECT * FROM Table1;

  INSERT INTO Table1 (Id, Name, Department, Salary)
VALUES
(101, 'SAKSHI','HR',25000);

SELECT * FROM Table1;

-- DELETE, TRUNCATE, DROP
-- DELETE DELETE THE PARTICULAR ROW FROM THE TABLE LIKE
DELETE FROM Table1 WHERE Id = 101;

SELECT * FROM Table1;

-- truncate - delete all the rows from the table
TRUNCATE TABLE Table1;

SELECT * FROM Table1;

-- drop- delete table from the database

DROP TABLE Table1;
SELECT * FROM Table1;


INSERT INTO Table1 (Id, Name, Department, Location, Salary)
VALUES
(101, 'SAKSHI','HR','DELHI',25000),
(102, 'PARUL','MARKETING','GURGAON',28000),
(103, 'NEHA','FINANCE','PUNE',22000),
(104, 'ROHAN','IT','MUMBAI',21000),
(105, 'RAHUL','IT','GURGAON',33000),
(106, 'SANDEEP','HR','DELHI',20000),
(107, 'SAMARIA','MARKETING','GURGAON',40000);



create table Table1 (Id int, Name varchar(30), Department varchar(25), Location varchar(40), Salary int)

INSERT INTO Table1 (Id, Name, Department, Location, Salary)
VALUES
(101, 'SAKSHI','HR','DELHI',25000),
(102, 'PARUL','MARKETING','GURGAON',28000),
(103, 'NEHA','FINANCE','PUNE',22000),
(104, 'ROHAN','IT','MUMBAI',21000),
(105, 'RAHUL','IT','GURGAON',33000),
(106, 'SANDEEP','HR','DELHI',20000),
(107, 'SAMARIA','MARKETING','GURGAON',40000);

SELECT * FROM Table1;

SELECT TOP 3 * FROM Table1;

-- find employee where Department is HR
select * from Table1 where Department = 'HR';

-- find the employee where salary is 25000
select * from Table1 where Salary = 25000;

-- find the employee who are not work in HR department
select * from Table1 where Department <> 'HR';

--find the employee whose salary is greater than 20000
select * from Table1 where Salary > 20000;

--find the employee whose salary is less than 20000
select * from Table1 where Salary < 20000;

--find the employee whose salary is greater than equal 20000
select * from Table1 where Salary >= 20000;

--find the employee whose salary is less than equal 20000
select * from Table1 where Salary <= 20000;

-- find the employee whose department is finance or it

select * from Table1 where Department in ('Finance', 'IT');
-- where Department = 'Finance' or Department = 'IT'

-- find the employee who are not working in HR and IT department
select * from Table1 where Department not in ('HR','IT');

--find the employee whose salary in between 20000 to 25000
select * from Table1 where Salary between 20000 and 25000;

-- find the employees whose name start with S
select * from Table1 where Name like 'S%';

--find the employee whose name ends with A
select * from Table1 where Name like '%A';

-- find those emp whose name have E at second place
select * from Table1 where Name like '_E%';

