﻿create table [SupportData].RoutRoules (
   IdRule               INT                  NOT NULL  IDENTITY,
   OperationParentId    INT                  NOT NULL,
   OperationChildId     INT                  NOT NULL,
   [RuleGroupId]		INT					 NOT NULL, 
   [RulePriority]       INT                  NOT NULL DEFAULT (0), 
   [Date]				DATETIME			 NOT NULL DEFAULT(Getdate()),
   [USER]				NVARCHAR(99)		 NOT NULL DEFAULT(SUSER_SNAME())
    CONSTRAINT PK_ROUTROULES PRIMARY KEY (IdRule),
   
    CONSTRAINT FK_ROUTROUL_REFERENCE_OPERATIO FOREIGN KEY (OperationParentId)
      REFERENCES [SupportData].ComposeOperation (idComposeOper),
   CONSTRAINT FK_ROUTROUL_REFERENCE_OPERCHILD FOREIGN KEY (OperationChildId)
      REFERENCES [SupportData].ComposeOperation (idComposeOper), 
	  CONSTRAINT FK_ROUTROUL_REFERENCE_RGroups FOREIGN KEY (RuleGroupId)
      REFERENCES [SupportData].[RuleGroup] (IdRuleGroup), 
    CONSTRAINT [CK_RoutRoules_ParentChild] UNIQUE(OperationParentId, OperationChildId)
	

)