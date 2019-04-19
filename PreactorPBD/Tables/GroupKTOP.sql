CREATE TABLE [SupportData].[GroupKTOP]
(
	[IdGroupKTOP] INT NOT NULL PRIMARY KEY IDENTITY, 
    [KTOP] INT NOT NULL UNIQUE, 
    [GroupOperationId] INT NOT NULL, 
    CONSTRAINT [FK_GroupKTOP_ToGroupsOperations] FOREIGN KEY (GroupOperationId) REFERENCES [SupportData].[GroupsOperations]([IdGroupOperations])
	ON UPDATE CASCADE
)