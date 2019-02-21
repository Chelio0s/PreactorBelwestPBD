CREATE TABLE [dbo].[ResourcesGroup]
(
	[IdResourceGroup] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Title] NVARCHAR(99) NOT NULL UNIQUE
)
