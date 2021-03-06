﻿CREATE TABLE [dbo].[drive](
	[REL] [decimal](9, 0) NOT NULL,
	[MOD] [char](15) NOT NULL,
	[NPP] [decimal](4, 0) NOT NULL,
	[KTOP] [decimal](5, 0) NOT NULL,
	[KPO] [char](6) NULL,
	[KOLD] [decimal](3, 0) NOT NULL,
	[RUCH] [bit] NOT NULL,
	[KOLN] [decimal](2, 0) NOT NULL,
	[PONEOB] [bit] NOT NULL,
	[KUCH] [decimal](2, 0) NULL,
	[KOB] [decimal](4, 0) NULL,
	[TEXT] [char](250) NULL,
	[DATE_S] [datetime] NOT NULL,
	[USER_S] [char](30) NOT NULL,
	[PC_S] [varchar](99) NOT NULL,
	[DATEKRKV] [datetime] NULL,
	[USERKRKV] [char](15) NULL,
	[PODRKRKV] [char](30) NULL,
	[DATEDO] [datetime] NULL,
	[NGROP] [decimal](5, 0) NOT NULL,
	[NPPN] [decimal](4, 0) NOT NULL,
	[KTOPN] [decimal](5, 0) NOT NULL,
	[NORMA] [decimal](6, 2) NOT NULL,
	[TEXTN] [varchar](250) NOT NULL,
	[DATEKRKVN] [datetime] NULL,
	[USERKRKVN] [char](15) NULL,
	[PODRKRKVN] [char](30) NULL,
	[NVP] [decimal](6, 2) NOT NULL)