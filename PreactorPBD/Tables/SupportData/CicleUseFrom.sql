CREATE TABLE [SupportData].[CicleUseFrom]
(
	[IdCicleUseFrom] INT NOT NULL PRIMARY KEY IDENTITY, 
    [CicleId] INT NOT NULL, 
    [StartUseFrom] DATE NOT NULL, 
    CONSTRAINT [FK_Cicle_ToCicleUseFrom] FOREIGN KEY (CicleId) 
    REFERENCES [SupportData].[Cicle]([IdCicle])
	ON UPDATE CASCADE ON DELETE CASCADE
)
