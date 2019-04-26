--Выборка данных по операциям для каждой номенклатуры
--Выборка напрямую с RKV - медленная
CREATE VIEW [InputData].[VI_OperationsRKVOnSemiProducts_SLOW]
AS
SELECT
	   IdNomenclature
      ,[Size]
	  ,semiprod.IdSemiProduct
	  ,semiprod.Title
	  ,op.KPO
	  ,area.Code
	  ,KTOPN
	  ,NTOP as [NTOP]
	  ,PONEOB
	  ,NORMATIME
	  ,KOB
	  ,MOB
	  ,KPROF
	  ,[InputData].[udf_GetTitleOperation] (KTOPN, NTOP) as [PreactorOperation]
	  ,seq.SimpleProductId
	  ,seq.OperOrder
  FROM [InputData].[Nomenclature] as nom
  INNER JOIN [InputData].[Article] as inpart ON nom.ArticleId = inpart.IdArticle
  OUTER APPLY [InputData].[udf_GetOperationsArticleFromRKV](inpart.Title) AS OP
  LEFT JOIN [InputData].[Areas] as area ON area.KPO COLLATE Cyrillic_General_CI_AS = op.KPO
  LEFT JOIN [SupportData].[SequenceOperations] as seq ON seq.KTOP = KTOPN
  LEFT JOIN [InputData].[SemiProducts] as semiprod ON semiprod.NomenclatureID  = IdNomenclature and semiprod.SimpleProductId = seq.SimpleProductId