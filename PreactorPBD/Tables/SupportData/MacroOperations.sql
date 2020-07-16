CREATE TABLE [SupportData].[MacroOperations]
(
	[IdMacroOperation]  INT             NOT NULL PRIMARY KEY IDENTITY, 
    [Title]             NVARCHAR(150)   NOT NULL, 
    [AreaId]            INT             NOT NULL, 
    [User]              NVARCHAR(50)    NOT NULL DEFAULT suser_sname(), 
    [Date]              DATETIME        NOT NULL DEFAULT getdate(), 
    CONSTRAINT [FK_MacroOperations_ToArea] FOREIGN KEY ([AreaId]) REFERENCES [InputData].[Areas]([IdArea])
    ON DELETE CASCADE ON UPDATE CASCADE
)
