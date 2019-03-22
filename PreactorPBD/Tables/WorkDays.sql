CREATE TABLE [SupportData].[WorkDays]
(
	[IdWorkDay] INT NOT NULL PRIMARY KEY IDENTITY, 
    [DateWorkDay] DATE NOT NULL, 
    [ShiftId] INT NOT NULL, 
    [Crew] NVARCHAR(1) NOT NULL, 
    CONSTRAINT [FK_WorkDays_ToShift] FOREIGN KEY (ShiftId) REFERENCES [SupportData].[Shift](IdShift)
)
