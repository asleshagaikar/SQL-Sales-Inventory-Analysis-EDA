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


--Analytics & Insights
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

--Customer Segmentation by Spending

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


--3 Top Selling Products for each month
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

--Trends in High-Spending Customers
SELECT 
    C.Name,
    C.MembershipType,
    COUNT(DISTINCT S.SaleID) AS TotalPurchases,
    SUM(S.QuantitySold * P.Price) AS TotalSpent
FROM Sales S
JOIN Customers C ON S.CustomerID = C.CustomerID
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY C.Name, C.MembershipType
ORDER BY TotalSpent DESC
LIMIT 10;

--Sales by City
SELECT 
    ST.City,
    SUM(S.QuantitySold * P.Price) AS TotalRevenue
FROM Sales S
JOIN Stores ST ON S.StoreID = ST.StoreID
JOIN Products P ON S.ProductID = P.ProductID
GROUP BY ST.City
ORDER BY TotalRevenue DESC;