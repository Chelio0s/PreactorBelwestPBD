--11.05.2020 Kovalkov
CREATE TRIGGER [tgr_Operation_DELETE]
ON [InputData].[Operations]
AFTER DELETE
AS
DELETE FROM [InputData].[OperationWithKTOP] 
WHERE OperationId IN (SELECT [IdOperation] FROM DELETED)
