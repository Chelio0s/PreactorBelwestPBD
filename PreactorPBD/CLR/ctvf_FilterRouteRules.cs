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
        FillRowMethodName = "FillFilterRouteRules", SystemDataAccess = SystemDataAccessKind.Read,
        DataAccess = DataAccessKind.Read,
        TableDefinition = "IDRoutRule int")]
    public static IEnumerable ctvf_FilterRouteRules(int idSemiProduct)
    {
        var resultEnum = new List<FilteredRoutRule>();
        using (SqlConnection sqlConnection
            = new SqlConnection("context connection=true"))
        {
            //Получем опреации для для правил ПФ
            SqlCommand command = new SqlCommand($@" SELECT  DISTINCT  sp.[IdSemiProduct]
		                                            ,r.IDRoutRule
		                                            ,rr.RuleGroupId
		                                            ,parentKTOP
		                                            ,childKTOP
		                                            ,rr.rulePriority
                                FROM [InputData].[SemiProducts] as sp
                                OUTER APPLY [InputData].ctvf_GetRouteRules(sp.[IdSemiProduct]) as r
                                INNER JOIN  [InputData].[VI_RulesWithOperations] as rr ON rr.IdRule = r.IDRoutRule
                                WHERE sp.[IdSemiProduct] = {idSemiProduct}
                                ORDER BY IDRoutRule DESC", sqlConnection);

            sqlConnection.Open();
            var reader = command.ExecuteReader();
            var list = new List<FilteredRoutRule>();
            while (reader.Read())
            {
                list.Add(new FilteredRoutRule(
                    Convert.ToInt32(reader[2]),
                    Convert.ToInt32(reader[1]),
                    Convert.ToInt32(reader[3]),
                    Convert.ToInt32(reader[4]),
                    Convert.ToInt32(reader[5])));
            }

            foreach (var item in list
                .OrderByDescending(x=> x.Priority)
                .ThenBy(x=>x.RuleId)
                .GroupBy(x => new { x.RuleId, x.GroupId }))
            {
                bool isOk = true;
                foreach (var i in item)
                {
                    if (resultEnum.Select(x => x.ParentKTOP).Contains(i.ParentKTOP))
                    {
                        isOk = false;
                        break;
                    }
                }
                if (isOk)
                {
                    resultEnum.AddRange(item.Select(x => x));
                }
            }
        }
        return resultEnum.Select(x=>x.RuleId).Distinct();
    }

    public static void FillFilterRouteRules(object obj, out SqlInt32 IDRoutRule)
    {
        IDRoutRule = (int)obj;
    }
}
