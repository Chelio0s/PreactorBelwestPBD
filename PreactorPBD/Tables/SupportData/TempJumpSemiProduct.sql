CREATE TABLE [SupportData].[TempJumpSemiProduct]
( Article				nvarchar(99) NOT NULL
, IdMergeRoutes			INT NOT NULL
, IdSemiProduct			INT PRIMARY KEY
, BaseAreaId			INT NOT NULL
, ChildAreaId			INT NOT NULL
, KtopChildRoute		INT NOT NULL
, KtopParentRoute		INT NOT NULL)
