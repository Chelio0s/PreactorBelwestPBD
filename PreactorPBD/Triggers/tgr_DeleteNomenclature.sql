CREATE TRIGGER [InputData].[tgr_DeleteNomenclature]
ON [InputData].[Nomenclature] INSTEAD OF DELETE
AS 
BEGIN TRANSACTION
	DELETE FROM [InputData].[SemiProducts]
	WHERE  NomenclatureID in (SELECT [IdNomenclature] FROM deleted)
	DELETE FROM [InputData].[Nomenclature] 
	WHERE IdNomenclature in (SELECT [IdNomenclature] FROM deleted)
	IF @@ERROR<>0
		ROLLBACK TRANSACTION
COMMIT TRANSACTION
RETURN