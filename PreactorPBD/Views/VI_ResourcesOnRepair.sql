CREATE VIEW [InputData].[VI_ResourcesOnRepair]
	AS 
	SELECT 
	       [DepartmentId]
		  ,[KOB]
		  ,[Count]
		  ,[DateStart]
		  ,[DateEnd]
		  ,[IdResource]
		  ,[Title]
		  ,[Number]
	FROM 
	(
	SELECT
		   PlanRepairs.[DepartmentId]
		  ,PlanRepairs.[KOB]
		  ,[Count]
		  ,[DateStart]
		  ,[DateEnd]
		  ,Resources.IdResource
		  ,Resources.Title
		  ,ROW_NUMBER() OVER(Partition by PlanRepairs.[DepartmentId] ORDER BY Resources.TitleWorkPlace) as Number
	  FROM [SupportData].[Repairs] as PlanRepairs
	  INNER JOIN [InputData].[Resources] as Resources ON Resources.DepartmentId = PlanRepairs.DepartmentId
													  AND Resources.KOB = PlanRepairs.KOB
	) as q
	WHERE q.[Number] <= q.[Count]
