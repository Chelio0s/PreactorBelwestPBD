using System;
using System.Collections;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using Oracle.ManagedDataAccess.Client;
using PreactorPBD;

public partial class UserDefinedFunctions
{
    [Microsoft.SqlServer.Server.SqlFunction(
       FillRowMethodName = "FillRowGetModelArticle", SystemDataAccess = SystemDataAccessKind.Read,
       DataAccess = DataAccessKind.Read,
       TableDefinition =
           "INDEX_MODEL nvarchar(150) ")]

    public static IEnumerable ctvf_GetModelArticle(SqlString article)
    {

        using (OracleConnection con = new OracleConnection(OracleSettings.GetConnectionString(OracleDataBase.SAP)))
        {
            con.Open();

            string commandStr = @"SELECT distinct INDEX_MODEL
                FROM gui_sap.MKZ_MAIN a 
                INNER JOIN gui_sap.MKZ_ART c ON a.id = c.id_model "+
                $"where  art = '{article}'";
            OracleDataReader reader;
            OracleCommand comm = new OracleCommand(commandStr, con);
            try
            {
                reader = comm.ExecuteReader();
            }
            catch (Exception e)
            {
                throw new Exception(commandStr + Environment.NewLine + e.Message);
            }
            ArrayList list = new ArrayList();

            while (reader.Read())
            {
                list.Add(new
                {
                    INDEX_MODEL = reader[0].ToString()
                });
            }
            return list;
        }
    }

    public static void FillRowGetModelArticle(object obj, out SqlString INDEX_MODEL)
    {
        var type = obj.GetType();
        INDEX_MODEL = type.GetProperty("INDEX_MODEL").GetValue(obj).ToString();
    }
}
