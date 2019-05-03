CREATE TRIGGER [InputData].[tgr_DeleteSemiProduct]
ON [InputData].[SemiProducts] INSTEAD OF DELETE
AS 
BEGIN TRANSACTION
	DELETE FROM [InputData].[EntrySemiProduct]
	WHERE [IdSemiProduct] in (SELECT [IdSemiProduct] FROM deleted) 
	or [IdSemiProductChild] in (SELECT [IdSemiProduct] FROM deleted) 
	DELETE FROM SemiProducts WHERE IdSemiProduct in (SELECT [IdSemiProduct] FROM deleted) 
	IF @@ERROR <> 0
		ROLLBACK TRANSACTION
COMMIT TRANSACTION
RETURN	
