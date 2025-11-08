use SQLBATCH

select * from Table1

-- mini salary
select min(salary) as AVerage_sal
from Table1

-- max of sal
select max(salary) as AVerage_sal
from Table1

-- how many rows are there in the table
select count(*) as total_rows from Table1

--group by 

-- find department wise total salary 
select Department, sum(Salary) as total_Sal
from Table1
group by Department

-- department and location wise total salaary
select Department,Location, sum(Salary) as total_Sal
from Table1
group by Department, Location

-- find the min salaries of the department where location is pune and banglore
select Department,Location,min(Salary) as min_Salary
from Table1
where Location IN ('PUNE','Banglore')
group by Department,Location

-- order by
select * from table1
order by Salary desc

--HAving 
select Department,Min(salary) as min_sal
from Table1
group by Department
having min(Salary) > 4000

-- order of operation at frontend

select
from 
where
group by
having
order by

--order of operations at backend

from 
where 
group by
having
select 
order by

-----sample store per work sstart yaha se
use SampleStore

--1 find the average sales region wise
select AVG(Sales) as avg_sales,region 
from Orders$
group by Region

--2show the total profit of regions wheres segment is home office or consumer
select region,sum(Profit)
from Orders$
where Segment in ('Home office','consumer')
group by region

--3find the category and sub-category wise total_profit, average discount, max sales
select Category,[Sub-Category],sum(profit) tot_profit,avg(Discount) avg_dis, max(Sales) max_sales
from Orders$
group by Category,[Sub-Category]

--4find sub-categorire where average discount is greater than 0.12
select [Sub-Category],avg(Discount) as avg_dis
from Orders$
group by [Sub-Category]
having avg(Discount) > 0.12
--5 list all unique sub-category
select distinct([Sub-Category])
from Orders$

--6find region wise unique orders count
select Region,count(distinct([order id])) as unique_order_count
from Orders$
group  by Region

--7 arrange the data in descending order based on segment wise total sales
select Segment,sum(Sales) as ts
from Orders$
group by Segment
order by ts desc

--topN--
select top 10 * 
from Orders$

select * from Orders$

-- update the value of standard class to normal class in ship mode
update Orders$
set [Ship Mode] = 'Normal class'
where [Ship Mode] = 'standard class'

--- execute of the query
select [Ship Mode] from Orders$
where [Ship Mode] = 'Normal class'


-- to add the column in the table
alter table Order$
add x varchar (20)

-- to delete any column from the table
alter table Order$
drop column x


---UNION AND UNION ALL

-- UNION - APPENDS THE DATA OF TWO OR MORE TABLES BUT REMOVES THE DUPLICATE THE ROWS
--CONDITIONS
-- NUMNBER OF COLUMNS IN BOTH THE TABLES SHOULD BE SAME
-- ORDER OF COLUMNS IN BOTH THE TABLES SHOULD BE SAME
-- DATA TYPE OF THE COLUMNS SHOULD BE SAME
----------
---SYNTAX
SELECT ID,NAME,DEPT FROM TABLE1
UNION
SELECT ID,NAME,DEPT FROM TABLE2

--UNION ALL - APPENDS THE DATA OF TWO OR MORE TABLES BUT DO NOT REMOVE THE DUPLICATES ROWS
-- CONDITIONs
-- NUMNBER OF COLUMNS IN BOTH THE TABLES SHOULD BE SAME
-- ORDER OF COLUMNS IN BOTH THE TABLES SHOULD BE SAME
-- DATA TYPE OF THE COLUMNS SHOULD BE SAME
----------
---SYNTAX
SELECT * FROM TABLE1
UNION ALL
SELECT * FROM TABLE2


--Joins

--left : complete data from right table and matching records from left table
--syntax:
select * 
from table1 left join table2
on table1.id  = table2.id

--right
--syntax:
select * 
from table1 right join table2
on table1.id  = table2.id

--inner: common records from left and right tabel 
--- syntax
select * from table1 inner join table2
on table1.id = table2.id


--full join : whole records from left and right tables (from both the records)
--syntax
select * 
from table1 inner join table2
on table1.id = table2.id

----joins queries on t1 t2 tab1 tab2
select t1$.date,t1$.sales,t2$.profit 
from t1$ left join t2$
on t1$.date = t2$.date

select t1$.date,t2$.profit,t1$.sales 
from t1$ right join t2$
on t1$.date = t2$.date

select t1$.date,t2$.date,t1$.sales,t2$.profit 
from t1$ full join t2$
on t1$.date = t2$.date

select * 
from t1$ full join t2$
on t1$.date = t2$.date


select * from t1$
select * from t2$




