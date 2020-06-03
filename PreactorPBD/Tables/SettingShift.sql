CREATE TABLE [SupportData].[SettingShift]
(
	[IdSettingShift] INT NOT NULL PRIMARY KEY IDENTITY, 
    [AreaId] INT NOT NULL, 
    [ShiftId] INT NOT NULL, 
    [TimeStart] TIME NOT NULL, 
    [User] NCHAR(50) NOT NULL DEFAULT suser_sname(), 
    [DateChanged] DATETIME NOT NULL DEFAULT getdate(), 
    CONSTRAINT [UK_SettingShift_Org_Shift_Time] UNIQUE ([AreaId], [ShiftId], [TimeStart]), 
    CONSTRAINT [FK_SettingShift_ToShift] FOREIGN KEY (ShiftId) REFERENCES [SupportData].[Shift](IdShift),
	CONSTRAINT [FK_SettingShift_ToArea] FOREIGN KEY ([AreaId]) REFERENCES [InputData].[Areas]([IdArea])
	ON DELETE CASCADE ON UPDATE CASCADE
)
