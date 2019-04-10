CREATE TABLE [InputData].[BalanceOMTS]
(
	[IdBalance] INT NOT NULL PRIMARY KEY Identity, 
    [OrderNumber] FLOAT NOT NULL, 
    [MaterialId] varchar(15) NOT NULL, 
    [Count] FLOAT NOT NULL, 
    CONSTRAINT [FK_BalanceOMTS_ToTable] FOREIGN KEY (MaterialId) REFERENCES [InputData].Material(IdMaterial)
)
