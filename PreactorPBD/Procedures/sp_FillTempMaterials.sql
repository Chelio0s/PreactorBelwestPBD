CREATE PROCEDURE [InputData].[sp_FillTempMaterials]
AS

BEGIN TRANSACTION

	TRUNCATE TABLE [SupportData].[TempMaterials]
	INSERT INTO [SupportData].[TempMaterials]
			   ([Article]
			   ,[REL]
			   ,[FKGR]
			   ,[NORMA])
	SELECT DISTINCT  ART, REL, FKGR, NORMA
	FROM    [InputData].[VI_MaterialsFromRKV_SLOW]

COMMIT TRANSACTION
RETURN 0
