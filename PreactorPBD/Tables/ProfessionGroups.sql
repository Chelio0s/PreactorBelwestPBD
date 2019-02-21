CREATE TABLE [InputData].[ProfessionGroups]
(
	[IdProfessionGroups] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Title] NVARCHAR(99) NOT NULL UNIQUE
)
