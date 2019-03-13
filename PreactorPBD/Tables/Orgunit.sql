CREATE TABLE [SupportData].[Orgunit]
(
	[orguinit] INT NOT NULL PRIMARY KEY, 
    [kcex] INT NOT NULL, 
    [title] NVARCHAR(99) NOT NULL UNIQUE
)
