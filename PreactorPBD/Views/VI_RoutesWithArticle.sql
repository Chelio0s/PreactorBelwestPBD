CREATE VIEW [InputData].[VI_RoutesWithArticle]
	AS SELECT 
	IdRout
	,Title as TitleRout
	,SemiProductId
	,SemiProdTitle
	,SimpleProductId
	,TitleArticle
	,Size
	,AreaId
  FROM  [InputData].[Rout] as r
  INNER JOIN [InputData].[VI_SemiProductsWithArticles] as a ON a.IdSemiProduct = r.SemiProductId
