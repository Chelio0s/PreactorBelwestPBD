CREATE VIEW [System].[MissingIndexesCost]
	AS 
	SELECT (GS.user_seeks + GS.user_scans) * GS.avg_total_user_cost*GS.avg_user_impact AS TotalCost
	,gs.user_seeks
	,gs.user_scans
	,gs.unique_compiles
	,gs.avg_total_user_cost
	,gs.avg_user_impact
	,det.database_id
	,det.inequality_columns
	,det.equality_columns
	,det.included_columns
	
	FROM sys.dm_db_missing_index_group_stats	AS GS
	INNER JOIN sys.dm_db_missing_index_groups	AS G	ON G.index_group_handle = GS.group_handle
	INNER JOIN sys.dm_db_missing_index_details	AS DET	ON DET.index_handle = G.index_handle