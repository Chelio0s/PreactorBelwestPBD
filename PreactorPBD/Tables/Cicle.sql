CREATE TABLE [SupportData].[Cicle]
(
	[IdCicle] INT NOT NULL PRIMARY KEY IDENTITY, 
    [AreaId] INT NOT NULL, 
    [DurationWork] TIME NOT NULL, 
    [DurationOff] TIME NOT NULL, 
    CONSTRAINT [FK_Cicle_ToOrguinut] FOREIGN KEY ([AreaId]) REFERENCES [InputData].[Areas]([IdArea])
	ON UPDATE CASCADE ON DELETE CASCADE
)
