CREATE PROCEDURE [InputData].[sp_DeleteInappropriateRoutes]
AS
	DELETE FROM [InputData].[Rout] WHERE IdRout NOT IN 
	(
		SELECT DISTINCT op.RoutId FROM [InputData].[Operations] AS op
	)
RETURN 0
