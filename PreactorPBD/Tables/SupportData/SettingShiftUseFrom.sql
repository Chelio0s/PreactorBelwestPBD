CREATE TABLE [SupportData].[SettingShiftUseFrom]
(
	[IdSettingShiftUseFrom] INT NOT NULL PRIMARY KEY IDENTITY, 
    [SettingShiftId] INT NOT NULL, 
    [StartUseFrom] DATE NOT NULL, 
    CONSTRAINT [FK_SettingShift_ToSettingShiftUseFromId] FOREIGN KEY (SettingShiftId) 
    REFERENCES [SupportData].[SettingShift]([IdSettingShift])
	ON UPDATE CASCADE ON DELETE CASCADE
)
