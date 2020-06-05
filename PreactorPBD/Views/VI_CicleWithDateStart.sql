CREATE VIEW [InputData].[VI_CicleWithDateStart]
	AS SELECT TOP 100 PERCENT [IdCicleUseFrom]
      ,[CicleId]
      ,[StartUseFrom]
	  ,cc.[DurationWork]
	  ,cc.[DurationOff]
      ,[SpecificOrgUnit]
	  ,cc.[ShiftId]
	  ,cc.[AreaId]
      ,area.[Title]
  FROM [SupportData].[CicleUseFrom]      AS cuf 
  INNER JOIN [SupportData].[Cicle]		 AS cc      ON cc.IdCicle = cuf.CicleId
  INNER JOIN [InputData].[Areas]         AS area    ON area.IdArea = cc.AreaId        
  ORDER BY [StartUseFrom] DESC, cc.AreaId, ShiftId, SpecificOrgUnit, CicleId