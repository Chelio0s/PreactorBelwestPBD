CREATE PROCEDURE [InputData].[sp_CreateSemiProductFroSingleArticle]
	@article nvarchar(99)
AS
DELETE sp FROM [InputData].[SemiProducts] AS sp
  INNER JOIN [InputData].[Nomenclature] AS n ON sp.NomenclatureID = n.IdNomenclature
  INNER JOIN [InputData].[Article] AS a ON n.ArticleId = a.IdArticle
  WHERE a.Title = @article								  
		INSERT INTO [InputData].[SemiProducts]
           ([Title]
           ,[NomenclatureID]
           ,[SimpleProductId])
SELECT	SP.Title+':'+Number_ 
		, IdNomenclature
		, IdSimpleProduct
  FROM [InputData].[Nomenclature]				AS Nomenclature
  CROSS JOIN [SupportData].[SimpleProduct]		AS SP
  INNER JOIN [InputData].[Article]				AS Article		ON Article.IdArticle = Nomenclature.ArticleId
  WHERE Article.Title = @article
RETURN 0
