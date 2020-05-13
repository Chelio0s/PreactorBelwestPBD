CREATE PROCEDURE [InputData].[sp_InsertSpecifications]
AS
    TRUNCATE TABLE  [InputData].[Specifications]
    INSERT INTO [InputData].[Specifications]
	SELECT IdMaterial, NORMA, IdOperation, KEI 
	FROM 
	(
		SELECT 
		ROW_NUMBER() OVER(PARTITION BY IdMaterial, RoutId ORDER BY NumberOp) AS Rn, * FROM -- нам нужн поставить материалы из паспорта на одну операцию
																						   -- операций может быть много которые потребляют мат. но норма одна на всех
		(
			SELECT DISTINCT  
			  MAT.IdMaterial
			  ,TM.NORMA
			  ,Op.IdOperation
			  ,Op.NumberOp
			  ,TM.KEI
			  ,OP.RoutId  
		  FROM [InputData].[VI_OperationsFromSDBWithREL]			AS	OP
		  LEFT JOIN [SupportData].[TempMaterials]					AS	TM	ON  TM.REL = OP.REL
																			AND ((TM.PROT <= Size AND TM.PRTO >= Size) 
																			OR (TM.PROT IS NULL OR TM.PRTO IS NULL))
		  INNER JOIN [InputData].[Material]							AS MAT  ON  MAT.CodeMaterial = TM.FKGR
																			AND MAT.AddictionAttribute = TM.DOP
																			AND MAT.Thickness = TM.TOL
																			AND MAT.ColorCode = TM.KC
																			AND ISNULL(MAT.MetricParam, 0) = ISNULL(TM.[PARAM],0) 
		  WHERE NORMA IS NOT NULL 
		) AS TempQuery
	)	AS FinalQuery
	WHERE Rn = 1
RETURN 0


