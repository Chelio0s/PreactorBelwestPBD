CREATE TABLE [SupportData].[Shift]
(
	[IdShift] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Title] NVARCHAR(50) NOT NULL unique
)
