using System;
using System.Collections;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using Microsoft.SqlServer.Server;
using PreactorPBD;

public partial class UserDefinedFunctions
{
    [Microsoft.SqlServer.Server.SqlFunction(
        FillRowMethodName = "FillAltRouteForFirstFloor",
        SystemDataAccess = SystemDataAccessKind.Read,
        DataAccess = DataAccessKind.Read,
        TableDefinition = @"IdRule              int
                            ,AreaId             int
                            ,TimeCoefficient    decimal(6,2)
                            ,TimeAddiction      decimal(6,2)
                            ,NeedCountDetails   bit
                            ,KOBParent          int
                            ,KOBChild           int
                            ,KTOPParent         int
                            ,KTOPChild          int
                            ,NormaTimeOld       decimal(6,2)
                            ,NormaTimeNew       decimal(6,2)
                            ,IdSemiProduct      int
                            ,IdRout             int
                            ,SimpleProductId    int
                            ,CategoryOperation  int
                            ,KPROF              int")]
    public static IEnumerable ctvf_GetAltRouteForSecondFloor(int idRoute, int idArea)
    {
        string Article = null;
        using (SqlConnection sqlConnection = new SqlConnection("context connection = true"))
        {
            SqlCommand command = new SqlCommand(
                @"SELECT [IdRule]
                    ,[AreaId]
                    ,[TimeCoefficient]
                    ,[TimeAddiction]
                    ,[NeedCountDetails]
                    ,[ResParentTitle]
                    ,[ResChildTitle]
                    ,[KOBParent]
                    ,[KOBChild]
                    ,[OpParentTitle]
                    ,[OpChildTitle]
                    ,[KTOPParent]
                    ,[KTOPChild]
                    ,[KTOPOriginal]
                    ,[KobOriginal]
                    ,[NormaTimeOld]
                    ,[NormaTimeNew]
                    ,[IdSemiProduct]
                    ,[IdRout]
                    ,[SimpleProductId]
                    ,[CategoryOperation]
                    ,[IdProfession]
                FROM [InputData].[VI_MappingRuleForFirstFloor] " +
                $"WHERE IdRout =  {idRoute}", sqlConnection);
            sqlConnection.Open();  

            var reader = command.ExecuteReader();

            var rules = new List<MappingRuleFull>();

            while (reader.Read())
            {
                rules.Add(new MappingRuleFull(Convert.ToInt32(reader[1]),
                    Convert.ToInt32(reader[18]),
                    Convert.ToInt32(reader[0]),
                    Convert.ToInt32(reader[17]),
                    Convert.ToInt32(reader[8]),
                    Convert.ToInt32(reader[7]),
                    Convert.ToInt32(reader[12]),
                    Convert.ToInt32(reader[11]),
                    Convert.ToBoolean(reader[4]),
                    Convert.ToDecimal(reader[16]),
                    Convert.ToDecimal(reader[15]),
                    Convert.ToDecimal(reader[3]),
                    Convert.ToDecimal(reader[2]),
                    Convert.ToInt32(reader[19]),
                    Convert.ToInt32(reader[20]),
                    Convert.ToInt32(reader[21])));
            }

            if (rules.Count == 0)
            {
                return null;
            }
            else reader.Close();



            return rules;
        }
    }
}
