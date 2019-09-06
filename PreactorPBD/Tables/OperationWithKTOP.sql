CREATE TABLE [InputData].[OperationWithKTOP]
(
	[IdOperWithKtop]	INT		NOT NULL PRIMARY KEY IDENTITY, 
    [OperationId]		INT		NOT NULL, 
    [KTOP]				INT		NOT NULL,
	[TimeMultiply]		FLOAT	NOT NULL
	CONSTRAINT FK_OperWithKtopToOperations  FOREIGN KEY (OperationId)
	REFERENCES [InputData].[Operations] ([IdOperation])
	ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT UK_Oper_KTOPN UNIQUE (OperationId, KTOP)
)
