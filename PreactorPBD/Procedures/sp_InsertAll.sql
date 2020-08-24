CREATE PROCEDURE [InputData].[sp_InsertAll]
AS

BEGIN
	--TRUNCATE TABLE [LogData].[InsertingLog]

	DECLARE @timeStart datetime, @diff int
	SET @timeStart = GETDATE()
	PRINT 'Артикул - модель таблицы'
	
	EXEC [SupportData].[sp_InsertArticleModels]
	SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
	EXEC [LogData].[WriteInsertingLog] @text = '[SupportData].[sp_InsertArticleModels]',
									   @timeMs = @diff
	SET @timeStart = GETDATE()
	
	PRINT 'Загрузка профессий'
	
	 
	EXEC [InputData].[sp_InsertProfsIntoPreactor]
	SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
	EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_InsertProfsIntoPreactor]',
									   @timeMs = @diff
	SET @timeStart = GETDATE()
	
	PRINT 'Загрузка рабочих'
	
	 
	EXEC [InputData].[sp_InsertActualEmployees]
	SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
	EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_InsertActualEmployees]',
									   @timeMs = @diff
	SET @timeStart = GETDATE()
	
	PRINT 'Загрузка рабочих в профессии'
	
	 
	EXEC [InputData].[sp_InsertEmployeesInProffs]
	SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
	EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_InsertEmployeesInProffs]',
									   @timeMs = @diff
	SET @timeStart = GETDATE()
	
	PRINT 'Загрузка календарей работы цехов'
	
	 
	EXEC [InputData].[sp_InsertOrgUnitsCalendars]
	SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
	EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_InsertOrgUnitsCalendars]',
									   @timeMs = @diff
	SET @timeStart = GETDATE()
	
	PRINT 'Загрузка рабочих дней'
	
	 
	EXEC [InputData].[sp_InsertWorkDays]
	SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
	EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_InsertWorkDays]',
									   @timeMs = @diff
	SET @timeStart = GETDATE()
	
	PRINT 'Загрузка оборуд.'
	
	 
	EXEC [InputData].[sp_InsertEquipmentWithDelete]
	SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
	EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_InsertEquipmentWithDelete]',
									   @timeMs = @diff
	SET @timeStart = GETDATE()
	
	PRINT 'Загрузка ремонтов'
	
 
	EXEC [InputData].[sp_PutResourcesOnRepair]
	SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
	EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_PutResourcesOnRepair]',
									   @timeMs = @diff
	SET @timeStart = GETDATE()
	
	PRINT 'Включение оборуд. в группы'
	
	 
	EXEC [InputData].[sp_IncludeEquipmentIntoGroups]
	SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
	EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_IncludeEquipmentIntoGroups]',
									   @timeMs = @diff
	SET @timeStart = GETDATE()
	
	PRINT 'Создание номенклатур (арт + размер)'
	
	 
	EXEC [InputData].[sp_CreateNomenclature]
	SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
	EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_CreateNomenclature]',
									   @timeMs = @diff
	SET @timeStart = GETDATE()
	
	PRINT 'Создание ПФ'
	
	 
	EXEC [InputData].[sp_CreateSemiProducts]
	SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
	EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_CreateSemiProducts]',
									   @timeMs = @diff
	SET @timeStart = GETDATE()
	
	PRINT 'Включение ПФ в ПФ'
	
	 
	EXEC [InputData].[sp_CreateEntrySemiProducts]
	SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
	EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_CreateEntrySemiProducts]',
									   @timeMs = @diff
	SET @timeStart = GETDATE()
	
	PRINT 'Создание резаков'
	
	 
	EXEC [InputData].[sp_CreateCutters]
	SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
	EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_CreateCutters]',
									   @timeMs = @diff
	SET @timeStart = GETDATE() 

	 
	EXEC [InputData].[sp_CreateSecondaryConstraint_Cutters]
	SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
	EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_CreateSecondaryConstraint_Cutters]',
									   @timeMs = @diff
	SET @timeStart = GETDATE() 
	
	PRINT 'Созание календаря ограничений, резаки'
	
	 
	EXEC [InputData].[sp_CreateConstraintCalendar_Cutters]
	SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
	EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_CreateConstraintCalendar_Cutters]',
									   @timeMs = @diff
	SET @timeStart = GETDATE() 
	
	PRINT 'Создание компбинаций операций'
	
	 
	EXEC [InputData].[sp_InsertCombines]							-- инсертим комбинации всех правил для создания ТМов
	SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
	EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_InsertCombines]',
									   @timeMs = @diff
	SET @timeStart = GETDATE() 
	
	PRINT 'Заполнение временной таблицы операций'
	
	 
	EXEC [InputData].[sp_FillTempOperationTable]				-- заполняем вр. таблицу с опер-ми
	SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
	EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_FillTempOperationTable]',
									   @timeMs = @diff
	SET @timeStart = GETDATE() 
	
	PRINT 'Удаляем пустые ПФ  '
	
	 
	EXEC [InputData].[sp_DeleteInappropriateSemiProducts]			-- Удаляем пустые ПФ
	SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
	EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_DeleteInappropriateSemiProducts]',
									   @timeMs = @diff
	SET @timeStart = GETDATE() 
	
	PRINT 'Создание маршрутов'
	
	 
	EXEC [InputData].[sp_InsertRoutes]							-- создаем маршруты
	SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
	EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_InsertRoutes]',
									   @timeMs = @diff
	SET @timeStart = GETDATE() 
	
	PRINT 'Загрузка операций'
	
	 
	EXEC [InputData].[sp_InsertOperations]						-- заполняем операции для продуктов
	SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
	EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_InsertOperations]',
									   @timeMs = @diff
	SET @timeStart = GETDATE() 
	
	PRINT 'Удаляем пустые ТМ'
	
	 
	EXEC [InputData].[sp_DeleteInappropriateRoutes]				-- Удаляем пустые ТМ
	SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
	EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_DeleteInappropriateRoutes]',
									   @timeMs = @diff
	SET @timeStart = GETDATE() 
	
	PRINT 'Ставим ограничения на операции'
	
	 
	EXEC [InputData].[sp_InsertContraintsOnOperations]			-- Ставим ограничения на операции
	SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
	EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_InsertContraintsOnOperations]',
									   @timeMs = @diff
	SET @timeStart = GETDATE() 
	
	PRINT 'Ставим операции на рессурсы'
	
	 
	EXEC [InputData].[sp_InsertOperationsInResources]			   -- заливаем операции на рессурсы
	SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
	EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_InsertOperationsInResources]',
									   @timeMs = @diff
	SET @timeStart = GETDATE() 
	
	PRINT 'Создание временной таблицы материаллов'
	
	 
	EXEC [InputData].[sp_FillTempMaterials]						-- заполняем вр. таблицу с мат-ми
	SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
	EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_FillTempMaterials]',
									   @timeMs = @diff
	SET @timeStart = GETDATE() 
	
	PRINT 'Загрузка мат-ов'
	
	 
	EXEC [InputData].[sp_InsertMaterials]
	SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
	EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_InsertMaterials]',
									   @timeMs = @diff
	SET @timeStart = GETDATE() 
	
	PRINT 'Загрузка спецификаций'
	
	 
	EXEC [InputData].[sp_InsertSpecifications]					-- заполняем спецификации
	SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
	EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_InsertSpecifications]',
									   @timeMs = @diff
	SET @timeStart = GETDATE() 
	PRINT 'Загрузка материаллов из НСИ'
	EXEC [InputData].[sp_InsertMissedMaterials]					-- заполняем материалы которые грузим из НСИ
	SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
	EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_InsertMissedMaterials]',
									   @timeMs = @diff
	SET @timeStart = GETDATE() 



	PRINT 'Загрузка спецификаций'
	EXEC [InputData].[sp_InsertMissedSpecifications]				-- заполняем спецификации из НСИ
	SET @diff = DATEDIFF(ms, @timeStart, GETDATE())
	EXEC [LogData].[WriteInsertingLog] @text = '[InputData].[sp_InsertMissedSpecifications]',
									   @timeMs = @diff
 
	
	

	TRUNCATE TABLE [SupportData].[TempOperationsWithMacro]
	INSERT INTO [SupportData].[TempOperationsWithMacro]
	SELECT [IdOperation]
      ,[OperTitle]
      ,[MacroTitle]
	  ,[KTOP]
      ,[AreaId]
    FROM [InputData].[VI_OperationsWithMacro]

END
RETURN 0
