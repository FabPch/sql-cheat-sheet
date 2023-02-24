SELECT SubcategoryName = A.[Name]
  , Products = 
    STUFF(
	  (
	    SELECT ';' + B.[Name]
	    FROM Production.Product B
	    WHERE A.ProductSubcategoryID = B.ProductSubcategoryID
		  AND B.ListPrice > 50
	    FOR XML PATH ('')
	  )
	  , 1, 1, '')
FROM Production.ProductSubcategory A