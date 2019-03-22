CREATE TABLE [SupportData].[SettingShift]
(
	[IdSettingShift] INT NOT NULL PRIMARY KEY IDENTITY, 
    [OrgUnitId] INT NOT NULL, 
    [ShiftId] INT NOT NULL, 
    [TimeStart] TIME NOT NULL, 
    CONSTRAINT [UK_SettingShift_Org_Shift_Time] UNIQUE ([OrgUnitId], [ShiftId], [TimeStart]), 
    CONSTRAINT [FK_SettingShift_ToShift] FOREIGN KEY (ShiftId) REFERENCES [SupportData].[Shift](IdShift)
	ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT [FK_SettingShift_ToOrgunit] FOREIGN KEY (OrgUnitId) REFERENCES [SupportData].[Orgunit](OrgUnit)
	ON DELETE CASCADE ON UPDATE CASCADE
)
