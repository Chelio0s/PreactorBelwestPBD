﻿CREATE TABLE [InputData].[Rout]
(
	[IdRout]			INT				NOT NULL PRIMARY KEY IDENTITY, 
    [Title]				NVARCHAR(199)	NOT NULL UNIQUE,
	[SemiProductId]		INT				NOT NULL, 
    [Priority]			INT				NOT NULL DEFAULT (0), 
    [CombineId]			INT				NULL, 
    [AreaId]			INT				NOT NULL, 
    [IsAutoGenerated]	BIT				NOT NULL DEFAULT (0), 
    [ParentRouteId]		INT				NULL, 
    [IsComplex]         BIT             NULL DEFAULT (0), 
    [IsCutters]         BIT             NULL DEFAULT (0), 
    [IsAutomat]         BIT             NULL DEFAULT (0), 
    CONSTRAINT [FK_Rout_ToSemiProduct]		FOREIGN KEY (SemiProductId)		REFERENCES [InputData].[SemiProducts](IdSemiProduct)
	ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT [FK_Rout_CombineRoutRules]	FOREIGN KEY ([CombineId])		REFERENCES [SupportData].[CombineRules](IdCombineRules),
	CONSTRAINT [FK_Rout_Areas]				FOREIGN KEY (AreaId)			REFERENCES [InputData].Areas(IdArea),
	CONSTRAINT [FK_Route_Route]				FOREIGN KEY ([ParentRouteId])	REFERENCES [InputData].[Rout]([IdRout])
)