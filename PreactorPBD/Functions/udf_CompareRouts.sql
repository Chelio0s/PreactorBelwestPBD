CREATE FUNCTION [InputData].[udf_CompareRouts]
(
	@IdSemiProduct int,
	@AreaId int
)
RETURNS @returntable TABLE
(
	NPP				int,
	IdSemiProduct	int,
	Article			nvarchar(99),
	SimpleProductId int,
	KtopParent		int,
	KobParent		int,
	KtopChild		int,
	KobChild		int,
	IsException		varchar(2),
	KTOPException	int
)
AS
BEGIN

DECLARE @table table (KTOPParent int, KOBParent int, KTOPChild int, KOBChild int)
INSERT INTO @table
SELECT * FROM [InputData].[ctvf_GetFinalRoutForOtherPlaceSemiProduct] (@IdSemiProduct, @AreaId)

INSERT INTO @returntable
SELECT DISTINCT NPP
      ,[IdSemiProduct]			as [IdSemiProduct]
      ,Article					as Article
      ,[SimpleProductId]		as SimpleProductId
	  ,vi.KTOPN					as KtopParent
	  ,vi.KOB					as KobParent
	  ,t.KTOPChild
	  ,t.KOBChild
	  ,CASE WHEN nt.KTOP is null THEN '-' ELSE '+' END
	  ,nt.KTOP
  FROM [InputData].[VI_OperationsWithSemiProducts_FAST] as vi
  LEFT JOIN @table as t ON t.KTOPParent = vi.KTOPN
  LEFT JOIN [SupportData].[NotMappingOperations] as nt ON nt.KTOP = vi.KTOPN
  WHERE IdSemiProduct = @IdSemiProduct and Code = 'OP02'
  ORDER BY NPP

  RETURN
END
