﻿CREATE TABLE [SupportData].[GroupKOB]
(
	[IdGroupKOB] INT NOT NULL PRIMARY KEY IDENTITY, 
    [GroupId] INT NOT NULL, 
    [KOB] INT NOT NULL, 
    [KTOPN] INT NOT NULL, 
    [AreaId] INT NULL, 
    CONSTRAINT [FK_GroupKOB_ToGroups] FOREIGN KEY ([GroupId]) REFERENCES [Inputdata].[ResourcesGroup]([IdResourceGroup])
	ON UPDATE CASCADE, 
    CONSTRAINT [FK_GroupKOB_ToArea] FOREIGN KEY (AreaId) REFERENCES [Inputdata].Areas([IdArea])
	ON DELETE SET NULL ON UPDATE SET NULL

)
