CREATE PROCEDURE [InputData].[sp_CheckRoutes]
AS
DECLARE @TableObor as table(KOB int, Code nvarchar(5))
DECLARE @KOBTable as Table(KOB int, KCEH varchar(10), NCEH varchar(99), NPLOT varchar(99), KPO varchar (10),  KUCH int, MOB varchar(50))
DECLARE @CTE as Table(REL varchar(15), ART varchar(15), KPO varchar(10) COLLATE Cyrillic_General_BIN, KTOPN int, NTOP varchar(199), KOB int, NORMA decimal(6,2))

	
INSERT INTO @KOBTable
EXEC    [InputData].[pc_Select_Oralce_MPU]
		@selectCommandText = N'SELECT
   KOB
   ,KCEH
   ,NCEH
   ,NPLOT
   ,KPO
   ,KUCH
   ,MOB
FROM
    belwpr.ri_bind_ob_v
    GROUP BY    KOB
   ,KCEH
   ,NCEH
   ,NPLOT
   ,KPO
   ,KUCH
   ,MOB';


  
    --Выборка всех ТМ для заданных артикулов
    INSERT INTO @CTE 
	SELECT * FROM [InputData].[VI_OperationsFromRKV] WHERE ART in (SELECT title FROM [InputData].[Article])
	INSERT INTO @TableObor
	--Выборка оборудования которе есть в ТМ но нет в МПУ
	SELECT KOB,  areas.Code FROM @CTE  as cte
	INNER JOIN [InputData].[Areas] as areas ON CTE.KPO = areas.KPO
	GROUP BY KOB,  areas.Code
	EXCEPT
	SELECT DISTINCT KOB, KCEH FROM @KOBTable
	ORDER BY Code

	 

   	SELECT 'Проверка на пустые операции для планируемых артикулов' as [Проверка]
	,CASE WHEN EXISTS( SELECT * FROM @CTE WHERE LTRIM(RTRIM(KTOPN)) = '') 
		THEN CONVERT(bit, 'FALSE') ELSE CONVERT(bit, 'TRUE') END as [Статус]
	,CASE WHEN EXISTS( SELECT * FROM @CTE WHERE LTRIM(RTRIM(KTOPN)) = '') 
		THEN 'Артикула: '+(SELECT [InputData].[ctvf_ConcatWithoutDublicates](ART)
							 FROM @CTE  
						     WHERE  LTRIM(RTRIM(KTOPN))= '') ELSE '' END as [Значение]
	 UNION
	 SELECT 'Проверка на наличие норм времени в операциях'
	 ,CASE WHEN EXISTS(SELECT * FROM @CTE WHERE NORMA is null or NORMA = 0) THEN CONVERT(bit, 'FALSE') ELSE CONVERT(bit, 'TRUE') END
	 ,CASE WHEN EXISTS(SELECT * FROM @CTE  WHERE NORMA is null or NORMA = 0) 
		THEN 'Артикула: '+(SELECT [InputData].[ctvf_ConcatWithoutDublicates](ART)
							 FROM @CTE   WHERE NORMA is null or NORMA = 0) ELSE '' END as val 
	UNION 
	SELECT 'Наличие оборудования в цеху'
	,CASE WHEN EXISTS(SELECT * FROM @TableObor  WHERE Code in ('OP01', 'OP02')) THEN CONVERT(bit, 'FALSE') ELSE CONVERT(bit, 'TRUE') END
	,CASE WHEN EXISTS(SELECT * FROM @TableObor  WHERE Code in ('OP01', 'OP02')) THEN    
	(SELECT [InputData].[ctvf_ConcatWithoutDublicates](CONVERT(varchar(5), KOB)+' '+Code) FROM @TableObor WHERE Code in ('OP01', 'OP02')) ELSE '' END
	UNION
	SELECT 'Наличие не учтенных норм (16 ПФ) или оперций не привязанных к ПФ'
	,CASE WHEN EXISTS(	SELECT * FROM @CTE as cte 
						LEFT JOIN [SupportData].[SequenceOperations] as so ON so.KTOP = cte.KTOPN
						INNER JOIN [InputData].[Areas] as areas ON CTE.KPO = areas.KPO
						WHERE SimpleProductId  = 16 or SimpleProductId is null 
						and areas.Code in ('OP01')) THEN CONVERT(bit, 'FALSE') ELSE CONVERT(bit, 'TRUE') END
	,(SELECT [InputData].[ctvf_ConcatWithoutDublicates](ART+' Опер.:'+CONVERT(nvarchar(6),KTOPN)+' Цех:'+Code)  FROM @CTE as cte 
	LEFT JOIN [SupportData].[SequenceOperations] as so ON so.KTOP = cte.KTOPN
	INNER JOIN [InputData].[Areas] as areas ON CTE.KPO = areas.KPO
	WHERE SimpleProductId  = 16 or SimpleProductId is null 
	and areas.Code in ('OP01'))
    UNION
	SELECT 'Проверка на неиспользуемое обрудование в маршрутах'
	,CASE WHEN EXISTS(SELECT * FROM (SELECT KOB, KCEH FROM @KOBTable
									EXCEPT  
									SELECT KOB, areas.Code FROM @CTE as cte
									INNER JOIN [InputData].[Areas] as areas ON CTE.KPO = areas.KPO) as t) 
		  THEN CONVERT(bit, 'FALSE') ELSE CONVERT(bit, 'TRUE') END
	 ,(SELECT [InputData].[ctvf_ConcatWithoutDublicates](CONVERT(nvarchar(5),KCEH)+' Оборуд.:'+CONVERT(nvarchar(5), KOB)) 
									FROM (SELECT KOB, KCEH FROM @KOBTable
									EXCEPT  
									SELECT KOB, areas.Code FROM @CTE as cte
									INNER JOIN [InputData].[Areas] as areas ON CTE.KPO = areas.KPO) as t)
	UNION 
	SELECT 'Проверка на наличие размеров обуви'
	,CASE WHEN EXISTS(SELECT title, size, Percents from [InputData].[Article]
						OUTER APPLY [InputData].[ctvf_GetSizes](title) 
						WHERE size is null ) THEN CONVERT(bit, 'FALSE') ELSE CONVERT(bit, 'TRUE') END 
    ,(SELECT [InputData].[ctvf_ConcatWithoutDublicates](title) FROM [InputData].[Article]
						OUTER APPLY [InputData].[ctvf_GetSizes](title) 
						WHERE size is null)
RETURN 0
