CREATE PROCEDURE [SupportData].[sp_InsertArticleModels]
AS
TRUNCATE TABLE [SupportData].[ArticleModels]
INSERT INTO [SupportData].[ArticleModels]
SELECT
      [Title]                                                            AS Art
      ,[MOD]
      ,[IdArticle]
  FROM [InputData].[Article] AS a
  INNER JOIN [$(RKV)].[$(RKV_SCAL)].[dbo].[F160013] AS rkv ON rkv.ART = a.Title
RETURN 0
