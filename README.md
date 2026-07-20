# Amazon Shopverse Records | E-commerce Sales Analysis

**Advanced SQL Data Analysis Portfolio Project**

## Project Overview

**Project Title**: Amazon Shopverse Records
**Database**: amazon_shopverse_records

A professional SQL-based data analysis project on Amazon Shopverse e-commerce records. This repository demonstrates advanced MySQL querying techniques including aggregations, window functions, time-series analysis, customer segmentation, and business intelligence insights.

**Amazon Shopverse Records** analyzes a comprehensive e-commerce dataset containing order transactions, customer information, product details, and geographical data. The analysis uncovers key business metrics such as revenue trends, top performers, customer behavior, and operational efficiency.

### Key Features
- Complete database schema with proper constraints and data types
- Advanced analytical queries (20+ business questions)
- Window functions for rankings, running totals, and moving averages
- Time-based and YoY growth analysis
- Customer retention and segmentation
- Performance optimization considerations

### Business Context
Comprehensive analysis of **1,000,000+** transactional records from Shopverse, a large-scale e-commerce platform. This project demonstrates advanced SQL proficiency in extracting actionable business intelligence from high-volume sales data.

### Objectives
- Measure revenue performance across products, categories, brands, and geographies
- Identify customer behavior patterns and retention signals
- Evaluate operational efficiency (shipping, discounts, order fulfillment)
- Deliver strategic recommendations backed by data

### Technical Highlights
- Optimized MySQL schema with strategic indexing
- Advanced SQL techniques: Window Functions, CTEs, Date Intelligence, Conditional Aggregation
- Performance-conscious query design for large datasets
- Structured business insights with clear recommendations
  
## Dataset
- **Source**: Synthetic/processed Amazon Shopverse e-commerce records
- **Time Period**: Multi-year (including 2023-2024)
- **Key Tables**: `shopverse_records` (denormalized transactional data)
- **Columns**: OrderID, OrderDate, CustomerID, CustomerName, ProductID, ProductName, Category, Brand, Quantity, UnitPrice, Discount, Tax, ShippingCost, TotalAmount, PaymentMethod, OrderStatus, City, State, Country, SellerID — all match.

## Queries Covered

###  Basic Aggregation & KPIs
- Total revenue, order count, average order value

###  Top Performers
- Top products, customers, sellers, categories

###  Time Intelligence
- Monthly revenue, YoY growth, peak days, moving averages

###  Customer & Retention Analysis
- Top spenders, retention between years

###  Advanced Analytics
- Window functions (ranking, running totals)
- Discount impact, return rates, price range analysis
- Geographic performance

## Technologies
- **MySQL** (Window functions, CTEs, DATE functions)
- **SQL Best Practices** (Indexing recommendations, query optimization)

## Business Insights Generated
- Revenue leaders by product/category
- Seasonal trends and growth rates
- Customer loyalty patterns
- Operational efficiency (shipping, returns, discounts)
- Geographic market performance

## Project Organization

The repository follows a clean, modular, and production-ready structure designed for scalability and maintainability:

- README.md – Executive summary, business context, setup instructions, and key insights.
- schema.sql – Defines the relational schema with proper data types, constraints, indexes, and documentation.
- data_loading.sql – Handles secure data import and includes post-load integrity checks.
- exploration.sql – Performs initial data discovery, quality validation, and descriptive statistics.
- analysis.sql – Contains 20+ advanced SQL queries addressing critical business questions using CTEs, window functions, and time-series analysis.
- RESULT.md – Dedicated folder for generated reports and analytical outputs.
