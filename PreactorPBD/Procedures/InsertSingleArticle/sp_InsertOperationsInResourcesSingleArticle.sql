CREATE PROCEDURE [InputData].[sp_InsertOperationsInResourcesSingleArticle]
	@article nvarchar(99)
AS
	 DELETE [InputData].[OperationInResource] 
     FROM [InputData].[OperationInResource]                  AS useop
     INNER JOIN [InputData].[Operations]                     AS Oper     ON Oper.IdOperation = useop.OperationId
     INNER JOIN [InputData].[Rout]					         AS R		ON R.IdRout = Oper.RoutId
     INNER JOIN [InputData].[VI_SemiProductsWithArticles]	 AS VISEMI	ON VISEMI.IdSemiProduct = R.SemiProductId
     WHERE VISEMI.TitleArticle = @article

INSERT INTO [InputData].[OperationInResource]
           ([OperationId]
           ,[ResourceId]
           ,[OperateTime])
  SELECT DISTINCT 
      VI.IdOperation
	  ,IdResource
      ,[NORMATIME]
  FROM [InputData].[VI_OperationsFromSDBWithConcreetResources]	 AS VI
  INNER JOIN [InputData].[Operations]                     AS Oper     ON Oper.IdOperation = VI.IdOperation
  INNER JOIN [InputData].[Rout]					          AS R		ON R.IdRout = Oper.RoutId
  INNER JOIN [InputData].[VI_SemiProductsWithArticles]	  AS VISEMI	ON VISEMI.IdSemiProduct = R.SemiProductId
  WHERE VISEMI.TitleArticle = @article
RETURN 0
