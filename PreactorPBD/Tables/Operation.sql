CREATE TABLE [dbo].[Operations]
(
	[IdOperation] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Title] NVARCHAR(99) NOT NULL, 
    [NumberOp] FLOAT NOT NULL, 
    [NomenclatureId] INT NOT NULL, 
    [ProfessionGroupId] INT NOT NULL, 
    [Type] BIT NOT NULL, 
    CONSTRAINT [FK_Operations_ToProfGroup] FOREIGN KEY (ProfessionGroupId) REFERENCES [ProfessionGroups](IdProfessionGroups), 
    CONSTRAINT [FK_Operations_ToNomenclature] FOREIGN KEY ([NomenclatureId]) REFERENCES [Nomenclature](IdNomenclature)
)
