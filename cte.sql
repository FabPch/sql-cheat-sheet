-- Nested queries
SELECT
  B_SALES.MonthDate
  , [TotalSales] = B_SALES.TotalSales
  , [TotalPurchases] = A_PURCHASE.TotalPuchases
FROM
(
  SELECT 
    MonthDate
    , TotalPuchases = SUM(TotalDue)
  FROM (
    SELECT 
      OrderDate
      , TotalDue
      , MonthDate = DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
      , TopPriceRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) ORDER BY TotalDue DESC)
    FROM Purchasing.PurchaseOrderHeader
  ) AS A
  WHERE TopPriceRank > 10
  GROUP BY MonthDate
) AS A_PURCHASE

JOIN (
  SELECT 
    MonthDate
    , TotalSales = SUM(TotalDue)
  FROM (
    SELECT 
      OrderDate
      , TotalDue
      , MonthDate = DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
      , TopPriceRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) ORDER BY TotalDue DESC)
    FROM Sales.SalesOrderHeader
  ) AS A
  WHERE TopPriceRank > 10
  GROUP BY MonthDate
) AS B_SALES
ON A_PURCHASE.MonthDate = B_SALES.MonthDate
ORDER BY 1;

-----------------
-- Using CTE

WITH A AS (
    SELECT 
      OrderDate
      , TotalDue
      , MonthDate = DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
      , TopPriceRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) ORDER BY TotalDue DESC)
    FROM Purchasing.PurchaseOrderHeader
)

, B AS (
SELECT
    MonthDate
	, TotalPurchases = SUM(TotalDue)
FROM A
WHERE TopPriceRank > 10
GROUP BY MonthDate
)

, C AS (
SELECT 
      OrderDate
      , TotalDue
      , MonthDate = DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1)
      , TopPriceRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate), 1) ORDER BY TotalDue DESC)
    FROM Sales.SalesOrderHeader
)

, D AS (
SELECT
    MonthDate
	, TotalSales = SUM(TotalDue)
FROM C
WHERE TopPriceRank > 10
GROUP BY MonthDate
)

SELECT
    B.MonthDate
	, D.TotalSales
	, B.TotalPurchases
FROM B
JOIN D ON B.MonthDate = D.MonthDate
ORDER BY 1
