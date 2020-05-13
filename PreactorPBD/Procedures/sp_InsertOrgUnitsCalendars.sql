CREATE PROCEDURE [InputData].[sp_InsertOrgUnitsCalendars]

AS
TRUNCATE TABLE [InputData].[EmployeesCalendar]
	INSERT INTO [InputData].[EmployeesCalendar]
           ([OrgUnit]
           ,[Start]
           ,[End])
	SELECT  [OrgUnit]
      ,[StartWork]
      ,[EndWork]
  FROM [InputData].[VI_WorkHoursForOrgUnit]
  ORDER BY StartWork
RETURN 0
