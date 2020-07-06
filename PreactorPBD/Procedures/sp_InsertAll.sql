CREATE PROCEDURE [InputData].[sp_InsertAll]
AS

BEGIN
	
	PRINT GETDATE()
	PRINT 'Артикул - модель таблицы'
	
	SET STATISTICS TIME ON  
	EXEC [SupportData].[sp_InsertArticleModels]
	SET STATISTICS TIME OFF 
	
	print 'Загрузка профессий'
	
	SET STATISTICS TIME ON  
	EXEC [InputData].sp_InsertProfsIntoPreactor
	SET STATISTICS TIME OFF 
	
	print 'Загрузка рабочих'
	
	SET STATISTICS TIME ON  
	EXEC [InputData].sp_InsertActualEmployees
	SET STATISTICS TIME OFF 
	
	print 'Загрузка рабочих в профессии'
	
	SET STATISTICS TIME ON  
	EXEC [InputData].sp_InsertEmployeesInProffs
	SET STATISTICS TIME OFF 
	
	print 'Загрузка календарей работы цехов'
	
	SET STATISTICS TIME ON  
	EXEC [InputData].sp_InsertOrgUnitsCalendars
	SET STATISTICS TIME OFF 
	
	print 'Загрузка рабочих дней'
	
	SET STATISTICS TIME ON  
	EXEC [InputData].sp_InsertWorkDays
	SET STATISTICS TIME OFF 
	
	print 'Загрузка оборуд.'
	
	SET STATISTICS TIME ON  
	EXEC [InputData].sp_InsertEquipmentWithDelete
	SET STATISTICS TIME OFF 
	
	print 'Загрузка ремонтов'
	
	SET STATISTICS TIME ON  
	EXEC [InputData].sp_PutResourcesOnRepair
	SET STATISTICS TIME OFF 
	
	print 'Включение оборуд. в группы'
	
	SET STATISTICS TIME ON  
	EXEC [InputData].sp_IncludeEquipmentIntoGroups
	SET STATISTICS TIME OFF 
	
	print 'Создание номенклатур (арт + размер)'
	
	SET STATISTICS TIME ON  
	EXEC [InputData].sp_CreateNomenclature
	SET STATISTICS TIME OFF 
	
	print 'Создание ПФ'
	
	SET STATISTICS TIME ON  
	EXEC [InputData].sp_CreateSemiProducts
	SET STATISTICS TIME OFF 
	
	print 'Включение ПФ в ПФ'
	
	SET STATISTICS TIME ON  
	EXEC [InputData].sp_CreateEntrySemiProducts
	SET STATISTICS TIME OFF 
	
	print 'Создание резаков'
	
	SET STATISTICS TIME ON  
	EXEC [InputData].[sp_CreateCutters]
	SET STATISTICS TIME OFF 

	SET STATISTICS TIME ON  
	EXEC [InputData].[sp_CreateSecondaryConstraint_Cutters]
	SET STATISTICS TIME OFF 
	
	print 'Созание календаря ограничений, резаки'
	
	SET STATISTICS TIME ON  
	EXEC [InputData].sp_CreateConstraintCalendar_Cutters
	SET STATISTICS TIME OFF 
	
	print 'Создание компбинаций операций'
	
	SET STATISTICS TIME ON  
	EXEC [InputData].sp_InsertCombines							-- инсертим комбинации всех правил для создания ТМов
	SET STATISTICS TIME OFF 
	
	print 'Заполнение временной таблицы операций'
	
	SET STATISTICS TIME ON  
	EXEC [InputData].sp_FillTempOperationTable					-- заполняем вр. таблицу с опер-ми
	SET STATISTICS TIME OFF 
	
	print 'Удаляем пустые ПФ  '
	
	SET STATISTICS TIME ON  
	EXEC [InputData].sp_DeleteInappropriateSemiProducts			-- Удаляем пустые ПФ
	SET STATISTICS TIME OFF 
	
	print 'Создание маршрутов'
	
	SET STATISTICS TIME ON  
	EXEC [InputData].sp_InsertRoutes							-- создаем маршруты
	SET STATISTICS TIME OFF 
	
	print 'Загрузка операций'
	
	SET STATISTICS TIME ON  
	EXEC [InputData].sp_InsertOperations						-- заполняем операции для продуктов
	SET STATISTICS TIME OFF 
	
	print 'Удаляем пустые ТМ'
	
	SET STATISTICS TIME ON  
	EXEC [InputData].sp_DeleteInappropriateRoutes				-- Удаляем пустые ТМ
	SET STATISTICS TIME OFF 
	
	print 'Ставим ограничения на операции'
	
	SET STATISTICS TIME ON  
	EXEC [InputData].[sp_InsertContraintsOnOperations]			-- Ставим ограничения на операции
	SET STATISTICS TIME OFF 
	
	print 'Ставим операции на рессурсы'
	
	SET STATISTICS TIME ON  
	EXEC [InputData].sp_InsertOperationsInResources			   -- заливаем операции на рессурсы
	SET STATISTICS TIME OFF 
	
	print 'Создание временной таблицы материаллов'
	
	SET STATISTICS TIME ON  
	EXEC [InputData].sp_FillTempMaterials						-- заполняем вр. таблицу с мат-ми
	SET STATISTICS TIME OFF 
	
	print 'Загрузка мат-ов'
	
	SET STATISTICS TIME ON  
	EXEC [InputData].sp_InsertMaterials
	SET STATISTICS TIME OFF 
	
	print 'Загрузка спецификаций'
	
	SET STATISTICS TIME ON  
	EXEC [InputData].sp_InsertSpecifications					-- заполняем спецификации
	SET STATISTICS TIME OFF 


END
RETURN 0
