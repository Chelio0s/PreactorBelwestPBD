﻿CREATE TABLE [SupportData].[RuleGroup]
(
	[IdRuleGroup] INT NOT NULL PRIMARY KEY IDENTITY,
	[Title] VARCHAR(99) NOT NULL UNIQUE, 
	[ForSemiProduct] INT NOT NULL,
    [Date] DATETIME NOT NULL DEFAULT(Getdate()),
	[USER] NVARCHAR(99) NOT NULL DEFAULT(SUSER_SNAME())
	CONSTRAINT FK_ROUTGROUP_REFERENCE_SEMIPROD FOREIGN KEY (ForSemiProduct)
      REFERENCES [SupportData].[SimpleProduct] (IdSimpleProduct)
)
