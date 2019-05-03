CREATE TABLE [InputData].[Specifications]
(
	[IdSpecification] INT NOT NULL PRIMARY KEY UNIQUE IDENTITY, 
    [MaterialId] varchar(15) NOT NULL, 
    [Norma] FLOAT NOT NULL, 
    [OperationId] INT NOT NULL, 
    CONSTRAINT [FK_Specifications_ToMaterial] FOREIGN KEY (MaterialId) REFERENCES [InputData].Material(IdMaterial), 
    CONSTRAINT [FK_Specifications_ToOperation] FOREIGN KEY ([OperationId]) REFERENCES [InputData].[Operations](IdOperation)
	ON DELETE CASCADE ON UPDATE CASCADE
)
