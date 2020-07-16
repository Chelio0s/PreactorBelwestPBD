CREATE TABLE [SupportData].[MacroOperationWithKtop]
(
	[MacroOperationId]          INT             NOT NULL , 
    [Ktop]                      INT             NOT NULL, 
    [DateChanged]               DATETIME        NOT NULL DEFAULT GETDATE(), 
    [User]                      NVARCHAR(50)    NOT NULL DEFAULT suser_sname(), 
    PRIMARY KEY ([MacroOperationId], [Ktop]), 
    CONSTRAINT [FK_MacroOperationWithKtop_ToMacroOperation] 
    FOREIGN KEY ([MacroOperationId]) 
    REFERENCES [SupportData].[MacroOperations]([IdMacroOperation])
)
