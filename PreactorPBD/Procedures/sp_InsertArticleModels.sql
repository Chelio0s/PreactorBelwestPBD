CREATE PROCEDURE [SupportData].[sp_InsertArticleModels]
AS
TRUNCATE TABLE [SupportData].[ArticleModels]
INSERT INTO [SupportData].[ArticleModels]
	SELECT  
      [Title]															AS Art
	  ,[InputData].[udf_GetModelForArticle]([Title])					AS Model
      ,[IdArticle]
  FROM [InputData].[Article]
RETURN 0
