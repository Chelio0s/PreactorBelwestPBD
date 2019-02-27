CREATE TABLE [InputData].[Operations]
(
	[IdOperation] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Title] NVARCHAR(99) NOT NULL, 
    [NumberOp] FLOAT NOT NULL, 
    [NomenclatureId] INT NOT NULL, 
    [ProfessionId] INT NOT NULL, 
    [TypeTime] BIT NOT NULL, 
    [CategoryProfession] INT NOT NULL, 
    CONSTRAINT [FK_Operations_ToProfGroup] FOREIGN KEY ([ProfessionId]) REFERENCES [InputData].[Professions](IdProfession), 
    CONSTRAINT [FK_Operations_ToNomenclature] FOREIGN KEY ([NomenclatureId]) REFERENCES [InputData].[Nomenclature](IdNomenclature)
)
