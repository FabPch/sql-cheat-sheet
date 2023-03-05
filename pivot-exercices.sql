SELECT
*
FROM
  (
  SELECT
    JobTitle
    , VacationHours
	, [Employee Gender] = Gender
  FROM HumanResources.Employee
  ) E
PIVOT(
  AVG(VacationHours)
  FOR JobTitle IN ([Sales Representative], [Buyer], [Janitor])
) P
