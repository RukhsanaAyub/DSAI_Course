
--Beginner Queries.
--meta data
CREATE TABLE online_retail (
    InvoiceNo INT NULL,
    StockCode NVARCHAR(50),  
    Description NVARCHAR(MAX), 
    Quantity INT NULL,
    InvoiceDate DATETIME, 
    UnitPrice FLOAT NULL, 
    CustomerID BIGINT NULL,
    Country NVARCHAR(100) 
);
--the distribution of order values across all customers in the dataset
SELECT CustomerID, SUM(Quantity * UnitPrice) AS TotalOrderValue
FROM online_retail
GROUP BY CustomerID;

--unique products has each customer purchased
SELECT CustomerID, COUNT(DISTINCT StockCode) AS UniqueProducts
FROM online_retail
GROUP BY CustomerID;
--customers have only made a single purchase from the company
SELECT CustomerID
FROM online_retail
GROUP BY CustomerID
HAVING COUNT(InvoiceNo) = 1;

--products are most commonly purchased together by customers in the dataset
SELECT StockCode, COUNT(StockCode) AS PurchaseCount
FROM online_retail
GROUP BY StockCode

--Advance Queries--

--Customer Segmentation by Purchase Frequency
SELECT CustomerID, 
       CASE 
           WHEN COUNT(InvoiceNo) > 50 THEN 'High Frequency'
           WHEN COUNT(InvoiceNo) BETWEEN 10 AND 50 THEN 'Medium Frequency'
           ELSE 'Low Frequency'
       END AS PurchaseFrequency
FROM online_retail
GROUP BY CustomerID;

--Average Order Value by Country

SELECT Country, AVG(Quantity * UnitPrice) AS AvgOrderValue
FROM online_retail
GROUP BY Country;

--Customer Churn Analysis Identify customers who haven’t made a purchase in the last 6 months.

SELECT DISTINCT CustomerID
FROM online_retail
WHERE InvoiceDate < DATEADD(MONTH, -6, GETDATE())
  AND CustomerID IS NOT NULL;


--Product Affinity Analysis You would first need to create pairs of products purchased together and calculate their correlation.

SELECT t1.StockCode AS Product1, t2.StockCode AS Product2, COUNT(*) AS TimesPurchasedTogether
FROM online_retail t1
JOIN online_retail t2 ON t1.InvoiceNo = t2.InvoiceNo AND t1.StockCode < t2.StockCode
GROUP BY t1.StockCode, t2.StockCode
ORDER BY TimesPurchasedTogether DESC;

--Time-based Analysis Example for monthly sales trends:

SELECT MONTH(InvoiceDate) AS Month, SUM(Quantity * UnitPrice) AS TotalSales
FROM online_retail
GROUP BY MONTH(InvoiceDate)
ORDER BY Month;