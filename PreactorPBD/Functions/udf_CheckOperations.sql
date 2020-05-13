CREATE FUNCTION [InputData].[udf_CheckOperations]
(
)
RETURNS @returntable TABLE
(
	CheckValue nvarchar(200),
	IsOK bit,
	Description_ nvarchar(max)
)
AS
BEGIN
	

	WITH CTE 
	AS (SELECT * FROM [InputData].[VI_OperationsFromRKV])


	INSERT INTO @returntable
	SELECT 'Проверка на пустые операции для планируемых артикулов'
	,CASE WHEN EXISTS( SELECT * FROM CTE WHERE LTRIM(RTRIM(KTOPN)) = '') 
		THEN 0 ELSE 1 END
	,CASE WHEN EXISTS( SELECT * FROM CTE WHERE LTRIM(RTRIM(KTOPN)) = '') 
		THEN 'Артикула: '+(SELECT [InputData].[ctvf_ConcatWithoutDublicates](ART)
							 FROM CTE  
						     WHERE  LTRIM(RTRIM(KTOPN))= '') ELSE '' END as val 
	 UNION
	 SELECT 'Проверка на наличие норм времени в операциях'
	 ,CASE WHEN EXISTS(SELECT * FROM CTE WHERE NORMA is null or NORMA = 0) THEN 0 ELSE 1 END
	 ,CASE WHEN EXISTS(SELECT * FROM CTE  WHERE NORMA is null or NORMA = 0) 
		THEN 'Артикула: '+(SELECT [InputData].[ctvf_ConcatWithoutDublicates](ART)
							 FROM CTE   WHERE NORMA is null or NORMA = 0) ELSE '' END as val 


	 RETURN
END
