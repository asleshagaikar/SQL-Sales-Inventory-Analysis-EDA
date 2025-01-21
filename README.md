# Comprehensive Sales and Inventory Analysis using PostgreSQL - EDA
This project provides a robust framework for performing data analysis on sales, inventory, and customer data stored in a PostgreSQL database. The SQL scripts implemented in this project offer insights into key performance indicators (KPIs), customer segmentation, product trends, and operational efficiency, enabling better business decision-making.

The project showcases how to leverage SQL queries for data cleaning, aggregation, and advanced analytics, including running totals, cumulative sales, and time-based trends. It can be easily adapted to different datasets and industries to provide meaningful insights.


Key Features:\n
Data Cleaning:

Identify and remove duplicate sales records.
Impute missing product prices with the average price per category.
Fill missing stock quantities with default values.


Sales Insights:

Top Selling Products: Identify the most popular products by units sold and revenue generated.
Customer Segmentation: Analyze customer spending patterns by membership type.
Gender-Based Trends: Understand purchasing behavior across product categories for different genders.
Peak Sales Days: Identify the most profitable sales days.


Inventory Management:

Analyze inventory levels and flag products for reorder.
Calculate inventory turnover ratios for better stock management.


Time-Based Trends:

Monthly revenue trends.
Weekly revenue patterns.
Best-selling products by quarter.


Advanced Analytics:

Calculate running totals of revenue by month.
Compute cumulative sales for each product over time.
Analyze running 7-day average revenue trends.
Store and City-Level Performance:


Data Model:


The project uses a relational data model with the following key tables:

Customers: Customer information, including demographics and membership type.
Products: Product details, including price, cost, and stock quantity.
Sales: Transaction data, including quantity sold, sale date, and associated product and customer IDs.
Stores: Store information, including name and location.


Skills Demonstrated:


Data Cleaning: Removal of duplicates, handling null values, and ensuring data consistency.
Joins: Combining data across multiple tables for holistic analysis.
Aggregations: Summarizing data using functions like SUM, AVG, and COUNT.
Window Functions: Using ROW_NUMBER() and RANK() to rank top-selling products.
Subqueries and CTE: Efficiently calculating metrics like customer lifetime value.
Case Statements: Categorizing data for easier interpretation (e.g., low stock status).

Technologies Used:


Database: PostgreSQL
Query Language: SQL
Dataset: Simulated data for customers, products, sales, and stores.



