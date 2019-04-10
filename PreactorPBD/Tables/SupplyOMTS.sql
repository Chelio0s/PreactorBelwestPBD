CREATE TABLE [InputData].[SupplyOMTS]
(
	[IdSupply] INT NOT NULL PRIMARY KEY identity, 
    [SupplyOrder] FLOAT NOT NULL UNIQUE, 
    [MaterialId] varchar(15) NOT NULL, 
    [Count] FLOAT NOT NULL, 
    [DateSupply] DATETIME NOT NULL, 
    CONSTRAINT [FK_SupplyOMTS_ToMaterial] FOREIGN KEY (MaterialId) REFERENCES [InputData].Material(IdMaterial)
)
