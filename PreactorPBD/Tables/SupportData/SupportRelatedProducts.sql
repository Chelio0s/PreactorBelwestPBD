CREATE TABLE [SupportData].[SupportRelatedProducts]
(
	[IdSupportRelatedProduct]   INT             NOT NULL PRIMARY KEY IDENTITY, 
    [KTOP]                      INT             NOT NULL, 
    [Title]                     NVARCHAR(99)    NOT NULL, 
    [Count]                     NUMERIC(8, 2)   NOT NULL, 
    [SimpleProductId]           INT             NOT NULL, 
    CONSTRAINT [FK_RelatedProducts_ToSimpleProduct] FOREIGN KEY ([SimpleProductId]) 
    REFERENCES [SupportData].[SimpleProduct](IdSimpleProduct) ON DELETE CASCADE ON UPDATE CASCADE, 
    CONSTRAINT [CK_SupportRelatedProducts_ktoptitle] UNIQUE(KTOP, Title, SimpleProductId)
)
