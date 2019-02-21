CREATE TABLE [InputData].[Departments]
(
	[IdDepartment] INT NOT NULL PRIMARY KEY IDENTITY,  
    [Title] NVARCHAR(99) NOT NULL UNIQUE
)
