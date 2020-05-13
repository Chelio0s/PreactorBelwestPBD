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
	  ,[InputData].[udf_GetMappingTime](NormaTime, TimeCoefficient, TimeAddiction,[NeedCountDetails],vioper.KOLD) AS NormaTimeNew
	  ,vioper.IdSemiProduct
	  ,vioper.IdRout
	  ,vioper.KOLD
	  ,vioper.KOLN
	  ,vioper.CategoryOperation
	  ,vioper.IdProfession
	  ,vioper.REL
  FROM [InputData].[VI_MappingRules]								as  vimr
  INNER JOIN [InputData].[VI_GetOperationsForMappingFirstFloor]		as  vioper ON  vioper.KTOPN = vimr.KTOPParent
																			   AND vioper.KOB = vimr.KOBParent	 


