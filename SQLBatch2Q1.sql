use SQLBATCH2

with CTE1 as (select avg(Salary) as aVG_ from Employee$)

select * from CTE1;


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


-- class 7 window function and rows between
-- cummulative sum/ Running Total
select *,
SUM(Salary) over (order by emp_id rows between unbounded preceding and current row )as Running_Total
from Employee$;

-- moving average
select *,
AVG(salary) over (order by emp_id rows between 2 PRECEDING AND CURRENT ROW ) AS Moving_avgOf_2Rows
from Employee$;

--lag/lead (lag means preceding ya above or lead means following ya below

-- create a new column and show the previous employee salary in the current row
select *,
LAG(Salary) over (partition by dept_name order by emp_id ) as Lag_Salary
from Employee$;


-- create a new column and show the second bottom employee name in the current row
select *,
LEAD(emp_NAME, 2, 'No name') over (partition by dept_name order by emp_id ) as LEAD_Name
from Employee$;

--FIRST_VALUE/LAST_VALUE

--find the First employee name in each department
SELECT *,
    FIRST_VALUE(emp_name) OVER (
        PARTITION BY dept_name 
        ORDER BY emp_id
    ) AS first_emp_in_dept,
     LAST_VALUE(emp_name) OVER (
        PARTITION BY dept_name 
        ORDER BY emp_id
    ) AS last_emp_in_dept
FROM Employee$;

--find the last employee name in each department
SELECT *,
    LAST_VALUE(emp_name) OVER (
        PARTITION BY dept_name 
        ORDER BY emp_id
    ) AS last_emp_in_dept
FROM Employee$;


-- practice questions on window functions

-- 1. write a query to rank employee by salary in descending order across the data
select *,
RANK() over (order by salary desc) as DESC_Salary
from Employee$;

-- 2. assign the employee within each department based on salary (highest to lowest)
select *,
ROW_NUMBER() over (partition by dept_name order by salary desc ) as row_Num
from Employee$;

-- 3. calculate the moving average of last 4 salaries of employees
select *,
AVG(salary) over (order by emp_id rows between 3 PRECEDING AND CURRENT ROW ) AS Moving_avgOf_4Rows
from Employee$;

-- 4. calculate the difference between current and previous employee salary
SELECT *,
lag(salary,1,0) over (order by emp_id) as previous_sal,
salary - Lag(salary,1,0) over (order by emp_id) as diff_curand_pre_sal
from Employee$;

-- 5. calculate the difference between each employee salary and the average salary of their department
SELECT *,
    AVG(salary) OVER (PARTITION BY dept_name) AS avg_dept_salary,
    salary - AVG(salary) OVER (PARTITION BY dept_name) AS diff_from_avg
FROM Employee$;

-- 6.  calculate the running total of salaries in each department
select *,
Sum(salary) over (partition by dept_name order by emp_id rows between unbounded preceding and current row ) as Running_Total_sal_in_dept
from Employee$;


-- 7. calculate the moving average salary within each department
select *,
AVG(salary) over (partition by dept_name order by emp_id ) AS Avg_sal_ofDept
from Employee$;

-- 8. calculate the average salary of last 3 employee within each department
select *,
AVG(salary) over (partition by dept_name order by emp_id rows between 2 preceding and current row ) as avg_sal_of3_emp
from Employee$;


----=== class 8
--NTILE
-- syntax

select *,
NTILE(3) over (order by salary) as Ntile_
from Employee$;

-- CASE WHEN - it is used to create a conditional column

-- first used case
select *,
        case when dept_name = 'HR' then 'Category A'
             when DEPT_NAME = 'IT' then 'Category B'
             when DEPT_NAME = 'Finance' then 'Category C'
             when DEPT_NAME = 'Admin' then 'Category D'
             end as Dept_category
             from Employee$;


--  second used case
select *,
        case when dept_name = 'HR' then 'Category A'
             when DEPT_NAME = 'IT' then 'Category B'
             else 'Category C'
             end as Dept_category
             from Employee$;


-- Question employee table ko divide 3 range me or salary highest, medium, lowest

-- 1 way to do question 
select *,
NTILE(3) over (order by salary desc) as salary_group,
case
   when ntile(3) over (order by salary desc) = 1 then 'Highest salary'
   when ntile(3) over (order by salary desc) = 2 then 'Medium salary'
   else 'Lowest salary'
end as Ntile_
from Employee$;

-- 2 way to do a question 
select*,
    case when X.Ntile_ = 1 then 'lowest salary'
    when X.Ntile_ = 2 then 'Medium salary'
    else 'Highest salary'
    end as sal_define
from (select *,
ntile(3) over (order by salary) as Ntile_
from Employee$) X;

-- window function question for pratice

--1.Assign a row to each order within each region sorted by descending sales

--2.Rank customer within each region by total sales
--3.Find the dense rank of each product by profit in each category
--4.Get the first product sold (by orderDate) in each region
--5.Get the last product sold (by orderDate) in each region 
--6.For each other, find the next order date by the same customer
--7.for each other, find the previous order's profit by the same customer
--8.calculate the running total of sales for each region by order date
--9.compute the cummulative average profit for each sub-category based in order date
--10. calculate the difference in sales between each order and the previous one for each customer