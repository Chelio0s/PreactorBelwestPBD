CREATE PROCEDURE [InputData].[sp_PutResourcesIntoGroups]
AS
	TRUNCATE TABLE [InputData].[ResourcesInGroups]
	INSERT INTO [InputData].[ResourcesInGroups]
    SELECT DISTINCT
	[IdResourceGroup]
	,[IdResource] 
	FROM [InputData].[VI_ResourcesInGroups]
RETURN 0
