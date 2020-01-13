CREATE PROCEDURE [InputData].[sp_InsertSingleArticleFull]
	@art nvarchar(99)
AS
	EXEC [InputData].[sp_InsertToArticle]						@article = @art
	EXEC [InputData].[sp_CreateNomenclatureForSingleArticle]	@article = @art
	EXEC [InputData].[sp_CreateSemiProductFroSingleArticle]		@article = @art
	EXEC [InputData].[sp_EntriSemiProductForArticle]			@article = @art
RETURN 0
