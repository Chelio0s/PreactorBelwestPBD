CREATE TABLE [dbo].[Nomenclature]
(
	[IdNomenclature] INT NOT NULL PRIMARY KEY IDENTITY, 
    [ArticleId] INT NOT NULL, 
    [Number_] NVARCHAR(99) NOT NULL UNIQUE, 
    [Size] FLOAT NOT NULL, 
    [CountPersent] DECIMAL(6, 2) NOT NULL, 
    CONSTRAINT [FK_Nomenclature_ToArticle] FOREIGN KEY (ArticleID) REFERENCES [Article]([IdArticle])

)
