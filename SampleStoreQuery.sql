create Database SampleStore;
use SampleStore;
select * from Orders$;
select * from People$;
select * from Returns$;

-- window function question for pratice

--1.Assign a row to each order within each region sorted by descending sales
select [Order ID],Region,Sales,
ROW_NUMBER() over (partition by Region order by Sales desc) as ROW_num_by_region_wise
from Orders$;

--2.Rank customer within each region by total sales
select [Customer ID], Region,
sum(sales) as Total_sales,
Rank() over (partition by Region order by sum(sales) desc) as Rankwise_total_Sales 
from Orders$
GROUP BY [Customer ID], Region
ORDER BY Region, Rankwise_total_Sales;

--3.Find the dense rank of each product by profit in each category
select Category, [Product ID],[Product Name], SUM(Profit) as TotalProfit,
DENSE_RANK() over (partition by Category order by Sum(Profit) DESC ) as DENSERANK_BY_PROFIT
from Orders$
group by Category, [Product ID],[Product Name];


--4.Get the first product sold (by orderDate) in each region
select [Product ID], [product Name], [order date], region,
FIRST_VALUE([Product ID]) over (Partition by region order by [Order Date]) as fv
from Orders$;

--5.Get the last product sold (by orderDate) in each region 
select [Product ID], [product Name], [order date], region,
LAST_VALUE([Product ID]) over (Partition by region order by [Order Date] rows between unbounded preceding and unbounded following) as LV
from Orders$;

--6.For each order, find the next order date by the same customer
select [Order ID],[Order Date],[Customer ID],
LEAD([Order Date]) over (partition by [customer ID] order by [order Date]) as next_Date
from Orders$;

--7.for each order, find the previous order's profit by the same customer
select [order ID],Profit,[customer ID],[order Date],
LAG(Profit) over (partition by [customer ID] order by [order Date]) as previous_profit
from Orders$;

--8.calculate the running total of sales for each region by order date
select [customer ID], region, [order Date], sales,
SUM(Sales) over ( partition by region order by [order Date], [order ID] rows between unbounded preceding and current row) as Running_total
from Orders$;

--9.compute the cummulative average profit for each sub-category based in order date
select profit,[Sub-Category],[order Date], [order ID],
AVG(Profit) over (partition by [sub-category] order by [order Date], [order ID] rows between unbounded preceding and current row) as Cumm_avg
from Orders$;


--10. calculate the difference in sales between each order and the previous one for each customer
select [customer ID], [order ID], Sales,
lag(sales,1,0) over (partition by [order ID] order by [customer ID] ) as previous_sal,
sales - lag(sales,1) over (partition by [order ID] order by [customer ID] ) as diffinsales_sal
from Orders$;

--10 AI solution 
SELECT [Customer ID],
       [Order ID],
       Sales,
       LAG(Sales, 1, 0) OVER (
           PARTITION BY [Customer ID]
           ORDER BY [Order Date], [Order ID]
       ) AS previous_sal,
       Sales - LAG(Sales, 1, 0) OVER (
           PARTITION BY [Customer ID]
           ORDER BY [Order Date], [Order ID]
       ) AS diffinsales
FROM Orders$;


-- class 9 union and union all
--UNION and UNION ALL

-- union all - it adds the data from both the tables, donot remove the duplicates
--           - data processin gis faster in union all as it just append the data

--select * from Table1
--UNION ALL
--select * from Table2;

-- union -- it adds the data from the both the tables, but remove the duplicates
--        - data processing is slower with that compared to union all because it compares records from bith the tables
---select * from Table1
--UNION 
--select * from Table2;

-- Condition for union and union all on table:
-- 1. order of columns should be same.
-- 2.numbers of columns in both table should be same.
-- 3. data type of all the column should be same.

-- INTERSECT and EXCEPT
-- intersect: common /matched records from both tables

--select * from table1
--intersect
--select * from Table2;

-- except: unmatched record from table1 with that compared to table2
--select * from table1
--except
--select * from Table2;

-- except: unmatched record from table2 with that compared to table1
--select * from table2
--except
--select * from Table1;

-- Temporary Tables
-- These are like main tables stored in the database but these temp tables gets 
--automatically deleted when no longer in use

-- Types of temporary table
-- 1 local temporary table- these are only available in the current session/window and gets deleted when we closed the session.
-- these are create with single #

Create table #temptable (id int, name varchar(20))

select * from #temptable;

-- 2 Global temporary table- these are available in all the sessions / windows and get deleted when we closed them.
-- these are created with double ##

Create table ##temptable2 (id int, name varchar(20))

select * from ##temptable2;



 use SQLBATCH2;

-- CTE -( Common Table Expression)
-- imaginary table create hotii hai or usse use kr skte h agye process k lye
-- complex query ko easy way me execute krta hai CTE bs 
-- CTE query is start WITH keyword


with CTE1 as (select avg(Salary) as aVG_ from Employee$)

select * from CTE1;

select * from Employee$;

-- same work ese b kr skte hai 

select avg(Salary) as aVG_ from Employee$

-- Question on CTE
-- 1. find the employees who earn more than the average salary of the employees?

with T1 as (select AVG(salary) as AVG_sal from Employee$)

select * from Employee$ E 
cross join T1 F
where E.salary > F.AVG_sal;

-- alternate way -(sub query se b kr skte hia)

select emp_NAME, SALARY, avg(salary) as AVG_sal
from Employee$
group by emp_NAME, SALARY
having SALARY > (select AVG(salary) as AVG_sal from Employee$);

-- 2. find the departments whose average salary is greater than the overall average salary of the employees?


with overall as (select AVG(salary) as overall_avgsal from Employee$),
dept_avg as (select dept_name, avg(salary) as dept_avg_salary from Employee$
group by DEPT_NAME
)

select dept_name, dept_avg_salary
FROM dept_avg, overall
WHERE dept_avg.dept_avg_salary > overall.overall_avgsal;


-- 3.find the departments whose sum of salary is greater than the overall average salary of the employees
with overall as (select avg(Salary) as overall_avgsal from Employee$),
dept_sumSal as (select DEPT_NAME, sum(Salary) as dept_sum_salary from Employee$
group by DEPT_NAME
)
select dept_name, dept_sum_salary
from dept_sumSal,overall
where dept_sumSal.dept_sum_salary > overall.overall_avgsal;



-- 4. find the top 2 highest paid employess in each department
  with rank_Emp AS (SELECT 
        emp_id,
        emp_name,
        dept_name,
        salary,
        ROW_NUMBER() OVER (PARTITION BY dept_name ORDER BY salary DESC) AS rn
    FROM Employee$)
 SELECT emp_id, emp_name, dept_name, salary,rn
FROM Rank_Emp
where rn <= 2
order by dept_name, salary DESC;


---===== class 10 CTE question [practice]-- 
-- CTE Questions

--1 Find the cummumlative salary of each department
with cumSalary as (select emp_id,emp_name, dept_name, salary, 
sum(salary) over (partition by dept_name order by emp_id rows between unbounded preceding and current row) as cumm_salary
from Employee$)

select * from cumSalary;

select * from Orders$;

-- 2 list the top 5 customers by total sales in each region who have not return any product?

with orderNotRet as (select o.[Customer ID], o.[Customer Name], o.Region, sum(o.sales) as Total_Sal 
from Orders$ as o 
left join Returns$ as r
on o.[Order ID] = r.[Order ID]
 WHERE r.[Order ID] IS NULL   
    GROUP BY o.[Customer ID], o.[Customer Name], o.Region
),
top5 as (select *,
DENSE_RANK() over (partition by region order by Total_Sal desc ) as RANKING
from orderNotRet)

select * from top5 
where RANKING <=5 ;

-- 3 find the customer who have placed the highest number of orders in each segment?
with t1 as (select [customer id], segment, count([order id]) as Total_orders
from Orders$
group by [customer id], segment
),
t2 as ( select *,
RANK() over (partition by segment order by Total_orders desc) as RANK_order
from t1)

select * from t2
where RANK_order = 1;

-- 4 list the top 10 products by total quantity sold in each region

with t1 as (select [product id], region, sum(quantity) as total_quantity
from orders$
group by [product id], region),
t2 as (select *,
DENSE_RANK() over (partition by region order by total_quantity desc) as Rank_quant
from t1 )

select * from t2
where Rank_quant <= 10; 



--5 calculate year-over-year sales for each region
with t1 as (select YEAR([order Date]) as Years, region, sum(sales) as total_Sales from orders$
group by YEAR([order Date]), region),
t2 as (select * ,
 LAG(total_Sales) over (partition by region order by Years) as Previous_sale,
 total_Sales - LAG(total_Sales) over (partition by region order by Years) as year_over_year
from t1)

select * from t2

-- mam ka method
with t1 as (select region, year([order date]) as years, sum(sales) as total_Sales
         from orders$
         group by region, year([order date])),
t2 as(select region, years, total_Sales,
lag(total_Sales) over (partition by region order by years) as previous_year_sale
from t1)

select region, years,total_Sales, previous_year_sale,
(total_Sales - previous_year_sale) as yoy_Sales
from t2


-- 6 Rank sub-categories by total sales within each category
with t1 as (select category, [sub-category], sum(sales) as total_Sales
from orders$
group by category, [sub-category]),
t2 as (select *,
rank() over (partition by category order by [sub-category]) as rank_category
from t1)

select * from t2


 ---alternate 

 with t1 as (select category, [sub-category], sum(sales) as total_Sales,
 rank() over (partition by category order by [sub-category]) as rank_category
from orders$
group by category, [sub-category])

select * from t1;



-- 7 calculate the running total of sales for each customer ordered by order date
with t1 as(select [customer id], [order date], sum(sales) as total_Sales
from orders$
group by [customer id], [order date])

select *,
sum(total_Sales) over (partition by [customer id] order by [order date] 
rows between unbounded preceding and current row) as running_total_Sales
from t1;


--- ====== class 11 (sub-query) ------

-- SUB-Query - when a query is placed inside another query
select * from Employee$;
select * from Department$



select * 
from (select distinct dept_name from Employee$) a 
where Location = 'Delhi';

--1 Single Row Sub-Query - when we get a single value output from the sub-query
select * from Employee$
where dept_id = (select dept_id from Department$ where dept_name = 'HR')

--2 Multiple Row sub-query
select * from Employee$
where dept_id in (Select dept_id from Department$ where location = 'Delhi')

-- SUB-Query practice question 

--1 write a query to find the name of employee who work in HR and Sales Department
select emp_name from Employee$
where DEPT_Id in (select dept_id from Department$ where DEPT_NAME in ('HR', 'Sales'))

--2 write a query to find  the department-wise average salary of employees,
-- excluding those employees who earn more than 5000
select dept_name, avg(salary) as AVG_Salary from employee$
where emp_id in (Select emp_id from employee$ where salary < 5000)
group by dept_name

-- alternate way
select dept_name, avg(salary) as AVG_salary 
from (select dept_name, salary from employee where salary <= 5000)
group by dept_name;

-- 3 Employee table - employeeid, name, salary
-- write a query to find employees whose salary is higher than the average salary of all employees
select emp_name, salary 
from Employee$ 
where salary > (Select avg(salary) from Employee$)


--4 Sales table - saleid, productid, saleamount
-- write a query to find all sales where the sales amount is  higher than the highest sale amount
-- of product 101
select saleid, saleamount 
from sales
where saleamount > (Select max(saleamount) from sales where productid = 101)


-- 5 orders table - orderid , customerid, orderdate
-- customer tble - customerid, customername
-- write a query to find the customers who have placed more then 5 orders
select customerid, customername
from customer
where customerid in (select customerid from orders group by customerid having count(orderid) > 5)


-- 6 customer tables - customerid, customername
-- order table - orderid, customerid
-- write a query to list customers who have never placed any order
select customerid, customername
from customer
where customerid not in (select distinct customerid from orders)


-- 7 employee table - employeeid, salary, departmentid
-- write a query to find employees whose salary is higher than the highest salary of any employee in department 10
select *
 from employee
 where salary > (select max(Salary) from employee where departmentid = 10)

-- 8 employee table - emp_id, emp_name , salary , deptname
-- write a query to find all employees who work in the same department as the employee with
--the highest salary
select * 
from Employee$
where DEPT_NAME in (Select DEPT_NAME from Employee$ 
                  where salary = (select max(salary) from Employee$))

--9 get the names of employees who are working in IT department and who earn more
--than the highest salary in the HR department
select emp_name
from Employee$
where DEPT_NAME = 'IT' and SALARY > (select max(salary) from Employee$ where DEPT_NAME = 'HR')

--10 list the employees whose salary is greater than the salary of Mohan
select * from Employee$
where SALARY > (select SALARY from Employee$ where emp_name = 'mohan')


-- ==============class 12 (correlated sub-query)====

--- type 3
-- correlated Sub-Query - this sub-query take reference of the column from the outer query table.

select * 
from Employee$ E1
where  salary > (select avg(salary) from Employee$ E2 where E1.DEPT_NAME = E2.DEPT_NAME)

---Question practice on sub-query topic
--1, find the employees who earn more than the average salary in their respective departments
select * from Employee$ E1
where SALARY > (select avg(salary) from Employee$ E2 where E1.DEPT_NAME = E2.DEPT_NAME) 

--2 list the employee who earn more than the employee in the same department with the lowest salary
select * from Employee$ E1
where salary > (Select min(salary) from Employee$ E2 where E1.DEPT_NAME = E2.DEPT_NAME)

--3 list the employee who earn more than the highest salary of any employee in the HR department
select * from Employee$ E1
where SALARY > (select max(salary) from Employee$ E2 where DEPT_NAME = 'HR')

--4 find the employee in the finance department whose salary is greater than the salary of the employee named dorvin
-- in the same department

select * from Employee$ A
where DEPT_NAME = 'Finance' 
and SALARY > (select salary from Employee$ B where emp_NAME = 'Dorvin' and A.DEPT_NAME = B.DEPT_NAME)



-- 5 find the employee whose salary is greater than the average salary of employees in a department with more than 3 employees.
select * from Employee$ A
where SALARY > (select avg(Salary) from Employee$ B 
where A.DEPT_NAME = B.DEPT_NAME
group by DEPT_NAME
having count(B.emp_name) > 5)




---=== class 13 (sub query more question for practice_) =========
select * from Sale_History$;
-- 1 find the name of the products that have sold more than 10 units on a given date - 14/01/2025
select p.id, p.name
from Producer$ p
where p.id in (select product_id
               from Sale_History$
               where date = '14/01/25'
               group by product_id
               having sum(amount) > 10)

-- with joins
select p.name
from Products p
join Sales_History s on p.id = s.product_id
where s.date = '2025-01-14'
group by p.id, p.name
having sum(s.amount) > 10;



-- 2.Find the department names that have products that sold more than 5 units on 15/01/2025
select d.id, d.name
from Department$ d
where d.id in (select s.product_id
           from  Sale_History$ s
           where s.date = '15/01/2025'
           group by product_id
           having sum(amount) > 5)

           USE SQLBATCH2

select name
from Department$
where id in (
    select department_id
    from Products$
    where id in (
        select product_id
        from Sale_History$
        where date = '2025-01-15'
        group by product_id
        having sum(amount) > 5
    )
);

-- with joinn
select d.name as department_name
from Department$ d
where d.id in (select Department_id
               from Products$ p
               inner join Sale_History$ sh
               on p.id = sh.product_id
               where date = '01/15/2025'
               group by Department_id
               having sum(amount) > 5)

--CHATGPT JOIN  SOLV
select distinct d.name
from Department d
join Products p on d.id = p.department_id
join Sales_History s on p.id = s.product_id
where s.date = '2025-01-15'
group by d.id, d.name, p.id
having sum(s.amount) > 5;



--3 Lsit all the products that have no sales recorded
select p.name
from Products$ p
where p.id not in (select distinct s.product_id
               from Sale_History$ s)

---Using LEFT JOIN
select p.name
from Products$ p
left join Sale_History$ s 
       on p.id = s.product_id
where s.product_id is null;

-- 4 write a query to find the department that have products with prices higher than the overall average price of all  products
select * 
from Department$
where id in (select DISTINCT Department_id
             from Products$ 
             where price > (Select avg(price) from Products$))


--Alternative (JOIN version, often clearer)
             select distinct d.*
from Department$ d
join Products$ p on d.id = p.Department_id
where p.price > (select avg(price) from Products$);

-- 5 write a query to list all producers who have products in the fruits departments
--Subquery
select name
from Producer$
where id in (
    select distinct producer_id
    from Products$
    where department_id = 1 and producer_id is not null
);

--JOIN
select distinct pr.name
from Producer$ pr
join Products$ p on pr.id = p.producer_id
where p.department_id = 1;

--6 wrtie a query to find the product with the highest price in each department
--Subquery
select *
from Products p
where price = (
    select max(price)
    from Products
    where department_id = p.department_id
);

--JOIN (with derived table)
select p.*
from Products p
join (
    select department_id, max(price) as max_price
    from Products
    group by department_id
) t on p.department_id = t.department_id and p.price = t.max_price;



---===============Class 14 : Video-26( stored procedures, views, pivot table) July 2025================
-- Stored Procedure
use SQLBATCH2
--- to create a stored procedure without parameter
--syntax:
create procedure SP_SAMPLE
as
begin

select * from Employee$
where salary > 6000

end

-- to execute the stored procedure
exec SP_SAMPLE



-- to create a stored procedure with parameter
--syntax:
create procedure SP_SAMPLE3

@dept_name varchar(20)
as
begin

select * from Employee$
where DEPT_NAME = @dept_name

end

-- to execute the stored procedure with parameter
exec SP_SAMPLE3 'HR'

-- quest- create a sp you have to make dept name and salary is generic where salary > 5000 and dept_name It?


-- to alter a store procedure
alter proc SP_sample3
@dept_name varchar(20)
as
begin

select * from Employee$
where DEPT_NAME = @dept_name

end

-- to execute the stored procedure with parameter
exec SP_SAMPLE3 'HR'

-- to delete a procedure from database
DROP proc SP_sample3

-- to encrypt the stored procedure
create procedure SP_SAMPLE4
with encryption 
as
begin

select * from Employee$
where salary > 6000

end

-- decrypt the code from lock
-- one more example
alter proc SP_sample4
as
begin

select * from Employee$
where salary > 6000

end


-- VIEWS
-- view will make only one table where stored procedure will not.
-- virtual table
-- column ki details show ni krni tb use kr skte hai ..
-- dashboard me data heavy na ho toh use krte hai....
create view VIEW_x
as
select A,B,C,D
from employee$
where dept_name = 'IT'
--yaha dept IT wale show ni honge ise row level security hogi 


create view VIEW_Sample
as
select 
C1,
C2,
C3
from Table3 a 
joins Tables5 b
on a.ID = b.ID
where financial_period < MAX(financial_period)


--- with example with store procedure
-- store procedure ko ni uski final table ko view me put kr skte hai 

create proc Procedure1
as begin
create table table1
as
select ID,name,location
from tableA
where location in ('HR','IT')

create table table2
as 
select ID,salary 
from tableB

create table Table_Stage
as 
select *
from table1 X
left join table2 Y
on.X.id = Y.id

end

--data sirf table_stage ka hi use hogaa bs..........
create view VIEW_Sample
as
select 
C1,
C2,
C3
from Table_stage
where financial_period < MAX(financial_period)


--PIVOT:
--In SQL, PIVOT is used when we want to convert rows into columns to make data more readable or better suited for reporting.

--Why we use PIVOT?

--Summarize data – Makes it easy to view aggregated data (like totals, counts, averages).

--Convert rows into columns – Helps in reporting where each unique value from a column becomes its own column.

--Better data visualization – Similar to pivot tables in Excel, it gives a cross-tab view of data.

--Reduces manual aggregation – Instead of writing multiple CASE WHEN statements, PIVOT simplifies the query.

-- Example:

--Suppose we have a sales table:

--Year	Product	Sales
--2023	A	100
--2023	B	150
--2024	A	200
--2024	B	250

--If we want to see sales per product by year, normally we’d write multiple SUM(CASE...).

--With PIVOT:

--SELECT *
--FROM Sales
--PIVOT (
  --  SUM(Sales)
 --    FOR Product IN ([A], [B])
--     ) AS PivotTable;


--Output:

--Year	A	B
--2023	100	150
--2024	200	250

--- In short: We use PIVOT in SQL to transform and summarize data (rows → columns) for easier analysis, similar to pivot tables in Excel.




select year,
[consumer] as Consumer,
[customer] as Customer,
[Home office] as Home_office

from (select year, segment, profit from tablex) as Source_table

pivot(sum(profit) for segment in ([consumer],[customer],[home office] )) as pivot_table




---===========Class 15 : Video ( indexes and its type) 27 July 2025==========

-- INDEX - to reduce the run time of the query amd make the searching faster

-- Clustered index- index key is store in the same table
--                  processing time is faster as compared to non-clustered index
--                  we can create only one clustered index per table
--syntax-
          create clustered index IX_SAMPLE
          on Employee$ (emp_id)
          select * from Employee$
-- Non-cluster index - index key is stored in another table
--                     processing time is slower as comapred to clustered index
--                     we can create multiple indexes using non-clustered
--syntax-
          create nonclustered index IX_SAMPLEE
          on Employee$ (emp_id)
