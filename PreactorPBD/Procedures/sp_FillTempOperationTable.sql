CREATE PROCEDURE [InputData].[sp_FillTempOperationTable]
	
AS
BEGIN TRANSACTION  
    TRUNCATE TABLE [SupportData].[TempOperations] 
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
	  ,GETDATE()
  FROM [InputData].[Nomenclature] as nom
  INNER JOIN [InputData].[Article] as inpart ON nom.ArticleId = inpart.IdArticle
  OUTER APPLY [InputData].[udf_GetOperationsArticleFromRKV](inpart.Title) AS OP
  LEFT JOIN [InputData].[Areas] as area ON area.KPO COLLATE Cyrillic_General_CI_AS = op.KPO
IF @@ERROR = 0
COMMIT TRANSACTION
RETURN 0