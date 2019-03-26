CREATE VIEW [InputData].[VI_WorkHoursForOrgUnit]
	AS 
	
	--Выборка OrgUnit кто работает 5-3-5-2
SELECT OrgUnit,  AreaId, org.Title as OrgTitle, code, areas.Title, DateWorkDay, ShiftId, wd.Crew as wdCrew, StartWork, EndWork
FROM [SupportData].[Orgunit] as org
INNER JOIN [InputData].[Areas] as areas ON areas.IdArea = org.AreaId
CROSS JOIN [SupportData].[WorkDays] as wd
OUTER APPLY [InputData].[ctvf_GetWorkTimeSummAccounting](org.OrgUnit, wd.DateWorkDay)
WHERE wd.Crew = org.Crew and OrgUnit in (50000457,
50000459
,50036706
,50000461
,50032499
,50036709
,50000464
,50000463
,50036715
,50000466
,50000467
,50036716
,50000471
,50000472
,50036717)

--Выборка OrgUnit кто работает в 1 смену 5 дней
UNION SELECT OrgUnit,  AreaId, org.Title as OrgTitle, code, areas.Title, DateWorkDay, ShiftId, wd.Crew as wdCrew, StartWork, EndWork
FROM [SupportData].[Orgunit] as org
INNER JOIN [InputData].[Areas] as areas ON areas.IdArea = org.AreaId
CROSS JOIN [SupportData].[WorkDays] as wd
OUTER APPLY [InputData].[ctvf_GetWorkTime1Shift](org.OrgUnit, wd.DateWorkDay)
WHERE OrgUnit in (50000451, 50000473, 50000460, 50008990, 50001844, 50001846) and ShiftId = 1 
--Отсев субботы и вс.
and (DATEPART(WEEKDAY,DateWorkDay) <>6 and DATEPART(WEEKDAY,DateWorkDay) <>7)

--Выборка OrgUnit кто работает в 2 смены 5 дней
UNION SELECT  
OrgUnit,  AreaId, org.Title as OrgTitle, code, areas.Title, DateWorkDay, ShiftId, wd.Crew as wdCrew, StartWork, EndWork
FROM [SupportData].[Orgunit] as org
INNER JOIN [InputData].[Areas] as areas ON areas.IdArea = org.AreaId
CROSS JOIN [SupportData].[WorkDays] as wd
OUTER APPLY [InputData].[ctvf_GetWorkTime2Shifts](org.OrgUnit, wd.DateWorkDay)
WHERE OrgUnit in (50033716,50033718,50033722,50033723) 
--Отсев субботы и вс.
and (DATEPART(WEEKDAY,DateWorkDay) <>6 and DATEPART(WEEKDAY,DateWorkDay) <>7) 
and ShiftId = [InputData].[udf_GetShiftNumber](OrgUnit, DateWorkDay)
