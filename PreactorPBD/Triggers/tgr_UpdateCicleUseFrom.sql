CREATE TRIGGER [SupportData].[tgr_UpdateCicleUseFrom]
 
ON [SupportData].[CicleUseFrom] AFTER UPDATE AS
BEGIN TRANSACTION
	UPDATE [SupportData].[CicleUseFrom]
	SET DateChanged = getdate()
	,[User] = suser_sname()
	WHERE IdCicleUseFrom in (SELECT IdCicleUseFrom FROM inserted)
	IF @@ERROR <> 0
		ROLLBACK TRANSACTION
	COMMIT TRANSACTION
RETURN	