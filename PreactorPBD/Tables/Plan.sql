CREATE TABLE [dbo].[Plan]
(
	[IdPlan] INT NOT NULL PRIMARY KEY IDENTITY, 
    [ArticleId] INT NOT NULL, 
    [Count] FLOAT NOT NULL, 
    [DateTime] DATETIME NULL, 
    [Priority] FLOAT NOT NULL, 
    CONSTRAINT [FK_Plan_ToArticle] FOREIGN KEY (ArticleId) REFERENCES Article(IdArticle)
)
