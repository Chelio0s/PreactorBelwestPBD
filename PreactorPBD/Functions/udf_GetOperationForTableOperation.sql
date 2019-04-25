CREATE FUNCTION [InputData].[udf_GetOperationForTableOperation]
(
	@IdNomenclature int
)
RETURNS @returntable TABLE
(
	Title nvarchar(99),
	NumberOp int,
	SemiProductId int,
	ProfessionId int
)
AS
BEGIN
	INSERT @returntable
	SELECT  
	[PreactorOperation]
	,ROW_NUMBER() over(partition by IdSemiProduct order by IdSemiProduct ) as opNum
      ,[Model]
      ,[Article]
      ,[Nomenclature]
      ,[Size]
      ,[IdSemiProduct]
      ,[Title]
      ,[KPO]
      ,[Code]
      ,[KTOPN]
      ,[NTOP]
      ,[PONEOB]
      ,[NORMATIME]
      ,[KOB]
      ,[MOB]
      ,[KPROF]
      
  FROM [InputData].[VI_OperationsRKVOnSemiProducts]
  WHERE IdNomenclature = 918 and IdSemiProduct is not null
	RETURN
END
