CREATE VIEW [InputData].[VI_ResourcesOnDepartments]
	AS SELECT [IdResource]
      ,res.[Title] as resTitle
      ,[TitleWorkPlace]
      ,[KOB]
	  ,area.IdArea
	  ,area.KPO
	  ,area.Title	as Area
	  ,dep.Title	as Department
	  ,dep.IdDepartment
  FROM [InputData].[Resources] as res
  INNER JOIN [InputData].[Departments] as dep ON dep.IdDepartment = res.[DepartmentId]
  INNER JOIN [InputData].[Areas] as area ON area.IdArea = dep.AreaId 