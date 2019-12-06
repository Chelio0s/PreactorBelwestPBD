using System;
using System.Collections;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using PreactorPBD;

public partial class UserDefinedFunctions
{
    [Microsoft.SqlServer.Server.SqlFunction(
        FillRowMethodName = "FillGetDisableOperationsForRout", SystemDataAccess = SystemDataAccessKind.Read,
        DataAccess = DataAccessKind.Read,
        TableDefinition = "IDRout int " +
                          ",KTOP int")]
    public static IEnumerable ctvf_GetDisableOperationsForRout(int IdRoute)
    {
        string conStr = "context connection=true";
        var listOper = new List<DisableOperations>();

        using (SqlConnection sqlConnection
            = new SqlConnection(conStr))
        {
            SqlCommand command = new SqlCommand($"SELECT * " +
                                                   "FROM[InputData].[VI_RoutWithOperationsRoutRules] " +
                                                   $"WHERE IdRout = {IdRoute} " +
                                                   $"and RuleId is not null", sqlConnection);
            sqlConnection.Open();
            var reader = command.ExecuteReader();



            var selectOperationsCommand = new SqlCommand("", sqlConnection);
            var listRuleOpers = new List<RoutRulesOperationSmall>();


            while (reader.Read())
            {
                var ruleOper = new RoutRulesOperationSmall(Convert.ToInt32(reader[0]),
                    Convert.ToInt32(reader[1]),
                    Convert.ToInt32(reader[2]),
                    Convert.ToBoolean(reader[3]));
                listRuleOpers.Add(ruleOper);
            }

            reader.Close();

            if (listRuleOpers.Count == 0)
            {
                return null;
            }

            var ruleOperBig = new RoutRulesOperation();
            var ruleBigList = new List<RoutRulesOperation>();
            foreach (var ruleOper in listRuleOpers)
            {
                if (ruleOperBig.IdRout != ruleOper.IdRout)
                {
                    ruleOperBig = new RoutRulesOperation()
                    {
                        IdRout = ruleOper.IdRout,
                        SemiProductId = ruleOper.SemiProductId
                    };
                    ruleBigList.Add(ruleOperBig);
                }

                ruleOperBig.RuleId = ruleOper.RuleId;
                ruleOperBig.RuleIsParent = ruleOper.RuleIsParent;

                var bit = ruleOperBig.RuleIsParent ? 0 : 1;
                selectOperationsCommand.CommandText = $"SELECT * FROM [InputData].[udf_GetOperationsRule] " +
                                                      $"({ruleOperBig.RuleId},{bit})";

                var readerOpers = selectOperationsCommand.ExecuteReader();

                while (readerOpers.Read())
                {
                    if (ruleOperBig.RuleIsParent)
                    {
                        ruleOperBig.ParentOperations.Add(Convert.ToInt32(readerOpers[1]));
                    }
                    else ruleOperBig.ChildOperations.Add(Convert.ToInt32(readerOpers[1]));
                }
                readerOpers.Close();
            }

            foreach (var item in ruleBigList)
            {
                foreach (var oper in item.ParentOperations)
                {
                    listOper.Add(new DisableOperations(item.IdRout, oper));
                }
                foreach (var oper in item.ChildOperations)
                {
                    listOper.Add(new DisableOperations(item.IdRout, oper));
                }
            }
        }
        return listOper;
    }


    public static void FillGetDisableOperationsForRout(object obj, out SqlInt32 IdRout, out SqlInt32 KTOP)
    {
        var resObj = (DisableOperations)obj;
        IdRout = resObj.IdRout;
        KTOP = resObj.KTOP;
    }
}
