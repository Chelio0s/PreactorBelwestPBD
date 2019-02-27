CREATE TABLE [InputData].[Specifications]
(
	[IdSpecification] INT NOT NULL PRIMARY KEY UNIQUE IDENTITY, 
    [MaterialId] INT NOT NULL, 
    [Norma] FLOAT NOT NULL, 
    [OperationId] INT NOT NULL, 
    CONSTRAINT [FK_Specifications_ToMaterial] FOREIGN KEY (MaterialId) REFERENCES [InputData].Material(IdMaterial), 
    CONSTRAINT [FK_Specifications_ToOperation] FOREIGN KEY ([OperationId]) REFERENCES [InputData].[Operations](IdOperation)
)
