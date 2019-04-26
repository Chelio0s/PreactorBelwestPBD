CREATE TRIGGER [InputData].tgr_DeleteArticle
ON [InputData].Article INSTEAD OF DELETE
AS 
BEGIN TRANSACTION
	DELETE FROM [InputData].Nomenclature
	WHERE  [ArticleId] = (SELECT top(1) [IdArticle] from deleted) 
	DELETE FROM [InputData].Article WHERE IdArticle = (select top(1) [IdArticle] from deleted) 
	if @@ERROR <> 0
		ROLLBACK TRANSACTION
COMMIT TRANSACTION
RETURN 