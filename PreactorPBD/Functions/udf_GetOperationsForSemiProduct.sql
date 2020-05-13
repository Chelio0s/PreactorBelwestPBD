--Получаем операции для ПФ

CREATE FUNCTION [InputData].[udf_GetOperationsForSemiProduct]
(
	@IdSemiProduct int
)

RETURNS @returntable TABLE
(
	[IdSemiProduct]			int 
      ,[KTOPN]				int
      ,[NTOP]				nvarchar(99)
      ,[PONEOB]				int
      ,[NORMATIME]			decimal(6,2)
      ,[KOB]				int
      ,[SimpleProductId]	int
	  ,Code					nvarchar(4)
)
AS
BEGIN
	INSERT @returntable
	SELECT 
      [IdSemiProduct]
      ,[KTOPN]
      ,[NTOP]
      ,[PONEOB]
      ,[NORMATIME]
      ,[KOB]
      ,[SimpleProductId]
	  ,Code
  FROM [InputData]. [VI_OperationsWithSemiProducts_FAST]
  WHERE IdSemiProduct = @IdSemiProduct 
  ORDER BY NPP
	RETURN
END
