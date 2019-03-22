CREATE TABLE [SupportData].[Cicle]
(
	[IdCicle] INT NOT NULL PRIMARY KEY, 
    [OrgUnitId] INT NOT NULL, 
    [DurationWork] TIME NOT NULL, 
    [DurationOff] TIME NOT NULL, 
    CONSTRAINT [FK_Cicle_ToOrguinut] FOREIGN KEY (OrgUnitId) REFERENCES [SupportData].[Orgunit]([OrgUnit])
	ON UPDATE CASCADE ON DELETE CASCADE
)
