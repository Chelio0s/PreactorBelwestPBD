CREATE TABLE [SupportData].[TempOperationForMapping]
(
	[Id]				INT				NOT NULL IDENTITY PRIMARY KEY,
	[IdRoute]			INT				NOT NULL,
	[TitleOperation]	NVARCHAR(99)	NOT NULL,
	[SemiProductId]		INT				NOT NULL,
	[IdProfession]		INT NOT NULL, 
    [CategoryOperation] INT NOT NULL, 
    [Code]				VARCHAR(4) NOT NULL, 
    [KTOPN]				INT NOT NULL, 
	[KOB]				INT NOT NULL, 
    [NORMATIME]			DECIMAL(6, 2) NOT NULL, 
    [REL] INT NOT NULL
  			
)
