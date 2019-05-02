CREATE TABLE [SupportData].[TempMaterials]
(
    [ID] int NOT NULL PRIMARY KEY IDENTITY,
	[Article] NCHAR(15) NOT NULL , 
    [REL] NCHAR(15) NOT NULL, 
    [FKGR] NCHAR(15) NOT NULL, 
    [NORMA] DECIMAL(6, 2) NOT NULL
)

GO

CREATE INDEX [IX_TempMaterials_REL] ON [SupportData].[TempMaterials] (REL, Article, FKGR)

GO
