CREATE TABLE [SupportData].[TypeConstraint]
(
	[IdTypeConstraint] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Title] NVARCHAR(99) NOT NULL unique
)
