# SQL-Sales-Inventory-Analysis-EDA
This project analyzes sales and inventory data for a fictional retail clothing store chain using PostgreSQL. The objective is to derive actionable insights into product performance, customer behavior, inventory management, and store operations. By performing both basic and advanced SQL operations, this project showcases a comprehensive range of SQL skills, including data cleaning, aggregations, window functions, and advanced analytics.
-------------------------------------------------------------------------------------------------------------------

Key Objectives
Analyze sales trends to identify top-selling products and revenue drivers.
Monitor inventory levels to optimize stock and prevent shortages.
Study customer purchasing behavior to segment customers and improve marketing strategies.
Evaluate store performance to identify high-performing locations and areas for improvement.
Generate insights into monthly sales trends and profit margins for better business decision-making.
--------------------------------------------------------------------------------------------------------------------

Dataset
The dataset consists of four tables:
Customers: Details about customers, including demographics and membership types.
Products: Product inventory with pricing, categories, and stock levels.
Sales: Transaction data including sales quantity, dates, and store locations.
Stores: Information about store locations and management.
--------------------------------------------------------------------------------------------------------------------

SQL Operations Highlights
Top Selling Products Per Month: Using ROW_NUMBER() to identify the top 3 products for each month based on revenue.
Inventory Reorder Analysis: Identifying low-stock products and recommending restocking actions.
Customer Segmentation: Grouping customers by spending levels and membership types for loyalty rewards.
Store Revenue Performance: Ranking stores by their total revenue to guide operational strategies.
Monthly Revenue Trends: Analyzing seasonal trends to align marketing efforts with peak sales periods.
--------------------------------------------------------------------------------------------------------------------

Skills Demonstrated
Data Cleaning: Removal of duplicates, handling null values, and ensuring data consistency.
Joins: Combining data across multiple tables for holistic analysis.
Aggregations: Summarizing data using functions like SUM, AVG, and COUNT.
Window Functions: Using ROW_NUMBER() and RANK() to rank top-selling products.
Subqueries: Efficiently calculating metrics like customer lifetime value.
Case Statements: Categorizing data for easier interpretation (e.g., low stock status).
--------------------------------------------------------------------------------------------------------------------
