CREATE TABLE [SupportData].[AltOperationRule]
(
	[IdRule] INT NOT NULL PRIMARY KEY IDENTITY,
	[AltOperationId] INT NOT NULL,
	KTOP INT NOT NULL, 
    CONSTRAINT [FK_AltOperationRule_ToAltOperation] FOREIGN KEY ([AltOperationId]) REFERENCES [SupportData].[AltOperations]([IdKtop])
	ON DELETE CASCADE ON UPDATE CASCADE, 
    CONSTRAINT [UK_AltOperationRule_Column] UNIQUE (AltOperationId, KTOP)
)
