CREATE PROCEDURE [InputData].[sp_InsertMissedMaterials]
--Залив материалов из RKV которые подтянулись из НСИ
AS
INSERT INTO [InputData].[Material]
 
  SELECT DISTINCT
    NULL        AS CodeMaterial
    ,mis.TITLE  AS Title
    ,''		    AS AddictionAttribute
    ,''		    AS AddAttrName
    ,''		    AS Thickness
    ,'000'	    AS ColorCode
    ,ISNULL(UPPER(COLOR), '') AS ColorName
    ,''         AS MetricParam
    ,0          AS SizeFrom
    ,0          AS SizeTo
    FROM [InputData].[VI_MissingMaterialsFromNSI]          AS mis
    INNER JOIN [InputData].[VI_ArticlesWithoutMaterials]   AS vi on vi.title = mis.art collate Cyrillic_General_BIN
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
