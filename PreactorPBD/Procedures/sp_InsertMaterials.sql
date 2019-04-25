CREATE PROCEDURE [InputData].[sp_InsertMaterials]
--Залив материалов из RKV
AS

  --TRUNCATE TABLE [InputData].[Material]
  DELETE FROM [InputData].[Material]
  INSERT INTO [InputData].[Material]
           ([IdMaterial]
           ,[Title]
           ,[Attribute])
     SELECT 
      [FKGR]
      ,LTRIM(RTRIM([FNGR]))
	  ,NEI
  FROM [$(RKV)].[$(POTREB)].[dbo].[s_group]
RETURN 0
