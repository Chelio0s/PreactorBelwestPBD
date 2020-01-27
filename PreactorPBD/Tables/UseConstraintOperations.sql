CREATE TABLE [InputData].[UseConstraintOperations]
(
	[IdUseConstraint]	INT				NOT NULL PRIMARY KEY IDENTITY, 
    [OperationId]		INT				NOT NULL, 
    [ConstraintId]		INT				NOT NULL, 
    [Count]				NUMERIC(5, 2)	NOT NULL, 
    [IsUse]				BIT				NOT NULL
	CONSTRAINT [FK_UseConstraintOp_ToConstraint] FOREIGN KEY (ConstraintId) 
	REFERENCES [InputData].[SecondaryConstraints](IdSecondaryConstraint)
	ON UPDATE CASCADE ON DELETE CASCADE, 
    CONSTRAINT [FK_UseConstraintOp_ToOperation] FOREIGN KEY (OperationId) 
	REFERENCES [InputData].Operations(IdOperation)
	ON UPDATE CASCADE ON DELETE CASCADE
)
