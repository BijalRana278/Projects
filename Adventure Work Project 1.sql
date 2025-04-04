create database adventure_work;
use adventure_work;

-- 0. Union of Fact Internet sales and Fact internet sales new

create table sales_union as 
select * from fact_internet_sales_new
union 
select * from fact_internet_sales;

select * from sales_union;

-- 1.Lookup the productname from the Product sheet to Sales sheet.
alter table sales_union add column ProductName varchar(255); 
set sql_safe_updates=0;
select d.EnglishProductName from dim_product d
inner join sales_union s on d.ProductKey = s.ProductKey;
-- k
update sales_union s
join dim_product d  on d.ProductKey = s.ProductKey
set s.ProductName = d.EnglishProductName;

-- 2.Lookup the Customerfullname from the Customer and Unit Price from Product sheet to Sales sheet.
alter table sales_union  add column FullName varchar(255), 
						 add column UnitPricee decimal(10,2);
alter table dimcustomer1 add column FullName varchar(255);

UPDATE dimcustomer1
SET FullName = CONCAT(FirstName, ' ', IFNULL(MiddleName, ''), ' ', LastName);
set sql_safe_updates=0;
select d.FullName from dimcustomer1 d
inner join sales_union s on d.CustomerKey = s.CustomerKey;

UPDATE sales_union s
join dimcustomer1 d  on d.CustomerKey = s.CustomerKey
set s.FullName = d.FullName
where s.FullName is null;

-- (2 half) Unit Price from Product sheet to Sales sheet
SELECT UnitPrice FROM sales_union s
JOIN dim_product d ON s.ProductKey = d.ProductKey;

SELECT UnitPrice FROM sales_union s
JOIN dim_product d ON s.ProductKey = d.ProductKey;

-- 3.calcuate the following fields from the Orderdatekey field ( First Create a Date Field from Orderdatekey)
  -- A.Year B.Monthno C.Monthfullname D.Quarter(Q1,Q2,Q3,Q4) E. YearMonth ( YYYY-MMM) 
  -- F. Weekdayno G.Weekdayname H.FinancialMOnth I. Financial Quarter 

select 
  STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d') AS OrderDate,
    YEAR(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d')) AS Year
    FROM sales_union s;

Select 
  STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d') AS OrderDate,
    MONTH(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d')) AS MonthNo
    FROM sales_union s;

Select 
    STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d') AS OrderDate,
    MONTHNAME(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d')) AS MonthFullName
    FROM sales_union s;
    
-- Display Orderdate, year, monthNo, MonthFullName
  Select 
  STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d') AS OrderDate,
    YEAR(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d')) AS Year,
    MONTH(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d')) AS MonthNo,
    MONTHNAME(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d')) AS MonthFullName
    FROM sales_union s;

SELECT 
       MONTHNAME(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d')) AS MonthFullName,
    CASE 
        WHEN MONTH(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d')) BETWEEN 1 AND 3 THEN 'Q1'
        WHEN MONTH(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d')) BETWEEN 4 AND 6 THEN 'Q2'
        WHEN MONTH(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d')) BETWEEN 7 AND 9 THEN 'Q3'
        WHEN MONTH(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d')) BETWEEN 10 AND 12 THEN 'Q4'
    END AS Quarter
FROM sales_union s;

SELECT 
STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d') AS OrderDate,
    CONCAT(YEAR(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')), '-', 
           DATE_FORMAT(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d'), '%b')) AS YearMonth
FROM sales_union s;

SELECT 
    STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d') AS OrderDate,
    DAYOFWEEK(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS WeekDayNo
FROM sales_union s;

SELECT 
    STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d') AS OrderDate,
    DAYOFWEEK(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS WeekDayNo,
    DAYNAME(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) AS WeekDayName
FROM sales_union s;

SELECT 
MONTHNAME(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d')) AS MonthFullName,
    CASE 
        WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) = 4 THEN '1'
        WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) = 5 THEN '2'
        WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) = 6 THEN '3'
        WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) = 7 THEN '4'
        WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) = 8 THEN '5'
        WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) = 9 THEN '6'
        WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) = 10 THEN '7'
        WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) = 11 THEN '8'
        WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) = 12 THEN '9'
        WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) = 1 THEN '10'
        WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) = 2 THEN '11'
        WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) = 3 THEN '12'
    END AS FinancialMonth
FROM sales_union s;

SELECT 
MONTHNAME(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d')) AS MonthFullName,
    CASE 
        WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) BETWEEN 4 AND 6 THEN 'Quarter 1'
        WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) BETWEEN 7 AND 9 THEN 'Quarter 2'
        WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) BETWEEN 10 AND 12 THEN 'Quarter 3'
        WHEN MONTH(STR_TO_DATE(CAST(OrderDateKey AS CHAR), '%Y%m%d')) BETWEEN 1 AND 3 THEN 'Quarter 4'
    END AS FinancialQuarter
FROM sales_union s;

--------------------------------------------------------------------------------------------------------------------------
-- Combine all 3rd question 
SELECT 
    STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d') AS OrderDate,
    YEAR(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d')) AS Year,
    MONTH(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d')) AS MonthNo,
    MONTHNAME(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d')) AS MonthFullName,
CASE 
	WHEN MONTH(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d')) BETWEEN 1 AND 3 THEN 'Q1'
	WHEN MONTH(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d')) BETWEEN 4 AND 6 THEN 'Q2'
	WHEN MONTH(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d')) BETWEEN 7 AND 9 THEN 'Q3'
	WHEN MONTH(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d')) BETWEEN 10 AND 12 THEN 'Q4'
END AS Quarter,
    CONCAT(YEAR(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d')), '-', 
           DATE_FORMAT(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d'), '%b')) AS YearMonth,
    DAYOFWEEK(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d')) AS WeekDayNo,
    DAYNAME(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d')) AS WeekDayName,
    CASE 
        WHEN MONTH(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d')) = 4 THEN '1'
        WHEN MONTH(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d')) = 5 THEN '2'
        WHEN MONTH(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d')) = 6 THEN '3'
        WHEN MONTH(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d')) = 7 THEN '4'
        WHEN MONTH(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d')) = 8 THEN '5'
        WHEN MONTH(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d')) = 9 THEN '6'
        WHEN MONTH(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d')) = 10 THEN '7'
        WHEN MONTH(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d')) = 11 THEN '8'
        WHEN MONTH(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d')) = 12 THEN '9'
        WHEN MONTH(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d')) = 1 THEN '10'
        WHEN MONTH(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d')) = 2 THEN '11'
        WHEN MONTH(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d')) = 3 THEN '12'
    END AS FinancialMonth,
    CASE 
        WHEN MONTH(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d')) BETWEEN 4 AND 6 THEN 'Quarter 1'
        WHEN MONTH(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d')) BETWEEN 7 AND 9 THEN 'Quarter 2'
        WHEN MONTH(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d')) BETWEEN 10 AND 12 THEN 'Quarter 3'
        WHEN MONTH(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d')) BETWEEN 1 AND 3 THEN 'Quarter 4'
    END AS FinancialQuarter
FROM sales_union s;

# 4.Calculate the Sales amount uning the columns(unit price,order quantity,unit discount)
# 5.Calculate the Productioncost uning the columns(unit cost ,order quantity)
# 6.Calculate the profit.

select * from sales_union;
alter table sales_union add column sales_amt decimal(19,4),
						add column ProductionCost decimal(19,4),
                        add column Profit decimal(19,4);

set sql_safe_updates=0;
update sales_union set sales_amt = (UnitPrice * OrderQuantity) * (1 - DiscountAmount),
					   ProductionCost = ProductStandardCost * OrderQuantity ,
					   Profit = sales_amt - ProductionCost;


-- 7.Create a table for month and sales (provide the Year as filter to select a particular Year)

Select 
    YEAR(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d')) AS Year,
    MONTHNAME(STR_TO_DATE(CAST(s.OrderDateKey AS CHAR), '%Y%m%d')) AS MonthFullName,
    (s.UnitPrice * s.OrderQuantity * (1 - s.UnitPriceDiscountPct)) AS SalesAmount
    FROM sales_union s;