using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using Oracle.ManagedDataAccess.Client;
using PreactorPBD;

public partial class StoredProcedures
{
    [Microsoft.SqlServer.Server.SqlProcedure]
    public static void pc_TestRelationOracle(SqlString selectCommandText)
    {
        using (OracleConnection con = new OracleConnection(OracleSettings.GetConnectionString(OracleDataBase.MPU)))
        {
            con.Open();

            OracleCommand command = new OracleCommand(selectCommandText.Value, con);
            var reader = command.ExecuteReader();
            bool first = true;
            bool isStart = false;
            try
            {
                SqlMetaData[] metaDatas = new SqlMetaData[reader.FieldCount];
                for (int i = 0; i < reader.FieldCount; i++)
                {
                    metaDatas[i] = new SqlMetaData(reader.GetName(i), SqlDbType.NVarChar, 150);
                }

                while (reader.Read())
                {
                    SqlDataRecord record = new SqlDataRecord(metaDatas);
                  
                    for (int i = 0; i < reader.FieldCount; i++)
                    { 
                        record.SetSqlString(i, Convert.ToString(reader[i])); break;
                    }

                    if (first)
                    {
                        SqlContext.Pipe.SendResultsStart(record);
                        SqlContext.Pipe.SendResultsRow(record);
                        first = false;
                        isStart = true;
                    }
                    else
                    {
                        SqlContext.Pipe.SendResultsRow(record);
                    }
                }

                if (SqlContext.Pipe.IsSendingResults && isStart)
                {
                    SqlContext.Pipe.SendResultsEnd();
                }

            }
            catch (Exception e)
            {
                if (isStart)
                    SqlContext.Pipe.SendResultsEnd();
                SqlContext.Pipe.ExecuteAndSend(new SqlCommand(string.Format("RAISERROR ( '{0}', 11, 1)", e.Message)));
            }
        }
    }
}
