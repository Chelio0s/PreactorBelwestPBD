CREATE PROCEDURE [InputData].[sp_InsertEquipmentWithDelete]
AS
	DELETE FROM [InputData].[Resources]
    INSERT INTO [InputData].[Resources]
           ([IdResource]
           ,[Title]
           ,[TitleWorkPlace]
           ,[DepartmentId]
           ,[KOB])
    SELECT ROW_NUMBER() OVER(ORDER BY KPLOT, WP) as Id
    ,  CONCAT ( mob, ' : Уч-ок ',KPLOT  ,' : Раб. место: ', WP )   as Title  
    ,WP
    ,KPLOT
    ,KOB
    FROM OPENQUERY(MPU,'SELECT KPLOT, WP, bind.KOB, obor.mob FROM belwpr.ri_bind_ob bind 
                INNER JOIN belwpr.st_obor obor ON bind.KOB = obor.KOB
				ORDER BY KPLOT, WP')

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
