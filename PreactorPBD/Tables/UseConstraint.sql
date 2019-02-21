CREATE TABLE [InputData].[UseConstraint]
(
	[IdUseConstraint] INT NOT NULL PRIMARY KEY Identity, 
    [ResourceId] INT NOT NULL, 
    [ConstraintId] INT NOT NULL, 
    [Count] INT NOT NULL, 
    CONSTRAINT [FK_UseConstraint_ToResources] FOREIGN KEY (ResourceId) REFERENCES [InputData].[Resources](IdResource), 
    CONSTRAINT [FK_UseConstraint_ToConstraint] FOREIGN KEY (ConstraintId) REFERENCES [InputData].[SecondaryConstraints](IdSecondaryConstraint)
	)