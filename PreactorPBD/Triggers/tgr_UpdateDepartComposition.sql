CREATE TRIGGER [SupportData].[tgr_UpdateDepartComposition]
 
ON [SupportData].[DepartComposition]
AFTER UPDATE
AS
BEGIN TRANSACTION
	UPDATE [SupportData].[DepartComposition]
	SET ChangeDate = getdate()
	,[User] = suser_sname()
	WHERE IdDepComposition in (SELECT IdDepComposition FROM inserted)
	IF @@ERROR <> 0
		ROLLBACK TRANSACTION
	COMMIT TRANSACTION
RETURN	