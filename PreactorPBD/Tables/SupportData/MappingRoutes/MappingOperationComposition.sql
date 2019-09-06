CREATE TABLE [SupportData].[MappingOperationComposition]
(
   [IdMappingComposition]		INT PRIMARY KEY IDENTITY,
   [MappingComposeOperationId]	INT				NOT NULL,
   [KTOP]						INT				NOT NULL,
   [User]						NVARCHAR(20)	NOT NULL DEFAULT(SUSER_SNAME()), 
   [DateChanged]				DATETIME		NOT NULL DEFAULT(GETDATE()), 
   CONSTRAINT FK_MAPPINGO_REFERENCE_MAPPINGC FOREIGN KEY (MappingComposeOperationId)
      REFERENCES [SupportData].MappingComposeOperation (IdMappingComposeOperation)
	  ON DELETE CASCADE ON UPDATE CASCADE, 

    CONSTRAINT [CK_MappingOperationComposition_Column] UNIQUE(MappingComposeOperationId, KTOP)
)
