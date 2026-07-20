**Amazon Shopverse Records - Database Schema**
-- Professional SQL Data Analysis Project

-- first creating a new database

create database amazon_shopverse_records;
use amazon_shopverse_records;

-- Drop existing table if exists
DROP TABLE IF EXISTS shopverse_records;

-- Create Main Transaction Table
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

-- Optional: Add comments for documentation
alter table shopverse_records
modify column PaymentMethod varchar(50);
