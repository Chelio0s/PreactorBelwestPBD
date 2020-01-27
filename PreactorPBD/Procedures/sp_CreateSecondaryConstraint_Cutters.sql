CREATE PROCEDURE [InputData].[sp_CreateSecondaryConstraint_Cutters]
AS
INSERT INTO [InputData].[SecondaryConstraints]
	 SELECT 
        [Title]
	    ,1							AS [TypeId]
	    ,'IdCutterRaw'				AS [ParamDescript]
	    ,IdCutterRaw
	 FROM [SupportData].[CuttersRaw]	
	 EXCEPT
	 SELECT   
		  [Title]
		  ,[TypeId]
		  ,[ParamDescript]
		  ,[Param]
	  FROM [InputData].[SecondaryConstraints]
RETURN 0
