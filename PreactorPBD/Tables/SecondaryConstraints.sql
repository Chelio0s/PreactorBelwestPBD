CREATE TABLE [InputData].[SecondaryConstraints]
(
	[IdSecondaryConstraint] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Title] NVARCHAR(99) NOT NULL UNIQUE, 
    [TypeId] INT  NULL, 
    [ParamDescript] NVARCHAR(99) NULL, 
    [Param] NVARCHAR(99) NULL, 
    CONSTRAINT [FK_SecondaryConstraints_ToType] 
	FOREIGN KEY (TypeId) REFERENCES [SupportData].[TypeConstraint](IdTypeConstraint)
	ON DELETE SET NULL ON UPDATE SET NULL

)
