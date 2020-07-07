CREATE TABLE [InputData].[Areas]
(
	[IdArea]	INT				NOT NULL PRIMARY KEY IDENTITY, 
    [Code]		VARCHAR(5), 
    [Title]		NVARCHAR(99)			COLLATE Cyrillic_General_BIN NOT NULL UNIQUE, 
    [KPO]		NVARCHAR(10)			COLLATE Cyrillic_General_BIN NOT NULL UNIQUE, 
    [KPODTO]	INT									                 NOT NULL UNIQUE
)
GO
