CREATE PROCEDURE [InputData].[sp_InsertSingleArticleFull]
	@art nvarchar(99)
AS
DECLARE @timeStart datetime, @diff int
SET @timeStart = GETDATE()
PRINT 'sp_InsertToArticle'


    EXEC [InputData].[sp_InsertToArticle]                               @article = @art
    SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
    EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_InsertToArticle]',
									   @timeMs = @diff
    SET @timeStart = GETDATE()

PRINT 'sp_CreateNomenclatureForSingleArticle'

 
    EXEC [InputData].[sp_CreateNomenclatureForSingleArticle]            @article = @art
    SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
    EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_CreateNomenclatureForSingleArticle]',
									   @timeMs = @diff
    SET @timeStart = GETDATE()

PRINT 'sp_CreateNomenclatureForSingleArticle'

 
    EXEC [InputData].[sp_CreateSemiProductFroSingleArticle]             @article = @art
    SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
    EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_CreateSemiProductFroSingleArticle]',
									   @timeMs = @diff
    SET @timeStart = GETDATE()

PRINT 'sp_EntriSemiProductForArticle'


    EXEC [InputData].[sp_EntriSemiProductForArticle]                    @article = @art
    SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
    EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_EntriSemiProductForArticle]',
									   @timeMs = @diff
    SET @timeStart = GETDATE()

PRINT 'sp_CreateCutters'
  
    EXEC [InputData].[sp_CreateCutters]
    SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
    EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_CreateCutters]',
									   @timeMs = @diff
    SET @timeStart = GETDATE()

PRINT 'sp_CreateSecondaryConstraint_Cutters'


    EXEC [InputData].[sp_CreateSecondaryConstraint_Cutters]
    SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
    EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_CreateSecondaryConstraint_Cutters]',
									   @timeMs = @diff
    SET @timeStart = GETDATE()

PRINT 'sp_CreateConstraintCalendar_Cutters'


    EXEC [InputData].[sp_CreateConstraintCalendar_Cutters]
    SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
    EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_CreateConstraintCalendar_Cutters]',
									   @timeMs = @diff
    SET @timeStart = GETDATE()

PRINT 'sp_InsertCombinesSingleArticle'


    EXEC [InputData].[sp_InsertCombinesSingleArticle]                   @article = @art
    SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
    EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_InsertCombinesSingleArticle]',
									   @timeMs = @diff
    SET @timeStart = GETDATE()


PRINT 'sp_FillTempOperationTableSingleArticle'

  
    EXEC [InputData].[sp_FillTempOperationTableSingleArticle]           @article = @art
    SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
    EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_FillTempOperationTableSingleArticle]',
									   @timeMs = @diff
    SET @timeStart = GETDATE()

PRINT 'sp_DeleteInappropriateSemiProducts'


    EXEC [InputData].[sp_DeleteInappropriateSemiProducts]               -- Удаляем пустые ПФ
    SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
    EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_DeleteInappropriateSemiProducts]',
									   @timeMs = @diff
    SET @timeStart = GETDATE()


PRINT 'sp_InsertRoutesSingleArticle'


    EXEC [InputData].[sp_InsertRoutesSingleArticle]                     @article = @art
    SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
    EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_InsertRoutesSingleArticle]',
									   @timeMs = @diff
    SET @timeStart = GETDATE() 

PRINT 'sp_InsertOperationsSingleArticle]'


    EXEC [InputData].[sp_InsertOperationsSingleArticle]                 @article = @art
    SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
    EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_InsertOperationsSingleArticle]',
									   @timeMs = @diff
    SET @timeStart = GETDATE() 
 

PRINT 'sp_DeleteInappropriateRoutes'

 
    EXEC [InputData].[sp_DeleteInappropriateRoutes]                     -- Удаляем пустые ТМ
    SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
    EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_DeleteInappropriateRoutes]',
									   @timeMs = @diff
    SET @timeStart = GETDATE()  

PRINT 'sp_InsertConstraintsOnOperationsSingleArticle'

  
    EXEC [InputData].[sp_InsertConstraintsOnOperationsSingleArticle]    @article = @art
    SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
    EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_InsertConstraintsOnOperationsSingleArticle]',
									   @timeMs = @diff
    SET @timeStart = GETDATE()  

PRINT 'sp_InsertOperationsInResourcesSingleArticle'

 
    EXEC [InputData].[sp_InsertOperationsInResourcesSingleArticle]      @article = @art
    SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
    EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_InsertOperationsInResourcesSingleArticle]',
									   @timeMs = @diff
    SET @timeStart = GETDATE() 

PRINT 'sp_FillTempMaterialsSingleArticle'

 
    EXEC [InputData].[sp_FillTempMaterialsSingleArticle]                @article = @art
    SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
    EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_FillTempMaterialsSingleArticle]',
									   @timeMs = @diff
    SET @timeStart = GETDATE() 

PRINT 'sp_InsertMaterials'

  
    EXEC [InputData].[sp_InsertMaterials]
    SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
    EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_InsertMaterials]',
									   @timeMs = @diff
    SET @timeStart = GETDATE() 

PRINT 'sp_InsertSpecificationsSingleArticle'


    EXEC [InputData].[sp_InsertSpecificationsSingleArticle]             @article = @art
    SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
    EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_InsertSpecificationsSingleArticle]',
									   @timeMs = @diff
    SET @timeStart = GETDATE() 


    PRINT 'Загрузка материаллов из НСИ'
	EXEC [InputData].[sp_InsertMissedMaterials]					-- заполняем материалы которые грузим из НСИ
	SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
	EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_InsertMissedMaterials]',
									   @timeMs = @diff
	SET @timeStart = GETDATE() 

    PRINT 'Загрузка спецификаций из НСИ'
	EXEC [InputData].[sp_InsertMissedSpecificationSingleArticle] @article = @art	-- заполняем спецификации из НСИ
	SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
	EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_InsertMissedMaterials]',
									   @timeMs = @diff
	SET @timeStart = GETDATE() 

    

RETURN 0
 