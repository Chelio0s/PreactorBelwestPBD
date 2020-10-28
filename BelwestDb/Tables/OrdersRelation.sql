CREATE TABLE [dbo].[OrdersRelation]
(
	[ParentOrderCode] INT NOT NULL, 
    [ParentArticleCode] VARCHAR(30) NOT NULL, 
    [ParentArticleName] VARCHAR(50) NOT NULL, 
    [ChildOrderCode] INT NOT NULL, 
    [ChildArticleCode] VARCHAR(30) NOT NULL, 
    [ChildArticleName] VARCHAR(50) NOT NULL 
)
