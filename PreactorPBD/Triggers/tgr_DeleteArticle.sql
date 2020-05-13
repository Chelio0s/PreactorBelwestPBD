CREATE TRIGGER [InputData].tgr_DeleteArticle
ON [InputData].Article INSTEAD OF DELETE
AS 
BEGIN TRANSACTION
DECLARE @IdArt int
SET @IdArt = (SELECT TOP(1) [IdArticle] FROM deleted)
	DELETE FROM [InputData].Nomenclature
	WHERE  [ArticleId] = @IdArt
	DELETE FROM [InputData].Article WHERE IdArticle = @IdArt
	if @@ERROR <> 0
		ROLLBACK TRANSACTION
COMMIT TRANSACTION
RETURN