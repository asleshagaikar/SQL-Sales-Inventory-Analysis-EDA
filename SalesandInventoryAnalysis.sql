-- Identify duplicates
SELECT SaleID, CustomerID, ProductID, SaleDate, COUNT(*)
FROM Sales
GROUP BY SaleID, CustomerID, ProductID, SaleDate
HAVING COUNT(*) > 1;

-- Remove duplicates while retaining the first occurrence
DELETE FROM Sales
WHERE SaleID IN (
    SELECT SaleID
    FROM (
        SELECT SaleID, ROW_NUMBER() OVER (PARTITION BY CustomerID, ProductID, SaleDate ORDER BY SaleID) AS RowNum
        FROM Sales
    ) SubQuery
    WHERE RowNum > 1
);


-- Fill missing product prices using the average price per category
UPDATE Products
SET Price = Sub.AvgPrice
FROM (
    SELECT Category, AVG(Price) AS AvgPrice
    FROM Products
    WHERE Price IS NOT NULL
    GROUP BY Category
) Sub
WHERE Products.Category = Sub.Category
  AND Products.Price IS NULL;


-- Fill missing stock quantities with 0
UPDATE Products
SET StockQuantity = 0
WHERE StockQuantity IS NULL;


--Analytics & Insights--

--Top 10 Selling Products

SELECT 
    P.ProductName,
    P.Category,
    SUM(S.QuantitySold) AS TotalUnitsSold,
    SUM(S.QuantitySold * P.Price) AS TotalRevenue
FROM Sales S
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY P.ProductName, P.Category
ORDER BY TotalUnitsSold DESC
LIMIT 10;

--Customer Segmentation by Spending & Membership Type

SELECT 
    C.CustomerID,
    C.Name,
    C.MembershipType,
    SUM(S.QuantitySold * P.Price) AS TotalSpent
FROM Sales S
JOIN Customers C ON S.CustomerID = C.CustomerID
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY C.CustomerID, C.Name, C.MembershipType
ORDER BY TotalSpent DESC;

--Gender-Based Purchasing Behavior

SELECT 
    C.Gender,
    P.Category,
    SUM(S.QuantitySold) AS UnitsPurchased,
    SUM(S.QuantitySold * P.Price) AS RevenueGenerated
FROM Sales S
JOIN Customers C ON S.CustomerID = C.CustomerID
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY C.Gender, P.Category
ORDER BY RevenueGenerated DESC;

--Inventory Reorder Levels

SELECT 
    ProductID,
    ProductName,
    StockQuantity,
    CASE 
        WHEN StockQuantity < 10 THEN 'Reorder Needed'
        ELSE 'Sufficient Stock'
    END AS StockStatus
FROM Products;

--Inventory Turnover Ratio

SELECT 
    P.ProductID,
    P.ProductName,
    SUM(S.QuantitySold) AS TotalUnitsSold,
    P.StockQuantity,
    ROUND(SUM(S.QuantitySold) * 1.0 / P.StockQuantity, 2) AS InventoryTurnoverRatio
FROM Sales S
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY P.ProductID, P.ProductName, P.StockQuantity
ORDER BY InventoryTurnoverRatio DESC;


--Monthly Revenue Trends

SELECT 
    TO_CHAR(S.SaleDate, 'YYYY-MM') AS Month,
    SUM(S.QuantitySold * P.Price) AS TotalRevenue
FROM Sales S
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY TO_CHAR(S.SaleDate, 'YYYY-MM')
ORDER BY Month;

--Top Categories by Profit

SELECT 
    P.Category,
    SUM(S.QuantitySold * (P.Price - P.CostPrice)) AS TotalProfit
FROM Sales S
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY P.Category
ORDER BY TotalProfit DESC;


--Top 3 best selling Products for each month
WITH MonthlyRev AS (
    SELECT 
        EXTRACT(MONTH FROM saledate) AS mnth,
        P.productid, 
        P.productname,
        SUM(S.quantitysold * P.price) AS monthlyrevenue
    FROM Sales S
    JOIN Products P ON S.ProductID = P.ProductID
    GROUP BY mnth, P.productid, P.productname
),
RankedProducts AS (
    SELECT 
        mnth, 
        productid, 
        productname, 
        monthlyrevenue,
        ROW_NUMBER() OVER (PARTITION BY mnth ORDER BY monthlyrevenue DESC) AS row_num
    FROM MonthlyRev
)
SELECT mnth, productid, productname, monthlyrevenue
FROM RankedProducts
WHERE row_num <= 3
ORDER BY mnth, row_num;


--Sales by City
SELECT 
    ST.City,
    SUM(S.QuantitySold * P.Price) AS TotalRevenue
FROM Sales S
JOIN Stores ST ON S.StoreID = ST.StoreID
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY ST.City
ORDER BY TotalRevenue DESC;

--Store Performance by Revenue

SELECT 
    ST.StoreName,
    ST.City,
    SUM(S.QuantitySold * P.Price) AS TotalRevenue
FROM Sales S
JOIN Products P ON S.ProductID = P.ProductID
JOIN Stores ST ON S.StoreID = ST.StoreID
GROUP BY ST.StoreName, ST.City
ORDER BY TotalRevenue DESC;

--Peak Sales Days

SELECT 
    SaleDate,
    COUNT(S.SaleID) AS NumberOfSales,
    SUM(S.QuantitySold * P.Price) AS RevenueGenerated
FROM Sales S
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY SaleDate
ORDER BY RevenueGenerated DESC;

--	Running total of revenue by month
SELECT 
    EXTRACT(MONTH from saledate) AS mnth,
    SUM(S.quantitysold * P.price) AS monthly_revenue,
    SUM(SUM(S.quantitysold * P.price)) OVER (ORDER BY EXTRACT(MONTH from saledate)) AS running_total
FROM Sales S
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY mnth
ORDER BY mnth;

-- Monthly Cumulative sales for each product

SELECT 
	P.productid,
    P.productname,
    EXTRACT(MONTH from S.saledate) AS month,
    SUM(S.quantitysold) AS monthly_sales,
    SUM(SUM(S.quantitysold)) OVER (PARTITION BY P.productid ORDER BY  EXTRACT(MONTH from S.saledate)) AS cumulative_sales
FROM Sales S
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY P.productid, P.productname, EXTRACT(MONTH from S.saledate)
ORDER BY  P.productid,month;

-- Running 7 day average revenue
SELECT 
	SaleDate,
    SUM(S.quantitysold * P.price) AS daily_revenue,
    AVG(SUM(S.quantitysold * P.price)) OVER (ORDER BY SaleDate ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS running_7_day_avg
FROM Sales S
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY SaleDate
ORDER BY SaleDate;

-- Weekly Revenue Trend
SELECT 
    DATE_TRUNC('week', saledate) AS week,
    SUM(S.quantitysold) AS total_units_sold,
    SUM(S.quantitysold * P.price) AS weekly_revenue
FROM Sales S
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY DATE_TRUNC('week', saledate)
ORDER BY week;

-- Best Selling Products by Quarter
WITH quarterly_sales AS(
SELECT 
    DATE_TRUNC('quarter', saledate) AS quarter,
    P.productid,
    P.productname,
    SUM(S.quantitysold) AS total_units_sold
FROM Sales S
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY DATE_TRUNC('quarter', saledate), P.productid, P.productname
ORDER BY quarter
),
ranked_products AS (
SELECT 
    quarter,
    productid,
    productname,
    total_units_sold,
	RANK() OVER(PARTITION BY quarter ORDER BY total_units_sold DESC) as product_rank
	FROM quarterly_sales
)
SELECT 
    quarter,
    productid,
    productname,
    total_units_sold,
	product_rank
FROM ranked_products
WHERE product_rank<=3
ORDER BY quarter, product_rank;




