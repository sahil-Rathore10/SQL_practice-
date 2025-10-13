create database SQLBATCH2

use SQLBATCH2;

select * from Nutrition$;

select * from Department$;


select * from Producer$;

select * from Products$;

select * from [dbo].[Sale_History$];


--Q4 get all products along with their producers, including products that do not have a producer?

select Products$.name Product_Name, Producer$.name Producer_Name 
from Products$ 
left join Producer$ 
on Products$.producer_id = Producer$.id;



--Q5 Lsit all the products along with their categories, including products that do not belong to any category
select Pro.name as Product_Name, Dept.name as Category_Name
from Department$ as Dept Right Join Products$ as Pro
on Pro.Department_id = dept.id;



--Q6 /list all the products along with their category and producers
select p.name as Product_Name, d.name as Department_Name, pr.name as Producer_Name
from Products$ p
left join Department$ d
on p.Department_id = d.id
left join Producer$ pr
on p.producer_id = pr.id

select * from Employee$;


-- class 6 
select * from Employee$;

select * from Employee$
order by DEPT_NAME,SALARY DESC;


-- query for row_number, rank, dense_rank for only order by salary
select *,
ROW_NUMBER () over (order by Salary) as RN,
RANK () over (order by salary) as Rk,
DENSE_RANK () over (order by salary) as DR
from Employee$

-- query or Row_number, Rank, Dense_rank for salary order by and partition by department namw
select *,
ROW_NUMBER () over (partition by dept_name order by Salary desc) as RN,
RANK () over (partition by dept_name order by salary desc) as Rk,
DENSE_RANK () over (partition by dept_name order by salary desc) as DR
from Employee$

-- rank the employees in finance and It Department 
-- combine ranking me hum bs partition hata denge bss
select *,
RANK () over (partition by dept_name order by salary) as Rank_
from Employee$
where DEPT_NAME in ('finance', 'IT');



--ROWS BETWEEN

select *,
sum(sales) over (order by date rows between 1 preceding and 1 following) as Sum_
from tablex

select *, sum(salary) over (order by emp_id rows between 1 preceding and 1 following) as Sum_
from Employee$;

select *, sum(salary) over (order by emp_id rows between 1 preceding and 2 following) as Sum_
from Employee$;