CREATE TABLE [InputData].[ConstraintsCalendar]
(
	[IdCalendar] INT NOT NULL PRIMARY KEY Identity, 
    [SecondaryConstraintId] INT NOT NULL, 
    [Start] DATETIME NOT NULL, 
    [End] DATETIME NOT NULL, 
    [Count] INT NOT NULL, 
    CONSTRAINT [FK_Calendar_ToSecondaryConstraint] FOREIGN KEY (SecondaryConstraintId) REFERENCES [InputData].[SecondaryConstraints](IdSecondaryConstraint)
	ON UPDATE CASCADE ON DELETE CASCADE
)
