CREATE VIEW [InputData].[VI_MappingRuleForFirstFloor]
	AS 
SELECT DISTINCT
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
	  --todo: Формулу нужно будет дорабатывать!
	  ,CASE WHEN [NeedCountDetails] = 1 THEN NormaTime + (TimeAddiction * vioper.KOLD)*TimeCoefficient 
			WHEN [NeedCountDetails] = 0 THEN NormaTime * TimeCoefficient + TimeAddiction END AS NormaTimeNew
	  ,vioper.IdSemiProduct
	  ,vioper.IdRout
	  ,vioper.KOLD
	  ,vioper.KOLN
	  ,vioper.CategoryOperation
	  ,vioper.IdProfession
  FROM [InputData].[VI_MappingRules]								as  vimr
  INNER JOIN [InputData].[VI_GetOperationsForMappingFirstFloor]		as  vioper ON  vioper.KTOPN = vimr.KTOPParent
																			   AND vioper.KOB = vimr.KOBParent	 


