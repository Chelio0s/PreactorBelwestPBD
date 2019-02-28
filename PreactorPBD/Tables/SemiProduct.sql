CREATE TABLE [InputData].[SemiProducts]
(
	[IdSemiProduct] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Title] NVARCHAR(99) NOT NULL UNIQUE, 
    [NomenclatureID] INT NOT NULL, 
    CONSTRAINT [FK_SemiProducts_ToNomenclature] FOREIGN KEY ([NomenclatureID]) REFERENCES [InputData].Nomenclature(IdNomenclature)
)
