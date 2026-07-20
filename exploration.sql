-- =============================================
-- Amazon Shopverse Records - Data Exploration
-- =============================================

USE amazon_shopverse_records;

-- Basic Information
SELECT DATABASE() AS current_database;
SHOW TABLES;

-- Row Count
SELECT COUNT(*) AS total_orders FROM shopverse_records;

-- checking for clarification 
select database();
show tables;

-- Column-level NULL check
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
