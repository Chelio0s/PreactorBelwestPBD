CREATE TABLE [SupportData].[SimpleProduct]
(
	[IdSimpleProduct] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Title] NVARCHAR(99) NOT NULL UNIQUE
)
