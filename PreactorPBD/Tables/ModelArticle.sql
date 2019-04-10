CREATE TABLE [SupportData].[ModelArticle]
(
	[IdRow] int Primary key identity,
	[IndexModel] varchar(99) NOT NULL,
	[Article] varchar(99) NOT NULL, 
    CONSTRAINT [UK_ModelArticle_Columns] UNIQUE (IndexModel, Article)
)
