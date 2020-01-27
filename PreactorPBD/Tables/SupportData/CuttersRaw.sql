CREATE TABLE [SupportData].[CuttersRaw]
(
	[IdCutterRaw]			INT				NOT NULL PRIMARY KEY IDENTITY, 
    [Model]					NCHAR(30)		NOT NULL, 
    [TypeCutterId]			INT				NOT NULL, 
    [Title]					NVARCHAR(99)	NOT NULL, 
    CONSTRAINT [FK_CuttersRaw_ToCuttersType] FOREIGN KEY (TypeCutterId) REFERENCES [SupportData].[CutterType](IdCutterType)
)
