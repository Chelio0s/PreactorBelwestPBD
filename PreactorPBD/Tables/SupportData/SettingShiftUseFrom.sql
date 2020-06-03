CREATE TABLE [SupportData].[SettingShiftUseFrom]
(
	[IdSettingShiftUseFrom] INT NOT NULL PRIMARY KEY IDENTITY, 
    [SettingShiftId]        INT NOT NULL, 
    [StartUseFrom]          DATE NOT NULL, 
    [SpecificOrgUnit]       INT NULL, 
    [DateChanged]           DATETIME NOT NULL           DEFAULT getdate(), 
    [User]                  NVARCHAR(50) NOT NULL   DEFAULT suser_sname(), 
    CONSTRAINT [FK_SettingShift_ToSettingShiftUseFromId] FOREIGN KEY (SettingShiftId) 
    REFERENCES [SupportData].[SettingShift]([IdSettingShift]),
    CONSTRAINT [FK_SettingShift_ToOrgUnit] FOREIGN KEY (SpecificOrgUnit) 
    REFERENCES [SupportData].[OrgUnit](OrgUnit)
	ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT UK_ShiftId_StartDate UNIQUE([SettingShiftId], [StartUseFrom], SpecificOrgUnit)
)
