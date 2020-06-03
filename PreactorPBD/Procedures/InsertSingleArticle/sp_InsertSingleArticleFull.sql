CREATE PROCEDURE [InputData].[sp_InsertSingleArticleFull]
	@art nvarchar(99)
AS
print 'sp_InsertToArticle'
SET STATISTICS TIME ON  
    EXEC [InputData].[sp_InsertToArticle]                               @article = @art
SET STATISTICS TIME OFF 
print 'sp_CreateNomenclatureForSingleArticle'
SET STATISTICS TIME ON  
    EXEC [InputData].[sp_CreateNomenclatureForSingleArticle]            @article = @art
    SET STATISTICS TIME OFF 
print 'sp_CreateNomenclatureForSingleArticle'
SET STATISTICS TIME ON  
    EXEC [InputData].[sp_CreateSemiProductFroSingleArticle]             @article = @art
    SET STATISTICS TIME OFF 
print 'sp_EntriSemiProductForArticle'
SET STATISTICS TIME ON  
    EXEC [InputData].[sp_EntriSemiProductForArticle]                    @article = @art
    SET STATISTICS TIME OFF 
print 'sp_CreateCutters'
SET STATISTICS TIME ON  
    EXEC [InputData].[sp_CreateCutters]
    SET STATISTICS TIME OFF 
print 'sp_CreateSecondaryConstraint_Cutters'
SET STATISTICS TIME ON  
    EXEC [InputData].[sp_CreateSecondaryConstraint_Cutters]
    SET STATISTICS TIME OFF 
print 'sp_CreateConstraintCalendar_Cutters'
SET STATISTICS TIME ON  
    EXEC [InputData].[sp_CreateConstraintCalendar_Cutters]
    SET STATISTICS TIME OFF 
print 'sp_FillTempOperationTableSingleArticle'
SET STATISTICS TIME ON  
    EXEC [InputData].[sp_FillTempOperationTableSingleArticle]           @article = @art
    SET STATISTICS TIME OFF 
print 'sp_DeleteInappropriateSemiProducts'
SET STATISTICS TIME ON  
    EXEC [InputData].[sp_DeleteInappropriateSemiProducts]               -- Удаляем пустые ПФ
    SET STATISTICS TIME OFF 
print 'sp_InsertCombinesSingleArticle'
SET STATISTICS TIME ON  
    EXEC [InputData].[sp_InsertCombinesSingleArticle]                   @article = @art
    SET STATISTICS TIME OFF 
print 'sp_InsertRoutesSingleArticle'
SET STATISTICS TIME ON  
    EXEC [InputData].[sp_InsertRoutesSingleArticle]                     @article = @art
    SET STATISTICS TIME OFF 
print 'sp_InsertOperationsSingleArticle]'
SET STATISTICS TIME ON  
    EXEC [InputData].[sp_InsertOperationsSingleArticle]                 @article = @art
    SET STATISTICS TIME OFF 
print 'sp_DeleteInappropriateRoutes'
SET STATISTICS TIME ON  
    EXEC [InputData].[sp_DeleteInappropriateRoutes]                     -- Удаляем пустые ТМ
    SET STATISTICS TIME OFF 
print 'sp_InsertConstraintsOnOperationsSingleArticle'
SET STATISTICS TIME ON  
    EXEC [InputData].[sp_InsertConstraintsOnOperationsSingleArticle]    @article = @art
    SET STATISTICS TIME OFF 
print 'sp_InsertOperationsInResourcesSingleArticle'
SET STATISTICS TIME ON  
    EXEC [InputData].[sp_InsertOperationsInResourcesSingleArticle]      @article = @art
    SET STATISTICS TIME OFF 
print 'sp_FillTempMaterialsSingleArticle'
SET STATISTICS TIME ON  
    EXEC [InputData].[sp_FillTempMaterialsSingleArticle]                @article = @art
    SET STATISTICS TIME OFF 
print 'sp_InsertMaterials'
SET STATISTICS TIME ON  
    EXEC [InputData].[sp_InsertMaterials]
    SET STATISTICS TIME OFF 
print 'sp_InsertSpecificationsSingleArticle'
SET STATISTICS TIME ON  
    EXEC [InputData].[sp_InsertSpecificationsSingleArticle]             @article = @art
    SET STATISTICS TIME OFF 
RETURN 0
 