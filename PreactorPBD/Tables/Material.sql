CREATE TABLE [InputData].[Material]
(
	[IdMaterial]			INT			 NOT NULL PRIMARY KEY IDENTITY, 
	[CodeMaterial]			NCHAR(99)	 NULL,
    [Title]					NVARCHAR(99) NOT NULL, 
    [AddictionAttribute]	NVARCHAR(99) NOT NULL, 
    [AddAttrName]			NVARCHAR(99) NOT NULL,
	[Thickness]				NVARCHAR(99) NOT NULL,
	[ColorCode]				NVARCHAR(10) NOT NULL,
	[ColorName]				NVARCHAR(99) NOT NULL,
	[MetricParam]			NVARCHAR(99) NULL,
	[SizeFrom]				DECIMAL(6,2) NULL,
	[SizeTo]				DECIMAL(6,2) NULL
)
