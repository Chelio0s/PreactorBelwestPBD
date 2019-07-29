CREATE VIEW [InputData].[VI_SelectSemiProductWithArticle]
	AS SELECT 
	IdSemiProduct
	,sp.Title
	,NomenclatureID
	,SimpleProductId
	,Size
	,CountPersent
	,art.Title as Article
FROM [InputData].[SemiProducts] as sp
INNER JOIN [InputData].[Nomenclature] as nom ON nom.IdNomenclature = sp.NomenclatureID
INNER JOIN [InputData].[Article] as art ON art.IdArticle = nom.ArticleId