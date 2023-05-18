/* Total number of invoices*/
SELECT COUNT(DISTINCT InvoiceNo) AS total_invoices
FROM online_invoice;
/* Total revenue generated*/
SELECT SUM(UnitPrice * Quantity) as Total_revenue
FROM online_retail;

/* Average quantity of items per invoice */
SELECT AVG(Quantity) as Average_quantity
FROM online_retail;

/* Maximum and minimun unit prices*/
SELECT MAX(UnitPrice) AS Max_unit_price, MIN(UnitPrice) AS Min_unit_price
FROM online_retail;

/* Number of Unique Customers */
SELECT COUNT(CustomerID) as Total_customer
FROM online_retail;
 
/* Total Quantity sold per country */
SELECT Country, SUM(Quantity) AS Total_quanity_sold
FROM online_retail
GROUP BY Country;

/* Top 10 selling Items by Quantity */
SELECT Description, SUM(Quantity) as Top_10_items
FROM online_retail
GROUP BY Description
ORDER BY Top_10_items DESC
LIMIT 10;

/* Average Unit Price per item */
SELECT Description, AVG(UnitPrice) AS Average_unit_price
FROM online_retail
GROUP BY Description;

/* Number of invoive per customer */
SELECT CustomerID, COUNT(DISTINCT InvoiceNo) AS Total_invoice_per_customer
FROM online_retail
GROUP BY CustomerID
ORDER BY Total_invoice_per_customer DESC;

/* Average revenue per invoice */
SELECT InvoiceNo, SUM(UnitPrice * Quantity) AS Invoice_Average
FROM online_retail
GROUP BY InvoiceNo
ORDER BY Invoice_Average DESC;

/* getting the highest total purchase amount by customers*/
SELECT CustomerID, sum(UnitPrice * Quantity) as Total_purchase
FROM online_retail
group by CustomerID
order by Total_purchase DESC;

/* which customer bought goods the most? */
Select CustomerID, Count(*) as Purchase_count
from online_retail
group by CustomerID
order by Purchase_count DESC;

/* To know the item that was bought the most */
Select Description, Count(*) as Discription_count
from online_retail
group by Description
order by Discription_count DESC;

/* To find the top 10 customers who bought a particular item*/

SELECT CustomerID, COUNT(*) AS item_count
FROM online_retail
WHERE Description = 'WHITE HANGING HEART T-LIGHT HOLDER'
GROUP BY CustomerID
ORDER BY item_count DESC
LIMIT 10;

/* Total revenue per country */
SELECT Country, SUM(UnitPrice * Quantity) AS Total_Country_revenue
FROM online_retail
GROUP BY Country
ORDER BY Total_Country_revenue DESC;

/* Find the most frequently purchased items. */
SELECT StockCode, Description, COUNT(*) AS PurchaseCount
FROM online_retail
GROUP BY StockCode, Description
ORDER BY PurchaseCount DESC
LIMIT 10;

/* Calculate the average unit price per country */
 SELECT Country, AVG(UnitPrice) as Average_Unit_price_country
 FROM online_retail
 GROUP BY Country;
 
 /* Find the most common descriptions among customers from a specific country. */
 SELECT Country, Description, COUNT(*) AS Description_country_common
 FROM online_retail
 WHERE Country = "United Kingdom"
 GROUP BY Country, Description
 ORDER BY Description_country_common DESC 
 LIMIT 10;
 
 /* Identify the most common items purchased together (co-occurrence analysis). */
 
SELECT A.StockCode AS Item1, B.StockCode AS Item2, COUNT(*) AS PurchaseCount
FROM online_retail A
JOIN online_retail B ON A.InvoiceNo = B.InvoiceNo AND A.StockCode < B.StockCode
GROUP BY A.StockCode, B.StockCode
ORDER BY PurchaseCount DESC
LIMIT 10;

/* Determine the correlation between quantity and unit price. */

SELECT CORR(Quantity, UnitPrice) AS Correlation
FROM online_retail;

/* Find the customers who have made purchases in consecutive months.*/
SELECT CustomerID
FROM (
  SELECT CustomerID, DATE_FORMAT(InvoiceDate, '%Y-%m') AS Month, 
         LAG(DATE_FORMAT(InvoiceDate, '%Y-%m')) OVER (PARTITION BY CustomerID ORDER BY InvoiceDate) AS PreviousMonth
  FROM online_retail
) AS T
WHERE PreviousMonth IS NOT NULL AND Month != PreviousMonth
GROUP BY CustomerID;

/* Calculate the average unit price difference between consecutive purchases for each customer. */
SELECT CustomerID, AVG(UnitPriceDiff) AS AvgUnitPriceDifference
FROM (
  SELECT CustomerID, InvoiceNo, UnitPrice - LAG(UnitPrice) OVER (PARTITION BY CustomerID ORDER BY InvoiceDate) AS UnitPriceDiff
  FROM online_retail
) AS T
WHERE UnitPriceDiff IS NOT NULL
GROUP BY CustomerID;

/* Identify the customers who have made purchases of all available items. */
SELECT CustomerID
FROM (
  SELECT CustomerID, COUNT(DISTINCT StockCode) AS UniqueItems
  FROM online_retail
  GROUP BY CustomerID
) AS T
WHERE UniqueItems = (SELECT COUNT(DISTINCT StockCode) FROM online_retail);

