CREATE TABLE [SupportData].[BigOperationsGroups]
(
	[IdBigOperationsGroup]  INT             NOT NULL PRIMARY KEY IDENTITY, 
    [Title]                 NVARCHAR(99)    NOT NULL, 
    [AreaId]                INT             NULL, 
    [Date]                  DATETIME        NOT NULL DEFAULT getdate(), 
    [UserName]              NVARCHAR(50)    NOT NULL DEFAULT suser_sname(), 
    CONSTRAINT [FK_BigOperationsGroups_ToAreas] FOREIGN KEY ([AreaId]) 
    REFERENCES [InputData].[Areas]([IdArea]) 
    ON UPDATE CASCADE ON DELETE CASCADE
)
