-- put particular equipment into repairs

CREATE PROCEDURE [InputData].[sp_PutResourcesOnRepair] AS
	 INSERT INTO [InputData].[ResourcesRepairs]
	 SELECT 
	  IdResource
	 ,DateStart
	 ,DateEnd
	 FROM [InputData].[VI_ResourcesOnRepair]
RETURN 0
