CREATE PROCEDURE [InputData].[sp_InsertAll]
AS

BEGIN
	
	EXEC [InputData].sp_InsertProfsIntoPreactor
	EXEC [InputData].sp_InsertActualEmployees
	EXEC [InputData].sp_InsertEmployeesInProffs
	EXEC [InputData].sp_InsertOrgUnitsCalendars
	EXEC [InputData].sp_InsertWorkDays
	EXEC [InputData].sp_InsertMaterials
	EXEC [InputData].sp_InsertEquipmentWithDelete
	EXEC [InputData].sp_IncludeEquipmentIntoGroups
	EXEC [InputData].sp_CreateNomenclature
	EXEC [InputData].sp_CreateSemiProducts
	EXEC [InputData].sp_CreateEntrySemiProducts
	EXEC [InputData].sp_CreateCutters
	EXEC [InputData].sp_CreateConstraintCalendar_Cutters
	EXEC [InputData].sp_InsertCombines						-- инсертим комбинации всех правил для создания ТМов
	EXEC [InputData].sp_InsertRoutes						-- создаем маршруты
	EXEC [InputData].sp_FillTempOperationTable				-- заполняем вр. таблицу с опер-ми
	EXEC [InputData].sp_InsertOperations					-- заполняем операции для продуктов
	EXEC [InputData].sp_InsertOperationsInResources
	EXEC [InputData].sp_FillTempMaterials					-- заполняем вр. таблицу с мат-ми
	EXEC [InputData].sp_InsertSpecifications				-- заполняем спецификации

END
RETURN 0
