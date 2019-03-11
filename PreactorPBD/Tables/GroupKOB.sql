CREATE TABLE [SupportData].[GroupKOB]
(
	[IdGroupKOB] INT NOT NULL PRIMARY KEY IDENTITY, 
    [GroupId] INT NOT NULL, 
    [KOB] INT NOT NULL, 
    [KTOPN] INT NOT NULL, 
    CONSTRAINT [FK_GroupKOB_ToGroups] FOREIGN KEY ([GroupId]) REFERENCES [Inputdata].[ResourcesGroup]([IdResourceGroup])
	ON UPDATE CASCADE
)
