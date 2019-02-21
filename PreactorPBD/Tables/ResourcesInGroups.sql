CREATE TABLE [dbo].[ResourcesInGroups]
(
	[GroupResourcesId] INT NOT NULL , 
    [ResourceId] INT NOT NULL, 
    PRIMARY KEY ([ResourceId], [GroupResourcesId]), 
    CONSTRAINT [FK_ResourcesInGroups_ToResources] FOREIGN KEY (ResourceId) REFERENCES [Resources](IdResource),
	CONSTRAINT [FK_ResourcesInGroups_ToGroups] FOREIGN KEY (GroupResourcesId) REFERENCES [ResourcesGroup](IdResourceGroup)
)
