-- Время начала смен 
CREATE VIEW [InputData].[VI_SttingShiftWithDateStart]
	AS SELECT TOP 100 PERCENT
       [IdSettingShiftUseFrom]
      ,[IdSettingShift]
      ,[AreaId]
	  ,area.Title
      ,[ShiftId]
      ,[TimeStart]
	  ,ssuf.[StartUseFrom]
	  ,[SpecificOrgUnit]
  FROM [SupportData].[SettingShift]			     as ss
  INNER JOIN [SupportData].[SettingShiftUseFrom] as ssuf ON ssuf.[SettingShiftId] = ss.IdSettingShift
  INNER JOIN [InputData].[Areas]				 as area ON area.IdArea = ss.AreaId
  ORDER BY [StartUseFrom] DESC
