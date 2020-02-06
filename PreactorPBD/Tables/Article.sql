CREATE TABLE [InputData].[Article]
(
	[IdArticle]		INT			 NOT NULL PRIMARY KEY IDENTITY, 
    [Title]			NVARCHAR(99) COLLATE Cyrillic_General_BIN NOT NULL UNIQUE,
    [MaxCountUse]	INT			 NOT NULL DEFAULT 0,
	[IsComplex]		BIT			 NOT NULL DEFAULT 0,
	[IsCutters]		BIT			 NOT NULL DEFAULT 0,
	[IsAutomat]		BIT			 NOT NULL DEFAULT 0
)
Go

