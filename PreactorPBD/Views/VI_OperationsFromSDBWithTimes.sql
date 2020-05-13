  CREATE VIEW [InputData].[VI_OperationsFromSDBWithTimes]
	AS   SELECT DISTINCT 
	  oper.RoutId
	  ,oper.Title
	  ,res.KOB
      ,[NORMATIME]
	  ,oper.Code
	  ,oper.ProfessionId
	  ,oper.CategoryOperation
	  ,r.SemiProductId
	  ,vi.SimpleProductId
	  ,vi.Article
	  ,vi.Size
	  ,vi.NPP
  FROM [InputData].[VI_OperationsWithSemiProducts_FAST] as vi
  INNER JOIN [InputData].[Rout]							as r		ON r.SemiProductId = vi.IdSemiProduct
  INNER JOIN [InputData].[Operations]					as oper		ON oper.RoutId = r.IdRout  and TitlePreactorOper = oper.Title
  LEFT JOIN [SupportData].[GroupKOB]					as groupkob ON groupkob.KTOPN = vi.KTOPN
  LEFT JOIN [InputData].[ResourcesGroup]				as resgroup ON resgroup.IdResourceGroup = groupkob.[GroupId]
  INNER JOIN [InputData].[Areas]						as area		ON area.Code = oper.Code COLLATE Cyrillic_General_BIN
  INNER JOIN [InputData].[Departments]					as dep		ON dep.AreaId = area.IdArea
  INNER JOIN [InputData].[Resources]					as res		ON res.KOB = vi.KOB 
														AND dep.IdDepartment = res.DepartmentId
