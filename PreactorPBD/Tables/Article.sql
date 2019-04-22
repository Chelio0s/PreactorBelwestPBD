CREATE TABLE [InputData].[Article]
(
	[IdArticle] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Title] NVARCHAR(99) COLLATE Cyrillic_General_BIN NOT NULL UNIQUE,
    [MaxCountUse] INT NOT NULL DEFAULT 0
)
Go

--ALTER TABLE [InputData].[Article]
--  ADD CONSTRAINT [UK_Article_Title] UNIQUE(Title)
--Go

