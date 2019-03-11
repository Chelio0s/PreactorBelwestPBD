CREATE TABLE [InputData].[Resources]
(
	[IdResource] INT NOT NULL PRIMARY KEY, 
    [Title] NVARCHAR(99) NOT NULL UNIQUE, 
    [TitleWorkPlace] NVARCHAR(99) NOT NULL, 
    [DepartmentId] INT NOT NULL, 
    [KOB] INT NOT NULL, 
    CONSTRAINT [FK_Resources_ToDepartment] FOREIGN KEY ([DepartmentId]) REFERENCES [InputData].[Departments](IdDepartment)
	ON UPDATE CASCADE

)
