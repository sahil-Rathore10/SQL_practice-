use SampleStore;
--Batch- 4092+4093

--class 2 understanding keywords in sql understanding operators in sql

-- fetch data for category = furniture, sales > 500 , segment = consumer

select * from Orders$
where (Category = 'Furniture' and Sales > 500) or Segment in ('Consumer')

-- category     no.of sales      total sales with category
-- union lagane k lye dono query k column output same hone chiaye tabhi query run kregi verna ni

select Category, Count(sales) #count, sum(Sales) Total_sale, sum(Quantity) Tot_quantity
from Orders$
group by Category
union
select 'Total',count(sales),sum(Sales), sum(Quantity) from Orders$

-- group by me alias name ni chalta hai
select Category, year([Order Date]) year_, sum(Sales) tot_sales
from Orders$
Group by Category,YEAR([Order Date])
order by year_,Category

--this query group by by category but it will not print that column in query

select year([Order Date]) year_, sum(Sales) tot_sales
from Orders$
Group by Category,YEAR([Order Date])
order by year_,Category


-- JOINS
--syntax
select
o1.[Order ID]
from Orders$ o1
join
Returns$ rt 
on o1.[Order ID] = rt.[Order ID]

--- study primary key and composite key what it is and where to use it??
-- ACID properties of Databases
-- Normalization in database

select
o1.[Order ID],
rt.[Order ID],
rt.Returned,
o1.Sales
from Orders$ o1
left join
Returns$ rt 
on o1.[Order ID] = rt.[Order ID]

select
sum(Sales) tot_sales,
sum(case when rt.Returned = 'Yes' then Sales else 0 end) as returned_sales
from Orders$ o1
left join
Returns$ rt on
o1.[Order ID] = rt.[Order ID]

-- CLASS 3 Introduction to joins ,Multiple where clauses, Multiple group by clauses , Writing multiple aggregations

SELECT TOP 10 * from Orders$

-- JOINS:
-- Left Join

select 
EOMONTH([Order Date],0) months,
count(od.[Order ID]) #orders, 
sum(Sales) tot_sales,
count(rt.[Order ID]) returned_orders,
sum(case when rt.Returned = 'Yes' then Sales else 0 end)
from Orders$ od
left join Returns$ rt
on od.[Order ID] = rt.[Order ID]
group by EOMONTH([Order Date],0)
order by EOMONTH([Order Date],0)


--- print an output according to sales group, count of orders, total sales
select 
case 
when Sales between 0 and 100 then '0-100'
when Sales between 100 and 200 then '100-200'
when Sales between 200 and 300 then '200-300'
when Sales between 300 and 400 then '300-400'
when Sales between 400 and 500 then '400-500'
else '500+' end as GROUPS,
count(sales) count_of_orders, sum(Sales) total_sales
from Orders$
group by
case
when Sales between 0 and 100 then '0-100'
when Sales between 100 and 200 then '100-200'
when Sales between 200 and 300 then '200-300'
when Sales between 300 and 400 then '300-400'
when Sales between 400 and 500 then '400-500'
else '500+' end 
order by GROUPS
UNION ALL

select 
  'Total' as GROUPss, 
  count(Sales) as count_of_orders, 
  sum(Sales) as total_sales 
from Orders$

  select 
  case 
    when Sales between 0 and 100 then '0-100'
    when Sales between 100 and 200 then '100-200'
    when Sales between 200 and 300 then '200-300'
    when Sales between 300 and 400 then '300-400'
    when Sales between 400 and 500 then '400-500'
    else '500+' 
  end as GROUPS,
  count(sales) as count_of_orders, 
  sum(Sales) as total_sales
from Orders$
group by
  case
    when Sales between 0 and 100 then '0-100'
    when Sales between 100 and 200 then '100-200'
    when Sales between 200 and 300 then '200-300'
    when Sales between 300 and 400 then '300-400'
    when Sales between 400 and 500 then '400-500'
    else '500+' 
  end 

UNION

select 
  'Total' as GROUPS, 
  count(Sales) as count_of_orders, 
  sum(Sales) as total_sales 
from Orders$




--GROUPS   	count_of_orders  	total_sales
--0-100     	6229	            195839.260399999
--100-200 	    1186	            172107.9164
--200-300	    675             	166273.7583
--300-400	    449               	155466.5896
--400-500	    293             	132529.2027
--500+	        1162	            1474984.1329
--Total	        9994	            2297200.86029994


--- SECOND QUERY
select 
pp.Person,sum(Sales)
from Orders$ od 
join
People$ pp
on od.Region = pp.Region
group by pp.Person

--output
--Person	                sum of sales
--Anna Andreadi	        725457.8245
--Cassandra Brandow	    391721.905
--Chuck Magee	            678781.239999999
--Kelly Williams	        501239.890800001


-- in sql column to column is easy to compare and it is hard for row level operatoins
--- another query
select 
-- formatting in sql
pp.Person,format(sum(Sales),'##,0k'),
sum(case 
when rt.Returned = 'Yes' then Sales else 0 end),
sum(case 
when rt.Returned = 'Yes' then Sales else 0 end) /sum(sales) as Return_ratio,
count(od.[order ID]) count_of_total_orders,
count(Sales),
count(rt.[Order ID]) count_of_tot_ret_orders,
sum(case
when rt.Returned = 'Yes' then 1 else 0 end),
-- '0.00%'
format(sum(case
when rt.Returned = 'Yes' then 1 else 0 end) / (count(sales) * 1.000000),'p'),

sum(case
when rt.Returned = 'Yes' then 1 else 0 end) / (cast (count(sales) as decimal(18,8) )) -- 18 digit and decimal place 8 
-- we can also used try cast it is just like try n catch in java and python

from Orders$ od 
join
People$ pp 
on od.Region = pp.Region
left join Returns$ rt 
on od.[Order ID] = rt.[Order ID]
group by pp.Person


-- Class 4 (date time function and CTE intro)
select
[Row ID],Sales,[Order Date],
year('2025-10-06') year_,month('2025-10-06') month_,day('2025-10-06') day_,
DATEFROMPARTS(year('2025-10-06'),month('2025-10-06'),day('2025-10-06')) calculated_Date,
EOMONTH([Order Date],0) end_of_month,
DATEADD(D,1,EOMONTH([Order Date],-1)) start_of_month,
CONVERT(datetime,[Order Date]) Converted_Date,
Convert(int,CONVERT(datetime,[Order Date])) Converted_Date_into_int,
convert(int,convert(datetime,dateadd(D,1,EOMONTH([Order Date], -1))))
from Orders$


select
format(EOMONTH([Order Date],0),'MMM-yy') dates,
sum(Sales),
Count(1)
from Orders$
group by EOMONTH([Order Date],0)
Order by EOMONTH([Order Date],0)

select
EOMONTH([Order Date],0) dates_,
sum(sales) tot_sales
from Orders$
group by EOMONTH([Order Date],0)

--
select DISTINCT
EOMONTH([Order Date],0) dates_,
sum(Sales) over(order by eomonth([Order Date],0)) running_total,
sales
from Orders$
group by EOMONTH([Order Date],0),sum(Sales) over(order by eomonth([Order Date],0))
order by EOMONTH([Order Date],0)

-- it is not working with this query so we used CTE
--Msg 4108, Level 15, State 1, Line 231
--Windowed functions can only appear in the SELECT or ORDER BY clauses. 

-- solve this with CTE (common table Expression)
--group by se jo dikkt arhi thi ab ni ayegi CTE se phle hi group by kr lia or usse use kr lia

with table1 as(
select
EOMONTH([Order Date],0) dates_,
sum(sales) tot_sales
from Orders$
group by EOMONTH([Order Date],0)
)

select 
dates_,
tot_sales,
sum(tot_sales) over(Order by dates_)
from table1
union
select '2016-01-01',sum(tot_sales),null from table1


--- question query 
--with T2 as(
--select segment,
--count([Order ID]) count_of_order,
--format(
--count([Order ID]) * 1.0 / sum(count([Order ID])),'00.0%') as Percent_of_Total
--from Orders$
--group by Segment
--)

--select * from T2;


--WITH T2 AS (
--  SELECT 
--    Segment,
--    COUNT([Order ID]) AS count_of_order,
--    SUM(Sales) tot_sales,
--    FORMAT(
--      COUNT([Order ID]) * 1.0 / SUM(COUNT([Order ID])) OVER(), 
--      'P'
--    ) AS Percent_of_Total
--  FROM Orders$
--  GROUP BY Segment
--)
--SELECT 
--Segment,
--count_of_order,
--tot_sales,
--Percent_of_Total
--FROM T2;

--UNION ALL

--SELECT 
--  'Total' AS Segment,
--  SUM(count_of_order) AS count_of_order,
--  SUM(tot_sales) AS tot_sales,
--  '100%' AS Percent_of_Total
--FROM T2;


WITH T2 AS (
  SELECT 
    Segment,
    COUNT([Order ID]) AS count_of_order,
    SUM(Sales) AS tot_sales,
    FORMAT(
      COUNT([Order ID]) * 1.0 / SUM(COUNT([Order ID])) OVER(), 
      'P'
    ) AS Percent_of_Total
  FROM Orders$
  GROUP BY Segment
)
SELECT 
  Segment,
  count_of_order,
  tot_sales,
  Percent_of_Total
FROM T2

UNION ALL

SELECT 
  'Total' AS Segment,
  SUM(count_of_order) AS count_of_order,
  SUM(tot_sales) AS tot_sales,
  '100%' AS Percent_of_Total
FROM T2;

-- same query sir k method se ---
with t3 as(
select
Segment,
count(1) cnt_,
sum(Sales) tot_sales
from Orders$
group by Segment
)
select 
Segment,cnt_,
format((cnt_*1.00)/(select sum(cnt_) from t3),'p') perc_tot,
format(tot_sales,'0.0') tot_sales
from t3
union
select 'Total',sum(cnt_),'100%',format(sum(tot_sales),'0.0') from t3;


---query
with tot as(
select 'Total' Segment_,count(1) cnt_,1.00 perc,sum(Sales) tot_sales from Orders$
)
select
Segment,
count(1) cntt_,
--(count(1)*1.00)/cnt_ perc,
sum(Sales) sales_tot,
tot.segment_,
tot.cnt_,
tot.perc,
tot.tot_sales
from Orders$,tot
group by Segment,tot.Segment_,
tot.cnt_,tot.perc,tot.tot_sales



-- class 5 (how to make reference table and used it for your outputs)
--- creating a data, insertion,updating,truncate, all this

