CREATE TABLE [SupportData].[TempMaterials]
(
    [ID]			INT				NOT NULL PRIMARY KEY IDENTITY,
	[Article]		NCHAR(99)		NOT NULL, 
    [REL]			NCHAR(99)		NULL, 
    [FKGR]			NCHAR(99)		NOT NULL, 
    [NORMA]			DECIMAL(6, 2)	NOT NULL, 
	[KEI]			INT				NOT NULL,
    [KPODTO]		NCHAR(10)		NULL, 
    [FNGR]			NCHAR(99)		NOT NULL, 
    [DOP]			NVARCHAR(50)	NULL, 
    [DOPN]			NVARCHAR(50)	NULL, 
    [TOL]			NVARCHAR(50)	NULL, 
    [KC]			NCHAR(10)		NULL, 
    [NC]			NVARCHAR(99)	NULL, 
    [PARAM]			NCHAR(99)		NULL, 
    [PROT]			DECIMAL(6, 3)	NULL, 
    [PRTO]			DECIMAL(6, 3)	NULL, 
    [IdArticle]		INT				NOT NULL
)

GO

--CREATE INDEX [IX_TempMaterials_REL] ON [SupportData].[TempMaterials] (REL, Article, FKGR)

GO
