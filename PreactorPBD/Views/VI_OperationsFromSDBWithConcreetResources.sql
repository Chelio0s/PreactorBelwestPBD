-- Операции ПБД с конкретными рессурсами

CREATE VIEW [InputData].[VI_OperationsFromSDBWithConcreetResources]
	AS SELECT  [IdOperation]
	  ,res.IdResource
	  ,res.Title
	  ,res.DepartmentId
	  ,vioper.NORMATIME  as NORMATIME
  FROM  [InputData].[VI_OperationsFromSDBWithResGroups]			    as vioper	
  INNER JOIN  [SupportData].[DepartComposition]						as depcomp	ON depcomp.ResourcesGroupId = vioper.GroupId
  INNER JOIN  [InputData].[Resources]								as res		ON res.DepartmentId = depcomp.DepartmentId
																				AND res.KOB = vioper.KOB
