# Project Overview

**Project Title: Retail Sales Analysis**

# Objectives
1.	**Set up a retail sales database:** Create and populate a retail sales database with the provided sales data.
2.	**Data Cleaning:** Identify and remove any records with missing or null values.
3.	**Exploratory Data Analysis (EDA):** Perform basic exploratory data analysis to understand the dataset.
4.	**Business Analysis:** Use SQL to answer specific business questions and derive insights from the sales data.

# Project Structure
## 1. Database Setup
- **Database Creation**: The project starts by creating a database named sql_project1.
- **Table Creation**: A table named retail_sales is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount. 

```sql

CREATE DATABASE sql_project1;
CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```
## 2. Data Exploration & Cleaning
- **Record Count**: Determine the total number of records in the dataset.
- **Customer Coun**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

## 3. Data Analysis
The following SQL queries were developed to answer specific business questions:

 **1. Understand Sales Trends:**

- **Monthly and yearly trends**
```sql
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
```
- **Seasonal Trends**
```sql
with seasonal_sales as
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
```

**2. Customer Demographics:**

- **Age based analysis**
```sql
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
```
- **Gender based analysis**
```sql
select gender,
sum(total_sale) as total_sales
from retail_sales_new
group by gender
order by total_sales desc;
```
**3. Product Category Analysis**

- **Top-Selling Categories:**
```sql
select 
category, 
sum(total_sale) as total_sales, 
count(*) as total_orders
from retail_sales_new
group by category
order by total_sales Desc;
```
**4. Pricing and Profitability Analysis**

- **Profitability by Category**
```sql
select category,
round(sum(total_sale - cogs),2) as Profit 
from retail_sales_new
group by category
order by Profit desc;
```
- **Average Price per Unit per Category**
```sql
select category,
round(avg(price_per_unit),2) as avg_price
from retail_sales_new
group by category
order by avg_price desc;
```
**5. Sales Efficiency**

- **Fastest-Selling Products (Quantity)**
```sql
select category,
sum(quantiy) as total_quantity
from retail_sales_new
group by category
order by total_quantity desc;
```
**6. Customer Behavior**

- **Most Active Customers**
```sql
select distinct customer_id,
count(*) as total_transactions 
from retail_sales_new
group by customer_id
order by total_transactions desc
limit 5;
```
**7. Combined Analysis**

- **Age Group vs. Category Analysis:**
```sql
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
```
- **Category-wise Sales by Gender:**
```sql
select category, 
 gender, 
 count(*) as total_transactions
 from retail_sales_new
 group by category, gender
 order by category;
```
**8. Top 5 customers based on the highest total sales**
```sql
select 
 customer_id, 
 sum(total_sale) as Total_sales 
 from retail_sales_new
 group by customer_id
 order by total_sales desc
 limit 5;
```
**9. Total number of unique customers from each category:**
```sql
select 
 category,
 count(distinct customer_id) as number_of_customers
 from retail_sales_new
 group by category
 order by number_of_customers desc;
```
**10. Most Active Customers:**
```sql
select distinct customer_id,
count(*) as total_transactions 
from retail_sales_new
group by customer_id
order by total_transactions desc
limit 5;
```

# Findings
- **Autumn** recorded the **highest number of orders**, followed by Summer, Spring, and Winter, showing significant seasonal variations in sales.
- Customers **aged above 50** contributed the **highest sales**, while the **under 20** group had the **least** impact.
- **Sales** were **higher for Female**, indicating a more engaged demographic.
- **Clothing** was the **most profitable**, while others showed varying margins.
- The **highest-priced** and **fast selling** category was **Clothing**, reflecting premium pricing strategies.

# Conclusion
The data analysis provides valuable insights into sales trends, customer demographics, product performance, and customer behavior. Key takeaways include:

- **Optimizing Seasonal Strategies:** Focus on peak-performing months and seasons, particularly Autumn and Summer, to maximize revenue.
- **Targeting Key Demographics:** Prioritize marketing efforts towards the age group above 50 and the dominant gender segment i.e., Female, to boost engagement and sales.
- **Enhancing Product Offerings:** Invest in high-performing and profitable categories while exploring opportunities to improve underperforming ones.
- **Leveraging High-Value Customers:** Strengthen relationships with the top-performing customers who drive significant revenue and transactions.
- **Data-Driven Decisions:** Utilize insights into category-wise gender preferences and age group trends for more personalized marketing and product development strategies.

These findings support actionable strategies to improve sales efficiency, enhance customer satisfaction, and drive profitability. By capitalizing on these insights, the business can better align operations with customer needs and market opportunities.
