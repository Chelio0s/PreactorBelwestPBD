CREATE VIEW [InputData].[VI_ArticlesWithoutMaterials]
AS  
SELECT 
IdArticle
,Title 
FROM [InputData].[Article]
WHERE IdArticle NOT IN
(
  SELECT DISTINCT ART.IdArticle
  FROM [InputData].[Specifications]			AS spec  
  INNER JOIN [InputData].[Operations]		AS op	ON op.IdOperation = spec.OperationId
  INNER JOIN [InputData].[Rout]				AS r	ON r.IdRout = op.RoutId
  INNER JOIN [InputData].[SemiProducts]		AS sp	ON sp.IdSemiProduct = r.SemiProductId
  INNER JOIN [InputData].[Nomenclature]		AS nom	ON nom.IdNomenclature = sp.NomenclatureID
  INNER JOIN [InputData].[Article]			AS art	ON art.IdArticle = nom.ArticleId
)      