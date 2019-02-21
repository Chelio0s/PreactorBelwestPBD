CREATE TABLE dbo.[Specifications]
(
	[IdSpecification] INT NOT NULL PRIMARY KEY UNIQUE IDENTITY, 
    [MaterialId] INT NOT NULL, 
    [Norma] FLOAT NOT NULL, 
    [NomenclatureId] INT NOT NULL, 
    CONSTRAINT [FK_Specifications_ToMaterial] FOREIGN KEY (MaterialId) REFERENCES Material(IdMaterial), 
    CONSTRAINT [FK_Specifications_ToNomenclature] FOREIGN KEY (NomenclatureId) REFERENCES [Nomenclature](IdNomenclature)
)
