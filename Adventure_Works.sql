CREATE DATABASE Adventure;
USE adventure;
SHOW TABLES;

-- question 0
CREATE TEMPORARY TABLE Union_Table AS
SELECT * FROM internet_sales
UNION
SELECT * FROM internet_sales_new;

SET SQL_SAFE_UPDATES = 0;

CREATE TABLE Sales AS
SELECT * FROM Union_Table;

SELECT * FROM Sales;

-- question 1
SELECT s.ProductKey,
p.EnglishProductName,
s.Orderquantity,
s.UnitPrice
FROM Sales s
INNER JOIN Product p
ON s.ProductKey = p.ProductKey
WHERE EnglishProductName IS NOT NULL AND EnglishProductName != '';

-- question 2
SELECT CONCAT(c.FirstName," ",c.MiddleName," ",c.LastName) AS CustomerName,
s.UnitPrice FROM Sales s
INNER JOIN Customers c
ON s.CustomerKey = c.CustomerKey;

-- question 3
ALTER TABLE Sales ADD DATE VARCHAR(10);
UPDATE Sales SET DATE = DATE_FORMAT(STR_TO_DATE(OrderDateKey, '%Y%m%d'), '%d/%m/%Y');
ALTER TABLE sales ADD YEAR VARCHAR(10);
UPDATE sales SET YEAR= YEAR(STR_TO_DATE(date, '%d/%m/%Y'));

ALTER TABLE sales
ADD MonthNo INT AFTER Year;

ALTER TABLE sales
ADD FinancialMonth INT AFTER MonthNo,
ADD FinancialQuarter CHAR(20) AFTER MonthNo,
ADD WeekDayName VARCHAR(100) AFTER MonthNo, 
ADD WeekDayNo INT AFTER MonthNo,
ADD YearMonth VARCHAR (100) AFTER MonthNo,
ADD MonthName VARCHAR (100) AFTER MonthNo;

ALTER TABLE sales
ADD Quarter VARCHAR (100) AFTER MonthNAme;

ALTER TABLE Sales
MODIFY COLUMN FinancialQuarter CHAR(20) AFTER FinancialMonth;

SELECT * FROM sales;
- columns for question 3 
ALTER TABLE sales
ADD Year INT AFTER Date;
ALTER TABLE sales
ADD MonthNo INT AFTER Year;

-- question 3A
UPDATE sales SET year= YEAR(STR_TO_DATE(date, '%d/%m/%Y'));
-- question 3B
UPDATE sales SET MonthNo = MONTH(STR_TO_DATE(date, '%d/%m/%Y'));
-- question 3C
UPDATE sales SET MonthName = MONTHNAME(STR_TO_DATE(date, '%d/%m/%Y'));
-- question 3D
UPDATE sales SET Quarter = quarter(STR_TO_DATE(date, '%d/%m/%Y'));
-- question 3E
UPDATE sales SET YearMonth = DATE_FORMAT(STR_TO_DATE(date, '%d/%m/%Y'), '%Y%m');
-- question 3F
UPDATE sales SET weekDayNo = DAYOFWEEK(STR_TO_DATE(date, '%d/%m/%Y'));
-- question 3G
UPDATE sales SET WeekDayName = DAYNAME(STR_TO_DATE(date, '%d/%m/%Y'));
-- question 3H
UPDATE sales
SET FinancialMonth = CASE 
    WHEN MONTH(STR_TO_DATE(date, '%d/%m/%Y')) IN (4, 5, 6) THEN MONTH(STR_TO_DATE(date, '%d/%m/%Y')) - 3
    WHEN MONTH(STR_TO_DATE(date, '%d/%m/%Y')) IN (7, 8, 9) THEN MONTH(STR_TO_DATE(date, '%d/%m/%Y')) - 6
    WHEN MONTH(STR_TO_DATE(date, '%d/%m/%Y')) IN (10, 11, 12) THEN MONTH(STR_TO_DATE(date, '%d/%m/%Y')) - 9
    ELSE MONTH(STR_TO_DATE(date, '%d/%m/%Y')) + 3
END;
-- question 3I
UPDATE sales
SET FinancialQuarter = CASE 
    WHEN MONTH(STR_TO_DATE(date, '%d/%m/%Y')) IN (4, 5, 6) THEN 1
    WHEN MONTH(STR_TO_DATE(date, '%d/%m/%Y')) IN (7, 8, 9) THEN 2  
    WHEN MONTH(STR_TO_DATE(date, '%d/%m/%Y')) IN (10, 11, 12) THEN 3 
    ELSE 4  
END;

SELECT OrderDateKey, Date, Year, MonthNo, MonthName, YearMonth, Quarter,WeekDayNo,WeekDayName,FinancialMonth,FinancialQuarter 
FROM Sales;

-- question 4
SELECT UnitPrice, OrderQuantity, UnitPriceDiscountPct, 
(UnitPrice*OrderQuantity)-UnitPriceDiscountPct AS Total_Sales 
FROM Sales;

-- question 5
SELECT ProductStandardCost, OrderQuantity,
(ProductStandardCost*OrderQuantity) AS Total_ProductCost
FROM Sales;

-- question 6
SELECT (UnitPrice*OrderQuantity)-UnitPriceDiscountPct AS Total_Sales,
(ProductStandardCost*OrderQuantity) AS Total_ProductCost,
(UnitPrice*OrderQuantity)-UnitPriceDiscountPct - (ProductStandardCost*OrderQuantity) AS Total_Profit
FROM Sales;     

-- question 7
SELECT Year , MonthName, ROUND(SUM((UnitPrice*OrderQuantity)-UnitPriceDiscountPct),2) AS TotalSales FROM Sales
WHERE Year = 2012 GROUP BY Year, MonthName
ORDER BY MonthName;

-- question 8
SELECT Year ,  ROUND(SUM((UnitPrice*OrderQuantity)-UnitPriceDiscountPct),2) AS TotalSales FROM Sales 
GROUP BY Year
ORDER BY Year;

-- question 9
SELECT Year, MonthName, ROUND(SUM((UnitPrice*OrderQuantity)-UnitPriceDiscountPct),2) AS TotalSales FROM Sales 
GROUP BY Year, MonthName
ORDER BY Year;

-- question 10
SELECT Quarter, ROUND(SUM((UnitPrice*OrderQuantity)-UnitPriceDiscountPct),2) AS TotalSales FROM Sales 
GROUP BY Quarter 
ORDER BY Quarter;

-- question 11
SELECT Year, ROUND(SUM((UnitPrice*OrderQuantity)-UnitPriceDiscountPct),2) AS TotalSales,
ROUND(SUM(ProductStandardCost*OrderQuantity),2) AS ProductionCost FROM sales
GROUP BY Year;

-- question 12
-- Year with highest sales
SELECT Year AS sale_year, ROUND(SUM((UnitPrice*OrderQuantity)-UnitPriceDiscountPct),2) AS Total_sales
FROM Sales
GROUP BY Year
ORDER BY Total_sales DESC
LIMIT 1;

-- Total Sales
SELECT ROUND(SUM((UnitPrice*OrderQuantity)-UnitPriceDiscountPct),2) AS Total_Sales
FROM Sales;

-- CGOS
SELECT ROUND(SUM(ProductStandardCost*OrderQuantity),2) AS Total_CGOS
FROM Sales;

-- Total Profit
SELECT ROUND(SUM((UnitPrice*OrderQuantity)-UnitPriceDiscountPct)-SUM(ProductStandardCost*OrderQuantity),2) AS Total_Profit
FROM Sales;

-- %Profit Margin
SELECT CONCAT(
ROUND(((SUM((OrderQuantity*UnitPrice)-UnitPriceDiscountPct)-SUM(OrderQuantity*ProductStandardCost))/SUM((OrderQuantity*UnitPrice)-UnitPriceDiscountPct))*100,
2),
"%") AS Profit_Margin
FROM Sales;

-- Total Order
SELECT COUNT(CustomerKey) AS Total_Orders FROM Sales;

