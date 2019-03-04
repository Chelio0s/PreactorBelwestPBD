CREATE TABLE [InputData].[Departments]
(
	[IdDepartment] INT NOT NULL PRIMARY KEY IDENTITY,  
    [Title] NVARCHAR(99) NOT NULL UNIQUE, 
    [AreaId] INT NOT NULL, 
    CONSTRAINT [FK_Departments_ToAreas] FOREIGN KEY (AreaId) REFERENCES [InputData].[Areas]([IdArea])
)
