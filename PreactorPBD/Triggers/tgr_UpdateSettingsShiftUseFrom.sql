CREATE TRIGGER [SupportData].[tgr_UpdateSettingsShiftUseFrom]
ON [SupportData].[SettingShiftUseFrom]
AFTER UPDATE
AS
BEGIN TRANSACTION
	UPDATE [SupportData].[SettingShiftUseFrom]
	SET DateChanged = getdate()
	,[User] = suser_sname()
	WHERE IdSettingShiftUseFrom in (SELECT IdSettingShiftUseFrom FROM inserted)
	IF @@ERROR <> 0
		ROLLBACK TRANSACTION
	COMMIT TRANSACTION
RETURN	