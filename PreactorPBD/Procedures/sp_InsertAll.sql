CREATE PROCEDURE [InputData].[sp_InsertAll]
AS

BEGIN
	
	EXEC [InputData].sp_InsertProfsIntoPreactor
	EXEC [InputData].sp_InsertActualEmployees
	EXEC [InputData].sp_InsertEmployeesInProffs
	EXEC [InputData].sp_InsertWorkDays
	EXEC [InputData].sp_InsertMaterials
	EXEC [InputData].sp_InsertEquipmentWithDelete
	EXEC [InputData].sp_IncludeEquipmentIntoGroups
	EXEC [InputData].sp_CreateNomenclature
	EXEC [InputData].sp_CreateSemiProducts
	EXEC [InputData].sp_CreateEntrySemiProducts
	EXEC [InputData].sp_CreateCutters
	EXEC [InputData].sp_CreateConstraintCalendar_Cutters
	EXEC [InputData].sp_FillTempOperationTable
	EXEC [InputData].[sp_InsertOperations]

END
RETURN 0
