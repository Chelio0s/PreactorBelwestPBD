CREATE PROCEDURE [InputData].[sp_InsertToArticle]
	@article nvarchar(99)
AS
IF EXISTS(SELECT TOP(1) IdArticle FROM [InputData].Article WHERE Title = @article)
	RETURN 1
ELSE
	BEGIN
	INSERT INTO [InputData].[Article]
           ([Title])
     VALUES
           (@article)
     END
	 RETURN 0