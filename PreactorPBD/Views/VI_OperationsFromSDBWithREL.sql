CREATE VIEW [InputData].[VI_OperationsFromSDBWithREL]
	AS SELECT [IdOperation]
      ,oper.[Title]															AS OperTitle
      ,[NumberOp]
      ,[RoutId]
      ,[ProfessionId]
      ,[TypeTimeId]
      ,oper.[CategoryOperation]
      ,oper.[Code]
	  ,[InputData].[udf_GetCorrectKTOPForArea] (operktop.KTOP, rout.AreaId) AS KTOP
	  ,operktop.REL
	  ,rout.SemiProductId
	  ,art.IdArticle
	  ,art.Title															AS ArtTitle
	  ,nom.Size
  FROM [InputData].[Operations]									AS oper 
  LEFT JOIN  [InputData].[OperationWithKTOP]					AS operktop ON oper.IdOperation = operktop.[OperationId]
  INNER JOIN [InputData].[Rout]									AS rout		ON rout.IdRout = oper.RoutId
  INNER JOIN [InputData].[SemiProducts]							AS sp		ON sp.IdSemiProduct = rout.SemiProductId
  INNER JOIN [InputData].[Nomenclature]							AS nom		ON nom.IdNomenclature = sp.NomenclatureID
  INNER JOIN [InputData].[Article]								AS art		ON art.IdArticle = nom.ArticleId
