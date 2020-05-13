CREATE TABLE [InputData].[Employees]
(
    [Name] NVARCHAR(99) NOT NULL, 
    [TabNum] VARCHAR(15) NOT NULL UNIQUE, 
    [OrgUnit] INT NOT NULL, 
    CONSTRAINT [FK_Employees_ToOrgUnit] FOREIGN KEY ([OrgUnit]) REFERENCES [SupportData].[OrgUnit]([OrgUnit])
	ON DELETE CASCADE ON UPDATE CASCADE, 
    PRIMARY KEY ([TabNum])
)
