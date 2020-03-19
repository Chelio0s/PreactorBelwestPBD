CREATE TRIGGER [SupportData].[tr_DeleteSimpleProduct]
ON [SupportData].[SimpleProduct] INSTEAD OF DELETE
AS 
BEGIN TRANSACTION
	
	DELETE FROM [SupportData].[EntrySupportRelatedProducts]
	WHERE SimpleProductId in (SELECT IdSimpleProduct FROM deleted)

	DELETE FROM [SupportData].SupportRelatedProducts
	WHERE SimpleProductId in (SELECT IdSimpleProduct FROM deleted)

	DELETE FROM [SupportData].[EntrySimpleProduct]
	WHERE SimpleProductId in (SELECT IdSimpleProduct FROM deleted) 
	or [SimpleProductIdChild] in (SELECT IdSimpleProduct FROM deleted) 
	
	DELETE FROM [SupportData].[SimpleProduct] 
	WHERE IdSimpleProduct in (SELECT IdSimpleProduct FROM deleted)

	IF @@ERROR <> 0
		ROLLBACK TRANSACTION
	COMMIT TRANSACTION

RETURN	
