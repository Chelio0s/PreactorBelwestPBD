CREATE VIEW [InputData].[VI_MissingOperations]
	AS 

--Потерянные операции.. 
--Берем операции из РКВ и в InputData и сравниваем каких не хватает
SELECT DISTINCT [IdNomenclature]
      ,[Article]
      ,[Model]
      ,[Nomenclature]
      ,[Size]
      ,[IdSemiProduct]
      ,vi.[Title]
      ,[KPO]
      ,vi.[Code]
      ,vi.[KTOPN]
      ,[NTOP]
      ,[PONEOB]
      ,[NORMATIME]
      ,vi.[KOB]
      ,[MOB]
      ,[KPROF]
      ,[IdProfession]
      ,vi.[CategoryOperation]
      ,[TitlePreactorOper]
      ,[SimpleProductId]
      ,[OperOrder]
      ,[REL]
      ,[NPP]
  FROM [InputData].[VI_OperationsWithSemiProducts_FAST] as vi
  INNER JOIN [InputData].[Rout] as r ON r.SemiProductId = vi.IdSemiProduct
  INNER JOIN [InputData].[Operations] as oper ON oper.RoutId = r.IdRout  and TitlePreactorOper = oper.Title
  EXCEPT 
  SELECT DISTINCT [IdNomenclature]
      ,[Article]
      ,[Model]
      ,[Nomenclature]
      ,[Size]
      ,[IdSemiProduct]
      ,vi.[Title]
      ,[KPO]
      ,vi.[Code]
      ,vi.[KTOPN]
      ,[NTOP]
      ,[PONEOB]
      ,[NORMATIME]
      ,vi.[KOB]
      ,[MOB]
      ,[KPROF]
      ,[IdProfession]
      ,vi.[CategoryOperation]
      ,[TitlePreactorOper]
      ,[SimpleProductId]
      ,[OperOrder]
      ,[REL]
      ,[NPP]
  FROM [InputData].[VI_OperationsWithSemiProducts_FAST] as vi
  INNER JOIN [InputData].[Rout] as r ON r.SemiProductId = vi.IdSemiProduct
  INNER JOIN [InputData].[Operations] as oper ON oper.RoutId = r.IdRout  and TitlePreactorOper = oper.Title
  LEFT JOIN [SupportData].[GroupKOB] as groupkob ON groupkob.KTOPN = vi.KTOPN
  LEFT JOIN [InputData].[ResourcesGroup] as resgroup ON resgroup.IdResourceGroup = groupkob.[GroupId]
  INNER JOIN [InputData].[Resources] as res ON res.KOB = vi.KOB 
  
