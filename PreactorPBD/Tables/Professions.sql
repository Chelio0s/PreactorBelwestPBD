CREATE TABLE [InputData].[Professions]
(
	[IdProfession] INT NOT NULL PRIMARY KEY, 
    [Title] NVARCHAR(99) NOT NULL UNIQUE, 
    [CodeRKV] NVARCHAR(99) NOT NULL
)
