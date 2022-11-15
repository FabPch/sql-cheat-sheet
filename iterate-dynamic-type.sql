/********** ITERATE OVER STRING_SPLIT **********/
DECLARE @col_names VARCHAR(50) = 'hey;ha;haio';
SELECT Value
    , RANK() OVER(ORDER BY value) AS Rank
INTO #TMP_COL_NAMES
FROM STRING_SPLIT(@col_names, ';');

DECLARE @rank_id INT
SELECT @rank_id = MIN(Rank) FROM #TMP_COL_NAMES

WHILE @rank_id is not null
BEGIN
    SELECT * FROM #TMP_COL_NAMES WHERE Rank = @rank_id
    SELECT @rank_id = MIN(Rank) FROM #TMP_COL_NAMES WHERE Rank > @rank_id
END

DROP TABLE #TMP_COL_NAMES

/********** ITERATE OVER STRING_SPLIT **********/
CREATE TABLE HELLO
(
    first_name VARCHAR(25)
	, last_name VARCHAR(25)
)

INSERT INTO HELLO (first_name, last_name) VALUES ('Fabien', 'Pichon')
INSERT INTO HELLO (first_name, last_name) VALUES ('Fabien', 'Pichon')
INSERT INTO HELLO (first_name, last_name) VALUES ('Alex', 'Costrachevici')
INSERT INTO HELLO (first_name, last_name) VALUES ('Elo', 'Pichon')
INSERT INTO HELLO (first_name, last_name) VALUES ('Louloute', 'Pichon')

SELECT * FROM HELLO;

-- DYNAMIC --
DECLARE @col_n VARCHAR(20) = 'first_name';
DECLARE @sqlText nvarchar(1000); 

SET @sqlText = 
N'DECLARE @col_n_inside VARCHAR(100) = ''' + @col_n + ''';'
+ 'WITH CTE_RANKED AS (SELECT ' + @col_n + ', Rank = ROW_NUMBER() OVER(ORDER BY ' + @col_n + ') FROM HELLO)'
+ 'SELECT @col_n_inside + CAST(Rank AS VARCHAR(10)) FROM CTE_RANKED'
/* Replace SELECT by UPDATE statement. */

EXEC (@sqlText);

-- NORMAL --
WITH CTE_RANKED AS
(
    SELECT first_name
	    , Rank = ROW_NUMBER() OVER(ORDER BY first_name)
	FROM HELLO
)

SELECT @col_n + CAST(Rank AS VARCHAR(10))
FROM CTE_RANKED

/********** CONDITION ON COL TYPE **********/
DECLARE @col_n3 VARCHAR(20) = 'first_name';
DECLARE @col_type VARCHAR(100)
SELECT @col_type = DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE 
     TABLE_SCHEMA = 'dbo' AND
     TABLE_NAME   = 'HELLO' AND 
     COLUMN_NAME  = @col_n3
