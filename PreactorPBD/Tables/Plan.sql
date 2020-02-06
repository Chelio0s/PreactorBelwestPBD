CREATE TABLE [InputData].[Plan]
(
	[IdPlan]			INT			NOT NULL PRIMARY KEY IDENTITY, 
    [ArticleId]			INT			NOT NULL, 
    [Count]				INT			NOT NULL, 
    [DateTime]			DATETIME	NULL, 
	[EarliestDateTime]	DATETIME	NULL, 
    [Priority]			INT			NOT NULL, 
    CONSTRAINT [FK_Plan_ToArticle] FOREIGN KEY (ArticleId) REFERENCES [InputData].Article(IdArticle)
	ON UPDATE CASCADE ON DELETE CASCADE
)
