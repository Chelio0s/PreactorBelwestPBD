CREATE TABLE [SupportData].[BigOperationsGroupWithKtop]
(
	[IdBigOperationsGroup]  INT				NOT NULL,
	[KTOP]					INT				NOT NULL, 
    [Date]					DATETIME		NOT NULL DEFAULT GETDATE(), 
    [UserName]				NVARCHAR(50)	NOT NULL DEFAULT SUSER_SNAME(), 
    CONSTRAINT [PK_BigOperationsGroupWithKtop] 
    PRIMARY KEY ([KTOP], [IdBigOperationsGroup]), 
    CONSTRAINT [FK_BigOperationsGroupWithKtop_ToBigOperationGroup] FOREIGN KEY (IdBigOperationsGroup) 
    REFERENCES [SupportData].[BigOperationsGroups]([IdBigOperationsGroup])
)
