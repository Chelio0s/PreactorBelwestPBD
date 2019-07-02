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
    FillRowMethodName = "FillRowGetRouteRules", SystemDataAccess = SystemDataAccessKind.Read,
    DataAccess = DataAccessKind.Read,
    TableDefinition = "IDRoutRule int")]
    public static IEnumerable ctvf_GetRouteRules(int idSemiProduct)
    {
        var resultEnum = new List<int>();
        using (SqlConnection sqlConnection
            = new SqlConnection("context connection=true"))
        {
            SqlCommand command = new SqlCommand(@"SELECT [IdSemiProduct]
                    ,[artTitle]
                    ,[spTitle]
                    ,[SimpleProductId]
                    ,[KTOP]
            FROM[InputData].[VI_KTOPWithSemiProducts] " +
            $"WHERE IdSemiProduct = {idSemiProduct} ", sqlConnection);
            sqlConnection.Open();
            //Заполняем лист исходными данными - какие операции есть на данный момент
            var reader = command.ExecuteReader();
            var firstResults = new List<KTOPWithSemiProducts>();
            while (reader.Read())
            {
                firstResults.Add(new KTOPWithSemiProducts()
                {
                    IdSemiProduct = Convert.ToInt32(reader[0]),
                    Article = reader[1].ToString(),
                    SimpleProductId = Convert.ToInt32(reader[3]),
                    KTOP = Convert.ToInt32(reader[4])
                });
            }

            reader.Close();
            if (firstResults.Count == 0)
            {
                return null;
            }

            //Получаем операции из правил - родительские
            command = new SqlCommand(@"SELECT DISTINCT [IdRule]
                                                              ,[parentTitle]
                                                              ,[KTOPParent]
                                                          FROM [InputData].[VI_OperationsRoutRules]", sqlConnection);

            var parentsOperationsList = new List<RuleOperations>();
            reader = command.ExecuteReader();
            while (reader.Read())
            {
                parentsOperationsList.Add(new RuleOperations()
                {
                    IdRule = Convert.ToInt32(reader[0]),
                    Title = reader[1].ToString(),
                    KTOP = Convert.ToInt32(reader[2])
                });
            }

            reader.Close();

            //Получаем операции из правил - дочерние

            command = new SqlCommand(@"SELECT DISTINCT IdRule
	                                                        ,childTitle
	                                                        ,KTOPChild
                                                          FROM [InputData].[VI_OperationsRoutRules]", sqlConnection);

            var childOperationsList = new List<RuleOperations>();
            reader = command.ExecuteReader();
            while (reader.Read())
            {
                childOperationsList.Add(new RuleOperations()
                {
                    IdRule = Convert.ToInt32(reader[0]),
                    Title = reader[1].ToString(),
                    KTOP = Convert.ToInt32(reader[2])
                });
            }

            reader.Close();


            //Группируем родительские правила
            var parentGroups = parentsOperationsList.GroupBy(x => x.IdRule).ToList();
            var sourceOperations = firstResults.Select(x => x.KTOP).ToList();

            foreach (var group in parentGroups)
            {
                var operations = group.Select(x => x.KTOP).ToList();
                //Первое пересечение Родитель - Исходник
                //Если в пересечении столько же операций сколько в родительском правиле - идем дальше
                if (sourceOperations.Intersect(operations).Count() == operations.Count)
                {
                    //Второе пересечение Child - Исходник
                    var childOpers = childOperationsList.Where(x => x.IdRule == group.Key)
                        .Select(x => x.KTOP)
                        .ToList();
                    if (sourceOperations.Intersect(childOpers).Count() == childOpers.Count)
                    {
                        resultEnum.Add(group.Key);
                    }
                }
            }
        }
        return resultEnum;
    }

    public static void FillRowGetRouteRules(object obj, out SqlInt32 IDRoutRule)
    {
        IDRoutRule = Convert.ToInt32(obj);
    }
}
