CREATE TABLE [InputData].[UseConstraintOperations]
(
	[IdUseConstraint] INT NOT NULL PRIMARY KEY Identity, 
    [OperationId] INT NOT NULL, 
    [ConstraintId] INT NOT NULL, 
    [Count] INT NOT NULL, 
    [IsUse] BIT NOT NULL, 
    CONSTRAINT [FK_UseConstraint_ToResources_Oper] FOREIGN KEY (OperationId) REFERENCES [InputData].[Operations](IdOperation), 
    CONSTRAINT [FK_UseConstraint_ToConstraint_Oper] FOREIGN KEY (ConstraintId) REFERENCES [InputData].[SecondaryConstraints](IdSecondaryConstraint)
	ON UPDATE CASCADE ON DELETE CASCADE
)