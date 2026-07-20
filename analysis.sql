-- =============================================
-- Amazon Shopverse Records - Advanced Analysis
-- Professional Business Intelligence Queries
-- =============================================

USE amazon_shopverse_records;

-- =============================================
-- 1. Overall Business KPIs
-- Basic Aggregation
-- Find the total revenue (TotalAmount), total orders, and average order value for the entire dataset.
-- =============================================
select sum(TotalAmount) as total_revenue ,
        count(*) as total_orders ,
          round(avg(TotalAmount),2) as avg_order_value
from shopverse_records ;

-- =============================================
-- 2. Top 10 Products by Revenue
-- Top Performers
-- Find the Top 10 products (by ProductName) that generated the highest total revenue. Show ProductName, Total Revenue, and Quantity Sold.
-- =============================================
select ProductName ,
        sum(TotalAmount) as total_revenue ,
          sum(Quantity) as quantity_sold 
      from shopverse_records
group by ProductName
order by total_revenue desc 
limit 10;

-- =============================================
-- 3. Monthly Revenue Trends (2023)
-- Time-based Analysis
-- Find the monthly total revenue for the year 2023. Show Year-Month and Total Revenue, sorted by revenue descending.
-- =============================================
select date_format(OrderDate , '%y-%m') as year_and_month ,
        sum(TotalAmount) as monthly_revenue
      from shopverse_records
where year(OrderDate) = 2023
group by year_and_month
order by monthly_revenue desc;

-- =============================================
-- 4. Category Performance Analysis
-- Which Category has the highest average UnitPrice? Also show the total quantity sold and total revenue for each category. Sort by average price descending.
-- =============================================
select Category ,
        sum(TotalAmount) as total_revenue ,
          sum(Quantity) as quantity_sold ,
            round(avg(UnitPrice),2) as avg_price
      from shopverse_records
group by Category
order by avg_price desc;

-- =============================================
-- 5. Top 5 Customers by Lifetime Value
-- Customer Analysis
-- Find the Top 5 customers (by CustomerName) who have spent the most money overall. Show CustomerName, Total Spent, and Number of Orders.
-- =============================================
select CustomerName ,
        sum(TotalAmount) as total_spent ,
          count(*) as number_of_orders
      from shopverse_records
group by CustomerName
order by total_spent desc
limit 5;

-- =============================================
-- 6. Delivered Revenue by Country + Contribution %
-- Order Status & Geography
-- For orders with status 'Delivered', find the total revenue per Country. Also calculate the percentage of total revenue each country contributes.
-- =============================================
select Country ,
        sum(TotalAmount) as total_revenue ,
          round(sum(TotalAmount) * 100.0 /sum(sum(TotalAmount)) over(), 2) as percent_contributes
      from shopverse_records
where OrderStatus = 'Delivered'
group by Country 
order by percent_contributes desc;

-- =============================================
-- 7. Discount Analysis
-- Discount Impact
-- Calculate the total discount amount given across all orders and the average discount percentage (Discount). Also find which Brand offers the highest average discount.
-- =============================================
select round(sum(UnitPrice * Quantity * Discount) , 2) as total_discount_amount ,
        round(avg(Discount) * 100.0 , 2) as avg_discount_percent ,
          Brand,
            round(avg(Discount) * 100.0 , 2 ) as brand_avg_discount
        from shopverse_records
group by Brand
order by brand_avg_discount desc;

-- =============================================
-- 8. Payment Method Performance
-- Which Payment Method is most popular? Show the count of orders and total revenue for each payment method, sorted by revenue.
-- =============================================
select PaymentMethod ,
        count(*) as number_of_orders,
          sum(TotalAmount) as total_revenue 
      from shopverse_records
group by PaymentMethod
order by total_revenue desc;

-- =============================================
-- 9. Product Ranking within Categories (Window Function)
-- Advanced - Window Function
-- For each Category, rank the products by their total revenue within that category (use RANK() or DENSE_RANK()). Show top 3 products per category.
-- =============================================
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

-- =============================================
-- 10. High-Value US Delivered Orders (2024)
-- Complex - Multi-condition
-- Find all orders placed in 2024 where:
-- OrderStatus = 'Delivered'
-- TotalAmount > 1000
-- Customer is from United States
 -- Show OrderID, OrderDate, CustomerName, TotalAmount, and ProductName. Limit to 20 rows.
-- =============================================
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

-- =============================================
-- 11. Year-over-Year Revenue Growth
-- (Using LAG)
-- Find the yearly total revenue and the YoY growth percentage from previous year. 
-- =============================================
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

-- =============================================
-- 12. Customer Retention (2023 vs 2024)
-- Find customers who placed orders in both 2023 and 2024. Show their names and total spending in each year.
-- =============================================
select CustomerName ,
		round(sum(case when year(OrderDate) = 2023 then TotalAmount else 0 end),2) as revenue_2023,
        round(sum(case when year(OrderDate) = 2024 then TotalAmount else 0 end),2) as revenue_2024 
        from shopverse_records 
        where year(OrderDate) in (2023, 2024)
        group by CustomerName 
        having count(distinct year(OrderDate)) = 2
        order by revenue_2024 desc;

-- =============================================
-- 13. Peak Sales by Day of Week
-- Which day of the week has the highest average order value? Show Day Name, Avg Order Value, and Total Orders.
-- =============================================
select dayname(OrderDate) as day_of_the_week ,
		    round(avg(TotalAmount),2) as avg_order_value ,
          count(*) as total_orders
       from shopverse_records
        group by day_of_the_week
        order by avg_order_value desc;

-- =============================================
-- 14. Return/Cancellation Rate by Category
-- Calculate the percentage of orders that were either Returned or Cancelled for each Category.
-- =============================================
select Category ,
		count(*) as total_orders , 
        sum(case when OrderStatus in ('Returned' , 'Cancelled') then 1 else 0 end ) as bad_orders,
        round(sum(case when OrderStatus in ('Returned' , 'Cancelled') then 1 else 0 end ) * 100.0 / count(*), 2) as bad_order_percent
        from shopverse_records
        group by Category
        order by bad_order_percent desc;

-- =============================================
-- 15. Top Sellers Performance
-- Find the Top 5 Sellers (SellerID) by total revenue. Also show average order value per seller.
-- =============================================
select SellerID ,
		sum(TotalAmount) as total_revenue ,
        round(avg(TotalAmount),2) as avg_order_value,
        count(*) as total_orders
        from shopverse_records
        group by SellerID
        order by total_revenue desc
        limit 5;

-- =============================================
-- 16. Brand Price Range Analysis
-- For each Brand, find:
-- Minimum UnitPrice
-- Maximum UnitPrice
-- Average UnitPrice
-- Price Range (Max - Min)
-- =============================================
select Brand ,
		    min(UnitPrice) as min_price,
          max(UnitPrice) as max_price,
            round(avg(UnitPrice),2) as avg_price,
              round(max(UnitPrice) - min(UnitPrice) ,2) as price_range
        from shopverse_records
	    group by Brand 
        order by price_range desc;

-- =============================================
-- 17. Running Cumulative Revenue
-- Show the cumulative (running) total revenue month by month from the start of the dataset, ordered by date.
-- =============================================
select date_format(OrderDate, '%y-%m') as year_and_month,
	    	sum(TotalAmount) as total_revenue ,
	      	round(sum(sum(TotalAmount)) over(order by date_format(OrderDate, '%y-%m')), 2) as cumulative_revenue
      from shopverse_records
        group by year_and_month
        order by year_and_month;

-- =============================================
-- 18. Multi-Country Comparison
-- Compare total revenue between United States, India, and Australia. Also show which country has the highest average shipping cost.
-- =============================================
select Country ,
		sum(TotalAmount) as total_revenue ,
		round(avg(ShippingCost),2) as avg_shipping_cost
        from shopverse_records
        where Country in ('United States' , 'India' , 'Australia' )
        group by Country
        order by avg_shipping_cost desc;

-- =============================================
-- 19. High-Volume High-Value Orders
-- Find all orders where Quantity >= 5 and TotalAmount > 1500. Show OrderID, CustomerName, ProductName, Quantity, and TotalAmount. Sort by Quantity DESC.
-- =============================================
select OrderID ,
		CustomerName,
        ProductName,
        Quantity,
        TotalAmount
        from shopverse_records
        where Quantity >= 5 and TotalAmount > 1500
        order by Quantity desc;

-- =============================================
-- 20. 3-Month Rolling Average Revenue
-- Calculate the 3-month rolling average revenue (moving average). Show Year-Month and the 3-month moving average.
-- =============================================
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
