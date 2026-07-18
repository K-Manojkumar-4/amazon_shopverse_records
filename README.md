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
- **Columns**: OrderID, OrderDate, Customer details, Product Name, Category, locations, Seller info etc,...

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


## Project Structure
 
 **Create Database**
   ```sql
   CREATE DATABASE amazon_shopverse_records;
   USE amazon_shopverse_records;
   ```

-- Drop existing table if exists
```sql
DROP TABLE IF EXISTS shopverse_records;
```

-- =============================================
-- LOAD DATA INFILE (Adjust path as per your MySQL setup)
-- =============================================
```sql
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/amazon_shopverse_records.csv'
INTO TABLE shopverse_records
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
```

