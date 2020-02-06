CREATE PROCEDURE [InputData].[sp_InsertEquipmentWithDelete]
AS
	DELETE FROM [InputData].[Resources]
	EXEC [InputData].[pc_InsertEquipmentIntoPreactorDB]

	INSERT INTO [InputData].[Resources]
           ([IdResource]
           ,[Title]
           ,[TitleWorkPlace]
           ,[DepartmentId]
           ,[KOB])
    SELECT
    ROW_NUMBER() OVER (Order by IdDepartment) + (SELECT MAX([IdResource]) FROM [InputData].[Resources])
    ,'Фиктивный рессурс для не назначенных операций: Уч-ок '+ CONVERT(NVARCHAR(10), IdDepartment) +' : Раб. место: ' + CONVERT(NVARCHAR(10), -1)
    ,-1
    ,IdDepartment
    ,-1
    FROM [InputData].[Departments]

RETURN 0
