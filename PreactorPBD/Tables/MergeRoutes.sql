CREATE TABLE [SupportData].[MergeRoutes]
(
	[IdMergeRoutes] INT NOT NULL PRIMARY KEY IDENTITY, 
    [KtopPrentRoute] INT NOT NULL, 
    [KtopChildRoute] INT NOT NULL, 
    [BaseAreaId] INT NOT NULL, 
    [ChildAreaId] INT NOT NULL
	CONSTRAINT FK_MERGEROUTES_BASE_TO_AREA FOREIGN KEY([BaseAreaId]) REFERENCES InputData.Areas(IdArea),
	CONSTRAINT FK_MERGEROUTES_CHILD_TO_AREA FOREIGN KEY([ChildAreaId]) REFERENCES InputData.Areas(IdArea),
	CONSTRAINT UK_CONSTRAINT_MERGEROUTE UNIQUE([KtopPrentRoute], [KtopChildRoute], [BaseAreaId], [ChildAreaId])
)
