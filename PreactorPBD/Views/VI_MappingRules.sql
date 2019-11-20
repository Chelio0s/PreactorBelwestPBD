--Вьюха для просмотра всех правил маппинга

CREATE VIEW [InputData].[VI_MappingRules]
	AS
	SELECT [IdRule]
      ,AreaId
      ,[TimeCoefficient]
	  ,TimeAddiction
	  ,NeedCountDetails
	  ,MCRParent.Title		as ResParentTitle
	  ,MCRChild.Title		as ResChildTitle
	  ,MRCParent.KOB		as KOBParent
	  ,MRCChild.KOB			as KOBChild
	  ,MRCOParent.Title		as OpParentTitle
	  ,MRCOChild.Title		as OpChildTitle
	  ,MOCParent.KTOP		as KTOPParent
	  ,MOCChild.KTOP		as KTOPChild
	  
FROM [SupportData].[MappingRules] as MR
  INNER JOIN [SupportData].[MappingComposeResource]			as MCRParent	ON MCRParent.IdMappingComposeResource = MR.MappingComposeResourceParentId
  INNER JOIN [SupportData].[MappingComposeResource]			as MCRChild		ON MCRChild.IdMappingComposeResource = MR.MappingComposeResourceChildId
  INNER JOIN [SupportData].[MappingComposeOperation]		as MRCOParent	ON MRCOParent.IdMappingComposeOperation = MR.OperationMappingParentId 
  INNER JOIN [SupportData].[MappingComposeOperation]		as MRCOChild	ON MRCOChild.IdMappingComposeOperation = MR.OperationMappingChildId
  INNER JOIN [SupportData].[MappingOperationComposition]	as MOCParent	ON MRCOParent.IdMappingComposeOperation = MOCParent.MappingComposeOperationId
  INNER JOIN [SupportData].[MappingOperationComposition]	as MOCChild		ON MOCChild.MappingComposeOperationId = MRCOChild.IdMappingComposeOperation
  INNER JOIN [SupportData].[MappingResourceComposition]		as MRCParent	ON MRCParent.MappingComposeResourceId = MCRParent.IdMappingComposeResource
  INNER JOIN [SupportData].[MappingResourceComposition]		as MRCChild		ON MRCChild.MappingComposeResourceId = MCRChild.IdMappingComposeResource


