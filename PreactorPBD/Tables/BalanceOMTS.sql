CREATE TABLE [dbo].[BalanceOMTS]
(
	[IdBalance] INT NOT NULL PRIMARY KEY Identity, 
    [OrderNumber] FLOAT NOT NULL, 
    [MaterialId] INT NOT NULL, 
    [Count] FLOAT NOT NULL, 
    CONSTRAINT [FK_BalanceOMTS_ToTable] FOREIGN KEY (MaterialId) REFERENCES Material(IdMaterial)
)
