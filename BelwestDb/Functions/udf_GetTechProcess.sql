CREATE FUNCTION [dbo].[udf_GetTechProcess]
(
)
RETURNS @returntable TABLE
(
	 RoutCode varchar(30),
	 SemiProductName varchar(50),
	 OperationCode varchar(24),
	 OperationNumber char(4),
	 OperationNextNumber char(4),
	 OperationName varchar(100) 
)
AS
BEGIN
	INSERT @returntable
	SELECT 
r.IdRout AS RoutCode
,sp.Title AS SemiProductName
,op.IdOperation AS OperationCode
,op.NumberOp AS OperationNumber
,LEAD(op.NumberOp) OVER(PARTITION BY op.RoutId ORDER BY op.NumberOp) AS OperationNextNumber
,op.Title AS OperationName
FROM [PreactorSDB].[InputData].[Rout] AS r
INNER JOIN [PreactorSDB].[InputData].[SemiProducts] AS sp ON sp.IdSemiProduct = r.SemiProductId 
INNER JOIN [PreactorSDB].[InputData].[Operations] AS op ON op.RoutId = R.IdRout

	RETURN
END
