--used cutters for operations
CREATE TABLE [SupportData].[CuttersForKTOPs]
(
	[IdCutterForKTOP]		INT				NOT NULL PRIMARY KEY IDENTITY, 
    [KTOP]					INT				NOT NULL UNIQUE, 
    [TypeCutterId]			INT				NOT NULL, 
    [UseCount]				DECIMAL(4, 2)	NOT NULL
	CONSTRAINT FK_Cutters_Types FOREIGN KEY([TypeCutterId]) REFERENCES [SupportData].[CutterType](IdCutterType)
)
