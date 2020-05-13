CREATE VIEW [InputData].[VI_MappingRuleForSecondFloor]
	AS SELECT DISTINCT
	   [IdRule]
      ,[AreaId]
      ,[TimeCoefficient]
	  ,TimeAddiction
	  ,NeedCountDetails
      ,[ResParentTitle]
      ,[ResChildTitle]
      ,[KOBParent]
      ,[KOBChild]
      ,[OpParentTitle]
      ,[OpChildTitle]
      ,[KTOPParent]
      ,[KTOPChild]
	  ,vioper.ktopn								AS KTOPOriginal
	  ,vioper.kob								AS KobOriginal
	  ,vioper.NormaTime							AS NormaTimeOld
	  ,vioper.SimpleProductId
	  ,vioper.REL
	  ,CASE WHEN AreaId = 20 AND (KTOPParent = 494 OR KTOPParent = 360) AND ( KTOPChild = 516 OR KTOPChild = 554 OR KTOPChild = 517 OR KTOPChild = 564) THEN 0.1
			WHEN AreaId = 20 AND (KTOPParent = 494 OR KTOPParent = 360) AND ( KTOPChild = 516 OR KTOPChild = 564) THEN 0.1
			WHEN AreaId = 20 AND (KTOPParent = 494 OR KTOPParent = 360) AND ( KTOPChild = 582) THEN 0.5
			ELSE [InputData].[udf_GetMappingTime](NormaTime, TimeCoefficient, TimeAddiction,[NeedCountDetails],vioper.KOLD) END AS NormaTimeNew 
	  ,vioper.IdSemiProduct
	  ,vioper.IdRout
	  ,vioper.KOLD
	  ,vioper.KOLN
	  ,vioper.CategoryOperation
	  ,vioper.IdProfession
  FROM [InputData].[VI_MappingRules]									AS  vimr
  INNER JOIN [InputData].[VI_GetOperationsForMappingSecondFloor]		AS  vioper ON  vioper.KTOPN = vimr.KTOPParent
																			   AND vioper.KOB = vimr.KOBParent	 

