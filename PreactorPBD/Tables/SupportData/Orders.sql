CREATE TABLE [SupportData].[Orders]
(
	[IdOrder] INT NOT NULL PRIMARY KEY IDENTITY, 
    [ArticleId] INT NOT NULL, 
    [DateStart] DATE NOT NULL, 
    [DateEnd] DATE NOT NULL, 
    [Count] INT NOT NULL, 
    [Priority] INT NOT NULL 
)
