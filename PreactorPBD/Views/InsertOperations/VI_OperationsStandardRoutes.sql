﻿CREATE VIEW [InputData].[VI_OperationsStandardRoutes]
	AS SELECT DISTINCT 
	  r.IdRout
	  ,[TitlePreactorOper]
      ,vi.[IdSemiProduct]
      ,vi.[IdProfession]
      ,4 AS [TypeTime]
	  ,CategoryOperation, vi.[OperOrder]
	  ,Code
	  ,NPP
	  ,KTOPN
	  ,vi.REL
	  ,0  AS isMappingRule
	  ,AreaId
	  ,SimpleProductId
  FROM [InputData].[Rout] as r
  INNER JOIN [InputData].[VI_OperationsWithSemiProducts_FAST] as vi ON vi.IdSemiProduct = r.SemiProductId
  WHERE CombineId IS NULL
