CREATE TRIGGER [InputData].[tgr_DeleteNomenclature]
ON [InputData].[Nomenclature] INSTEAD OF DELETE
AS 
BEGIN TRANSACTION
	DECLARE @IdNom  TABLE(IdNomenclature int)
	INSERT INTO @IdNom 
	SELECT [IdNomenclature] FROM deleted
	DELETE FROM [InputData].[SemiProducts]
	WHERE  NomenclatureID in (@IdNom)
	DELETE FROM [InputData].[Nomenclature] 
	WHERE IdNomenclature in (@IdNom)
	IF @@ERROR<>0
		ROLLBACK TRANSACTION
COMMIT TRANSACTION
RETURN