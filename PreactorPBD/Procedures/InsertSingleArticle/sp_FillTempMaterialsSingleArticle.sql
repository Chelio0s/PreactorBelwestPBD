CREATE PROCEDURE [InputData].[sp_FillTempMaterialsSingleArticle]
	@article nvarchar(99)
AS
	DELETE FROM  [SupportData].[TempMaterials] 
	WHERE Article = @article

	INSERT INTO [SupportData].[TempMaterials]
	SELECT DISTINCT  ART
	, REL
	, FKGR
	, NORMA
	, KEI
	, KPODTO
	, FNGR
	, DOP
	, DOPN
	, TOL
	, KC
	, NC
	, [PARAM]
	, RROT
	, RRTO
	, IdArticle 
	FROM    [InputData].[VI_MaterialsFromRKV_SLOW]
	WHERE ArtTitle = @article
RETURN 0
