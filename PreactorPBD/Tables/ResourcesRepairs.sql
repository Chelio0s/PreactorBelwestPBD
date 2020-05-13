CREATE TABLE [InputData].[ResourcesRepairs]
(
	[IdRepair]				INT			NOT NULL PRIMARY KEY IDENTITY, 
    [ResourceId]			INT			NOT NULL, 
    [DateStart]				DATETIME	NOT NULL, 
    [DateEnd]				DATETIME	NOT NULL, 
    CONSTRAINT [FK_ResourcesRepairs_ToResource] FOREIGN KEY (ResourceId) REFERENCES [InputData].[Resources]([IdResource])
    ON DELETE CASCADE ON UPDATE CASCADE
)
