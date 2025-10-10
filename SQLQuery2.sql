-- find the employees whose last name starts with S
select * from Table1 where Name like '% S%';

-- insert table surname value
INSERT INTO Table1 (Id, Name, Department, Location, Salary)
VALUES
(108, 'SAHIL SHARMA','IT','AGRA',45000);

-- find the names whose firt name ends with i and has s in the second name
select * from Table1 where Name like '%I %S%';


-- find the name start with S and surname also start with s
select * from Table1 where Name like 'S% S%';

--insert new value 
INSERT INTO Table1 (Id, Name, Department, Location, Salary)
VALUES
(109, 'shalini jeswani','HR','AGRA',5000);

select * from Table1;

-- find the name that have S and A in their first name and e and s in surname
select Name from Table1 where Name like '%S%A% %E%S%';

-- questions for practice
--1 find the employee ids whose salary second character is 2
select Id from Table1 where Salary like '_2%';

--2 find the employee who are working in HR  department and have salary more than 20000
select * from Table1 where Department = 'HR' and Salary >= 20000;


--3 find the employee whose name contains H and works in IT department
select * from Table1 where Name like '%H%' and Department = 'IT';

--4 find the department whose employee name starts with V OR S
select Department from Table1 where Name like 'V%' or Name like 'S%';

--5 how many unique departments are there in a table
select count (DISTINCT Department) from Table1;

--6 how many employees are working in finance and IT department
select count (*) as Departments from Table1 where Department in ('finance', 'IT');


-- aggregation functions

--1 find  the employee having maximum salary
select max(Salary) as MAX_Salary
from Table1;

--2 find the employee having minimum salary
select min(Salary) as MAX_Salary
from Table1;

--3 find the total salary of employee
select sum(Salary) as TOTAL_Salary
from Table1;

--4 find the average salary of an employee
select avg(Salary) as Average_Salary
from Table1;


--5 find the total salary of employee department wise
select Department, sum(Salary) as Sum_Salary
from Table1
group by Department

-- order by ..arrange data according to ASC or DESC order 
select * 
from Table1
order by Salary desc

-- INTERVIEW QUESTION 
-- ORDER OF OPERATION AT FRONTEND
SELECT
FROM 
WHERE
GROUP BY
HAVING
ORDER BY

-- ORDER OF OPERATION AT BACKEND
FROM 
WHERE
GROUP BY
HAVING 
SELECT
ORDER BY


-- question on having or where (having use on aggregate functin column and where used non-Aggregate function )
-- 1 find the empl whose emp_id range from 115 to 120
select * 
from Table1
where Id in (105, 108);

-- 2 find the emp_id whose salary is greater than 4000 and less than 8000
select Id 
from Table1
where Salary > 4000 and Salary < 8000 ;

select * from Table1

-- 3 find the emp name whose has R in their names
select Name 
from Table1
where Name like '%R%';

-- 4 find the departments whose average salary is less than equal to 7000
select Department, avg(Salary) as AVG_SAlary
from Table1
group by Department
having avg(Salary) <= 7000

-- 5 find the emp whose departments is either HR or IT and sum of salary is greater than 13000
SELECT Name, Department, sum(Salary) as total_SALARY
FROM Table1
WHERE Department IN ('HR', 'IT')
GROUP BY Name, Department
HAVING sum(Salary) > 13000;

-- hum yaha per total_salary alias name use ni kr skte having me because of order of backend select run at the end

SELECT *
FROM Table1
WHERE Department IN (
    SELECT Department
    FROM Table1
    WHERE Department IN ('HR','IT')
    GROUP BY Department
    HAVING SUM(Salary) > 13000
);


-- 6 Arrange the data in ascendding order based on emp_name
select *
from Table1
order by Name;


-- 7 find the employees whose name ends with M and have Department name either IT or Finance
select *
from Table1
where Name like '%l' and Department IN ('IT', 'Finance');




-- Joins
-- what is joins
-- joins are used to combine data of 2 or more tables based on the common column between them 

--types of Joins
-- INNER - gives you common records from both the tables
-- LEFT - gives you complete left table data and matched records from right table
-- RIGHT - gives you complete right table data and matched records from the left table
-- FULL - complete records from both the tables
-- CROSS - cartesian product
-- SELF - when a table is joined with itself

use SQLBATCH

create table Left1 (Id int, Name varchar(30), Department varchar(25)) 

-- left join
select *
from Sheet1$ LEFT JOIN Sheet2$
ON Sheet1$.id = Sheet2$.id;

-- right join
select *
from Sheet1$ RIGHT JOIN Sheet2$
ON Sheet1$.id = Sheet2$.id;

-- Inner join 
select *
from Sheet1$ INNER JOIN Sheet2$
ON Sheet1$.id = Sheet2$.id;

-- Full join
select * 
from Sheet1$ FULL JOIN Sheet2$
ON Sheet1$.id = Sheet2$.id;

select * from Sheet1$

select * from Sheet2$

-- Cross Join
select * 
from Sheet1$ CROSS JOIN Sheet2$;

-- self joins



-- class 5 joins practice

use SQLBATCH

create table Q3T1 (Id int, First_name varchar(30), Last_name varchar(35)) 

INSERT INTO Q3T1 (Id, First_name, Last_name )
VALUES
(1, 'Steve','bergman'),
(2, 'Steve','Johnson'),
(3, 'Steve','King');

create table Q3T2 (Id int, First_name varchar(30), Last_name varchar(35)) 

INSERT INTO Q3T2 (Id, First_name, Last_name )
VALUES
(1, 'Ann','Coleman'),
(2, 'Steve','Bergman'),
(3, 'Steve','Young'),
(4, 'Donna','Winter'),
(5, 'Steve','King');

select * from Q3T1;

select * from Q3T2;

create table Q2T1 (Id int, name varchar(30), supervisor_id int) 

INSERT INTO Q2T1 (Id, name, supervisor_id  )
VALUES
(1, 'Mathew',null),
(2, 'Kate',1),
(3, 'John', 5),
(4, 'Walter', 2),
(5, 'Suzan',null);

select * from Q2T1;

--Employee Table- EmployeeID, Name, DepartmentID
--Department Table- DepartmentID, DepartmentName

-- questions
--Q1 write a query to list all employees along with their respective department names.

select emp.EmployeeID, emp.Name, emp.DepartmentID, dept.DepartmentNAme
from Employee emp 
LEFT JOIN Department dept
ON emp.DepartmentID = dept.DepartmentID;

--Q2 List all workers and their direct supervisors
select t1.id, t1.name, t1.supervisor_id, t2.name as supervisor_name
from Q2T1 as t1
join Q2T1 as t2
on t2.supervisor_id = t1.id;


--Q3 give the following output first_name , Last_name steve, steve, bergman, king

select t1.First_name, t1.Last_name
from Q3T1 t1 
INNER JOIN Q3T2 t2
ON t1.Last_name = t2.Last_name
and t1.First_name = t1.First_name;




--Q4 get all products along with their producers, including products that do not have a producer


--Q5 Lsit all the products along with their categories, including products that do not belong to any category

--Q6 /list all the products along with their category and producers
