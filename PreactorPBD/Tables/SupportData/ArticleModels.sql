CREATE TABLE [SupportData].[ArticleModels]
(
	[Article] VARCHAR(50) NOT NULL, 
    [Model] VARCHAR(50) NOT NULL, 
    [AticleId] INT NOT NULL, 
    CONSTRAINT [PK_ArticleModels] PRIMARY KEY ([Article], [Model]), 
    CONSTRAINT [FK_ArticleModels_ToArticle] FOREIGN KEY (AticleId) REFERENCES [InputData].[Article](IdArticle)
)
