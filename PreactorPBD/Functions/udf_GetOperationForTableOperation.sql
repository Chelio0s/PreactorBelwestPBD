CREATE FUNCTION [InputData].[udf_GetOperationForTableOperation]
(
	@SimpleProductId int
)
RETURNS @returntable TABLE
(
	Title nvarchar(99),
	NumberOp int,
	SimpleProductId int,
	--ProfessionId int,
	IdSemiProduct int, 
	OperOrder int
)
AS
BEGIN
	INSERT @returntable
	SELECT  
	[PreactorOperation]
	,ROW_NUMBER() over(partition by IdSemiProduct order by IdSemiProduct, OperOrder)*10 as opNum
	,SimpleProductId
   -- ,[InputData].[udf_GetSAPCodeProfession]([KPROF])
    ,IdSemiProduct
	,OperOrder
  FROM [InputData].[VI_OperationsRKVOnSemiProducts_SLOW]
 WHERE IdSemiProduct = @SimpleProductId and IdSemiProduct is not null
	RETURN
END
