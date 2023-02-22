SELECT PurchaseOrderID
  , VendorID
  , OrderDate
  , TotalDue
  , NonRejectedItems  = 
  (
    SELECT COUNT(1)
    FROM Purchasing.PurchaseOrderDetail d
    WHERE h.PurchaseOrderID = d.PurchaseOrderID AND d.RejectedQty = 0
  )
  , MostExpensiveItem = 
  (
    SELECT MAX(UnitPrice)
	FROM Purchasing.PurchaseOrderDetail d2
	WHERE d2.PurchaseOrderID = h.PurchaseOrderID
  )
FROM Purchasing.PurchaseOrderHeader h
