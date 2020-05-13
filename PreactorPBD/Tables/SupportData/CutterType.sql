--types of cutters
CREATE TABLE [SupportData].[CutterType]
(
	[IdCutterType]	INT				NOT NULL PRIMARY KEY IDENTITY, 
    [Title]			NVARCHAR(99)	NOT NULL UNIQUE
)
