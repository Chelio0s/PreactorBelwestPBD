CREATE TABLE [InputData].[OperationWithKTOP]
(
	[IdOperWithKtop]	INT		NOT NULL PRIMARY KEY IDENTITY, 
    [OperationId]		INT		NOT NULL, 
    [KTOP]				INT		NOT NULL,
	[REL]				INT NOT NULL, 
    CONSTRAINT UK_Oper_KTOPN UNIQUE (OperationId, KTOP)
)
