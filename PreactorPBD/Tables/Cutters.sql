CREATE TABLE [SupportData].[Cutters]		--Резаки
(
	[IdCutter] INT NOT NULL PRIMARY KEY,	--Код
	Model nvarchar(99) unique not null,		--Модель обуви
	isAutomat bit not null,					--автомат. комплекс
    [DateStart] DATETIME NOT NULL			--Когда приедут резаки
)
