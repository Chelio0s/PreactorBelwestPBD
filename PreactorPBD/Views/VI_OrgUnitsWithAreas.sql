﻿CREATE VIEW [InputData].[VI_OrgUnitsWithAreas]
	AS /****** Выбрать OrgUnits с привязкой к цехам  ******/
SELECT [IdArea]
      ,areas.Title as TitleArea
      ,[Code]
	  ,OrgUnit
      ,org.[Title] as TitleOrgUnit
  FROM [InputData].[Areas] as areas 
  INNER JOIN [SupportData].[OrgUnit] as org ON org.AreaId = areas.IdArea
