CREATE PROCEDURE [InputData].[sp_InsertEquipmentWithDelete]
AS
	DELETE FROM [InputData].[Resources]
	EXEC [InputData].[pc_InsertEquipmentIntoPreactorDB]
RETURN 0
