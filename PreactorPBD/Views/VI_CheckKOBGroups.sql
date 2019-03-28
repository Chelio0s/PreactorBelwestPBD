--Выборка тех операций, которые встречаются в нескольких группах в пределах одного цеха
-- Если таких нет, то все ОК
CREATE VIEW [InputData].[VI_CheckKOBGroups]
	AS 

	SELECT 
      [KOB]
      ,[KTOPN]
      ,COUNT(*) as count_
	  ,AreaId as Цех
  FROM [SupportData].[GroupKOB] as kob
  INNER JOIN [InputData].[ResourcesGroup] as resgr ON resgr.IdResourceGroup = kob.[GroupId]
  GROUP BY [KOB]
      ,[KTOPN],AreaId

	  HAVING COUNT(*) >1