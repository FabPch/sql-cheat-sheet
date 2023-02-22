SELECT
       A.PurchaseOrderID,
	   A.OrderDate,
	   A.TotalDue

FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader A

WHERE EXISTS (
	SELECT
	1
	FROM AdventureWorks2019.Purchasing.PurchaseOrderDetail B
	WHERE A.PurchaseOrderID = B.PurchaseOrderID
		AND B.RejectedQty > 5
)

ORDER BY 1


IF OBJECT_ID('tempdb..#TMP') IS NOT NULL
    DROP TABLE #TMP

CREATE TABLE #TMP
(
    PurchaseOrderID INT
	, OrderDate DATETIME
	, TotalDue MONEY
	, RejectedQty DECIMAL(8, 2)
)

INSERT INTO #TMP
(
    PurchaseOrderID,
    OrderDate,
    TotalDue
)
SELECT
       PurchaseOrderID,
	   OrderDate,
	   TotalDue
FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader

UPDATE #TMP SET RejectedQty = B.RejectedQty
FROM #TMP
JOIN AdventureWorks2019.Purchasing.PurchaseOrderDetail B
    ON #TMP.PurchaseOrderID = B.PurchaseOrderID
WHERE B.RejectedQty > 5

SELECT PurchaseOrderID
    , OrderDate
	, TotalDue
	, RejectedQty
FROM #TMP
WHERE RejectedQty > 5
ORDER BY 1

DROP TABLE #TMP
