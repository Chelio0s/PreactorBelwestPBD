CREATE PROCEDURE [InputData].[sp_InsertSingleArticleFull]
	@art nvarchar(99)
AS
	EXEC [InputData].[sp_InsertToArticle]								@article = @art
	EXEC [InputData].[sp_CreateNomenclatureForSingleArticle]			@article = @art
	EXEC [InputData].[sp_CreateSemiProductFroSingleArticle]				@article = @art
	EXEC [InputData].[sp_EntriSemiProductForArticle]					@article = @art
	EXEC [InputData].[sp_CreateCutters]
	EXEC [InputData].[sp_CreateSecondaryConstraint_Cutters]
	EXEC [InputData].[sp_CreateConstraintCalendar_Cutters]
	EXEC [InputData].[sp_InsertRoutesSingleArticle]						@article = @art
	EXEC [InputData].[sp_FillTempOperationTableSingleArticle]			@article = @art
	EXEC [InputData].[sp_DeleteInappropriateSemiProducts]				-- Удаляем пустые ПФ
	EXEC [InputData].[sp_InsertOperationsSingleArticle]					@article = @art
	EXEC [InputData].[sp_DeleteInappropriateRoutes]						-- Удаляем пустые ТМ
	EXEC [InputData].[sp_InsertConstraintsOnOperationsSingleArticle]	@article = @art
	EXEC [InputData].[sp_InsertOperationsInResourcesSingleArticle]		@article = @art
	EXEC [InputData].[sp_FillTempMaterialsSingleArticle]				@article = @art
	EXEC [InputData].[sp_InsertMaterials]
	EXEC [InputData].[sp_InsertSpecificationsSingleArticle]				@article = @art
RETURN 0
