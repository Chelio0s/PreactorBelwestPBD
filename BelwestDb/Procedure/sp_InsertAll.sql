CREATE PROCEDURE [dbo].[sp_InsertAll]
AS
TRUNCATE TABLE ART
TRUNCATE TABLE OPE
TRUNCATE TABLE ORDERS
TRUNCATE TABLE LINKS
TRUNCATE TABLE MACH
TRUNCATE TABLE BOM
TRUNCATE TABLE PHAS


DECLARE @routs AS TABLE (
IdRout int, 
RoutCode varchar(50),
ArtVersion int
)
INSERT @routs
SELECT r.IdRout,
REPLACE(nom.Number_, ' ','_')+'_'+CAST(sp.SimpleProductId AS varchar(max))+'_' + CAST (ROW_NUMBER() OVER (PARTITION BY nom.IdNomenclature , sp.SimpleProductId ORDER BY IdSemiProduct) - 1 AS varchar(max)) AS [RoutCode],
ROW_NUMBER() OVER (PARTITION BY nom.IdNomenclature , sp.SimpleProductId ORDER BY IdSemiProduct) - 1 AS ArtVersion
FROM [PreactorSDB].[InputData].[Rout] AS r
INNER JOIN [PreactorSDB].[InputData].[SemiProducts] AS sp ON r.SemiProductId = sp.IdSemiProduct
INNER JOIN [PreactorSDB].[InputData].[Nomenclature] AS nom ON nom.IdNomenclature = sp.NomenclatureID
INNER JOIN [PreactorSDB].[InputData].[Article] AS art ON nom.ArticleId = art.IdArticle
INNER JOIN [PreactorSDB].[SupportData].[Orders] AS ord ON art.IdArticle = ord.ArticleId


	print('Загрузка артикулов')
	--Артикула 
	INSERT ART
	SELECT 
	art.Title AS [CODEARTIC]
	,art.Title AS[LIBARTIC]
	,0 AS [VER_ART]
	,NULL AS [NOMG]
	,NULL AS [BOM]
	,'PF' AS [TYPEMATI]
	,'ПАРА' AS [UTIL] 
	FROM [PreactorSDB].[InputData].[Article] AS art
	INNER JOIN [PreactorSDB].[SupportData].[Orders] AS ord ON art.IdArticle = ord.ArticleId

	--Номенклатура
	INSERT ART
	SELECT REPLACE(Number_,' ','_') AS [CODEARTIC]
	,REPLACE(Number_,' ','_')  AS[LIBARTIC]
	,0 AS [VER_ART]
	,NULL AS [NOMG]
	,NULL AS [BOM]
	,'SF' AS [TYPEMATI]
	,'ПАРА' AS [UTIL] 
	FROM [PreactorSDB].[InputData].[Nomenclature] AS nom
	INNER JOIN [PreactorSDB].[InputData].[Article] AS art ON art.IdArticle  = nom.ArticleId
	INNER JOIN [PreactorSDB].[SupportData].[Orders] AS ord ON art.IdArticle = ord.ArticleId

	--ПФ 
	INSERT ART
	SELECT 
	REPLACE(nom.Number_, ' ','_')+'_'+CAST(sp.SimpleProductId AS varchar(max))  AS [CODEARTIC]
	,sp.Title AS[LIBARTIC]
	,rt.ArtVersion AS [VER_ART]
	,rt.RoutCode AS [NOMG]
	,NULL AS [BOM]
	,'SF' AS [TYPEMATI]
	,'ПАРА' AS [UTIL] 
	FROM [PreactorSDB].[InputData].[SemiProducts] AS sp
	INNER JOIN [PreactorSDB].[InputData].[Nomenclature] AS nom ON nom.IdNomenclature = sp.NomenclatureID
	INNER JOIN [PreactorSDB].[InputData].[Rout] AS r ON r.SemiProductId = sp.IdSemiProduct
	INNER JOIN [PreactorSDB].[InputData].[Article] AS art ON nom.ArticleId = art.IdArticle
	INNER JOIN [PreactorSDB].[SupportData].[Orders] AS ord ON art.IdArticle = ord.ArticleId
	INNER JOIN @routs AS rt ON rt.IdRout = r.IdRout
	--Материалы
	INSERT ART
	SELECT DISTINCT CodeMaterial AS [CODEARTIC]
	,mat.Title AS[LIBARTIC]
	,0 AS [VER_ART]
	,NULL AS [NOMG]
	,NULL AS [BOM]
	,'MP' AS [TYPEMATI]
	,NEI AS [UTIL] 
	FROM    [PreactorSDB].[InputData].[Material] AS mat
	INNER JOIN [PreactorSDB].[InputData].[Specifications] AS spec ON spec.MaterialId = mat.IdMaterial
	INNER JOIN [PreactorSDB].[InputData].[Operations] AS op ON op.IdOperation = spec.OperationId
	INNER JOIN [PreactorSDB].[InputData].[Rout] AS r ON r.IdRout = op.RoutId
	INNER JOIN [PreactorSDB].[InputData].[SemiProducts] AS sp ON sp.IdSemiProduct = r.SemiProductId
	INNER JOIN [PreactorSDB].[InputData].[Nomenclature] AS nom ON nom.IdNomenclature = sp.NomenclatureID
	INNER JOIN [PreactorSDB].[InputData].[Article] AS art ON art.IdArticle = nom.ArticleId
	INNER JOIN [PreactorSDB].[SupportData].[Orders] AS ord ON ord.ArticleId = art.IdArticle
	INNER JOIN [PreactorSDB].[SupportData].[KEI] AS k ON k.KEI = spec.KEI
	INNER JOIN @routs AS tabl ON tabl.IdRout = r.IdRout

	print('Загрузка ресурсов')
	INSERT MACH
	SELECT * FROM udf_GetResourceFromSDB();

	print('Загрузка операций')
	INSERT OPE
	SELECT
	tabl.RoutCode AS [NOMG]
,r.Title AS LIBNOMG
,KTOP AS OPE  
,op.Title AS LIBOPE
,rg.IdResourceGroup AS ILOT
,res.IdResource AS MACHINE
,'МИН' AS UNIT
,opinres.OperateTime AS DURREAL
,10 AS RUC
,NULL AS THM
,5 AS Priorite
FROM 
[PreactorSDB].[InputData].[Rout] AS r
INNER JOIN [PreactorSDB].[InputData].[SemiProducts] AS sp ON r.SemiProductId = sp.IdSemiProduct
INNER JOIN [PreactorSDB].[InputData].[Operations] AS op ON r.IdRout = op.RoutId
INNER JOIN [PreactorSDB].[InputData].[OperationInResource] AS opinres  ON opinres.OperationId = op.IdOperation
INNER JOIN [PreactorSDB].[InputData].[Resources] AS res ON res.IdResource = opinres.ResourceId
INNER JOIN [PreactorSDB].[InputData].[ResourcesInGroups] AS rig ON res.IdResource = rig.ResourceId
INNER JOIN [PreactorSDB].[InputData].[ResourcesGroup] AS rg ON rg.IdResourceGroup = rig.GroupResourcesId
INNER JOIN [PreactorSDB].[InputData].[OperationWithKTOP] AS owk ON owk.OperationId = op.IdOperation
INNER JOIN [PreactorSDB].[InputData].[Nomenclature] AS nom ON nom.IdNomenclature = sp.NomenclatureID
INNER JOIN [PreactorSDB].[InputData].[Article] AS art ON nom.ArticleId = art.IdArticle
INNER JOIN [PreactorSDB].[SupportData].[Orders] AS ord ON art.IdArticle = ord.ArticleId
INNER JOIN @routs AS tabl ON tabl.IdRout = r.IdRout

	print('Загрузка техпроцессов')
	INSERT PHAS
	SELECT 
tabl.RoutCode AS NOMG
,sp.Title AS LIBNOMG
,owk.KTOP AS OPE
,op.NumberOp AS START_PHASE
,LEAD(op.NumberOp) OVER(PARTITION BY op.RoutId ORDER BY op.NumberOp) AS END_PHASE
,op.Title AS LIBOPE
FROM [PreactorSDB].[InputData].[Rout] AS r
INNER JOIN [PreactorSDB].[InputData].[SemiProducts] AS sp ON sp.IdSemiProduct = r.SemiProductId 
INNER JOIN [PreactorSDB].[InputData].[Operations] AS op ON op.RoutId = R.IdRout
INNER JOIN [PreactorSDB].[InputData].[OperationWithKTOP] AS owk ON owk.OperationId = op.IdOperation
INNER JOIN [PreactorSDB].[InputData].[Nomenclature] AS nom ON nom.IdNomenclature = sp.NomenclatureID
INNER JOIN [PreactorSDB].[InputData].[Article] AS art ON nom.ArticleId = art.IdArticle
INNER JOIN [PreactorSDB].[SupportData].[Orders] AS ord ON art.IdArticle = ord.ArticleId
INNER JOIN @routs AS tabl ON tabl.IdRout = r.IdRout
WHERE  owk.KTOP not in (5580, 5494)


	print('Загрузка спецификаций')
	INSERT BOM
SELECT 
	REPLACE(nom.Number_, ' ','_')+'_'+CAST(sp.SimpleProductId AS varchar(max))  AS b_v_codeartic
	,sp.Title b_v_libartic
	,NULL AS BOM_ver
	,tabl.RoutCode AS VER_ART
	,CodeMaterial AS codeartic
	,mat.Title AS libartic
	,1 AS qteref
	,spec.Norma AS qtenec
	,op.NumberOp AS nophase
	FROM       [PreactorSDB].[InputData].[Material] AS mat
	INNER JOIN [PreactorSDB].[InputData].[Specifications] AS spec ON spec.MaterialId = mat.IdMaterial
	INNER JOIN [PreactorSDB].[InputData].[Operations] AS op ON op.IdOperation = spec.OperationId
	INNER JOIN [PreactorSDB].[InputData].[Rout] AS r ON r.IdRout = op.RoutId
	INNER JOIN [PreactorSDB].[InputData].[SemiProducts] AS sp ON sp.IdSemiProduct = r.SemiProductId
	INNER JOIN [PreactorSDB].[InputData].[Nomenclature] AS nom ON nom.IdNomenclature = sp.NomenclatureID
	INNER JOIN [PreactorSDB].[InputData].[Article] AS art ON art.IdArticle = nom.ArticleId
	INNER JOIN [PreactorSDB].[SupportData].[Orders] AS ord ON ord.ArticleId = art.IdArticle
	INNER JOIN [PreactorSDB].[SupportData].[KEI] AS k ON k.KEI = spec.KEI
	INNER JOIN @routs AS tabl ON tabl.IdRout = r.IdRout


	 DECLARE @art varchar(max)

  DECLARE curs CURSOR FOR 
     SELECT art.Title
     FROM [PreactorSDB].[SupportData].[Orders] AS ord
	 INNER JOIN [PreactorSDB].[InputData].[Article] AS art ON ord.ArticleId = art.IdArticle

	  OPEN curs
   FETCH NEXT FROM curs INTO @art
   WHILE @@FETCH_STATUS = 0
   BEGIN
		print 'Создание заказа для ' + @art
        exec [dbo].[cssp_InsertOrder] @art
        FETCH NEXT FROM curs INTO @art
   END
   CLOSE curs
   DEALLOCATE curs

   print 'Удаление неиспользуемых рабочих центорв'

   DELETE FROM [dbo].[MACH]
   WHERE ILOT + MACHINE IN (
   select m.ILOT + m.MACHINE from ope as o
	right join mach as m on m.ilot = o.ILOT and m.MACHINE = o.MACHINE
	where o.MACHINE is null)

	print 'Удаление заказов которых нет в ART'

	DELETE FROM  [dbo].[ORDERS] WHERE NOF IN (select NOF from orders as o
	left join art as a on a.codeartic  = o.codeartic
	where a.CODEARTIC is null)
	
	DELETE FROM [dbo].[LINKS] WHERE [B_P_NOF] IN (select NOF from orders as o
	left join art as a on a.codeartic  = o.codeartic
	where a.CODEARTIC is null) OR [NOF] IN (select NOF from orders as o
	left join art as a on a.codeartic  = o.codeartic
	where a.CODEARTIC is null)

RETURN 0
