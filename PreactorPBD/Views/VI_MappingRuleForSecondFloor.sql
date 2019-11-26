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
	  ,[InputData].[udf_GetMappingTime](NormaTime, TimeCoefficient, TimeAddiction,[NeedCountDetails],vioper.KOLD) AS NormaTimeNew
	  ,vioper.IdSemiProduct
	  ,vioper.IdRout
	  ,vioper.KOLD
	  ,vioper.KOLN
	  ,vioper.CategoryOperation
	  ,vioper.IdProfession
  FROM [InputData].[VI_MappingRules]									AS  vimr
  INNER JOIN [InputData].[VI_GetOperationsForMappingSecondFloor]		AS  vioper ON  vioper.KTOPN = vimr.KTOPParent
																			   AND vioper.KOB = vimr.KOBParent	 

