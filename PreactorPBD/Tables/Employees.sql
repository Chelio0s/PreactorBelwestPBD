CREATE TABLE [InputData].[Employees]
(
    [Name] NVARCHAR(99) NOT NULL, 
    [TabNum] VARCHAR(15) NOT NULL UNIQUE, 
    [Orgunit] INT NOT NULL, 
    CONSTRAINT [FK_Employees_ToOrgunit] FOREIGN KEY ([Orgunit]) REFERENCES [SupportData].[Orgunit]([OrgUnit]), 
    PRIMARY KEY ([TabNum])
)
