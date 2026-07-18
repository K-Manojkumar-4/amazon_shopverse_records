-- **SQL project using amazon shopverse records dataset**

-- first creating a new database
create database amazon_shopverse_records;
use amazon_shopverse_records;

-- creating table columns for the dataset

drop table if exists shopverse_records ;
create table shopverse_records ( 
		OrderID varchar(20) primary key,
        OrderDate date ,
        CustomerID varchar(20) ,
        CustomerName varchar(100) ,
        ProductID varchar(20) ,
        ProductName varchar(100),
        Category varchar(100) ,
        Brand varchar(100) ,
        Quantity int ,
        UnitPrice decimal (12,2) ,
        Discount decimal(10,2) ,
        Tax decimal(10,2) ,
        ShippingCost decimal(10,2) ,
        TotalAmount decimal (12,2) ,
        PaymentMethod decimal(12,2) ,
        OrderStatus varchar(50),
        City varchar(100) ,
        State varchar(100) ,
        Country varchar(100) ,
        SellerID varchar(20) ) ;

select * from shopverse_records ;

-- making changes in the structure of an existing table

alter table shopverse_records
modify column PaymentMethod varchar(50);

-- time for loading data in table.csv

SHOW VARIABLES LIKE 'secure_file_priv';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/New folder/amazon shopverse records.csv'
INTO TABLE shopverse_records
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- **data expoloration** 

-- checking for clarification 

select database();
show tables;

-- check how many rows been there ?

select count(*) from shopverse_records;

-- check how many unique customer orders  ?

select count(distinct CustomerID) from shopverse_records;

-- checking for columns have null values ?

select * from shopverse_records
where
	OrderID is null or
	OrderDate is null or
	CustomerID is null or
	CustomerName is null or
	ProductID is null or
	ProductName is null or
	Category is null or
	Brand is null or
	Quantity is null or
	UnitPrice is null or
	Discount is null or
	Tax is null or
	ShippingCost is null or
	TotalAmount is null or
	PaymentMethod is null or
	OrderStatus is null or
	City is null or
	State is null or
	Country is null or
	SellerID is null ;

-- **data analysis and business key problems & answer**

-- ** MySQL Questions to Solve **

-- 1. Basic Aggregation
-- Find the total revenue (TotalAmount), total orders, and average order value for the entire dataset.

select sum(TotalAmount) as total_revenue ,
count(*) as total_orders ,
round(avg(TotalAmount),2) as avg_order_value
from shopverse_records ;

-- 2. Top Performers
-- Find the Top 10 products (by ProductName) that generated the highest total revenue. Show ProductName, Total Revenue, and Quantity Sold.

select ProductName ,
sum(TotalAmount) as total_revenue ,
sum(Quantity) as quantity_sold 
from shopverse_records
group by ProductName
order by total_revenue desc 
limit 10;

-- 3. Time-based Analysis
-- Find the monthly total revenue for the year 2023. Show Year-Month and Total Revenue, sorted by revenue descending.

select date_format(OrderDate , '%y-%m') as year_and_month ,
sum(TotalAmount) as monthly_revenue
from shopverse_records
where year(OrderDate) = 2023
group by year_and_month
order by monthly_revenue desc;

-- 4. Category Performance
-- Which Category has the highest average UnitPrice? Also show the total quantity sold and total revenue for each category. Sort by average price descending.

select Category ,
sum(TotalAmount) as total_revenue ,
sum(Quantity) as quantity_sold ,
round(avg(UnitPrice),2) as avg_price
from shopverse_records
group by Category
order by avg_price desc;

-- 5. Customer Analysis
-- Find the Top 5 customers (by CustomerName) who have spent the most money overall. Show CustomerName, Total Spent, and Number of Orders.

select CustomerName ,
sum(TotalAmount) as total_spent ,
count(*) as number_of_orders
from shopverse_records
group by CustomerName
order by total_spent desc
limit 5;

-- 6. Order Status & Geography
-- For orders with status 'Delivered', find the total revenue per Country. Also calculate the percentage of total revenue each country contributes.

select Country ,
sum(TotalAmount) as total_revenue ,
round(sum(TotalAmount) * 100.0 /sum(sum(TotalAmount)) over(),2) as percent_contributes
from shopverse_records
where OrderStatus = 'Delivered'
group by Country 
order by percent_contributes desc;

-- 7. Discount Impact
-- Calculate the total discount amount given across all orders and the average discount percentage (Discount). Also find which Brand offers the highest average discount.

select round(sum(UnitPrice * Quantity * Discount) , 2) as total_discount_amount ,
round(avg(Discount) * 100.0 , 2) as avg_discount_percent ,
Brand,
round(avg(Discount) * 100.0 , 2 ) as brand_avg_discount
from shopverse_records
group by Brand
order by brand_avg_discount desc;

-- 8. Payment Method Trends
-- Which Payment Method is most popular? Show the count of orders and total revenue for each payment method, sorted by revenue.

select PaymentMethod ,
count(*) as number_of_orders,
sum(TotalAmount) as total_revenue 
from shopverse_records
group by PaymentMethod
order by total_revenue desc;

-- 9. Advanced - Window Function
-- For each Category, rank the products by their total revenue within that category (use RANK() or DENSE_RANK()). Show top 3 products per category.

with category_revenue as (
select Category ,
		ProductName ,
		sum(TotalAmount) as total_revenue ,
        dense_rank() over(partition by Category order by sum(TotalAmount) desc) as ranking_product
        from shopverse_records
        group by Category , ProductName)
    select Category ,
			ProductName ,
            total_revenue,
            ranking_product
            from category_revenue
            where ranking_product <= 3
            order by Category;

-- 10. Complex - Multi-condition
-- Find all orders placed in 2024 where:
-- OrderStatus = 'Delivered'
-- TotalAmount > 1000
-- Customer is from United States
 -- Show OrderID, OrderDate, CustomerName, TotalAmount, and ProductName. Limit to 20 rows.
 
 select OrderID ,
		OrderDate ,
        CustomerName,
        TotalAmount,
        ProductName
        from shopverse_records
        where year(OrderDate) like '2024%'
        and OrderStatus = 'Delivered'
        and TotalAmount > 1000 
        and Country = 'United States'
        order by TotalAmount desc
        limit 20;
     
-- 11. Year-over-Year Growth (Using LAG)
-- Find the yearly total revenue and the YoY growth percentage from previous year.     

with yearly_revenue as (
select year(OrderDate) as sales_year ,
		sum(TotalAmount) as total_revenue
        from shopverse_records
        group by sales_year)
select sales_year ,
		total_revenue ,
        round((total_revenue - lag(total_revenue) over(order by sales_year)) * 100.0 / lag(total_revenue) over(order by sales_year),2) as yoy_growth
        from yearly_revenue
        order by sales_year;
        
-- 12. Customer Retention
-- Find customers who placed orders in both 2023 and 2024. Show their names and total spending in each year.

select CustomerName ,
		round(sum(case when year(OrderDate) = 2023 then TotalAmount else 0 end),2) as revenue_2023,
        round(sum(case when year(OrderDate) = 2024 then TotalAmount else 0 end),2) as revenue_2024 
        from shopverse_records 
        where year(OrderDate) in (2023, 2024)
        group by CustomerName 
        having count(distinct year(OrderDate)) = 2
        order by revenue_2024 desc;

-- 13. Peak Sales Days
-- Which day of the week has the highest average order value? Show Day Name, Avg Order Value, and Total Orders.

select dayname(OrderDate) as day_of_the_week ,
		round(avg(TotalAmount),2) as avg_order_value ,
        count(*) as total_orders
        from shopverse_records
        group by day_of_the_week
        order by avg_order_value desc;

-- 14. Return / Cancellation Rate
-- Calculate the percentage of orders that were either Returned or Cancelled for each Category.

select Category ,
		count(*) as total_orders , 
        sum(case when OrderStatus in ('Returned' , 'Cancelled') then 1 else 0 end ) as bad_orders,
        round(sum(case when OrderStatus in ('Returned' , 'Cancelled') then 1 else 0 end ) * 100.0 / count(*), 2) as bad_order_percent
        from shopverse_records
        group by Category
        order by bad_order_percent desc;
        
-- 15. Seller Performance
-- Find the Top 5 Sellers (SellerID) by total revenue. Also show average order value per seller.

select SellerID ,
		sum(TotalAmount) as total_revenue ,
        round(avg(TotalAmount),2) as avg_order_value,
        count(*) as total_orders
        from shopverse_records
        group by SellerID
        order by total_revenue desc
        limit 5;

-- 16. Price Range Analysis
-- For each Brand, find:
-- Minimum UnitPrice
-- Maximum UnitPrice
-- Average UnitPrice
-- Price Range (Max - Min)

select Brand ,
		min(UnitPrice) as min_price,
        max(UnitPrice) as max_price,
        round(avg(UnitPrice),2) as avg_price,
        round(max(UnitPrice) - min(UnitPrice) ,2) as price_range
        from shopverse_records
	    group by Brand 
        order by price_range desc;

-- 17. Running Total Revenue (Window Function)
-- Show the cumulative (running) total revenue month by month from the start of the dataset, ordered by date.

select date_format(OrderDate, '%y-%m') as year_and_month,
		sum(TotalAmount) as total_revenue ,
		round(sum(sum(TotalAmount)) over(order by date_format(OrderDate, '%y-%m')), 2) as cumulative_revenue
        from shopverse_records
        group by year_and_month
        order by year_and_month;

-- 18. Multi-Country Comparison
-- Compare total revenue between United States, India, and Australia. Also show which country has the highest average shipping cost.
		
select Country ,
		sum(TotalAmount) as total_revenue ,
		round(avg(ShippingCost),2) as avg_shipping_cost
        from shopverse_records
        where Country in ('United States' , 'India' , 'Australia' )
        group by Country
        order by avg_shipping_cost desc;
        
-- 19. High Quantity Orders
-- Find all orders where Quantity >= 5 and TotalAmount > 1500. Show OrderID, CustomerName, ProductName, Quantity, and TotalAmount. Sort by Quantity DESC.

select OrderID ,
		CustomerName,
        ProductName,
        Quantity,
        TotalAmount
        from shopverse_records
        where Quantity >= 5 and TotalAmount > 1500
        order by Quantity desc;
        
-- 20. Advanced - Moving Average
-- Calculate the 3-month rolling average revenue (moving average). Show Year-Month and the 3-month moving average.

with monthly as (
select date_format(OrderDate , '%y-%m') as year_and_month ,
		sum(TotalAmount) as total_revenue 
        from shopverse_records
        group by year_and_month )
select year_and_month,
		total_revenue ,
        round(avg(total_revenue) over(order by year_and_month rows between 2 preceding and current row),2) as three_month_moving_avg
from monthly
order by year_and_month;

