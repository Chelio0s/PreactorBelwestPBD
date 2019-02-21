CREATE TABLE [dbo].[SupplyOMTS]
(
	[IdSupply] INT NOT NULL PRIMARY KEY identity, 
    [SupplyOrder] FLOAT NOT NULL UNIQUE, 
    [MaterialId] INT NOT NULL, 
    [Count] FLOAT NOT NULL, 
    [DateSupply] DATETIME NOT NULL, 
    CONSTRAINT [FK_SupplyOMTS_ToMaterial] FOREIGN KEY (MaterialId) REFERENCES Material(IdMaterial)
)
