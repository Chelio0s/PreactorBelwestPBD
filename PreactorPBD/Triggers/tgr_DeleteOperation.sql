--11.05.2020 Kovalkov
CREATE TRIGGER [InputData].[tgr_DeleteOperation]
ON [InputData].[Operations]
AFTER DELETE
AS
DELETE FROM [InputData].[OperationWithKTOP] 
WHERE OperationId IN (SELECT [IdOperation] FROM DELETED)
