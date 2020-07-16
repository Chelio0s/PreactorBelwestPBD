CREATE TABLE [SupportData].[BannedOperationsForMappingTo9_1]
(
	[BannedKtop] INT NOT NULL PRIMARY KEY, 
    [InsertedDate] DATETIME NOT NULL DEFAULT getdate() 
)
