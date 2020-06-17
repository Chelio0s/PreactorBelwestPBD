CREATE VIEW [InputData].[VI_OperationsAfterMapping]
	AS 
	SELECT DISTINCT
	  R.IdRout
	  ,[InputData].[udf_GetTitleOperation](FN.KTOPChild, SO.Title)					AS TitleOperation
      ,R.SemiProductId
      ,FN.KPROF																		AS [idProfesson]																
	  ,FN.CategoryOperation
	  ,AR.Code
	  ,FN.KTOPChild
	  ,FN.KOBChild
	  ,FN.NormaTimeNew
	  ,FN.REL
  FROM [InputData].[Rout]															AS R
  CROSS APPLY [InputData].[ctvf_GetAltRouteForSecondFloor](ParentRouteId, Areaid)	AS FN
  INNER JOIN  [SupportData].[SequenceOperations]									AS SO	ON SO.KTOP = FN.KTOPChild																			  
  INNER JOIN  [InputData].[Areas]													AS AR	ON AR.IdArea = R.AreaId
  WHERE ParentRouteId IS NOT NULL 
  AND R.AreaId IN (9,13,14,20)
  UNION
  SELECT DISTINCT
	  R.IdRout
	  ,[InputData].[udf_GetTitleOperation](FN.KTOPChild, SO.Title)					AS TitleOperation
      ,R.SemiProductId
      ,FN.KPROF																		AS [idProfesson]																
	  ,FN.CategoryOperation
	  ,AR.Code
	  ,FN.KTOPChild
	  ,FN.KOBChild
	  ,FN.NormaTimeNew
	  ,FN.REL
  FROM [InputData].[Rout]															AS R
  CROSS APPLY [InputData].[ctvf_GetAltRouteForFirstFloor](ParentRouteId)		    AS FN
  INNER JOIN  [SupportData].[SequenceOperations]									AS SO	ON SO.KTOP = FN.KTOPChild
  INNER JOIN  [InputData].[Areas]													AS AR	ON AR.IdArea = R.AreaId
  WHERE ParentRouteId IS NOT NULL 
