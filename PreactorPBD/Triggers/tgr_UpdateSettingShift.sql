CREATE TRIGGER [SupportData].[tgr_UpdateSettingsShift]
ON [SupportData].[SettingShift]
AFTER UPDATE
AS
BEGIN TRANSACTION
	UPDATE [SupportData].[SettingShift]
	SET DateChanged = getdate()
	,[User] = suser_sname()
	WHERE IdSettingShift in (SELECT IdSettingShift FROM inserted)
	IF @@ERROR <> 0
		ROLLBACK TRANSACTION
	COMMIT TRANSACTION
RETURN	