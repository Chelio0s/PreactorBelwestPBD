CREATE TRIGGER [InputData].[tgr_DeleteSemiProduct]
ON [InputData].[SemiProducts] INSTEAD OF DELETE
AS 
BEGIN TRANSACTION
	DECLARE @IdSemiProducts TABLE (IdSemiProduct int)
	INSERT INTO @IdSemiProducts 
	SELECT [IdSemiProduct] FROM deleted
	DELETE FROM [InputData].[EntrySemiProduct]
	WHERE [IdSemiProduct] in (@IdSemiProducts) 
	or [IdSemiProductChild] in (@IdSemiProducts) 
	DELETE FROM SemiProducts WHERE IdSemiProduct in (@IdSemiProducts) 
	IF @@ERROR <> 0
		ROLLBACK TRANSACTION
COMMIT TRANSACTION
RETURN	
