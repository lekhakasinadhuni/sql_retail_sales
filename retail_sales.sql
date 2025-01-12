-- SQL Retail sales Analysis
create database sql_project1;
-- create table
create table retail_sales_new 
		(
		transactions_id	int primary key,
        sale_date	date,
        sale_time	time,
        customer_id	int,
        gender	varchar(15),
        age	int,
        category varchar(15),	
        quantiy	int,
        price_per_unit float,	
        cogs float,	
        total_sale float
		);
select * from retail_sales_new;

-- the same file has 2000 records in excel where there are 13 null values. Those have not been imported to sql automatically while importing the file
select 
count(*) 
from retail_sales_new
where age is null;

-- Data exploration

-- how many sales are there

select 
count(*) as total_sales 
from retail_sales_new;

-- how many unique customers are there

select 
count(distinct customer_id) as customers 
from retail_sales_new;

---- how many unique category are there

select 
count(distinct category) as customers 
from retail_sales_new;

-- DATA ANALYSIS - BUSINESS PROBLEMS ------

-- Q1.  write a sql query to retrive all columns for sales made on '2022-11-05'

select * 
from retail_sales_new
where sale_date = '2022-11-05';

-- Q2. write an sql query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of nov-22
SELECT *
FROM retail_sales_new
WHERE category = 'Clothing'
  AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
  and quantiy >= 4;
 
 
 -- Q3. write and sql query to calculate the Top Selling category
 
 select 
 category, 
 sum(total_sale) as total_sales, 
 count(*) as total_orders
 from retail_sales_new
 group by category
 order by total_sales Desc;
 
 -- Q4. write an sql query to find the average age of customers who purchased items from the 'beauty' category

select category, 
round(avg(age),2) as Avg_age
from retail_sales_new
where category = 'beauty';
 
 -- Q5. write a sql query to find all transactions where the total_sale is greater than 1000
 
 select * 
 from retail_sales_new
 where total_sale>1000;
 
 -- Q6. Write an sql query to find the total number of transactions (transaction_id) made by each gender in each category
 
 select category, 
 gender, 
 count(*) as total_transactions
 from retail_sales_new
 group by category, gender
 order by category;
 
 -- Q7. write an sql query to calculate the average sale for each month.( run without subquery)
 -- find out best selling month in each year(run as subquery)
 
 select year,
 month,
 average_sale 
 from
 (
 select 
 year(sale_date) as year,
 month(sale_date)as month,
 round(avg(total_sale),2) as average_sale,
 rank() over (partition by year(sale_date) order by avg(total_sale)desc) as best_selling_month_by_rank
 from retail_sales_new
 group by year, month
 ) as t1
 where best_selling_month_by_rank = 1;
 
 -- Q8. write an sql query to find the top 5 customers based on the highest total sales
 
 select 
 customer_id, 
 sum(total_sale) as Total_sales 
 from retail_sales_new
 group by customer_id
 order by total_sales desc
 limit 5;
 
 -- Q9. write an sql query to find the number of unique customers who purchased items from each category
 
 select 
 category,
 count(distinct customer_id) as number_of_customers
 from retail_sales_new
 group by category
 order by number_of_customers desc;
 
 -- Q10. write an sql query to create each shift and number of orders ( Example morning <=12, Afternoon between 12 and 17, evening > 17)
 
 with hourly_sales
 AS
 (
 select * ,
 case
 when hour(sale_time) < 12 then 'Morning'
 when hour(sale_time) between 12 and 17 then 'Afternoon'
 else 'Evening'
 End as Shift
 from retail_sales_new
 )
 SELECT Shift,
 count(*) as total_orders
 from hourly_sales
 group by Shift 
-- Evenings are peaks hours for sales 
 
-- Q11. Seasonal Trends

with seasonal_sales AS
 (
 select * ,
 case
when month(sale_date) in (03, 04, 05) then 'Spring'
when month(sale_date) in (06, 07, 08) then 'Summer'
when month(sale_date) in (09, 10, 11) then 'Autumn'
else 'Winter'
 End as Season
 from retail_sales_new
 )
 SELECT Season,
 count(*) as total_orders
 from seasonal_sales
 group by Season 
 order by total_orders desc
-- Autumn has the highest number of sales of all seasons

-- Q12. Gender based sales

select gender,
sum(total_sale) as total_sales
from retail_sales_new
group by gender
order by total_sales desc;

-- Q13. Age based analysis

with age_analysis as
(
select *,
case
WHEN age < 20 THEN 'Under 20'
    WHEN age BETWEEN 20 AND 30 THEN '20-30'
    WHEN age BETWEEN 31 AND 40 THEN '31-40'
    WHEN age BETWEEN 41 AND 50 THEN '41-50'
    ELSE 'Above 51'
    end as age_group
from retail_sales_new
) 
select age_group,
count(*) as total_sales
from age_analysis
group by age_group
order by total_sales asc;

-- Profitability by Category

select category,
round(sum(total_sale - cogs),2) as Profit 
from retail_sales_new
group by category
order by Profit desc;

-- Average Price per Unit per Category

select category,
round(avg(price_per_unit),2) as avg_price
from retail_sales_new
group by category
order by avg_price desc; 

-- Fastest-Selling Products (Quantity)

select category,
sum(quantiy) as total_quantity
from retail_sales_new
group by category
order by total_quantity desc;

-- Most Active Customers:

select distinct customer_id,
count(*) as total_transactions 
from retail_sales_new
group by customer_id
order by total_transactions desc
limit 5;

-- Age Group vs. Category Analysis:


select
case
WHEN age < 20 THEN 'Under 20'
    WHEN age BETWEEN 20 AND 30 THEN '20-30'
    WHEN age BETWEEN 31 AND 40 THEN '31-40'
    WHEN age BETWEEN 41 AND 50 THEN '41-50'
    ELSE 'Above 51'
    end as age_group,
category,
sum(total_sale) as total_sales
from retail_sales_new
group by category, age_group
order by total_sales desc;

-- End of analysis 