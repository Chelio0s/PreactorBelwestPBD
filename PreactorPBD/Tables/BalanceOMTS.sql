CREATE TABLE [InputData].[BalanceOMTS]
(
	[IdBalance]		INT		NOT NULL PRIMARY KEY Identity, 
    [OrderNumber]	FLOAT	NOT NULL, 
    [MaterialId]	INT		NOT NULL, 
    [Count]			FLOAT	NOT NULL, 
    CONSTRAINT [FK_BalanceOMTS_ToTable] FOREIGN KEY (MaterialId) REFERENCES [InputData].Material(IdMaterial)
)
