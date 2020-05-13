create table [SupportData].OperationСomposition (
   IdComposition        int				     not null IDENTITY,
   ComposeOperationId   int                  not null,
   KTOP                 int                  not null,
   constraint PK_OPERATIONСOMPOSITION primary key (IdComposition),
   constraint FK_OPERATIO_REFERENCE_OPERATIO foreign key (ComposeOperationId)
      references [SupportData].ComposeOperation (idComposeOper) 
	  ON DELETE CASCADE ON UPDATE CASCADE, 
    CONSTRAINT [CK_OperationСomposition_Column] UNIQUE(ComposeOperationId, KTOP)
)
