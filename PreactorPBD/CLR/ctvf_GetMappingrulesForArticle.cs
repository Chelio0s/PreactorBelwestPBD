using System;
using System.Collections;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Linq;
using Microsoft.SqlServer.Server;
using PreactorPBD;

public partial class UserDefinedFunctions
{
    [Microsoft.SqlServer.Server.SqlFunction(
       FillRowMethodName = "FillMappingrulesForArticle", SystemDataAccess = SystemDataAccessKind.Read,
       DataAccess = DataAccessKind.Read,
       TableDefinition = "IDMapRule int, " +
                         "ParentOperationKTOP int, " +
                         "ParentOperationKOB int, " +
                         "ChildKTOP int, " +
                         "ChildKOB int ")]
    public static IEnumerable ctvf_GetMappingrulesForArticle(string Article, int IdArea)
    {
        var resultList = new List<MappingRule>();
        using (SqlConnection sqlConnection
            = new SqlConnection("context connection=true"))
        {
            //Выбираем операции для 18 ПФ для не зависимо от цеха
            SqlCommand command;
            switch (IdArea)
            {
                case 9:
                case 13:
                case 14:
                case 20:
                    command = new SqlCommand($"SELECT * FROM [InputData].[udf_GetOperationsForArticle] ('{Article}', 18) ",
                        sqlConnection); break;
                   
                //Чтобы функция не падала при не верном вводе цеха, выходим из нее
                default:return null;

            }
            sqlConnection.Open();

            //Заполняем лист исходными данными - какие операции есть на данный момент
            var reader = command.ExecuteReader();
            var parentOperations = new List<OperationData>();
            while (reader.Read())
            {
                parentOperations.Add(new OperationData(-1,
                    Convert.ToInt32(reader[1]),
                    Convert.ToInt32(reader[3]),
                    Convert.ToDecimal(reader[4]),
                    Convert.ToInt32(reader[5]),
                    Convert.ToInt32(reader[6])));
            }

            reader.Close();

            //Если операции не найдены, выходим
            if (parentOperations.Count == 0)
            {
                return null;
            }

            //Далее выбираем все правила для выбранного цеха
            command = new SqlCommand(@"SELECT  [IdRule]
                    ,[KOBParent]
                    ,[KOBChild]
                    ,[KTOPParent]
                    ,[KTOPChild]
                FROM [InputData].[VI_MappingRules] " +
            $"WHERE AreaId = {IdArea} " +
            $"ORDER BY COUNT(IdRule) over(partition by [IdRule])  desc",
                sqlConnection);
            
            //Заполняем ими лист
            var mappingRules = new List<MappingRule>();
            reader = command.ExecuteReader();
            while (reader.Read())
            {
                mappingRules.Add(new MappingRule(
                                                Convert.ToInt32(reader[0]),
                                                Convert.ToInt32(reader[1]),
                                                Convert.ToInt32(reader[2]),
                                                Convert.ToInt32(reader[3]),
                                                Convert.ToInt32(reader[4])));
            }

            //Если правила не найдены, вывходим
            if (mappingRules.Count == 0)
            {
                return null;
            }


            var grouppingMappingRules = mappingRules.GroupBy(x => x.IdMappingRule).ToList();
            var parentOperationsRaw = parentOperations.Select(x => x.Operation).ToList();

             //Пересечения операций из правил и из ТМа
          
            foreach (var group in grouppingMappingRules)
            {
                var intersect = group
                    .Select(x => x.ParentOperation)
                    .Intersect(parentOperationsRaw)
                    .ToList();
                //если кол-во в пересечении такое же как в исходных данных
                if (intersect.Count() == group.Select(x => x.ParentOperation.KTOP).Distinct().Count())
                {
                    //Формируем список правил подходщих для маппинга
                    foreach (var VARIABLE in intersect)
                    {
                        var mpr = group
                            .FirstOrDefault(x => x.ParentOperation.KTOP == VARIABLE.KTOP && x.ParentOperation.KOB == VARIABLE.KOB);
                        resultList.Add(mpr);
                    }
                }
            }
        }
        return resultList;
    }

    public static void FillMappingrulesForArticle(object obj
                                                    , out SqlInt32 IDMapRule
                                                    , out int ParentOperationKTOP
                                                    , out int ParentOperationKOB
                                                    , out int ChildOperationKTOP
                                                    , out int ChildOperationKOB)
    {
        var item = (MappingRule)obj;
        IDMapRule = item.IdMappingRule;
        ParentOperationKTOP = item.ParentOperation.KTOP;
        ParentOperationKOB = item.ParentOperation.KOB;
        ChildOperationKTOP = item.ChildOperation.KTOP;
        ChildOperationKOB = item.ChildOperation.KOB;
    }
}
