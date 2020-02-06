CREATE PROCEDURE [InputData].[sp_FillTempOperationTableSingleArticle]
	@article nvarchar(99)
AS
	DELETE FROM [SupportData].[TempOperations]
	WHERE Article = @article
	INSERT [SupportData].[TempOperations] 
	SELECT  
	[IdNomenclature]
	  ,REL
	  ,op.[MOD] as Model
      ,inpart.Title as Article
      ,[Number_] as [Nomenclature]
      ,[Size]
	  ,op.KPO
	  ,area.Code
	  ,KTOPN
	  ,NTOP as [NTOP]
	  ,PONEOB
	  ,NORMATIME
	  ,KOB
	  ,MOB
	  ,KPROF
	  ,RD
	  ,[InputData].[udf_GetTitleOperation] (KTOPN, NTOP) as [PreactorOperation]
	  ,NPP
	  ,GETDATE()
	  ,KOLD  -- count details
	  ,KOLN  -- count nastills
  FROM [InputData].[Nomenclature] as nom
  INNER JOIN [InputData].[Article] as inpart ON nom.ArticleId = inpart.IdArticle
  OUTER APPLY [InputData].[udf_GetOperationsArticleFromRKV](inpart.Title) AS OP
  LEFT JOIN [InputData].[Areas] as area ON area.KPO COLLATE Cyrillic_General_CI_AS = op.KPO
  WHERE code is not null
  AND inpart.Title = @article
RETURN 0
