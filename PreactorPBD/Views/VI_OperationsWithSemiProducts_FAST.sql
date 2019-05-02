--Представление через временную таблицу с индексами - Быстрая выборка
CREATE VIEW [InputData].[VI_OperationsWithSemiProducts_FAST]
	AS 
	SELECT 	   IdNomenclature
	  ,Article
	  ,Model
	  ,Nomenclature
      ,[Size]
	  ,semi.IdSemiProduct
	  ,semi.Title
	  ,KPO
	  ,Code
	  ,KTOPN
	  ,NTOP
	  ,PONEOB
	  ,NORMATIME
	  ,KOB
	  ,MOB
	  ,KPROF
	  ,IdProfession
	  ,CategoryOperation
	  ,TitlePreactorOper
	  ,seq.SimpleProductId
	  ,seq.OperOrder
	  ,REL
	FROM [SupportData].[TempOperations] as temp
	LEFT JOIN [SupportData].[SequenceOperations] as seq ON seq.KTOP = temp.KTOPN 
	LEFT JOIN [InputData].[SemiProducts] as semi ON semi.NomenclatureID = temp.IdNomenclature 											
												and seq.SimpleProductId = semi.SimpleProductId
	LEFT JOIN [InputData].[Professions] as proffs ON proffs.CodeRKV = KPROF
