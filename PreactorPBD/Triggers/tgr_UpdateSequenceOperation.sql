CREATE TRIGGER [SupportData].[tgr_UpdateSequenceOperation]
ON [SupportData].[SequenceOperations] AFTER UPDATE
AS
BEGIN TRANSACTION

	UPDATE [SupportData].[SequenceOperations]
	SET Changed = getdate()
	WHERE [IdSeqOperation] in (SELECT [IdSeqOperation] FROM inserted)

	IF @@ERROR <> 0
		ROLLBACK TRANSACTION
	COMMIT TRANSACTION

RETURN	
