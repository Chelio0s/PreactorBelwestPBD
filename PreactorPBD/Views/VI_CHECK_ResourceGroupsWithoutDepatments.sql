CREATE VIEW [InputData].[VI_CHECK_ResourceGroupsWithoutDepatments]
	AS  SELECT IdResourceGroup
               ,Title
        FROM [InputData].[ResourcesGroup] AS gr
        LEFT JOIN [SupportData].[DepartComposition] as dc ON gr.IdResourceGroup =  dc.ResourcesGroupId
        WHERE dc.DepartmentId IS NULL
