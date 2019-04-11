CREATE TABLE [InputData].[SemiProducts]
(
	[IdSemiProduct] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Title] NVARCHAR(99) NOT NULL UNIQUE, 
    [NomenclatureID] INT NOT NULL, 
    [SimpleProductId] INT  NULL, 
    CONSTRAINT [FK_SemiProducts_ToNomenclature] FOREIGN KEY ([NomenclatureID]) REFERENCES [InputData].Nomenclature(IdNomenclature)
	ON UPDATE CASCADE ON DELETE CASCADE, 
    CONSTRAINT [FK_SemiProducts_ToSimpleProduct] FOREIGN KEY (SimpleProductId) REFERENCES [SupportData].[SimpleProduct](IdSimpleProduct)
	on UPDATE  CASCADE ON DELETE SET NULL
)
