CREATE PROCEDURE [InputData].[sp_CreateNomenclatureForSingleArticle]
	@article nvarchar(99)
AS
	DELETE Nomenclature FROM [InputData].[Nomenclature]		as Nomenclature
	INNER JOIN [InputData].[Article]						as Article		ON Article.IdArticle = Nomenclature.ArticleId
	WHERE Article.Title = @article

	INSERT INTO [InputData].[Nomenclature]
           ([ArticleId]
           ,[Number_]
           ,[Size]
           ,[CountPersent])
	SELECT  Nomenclature.[IdArticle]
      ,[TitleNomenclature]
      ,[SIZE]
      ,[Percents]
  FROM [InputData].[VI_PercentageNomenclature] as Nomenclature
  INNER JOIN [InputData].[Article]			   as Article		ON Article.IdArticle = Nomenclature.IdArticle
  WHERE size is not null and sumpercents = 100 AND Article.Title = @article
RETURN 0