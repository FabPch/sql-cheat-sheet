WITH OddNumberSeries AS
(
SELECT 1 AS MyOddNumber

UNION ALL

SELECT MyOddNumber + 2
FROM OddNumberSeries
WHERE MyOddNumber < 99
)

SELECT MyOddNumber
FROM OddNumberSeries;

---

WITH DateSeries AS
(
SELECT CAST('01/01/2020' AS DATE) AS MyDate

UNION ALL

SELECT DATEADD(MONTH, 1, MyDate)
FROM DateSeries
WHERE MyDate < CAST('01/12/2029' AS DATE)
)

SELECT MyDate
FROM DateSeries
OPTION(MAXRECURSION 200)