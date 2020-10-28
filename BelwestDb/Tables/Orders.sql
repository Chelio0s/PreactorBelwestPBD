CREATE TABLE [dbo].[Orders]
(
	[OrderCode] INT NOT NULL PRIMARY KEY IDENTITY, 
    [ArticleCode] VARCHAR(30) NOT NULL, 
    [ArticleName] VARCHAR(50) NOT NULL, 
    [ArticleVersion] VARCHAR(10) NOT NULL DEFAULT 00, 
    [CountOnOrder] INT NOT NULL, 
    [DateStart] DATETIME NOT NULL, 
    [DateEnd] DATETIME NOT NULL, 
    [Priority] INT NOT NULL DEFAULT 10
)
