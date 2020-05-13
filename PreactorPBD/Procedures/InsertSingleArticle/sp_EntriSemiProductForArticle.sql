CREATE PROCEDURE [InputData].[sp_EntriSemiProductForArticle]
	@article nvarchar(99)
AS
	--Delete all entrys if they were
	DELETE ESP FROM [InputData].[EntrySemiProduct]			AS ESP		 		
	INNER JOIN [InputData].[VI_SemiProductsWithArticles]	AS VI	ON VI.IdSemiProduct = ESP.IdSemiProduct 
																	OR VI.IdSemiProduct = ESP.IdSemiProductChild
	WHERE VI.TitleArticle = @article
	--Insert new entrys for article's semi products
	INSERT INTO [InputData].[EntrySemiProduct]
           ([IdSemiProduct]
           ,[IdSemiProductChild])
	SELECT semi.IdSemiProduct
	  ,spp.IdSemiProduct
  FROM  [InputData].[SemiProducts]						AS semi
  INNER JOIN [SupportData].[EntrySimpleProduct]			AS simplep	ON semi.SimpleProductId = simplep.SimpleProductId
  INNER JOIN [InputData].[SemiProducts]					AS spp		ON simplep.SimpleProductIdChild= spp.SimpleProductId 
																	AND spp.NomenclatureID = semi.NomenclatureID
  INNER JOIN [InputData].[VI_SemiProductsWithArticles]	AS VI		ON VI.IdSemiProduct = semi.IdSemiProduct 
  INNER JOIN [InputData].[VI_SemiProductsWithArticles]	AS VI1		ON VI1.IdSemiProduct = spp.IdSemiProduct 
  WHERE VI.TitleArticle = @article OR VI1.TitleArticle  = @article
RETURN 0
