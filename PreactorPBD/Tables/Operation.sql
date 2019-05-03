CREATE TABLE [InputData].[Operations]
(
	[IdOperation] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Title] NVARCHAR(99) NOT NULL, 
    [NumberOp] FLOAT NOT NULL, 
    [SemiProductID] INT NOT NULL, 
    [ProfessionId] INT NOT NULL, 
    [TypeTime] BIT NOT NULL, 
    [CategoryOperation] INT NOT NULL, 
    [Code] varchar(4) NULL, 
    CONSTRAINT [FK_Operations_ToProfGroup] FOREIGN KEY ([ProfessionId]) REFERENCES [InputData].[Professions](IdProfession)
	ON UPDATE CASCADE ON DELETE CASCADE, 
    CONSTRAINT [FK_Operations_ToSemiProduct] FOREIGN KEY ([SemiProductID]) REFERENCES [InputData].[SemiProducts](IdSemiProduct)
	ON UPDATE CASCADE ON DELETE CASCADE
)
