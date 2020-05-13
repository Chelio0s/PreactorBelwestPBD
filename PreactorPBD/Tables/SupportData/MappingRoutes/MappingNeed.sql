CREATE TABLE [SupportData].[MappingNeed]
(
	[IdMapNeed] INT NOT NULL PRIMARY KEY IDENTITY, 
    [AreaId] INT NOT NULL
	CONSTRAINT FK_MappingNeedToAreas FOREIGN KEY (AreaId) REFERENCES [InputData].[Areas] ([IdArea])
)
