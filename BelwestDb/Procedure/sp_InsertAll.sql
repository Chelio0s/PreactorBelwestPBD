CREATE PROCEDURE [dbo].[sp_InsertAll]
AS
	print('Загрузка артикулов')
	INSERT Article
	SELECT * FROM udf_GetArticle();

	print('Загрузка ресурсов')
	INSERT Resources
	SELECT * FROM udf_GetResourceFromSDB();

	print('Загрузка операций')
	INSERT Operation
	SELECT * FROM udf_GetFullOperation();

	print('Загрузка техпроцессов')
	INSERT TechProcess
	SELECT * FROM [udf_GetTechProcess]();

	print('Загрузка спецификаций')
	INSERT TechProcess
	SELECT * FROM [udf_GetTechProcess]();


RETURN 0
