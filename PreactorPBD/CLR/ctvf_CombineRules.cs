using System;
using System.Collections;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Linq;
using Microsoft.SqlServer.Server;
using PreactorPBD;
using PreactorSDB;

public partial class UserDefinedFunctions
{
    [Microsoft.SqlServer.Server.SqlFunction(
        FillRowMethodName = "FillCombineRules", SystemDataAccess = SystemDataAccessKind.Read,
        DataAccess = DataAccessKind.Read,
        TableDefinition = "IDRoutRule int " +
                          ",IdCombine int " +
                          ",GroupId int")]
    public static IEnumerable ctvf_CombineRules(int IdSemiProduct)
    {
        var resultList = new List<CombineResult>();
        using (SqlConnection sqlConnection
            = new SqlConnection("context connection=true"))
        {
            SqlCommand command = new SqlCommand($@"SELECT TOP(1) SimpleProductId 
                                                         FROM [InputData].[SemiProducts] 
                                                         WHERE IdSemiProduct = {IdSemiProduct} ", sqlConnection);


            sqlConnection.Open();
            int? simpleProductId = null;
            var reader = command.ExecuteReader();
            while (reader.Read())
                simpleProductId = int.Parse(reader[0].ToString());
            reader.Close();

            command = simpleProductId == null ? new SqlCommand($@" SELECT IdSemiProduct
												   ,IdRoutRule
												   ,RuleGroupId FROM [InputData].[udf_GetRulesForSemiProduct] 
                                                    ({IdSemiProduct}, NULL)", sqlConnection) 
                                               : new SqlCommand($@" SELECT IdSemiProduct
                                                 , IdRoutRule
                                                 , RuleGroupId FROM[InputData].[udf_GetRulesForSemiProduct] 
                                                 ({IdSemiProduct}, {simpleProductId})", sqlConnection);

            reader = command.ExecuteReader();

            List<RoutRules> list = new List<RoutRules>();
            while (reader.Read())
            {
                list.Add(new RoutRules(Convert.ToInt32(reader[1]), Convert.ToInt32(reader[2])));
            }

            //Группируем все по группам и помещаем в спец. листы

            var groups = list.GroupBy(x => x.RuleGroupId);

            List<List<CombineData<RoutRule>>> dataList 
                = groups.Select(gr => 
                    gr.Select(x => new CombineData<RoutRule>()
                        {Data = {new RoutRule(x.IdRoutRule, x.RuleGroupId)}})
                        .ToList())
                    .ToList();

            if (dataList.Count == 0)
                return null;

            List<CombineData<RoutRule>> finalCombine;

            if (dataList.Count > 1)
            {
                List<CombineData<RoutRule>> tempCombine = null;
                for (int i = 0; i < dataList.Count; i++)
                {
                    if (i < dataList.Count - 1)
                    {
                        tempCombine = i == 0
                            ? dataList[i].Combine(dataList[i + 1]).ToList()
                            : tempCombine.Combine(dataList[i + 1]).ToList();
                    }
                }
                finalCombine = tempCombine;
            }
            else finalCombine = dataList[0];

            var counter = 0;
            foreach (var f in finalCombine)
            {
                resultList
                    .AddRange(f.Data.Select(data => new CombineResult(counter, data.IdRoutRule, data.GroupId)));

                counter++;
            }
        }
        return resultList;
    }


    public static void FillCombineRules(object obj, out SqlInt32 IdRule, out SqlInt32 IdCombine, out SqlInt32 GroupId)
    {
        var resObj = (CombineResult)obj;
        IdRule = resObj.IdRule;
        IdCombine = resObj.IdCombine;
        GroupId = resObj.GroupId;
    }
}


 