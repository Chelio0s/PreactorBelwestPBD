CREATE VIEW [InputData].[VI_OperationsRKV_Preactor]
	AS 
	SELECT  [IdNomenclature]
	  ,op.[MOD] as модель
      ,inpart.Title as Артикул
      ,[Number_] as [Номенклатура]
      ,[Size]
	  ,op.KPO
	  ,KTOPN
	  ,NTOP as [Операция RKV]
	  ,PONEOB
	  ,NORMATIME
	  ,KOB
	  ,MOB
	  ,KPROF
	  ,[InputData].[udf_GetTitleOperation] (KTOPN, NTOP) as [Опер. пеактор]
  FROM [InputData].[Nomenclature] as nom
  INNER JOIN [InputData].[Article] as inpart ON nom.ArticleId = inpart.IdArticle
  OUTER APPLY [InputData].[udf_GetOperationsArticleFromRKV](inpart.Title) AS OP