CREATE VIEW [InputData].[VI_EmployeesWorkHours]
	AS 
	SELECT top(1000000) [Name] as [EmpName]
      ,[TabNum] as [EmpTab]
      ,emp.OrgUnit as [EmpOrg]
	  ,wd.DateWorkDay as [EmpWorkDate]
	  ,[ShiftId]
	  ,org.Crew 
	  ,AreaId
	  ,Title
	  ,StartWork
	  ,EndWork
  FROM [InputData].[Employees] as emp
  CROSS JOIN [SupportData].[WorkDays]  as wd
  INNER JOIN [SupportData].[OrgUnit] as org ON org.OrgUnit = emp.OrgUnit
  CROSS APPLY  [InputData].[ctvf_GetWorkTimeSummAccounting](org.OrgUnit, wd.DateWorkDay) as ca
  WHERE wd.Crew = org.Crew 
  ORDER BY emp.TabNum, wd.DateWorkDay