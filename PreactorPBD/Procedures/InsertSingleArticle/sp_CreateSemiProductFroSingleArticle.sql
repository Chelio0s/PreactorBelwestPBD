CREATE PROCEDURE [InputData].[sp_CreateSemiProductFroSingleArticle]
	@article nvarchar(99)
AS
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
