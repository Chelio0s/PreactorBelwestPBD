CREATE PROCEDURE [InputData].[sp_InsertMaterials]
--Залив материалов из RKV
AS

  INSERT INTO [InputData].[Material]
SELECT DISTINCT
      [FKGR]
      ,[FNGR]
      ,[DOP]
      ,[DOPN]
      ,[TOL]
      ,[KC]
      ,[NC]
      ,ISNULL([PARAM],0)
      ,ISNULL([PROT],0)
      ,ISNULL([PRTO],0)
  FROM [InputData].[VI_MaterialsForArticleWithNomenclatureFAST]
  EXCEPT  
  SELECT 
		[CodeMaterial]
		,[Title]
		,[AddictionAttribute]
		,[AddAttrName]
		,[Thickness]
		,[ColorCode]
		,[ColorName]
		,ISNULL([MetricParam],0)
		,ISNULL([SizeFrom],0)
		,ISNULL([SizeTo],0)
  FROM [InputData].[Material]
 
RETURN 0
