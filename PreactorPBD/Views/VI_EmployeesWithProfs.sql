CREATE VIEW [InputData].[VI_EmployeesWithProfs]
	AS
	SELECT [Name]
      ,[TabNum]
      ,emp.[Orgunit]
	  ,org.Title as OrgTitle
	  ,org.Crew
	  ,empInProf.ProfessionId
	  ,empInProf.CategoryProfession
	  ,prof.Title as TitleProf
  FROM [InputData].[Employees] as emp
  INNER JOIN [SupportData].[Orgunit] as org ON org.OrgUnit = emp.Orgunit
  INNER JOIN [InputData].[EmployeesInProfession] as empInProf ON empInProf.EmployeeId = emp.TabNum
  INNER JOIN [InputData].[Professions] as prof ON prof.IdProfession = empInProf.ProfessionId 