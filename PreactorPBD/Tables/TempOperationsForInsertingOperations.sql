CREATE TABLE [SupportData].[TempOperationsForInsertingOperations]
(
	[Id]				INT NOT NULL PRIMARY KEY IDENTITY,
	[idRout]			INT NOT NULL, 
	[TitleOperPr]		NVARCHAR(99) NOT NULL, 
	[IdSemiProduct]		INT NOT NULL, 
	[idProfesson]		INT NOT NULL, 
	[TypeTime]			INT NOT NULL, 
	[CategoryOperation] INT NOT NULL, 
	[OperOrder]			INT NOT NULL, 
	[Code]				VARCHAR(4) NOT NULL, 
	[NPP]				INT NOT NULL, 
	[KTOPN]				INT NOT NULL,
	[REL]				NCHAR(15) NOT NULL,
	[IsMappingRule]		bit NOT NULL
)
