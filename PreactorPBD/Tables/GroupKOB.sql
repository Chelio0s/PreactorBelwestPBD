CREATE TABLE [SupportData].[GroupKOB]
(
	[IdGroupKOB]		INT				NOT NULL PRIMARY KEY IDENTITY, 
    [GroupId]			INT				NOT NULL, 
    [KOB]				INT				NOT NULL, 
    [KTOPN]				INT				NOT NULL, 
    [AreaId]			INT				NOT NULL, 
    [DateChanged]		DATETIME		NOT NULL DEFAULT(GETDATE()), 
    [User]				NVARCHAR(99)	NOT NULL DEFAULT(SUSER_SNAME()), 
    [FromMappingRules]	BIT				NOT NULL, 
    CONSTRAINT [FK_GroupKOB_ToGroups]			FOREIGN KEY ([GroupId]) 
												REFERENCES [InputData].[ResourcesGroup]([IdResourceGroup])
	ON UPDATE CASCADE ON DELETE CASCADE, 
    CONSTRAINT [FK_GroupKOB_ToArea]				FOREIGN KEY (AreaId) 
												REFERENCES [InputData].Areas([IdArea]), 
    CONSTRAINT [UK_GroupKOB_KOB_KTOPN_AreaId]	UNIQUE(KOB,KTOPN, AreaId)
)
