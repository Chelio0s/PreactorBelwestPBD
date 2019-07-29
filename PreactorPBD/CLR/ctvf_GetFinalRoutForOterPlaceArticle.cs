using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Linq;
using Microsoft.SqlServer.Server;
using PreactorPBD;

public partial class UserDefinedFunctions
{
    [Microsoft.SqlServer.Server.SqlFunction(
    FillRowMethodName = "FillFinalRoutForOterPlaceArticle", SystemDataAccess = SystemDataAccessKind.Read,
    DataAccess = DataAccessKind.Read,
    TableDefinition = "KTOPParent int, " +
                      "KOBParent int," +
                      "KTOPChild int, " +
                      "KOBChild int ")]
    public static IEnumerable ctvf_GetFinalRoutForOterPlaceArticle(string Article, int IdArea)
    {
        var resultList = new List<MappingRule>();
        using (SqlConnection sqlConnection
            = new SqlConnection("context connection=true"))
        {
            SqlCommand command;
            switch (IdArea)
            {
                case 9:
                case 13:
                case 14:
                case 20:
                    command = new SqlCommand($"SELECT * FROM [InputData].[udf_GetOperationsForArticle] ('{Article}', 18) ",
                    sqlConnection); break;
                default:
                    command = new SqlCommand($"SELECT * FROM [InputData].[udf_GetOperationsForArticle] ('{Article}', DEFAULT) ",
                        sqlConnection); break;

            }

              
            sqlConnection.Open();
            //Заполняем лист исходными данными - какие операции есть на данный момент
            var reader = command.ExecuteReader();
            var parentOperations = new List<OperationData>();
            while (reader.Read())
            {
              
                    parentOperations.Add(new OperationData(0,
                        Convert.ToInt32(reader[1]),
                        Convert.ToInt32(reader[3]),
                        Convert.ToDecimal(reader[4]),
                        Convert.ToInt32(reader[5]),
                        Convert.ToInt32(reader[6])));
                
        
            }

            reader.Close();

            if (parentOperations.Count == 0)
            {
                return null;
            }

            command = new SqlCommand($"SELECT  *  FROM [InputData].[ctvf_GetMappingRulesForArticle]('{Article}', {IdArea})",
                sqlConnection);

            var mappingRules = new List<MappingRule>();
            reader = command.ExecuteReader();
            while (reader.Read())
            {
                mappingRules.Add(new MappingRule(
                                                Convert.ToInt32(reader[0]),
                                                Convert.ToInt32(reader[2]),
                                                Convert.ToInt32(reader[4]),
                                                Convert.ToInt32(reader[1]),
                                                Convert.ToInt32(reader[3])));
            }

            if (mappingRules.Count == 0)
            {
                return null;
            }

            var grouppingMappingRules = mappingRules.GroupBy(x => x.IdMappingRule).OrderByDescending(x => x.Count()).ToList();
            var operationsReady = new List<int>();

            foreach (var group in grouppingMappingRules)
            {
                var tempArr = new List<MappingRule>();
                foreach (var itemRule in group)
                {
                    //Сопоставлена ли уже эта родительская операция?
                    if (!operationsReady.Contains(itemRule.ParentOperation.KTOP))
                    {
                        //Сопоставляю ли я Родитель = Заменитель? Например КТОП 404 = 404
                        //Если да, то все норм
                        if (itemRule.ParentOperation.KTOP == itemRule.ChildOperation.KTOP)
                        {
                            tempArr.Add(new MappingRule(0, itemRule.ParentOperation, itemRule.ChildOperation));
                            operationsReady.Add(itemRule.ParentOperation.KTOP);
                        }
                        //Если сопоставляю одну на другую, например, 404 = 578
                        else
                        {
                            //Нужно проверить, нет ли в ТМе такой операции
                            //-1  - такой нет
                            var indexOf =
                                parentOperations.FindIndex(x => x.Operation == itemRule.ChildOperation);
                            if (indexOf == -1)
                            {
                                tempArr.Add(new MappingRule(0, itemRule.ParentOperation, itemRule.ChildOperation));
                                operationsReady.Add(itemRule.ParentOperation.KTOP);
                            }
                            else break;
                        }
                    }
                    else break;
                }
                //Все операции правила замапены
                if (tempArr.Count == group.Count())
                {
                    resultList.AddRange(tempArr);
                }
            }
        }
        return resultList;
    }


    public static void FillFinalRoutForOterPlaceArticle(object obj
        , out SqlInt32 KTOPParent
        , out SqlInt32 KOBParent
        , out SqlInt32 KTOPChild
        , out SqlInt32 KOBChild)
    {
        try
        {
            var item = (MappingRule)obj;
            KTOPParent = item.ParentOperation.KTOP;
            KOBParent = item.ParentOperation.KOB;
            KTOPChild = item.ChildOperation.KTOP;
            KOBChild = item.ChildOperation.KOB;
        }
        catch (Exception e)
        {
            
            throw new Exception("Ошибка в методе заполнения строки");
        }

    }
}
