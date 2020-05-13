CREATE FUNCTION [InputData].[udf_GetOperationsForArticle] 
(
	@Article nvarchar(99),
	@SimpleProductId int = null
)

RETURNS @returntable TABLE
(
	   Article				nvarchar(99) 
      ,[KTOPN]				int
      ,[NTOP]				nvarchar(99)
      ,[PONEOB]				int
      ,[NORMATIME]			decimal(6,2)
      ,[KOB]				int
      ,[SimpleProductId]	int
	  ,NPP					int
)
AS
BEGIN
	IF @SimpleProductId is null
	BEGIN
		INSERT @returntable
		SELECT 
		  Article
		  ,[KTOPN]
		  ,[NTOP]
		  ,[PONEOB]
		  ,[NORMATIME]
		  ,[KOB]
		  ,[SimpleProductId]
		  ,NPP
	  FROM [InputData]. [VI_OperationsWithSemiProducts_FAST]
	  WHERE Article = @Article 
	  ORDER BY NPP
	END
		IF @SimpleProductId is not null
	BEGIN
		INSERT @returntable
		SELECT DISTINCT
		  Article
		  ,[KTOPN]
		  ,[NTOP]
		  ,[PONEOB]
		  ,[NORMATIME]
		  ,[KOB]
		  ,[SimpleProductId]
		  ,NPP
	  FROM [InputData]. [VI_OperationsWithSemiProducts_FAST]
	  WHERE Article = @Article and [SimpleProductId] = @SimpleProductId
	  ORDER BY NPP
	END
	RETURN
END
