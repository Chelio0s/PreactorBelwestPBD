CREATE PROCEDURE [InputData].[sp_FillTempMaterials]
AS
	TRUNCATE TABLE [SupportData].[TempMaterials]
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
RETURN 0
