CREATE TABLE [SupportData].[GroupKTOP]
(
	[IdGroupKTOP]				INT				NOT NULL		PRIMARY KEY IDENTITY, 
    [KTOP]						INT				NOT NULL		UNIQUE, 
    [GroupOperationId]			INT				NOT NULL, 
    [DateModify]				DATETIME		NOT NULL		DEFAULT(GETDATE()), 
	[User]						NVARCHAR(99)	NOT NULL		DEFAULT(SUSER_SNAME()) 

    CONSTRAINT [FK_GroupKTOP_ToGroupsOperations] FOREIGN KEY (GroupOperationId) REFERENCES [SupportData].[GroupsOperations]([IdGroupOperations])
	ON UPDATE CASCADE 
)