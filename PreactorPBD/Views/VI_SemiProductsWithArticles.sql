CREATE VIEW [InputData].[VI_SemiProductsWithArticles]
	AS 
	SELECT 
		IdSemiProduct
		,sp.Title as SemiProdTitle
		,NomenclatureID
		,SimpleProductId
		,ArticleId
		,Number_ as NomenclatureNumber
		,Size
		,CountPersent
		,art.Title as TitleArticle
		,MaxCountUse
		,art.IsComplex
		,art.IsCutters
		,art.IsAutomat
  FROM [InputData].[SemiProducts] as sp 
  INNER JOIN [InputData].[Nomenclature] as nom ON sp.NomenclatureID = nom.IdNomenclature
  INNER JOIN [InputData].[Article] as art ON art.IdArticle = nom.ArticleId