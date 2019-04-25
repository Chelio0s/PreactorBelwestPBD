CREATE TRIGGER [InputData].[tgr_DeleteSemiProduct]
ON [InputData].[SemiProducts] INSTEAD OF DELETE
AS 
BEGIN TRANSACTION
	DELETE FROM [InputData].[EntrySemiProduct]
	WHERE [IdSemiProduct] in (select  [IdSemiProduct] from deleted) 
	or [IdSemiProductChild] in (select  [IdSemiProduct] from deleted) 
	DELETE FROM SemiProducts WHERE IdSemiProduct in (select [IdSemiProduct] from deleted) 
	IF @@ERROR <> 0
		ROLLBACK TRANSACTION
COMMIT TRANSACTION
RETURN	
