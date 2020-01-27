CREATE PROCEDURE [InputData].[sp_InsertAll]
AS

BEGIN
	print 'Артикул - модель таблицы'
	EXEC [SupportData].[sp_InsertArticleModels]
	print 'Загрузка профессий'
	EXEC [InputData].sp_InsertProfsIntoPreactor
	print 'Загрузка рабочих'
	EXEC [InputData].sp_InsertActualEmployees
	print 'Загрузка рабочих в профессии'
	EXEC [InputData].sp_InsertEmployeesInProffs
	print 'Загрузка календарей работы цехов'
	EXEC [InputData].sp_InsertOrgUnitsCalendars
	print 'Загрузка рабочих дней'
	EXEC [InputData].sp_InsertWorkDays
	print 'Загрузка оборуд.'
	EXEC [InputData].sp_InsertEquipmentWithDelete
	print 'Загрузка ремонтов'
	EXEC [InputData].sp_PutResourcesOnRepair
	print 'Включение оборуд. в группы'
	EXEC [InputData].sp_IncludeEquipmentIntoGroups
	print 'Создание номенклатур (арт + размер)'
	EXEC [InputData].sp_CreateNomenclature
	print 'Создание ПФ'
	EXEC [InputData].sp_CreateSemiProducts
	print 'Включение ПФ в ПФ'
	EXEC [InputData].sp_CreateEntrySemiProducts
	print 'Создание резаков'
	EXEC [InputData].sp_CreateCutters
	EXEC [InputData].[sp_CreateSecondaryConstraint_Cutters]
	print 'Созание календаря ограничений, резаки'
	EXEC [InputData].sp_CreateConstraintCalendar_Cutters

	print 'Создание компбинаций операций'
	EXEC [InputData].sp_InsertCombines							-- инсертим комбинации всех правил для создания ТМов
	print 'Заполнение временной таблицы операций'
	EXEC [InputData].sp_FillTempOperationTable					-- заполняем вр. таблицу с опер-ми
	print 'Удаляем пустые ПФ  '
	EXEC [InputData].sp_DeleteInappropriateSemiProducts			-- Удаляем пустые ПФ
	print 'Создание маршрутов'
	EXEC [InputData].sp_InsertRoutes							-- создаем маршруты
	print 'Загрузка операций'
	EXEC [InputData].sp_InsertOperations						-- заполняем операции для продуктов
	print 'Удаляем пустые ТМ'
	EXEC [InputData].sp_DeleteInappropriateRoutes				-- Удаляем пустые ТМ
	print 'Ставим ограничения на операции'
	EXEC [InputData].[sp_InsertContraintsOnOperations]			-- Ставим ограничения на операции
	print 'Ставим операции на рессурсы'
	EXEC [InputData].sp_InsertOperationsInResources			   -- заливаем операции на рессурсы
	print 'Создание временной таблицы материаллов'
	EXEC [InputData].sp_FillTempMaterials						-- заполняем вр. таблицу с мат-ми
	print 'Загрузка мат-ов'
	EXEC [InputData].sp_InsertMaterials
	print 'Загрузка спецификаций'
	EXEC [InputData].sp_InsertSpecifications					-- заполняем спецификации
END
RETURN 0
