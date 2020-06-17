CREATE TRIGGER [SupportData].[tgr_UpdateGroupKOB]
ON [SupportData].[GroupKOB] AFTER UPDATE AS
BEGIN TRANSACTION
	UPDATE [SupportData].[GroupKOB]
	SET DateChanged = getdate()
	,[User] = suser_sname()
	WHERE [IdGroupKOB] in (SELECT [IdGroupKOB] FROM inserted)
	IF @@ERROR <> 0
		ROLLBACK TRANSACTION
	COMMIT TRANSACTION
RETURN	
