CREATE TRIGGER [InputData].[tgr_DeleteNomenclature]
ON [InputData].[Nomenclature] INSTEAD OF DELETE
AS 
BEGIN TRANSACTION
	DELETE FROM [InputData].[SemiProducts]
	WHERE  NomenclatureID in (select  [IdNomenclature] from deleted) 
	DELETE FROM [InputData].[Nomenclature] 
	WHERE IdNomenclature in  (select [IdNomenclature] from deleted) 
	IF @@ERROR<>0
		ROLLBACK TRANSACTION
COMMIT TRANSACTION
RETURN