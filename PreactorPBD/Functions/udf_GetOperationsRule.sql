CREATE FUNCTION [InputData].[udf_GetOperationsRule]
(
	@IdRule int,
	@IsParent bit
)
RETURNS @returntable TABLE
(
	IdRule int,
	KTOP int,
	IsParent bit
)

AS
BEGIN
	

IF @IsParent = 1
	BEGIN 
	INSERT INTO @returntable
	SELECT DISTINCT IdRule, oc.KTOP, CONVERT(bit, 1) as IsParent
	  FROM [SupportData].[RoutRoules] as rr 
	  INNER JOIN [SupportData].[ComposeOperation] as co ON co.idComposeOper = rr.OperationParentId
	  INNER JOIN [SupportData].[OperationСomposition] as oc ON oc.ComposeOperationId = co.idComposeOper
	  WHERE IdRule = @IdRule 
   END
ELSE 
   BEGIN
   INSERT INTO @returntable
	  SELECT DISTINCT IdRule, oc1.KTOP, CONVERT(bit, 0) as IsParent
	  FROM [SupportData].[RoutRoules] as rr 
	  INNER JOIN [SupportData].[ComposeOperation] as co1 ON co1.idComposeOper = rr.OperationChildId
	  INNER JOIN [SupportData].[OperationСomposition] as oc1 ON oc1.ComposeOperationId = co1.idComposeOper
	  WHERE IdRule = @IdRule
   END 
	RETURN
END
