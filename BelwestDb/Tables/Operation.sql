CREATE TABLE [dbo].[Operation]
(
	RoutCode varchar(30) NULL,
	RoutName varchar(100) NULL,
	OperationCode varchar(100) NULL,
	OperationName varchar(100) NULL,
	ResourceGroupCode varchar(100) NULL,
	ResourceCode varchar(100) NULL,
	Unit varchar(10) NULL,
	Performance Numeric (10,3) NULL,
    RUC int NULL,
	TPZ Numeric (4,3) NULL,
	PriorityOnResource varchar(10) NULL
)
