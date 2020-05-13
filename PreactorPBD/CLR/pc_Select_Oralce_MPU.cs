using System;
using System.Data;
using System.Data.Odbc;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Security.Permissions;
using Microsoft.SqlServer.Server;
using Oracle.ManagedDataAccess.Client;
using PreactorPBD;

public partial class StoredProcedures
{
    [SqlProcedure]
    [OdbcPermission(SecurityAction.Assert)]
    public static void pc_Select_Oralce_MPU(SqlString selectCommandText)
    {
        using (OracleConnection con = new OracleConnection(OracleSettings.GetConnectionString(OracleDataBase.MPU)))
        {
            con.Open();

            OracleCommand command = new OracleCommand(selectCommandText.Value, con);
            var reader = command.ExecuteReader();
            SqlMetaData[] metaDatas = new SqlMetaData[reader.FieldCount];
            for (int i = 0; i < reader.FieldCount; i++)
            {
                SqlDbType type;

                switch (reader.GetDataTypeName(i).ToUpper())
                {
                    case "BOOLEAN": type = SqlDbType.Bit; break;
                    case "INT16": type = SqlDbType.SmallInt; break;
                    case "INT32": type = SqlDbType.Int; break;
                    case "INT64": type = SqlDbType.BigInt; break;
                    case "DOUBLE": type = SqlDbType.Decimal; break;
                    case "FLOAT": type = SqlDbType.Float; break;
                    case "NCHAR": type = SqlDbType.NChar; break;
                    case "CHAR": type = SqlDbType.Char; break;

                    default: type = SqlDbType.NVarChar; break;
                }

                if (type == SqlDbType.NVarChar || type == SqlDbType.Char || type == SqlDbType.NChar)
                    metaDatas[i] = new SqlMetaData(reader.GetName(i), type, 150);
                else metaDatas[i] = new SqlMetaData(reader.GetName(i), type);
            }

            bool first = true;
            bool start = false;

            try
            {
                while (reader.Read())
                {
                    SqlDataRecord record = new SqlDataRecord(metaDatas);
                    for (int i = 0; i < reader.FieldCount; i++)
                    {
                        switch (reader.GetDataTypeName(i).ToUpper())
                        {
                            case "BOOLEAN": record.SetSqlBoolean(i, (bool)reader[i]); break;
                            case "INT16": record.SetSqlInt16(i, reader[i] == DBNull.Value ? (short)0 : (short)reader[i]); break;
                            case "INT32": record.SetSqlInt32(i, (int)reader[i]); break;
                            case "INT64": record.SetSqlInt64(i, (long)reader[i]); break;
                            case "DOUBLE": record.SetSqlDouble(i, (double)reader[i]); break;
                            case "FLOAT": record.SetSqlDecimal(i, (decimal)reader[i]); break;
                            case "NCHAR": record.SetSqlString(i, Convert.ToString(reader[i])); break;
                            case "CHAR": record.SetSqlString(i, Convert.ToString(reader[i])); break;

                            default: record.SetSqlString(i, Convert.ToString(reader[i])); break;
                        }
                    }
                    if (first)
                    {
                        try
                        {
                            SqlContext.Pipe.SendResultsStart(record);
                            SqlContext.Pipe.SendResultsRow(record);
                            first = false;
                        }
                        catch (Exception eq)
                        {
                            if (SqlContext.Pipe.IsSendingResults)
                                SqlContext.Pipe.SendResultsEnd();

                            string error = string.Empty;
                            for (int i = 0; i < record.FieldCount; i++)
                            {
                                error += $"{record.GetFieldType(i)?.Name}: {record.GetString(i)} | ";
                            }
                             
                            SqlContext.Pipe.ExecuteAndSend(new SqlCommand(
                                $"RAISERROR ( '{eq.Message} {error}', 11, 1)"));
                            return;
                        }
                    }
                    else
                    {
                        try
                        {
                            SqlContext.Pipe.SendResultsRow(record);
                        }
                        catch (Exception e)
                        {
                            if (SqlContext.Pipe.IsSendingResults)
                                SqlContext.Pipe.SendResultsEnd();

                            SqlContext.Pipe.ExecuteAndSend(new SqlCommand($"RAISERROR ('{e.Message}', 11, 1)"));
                            return;
                        }
                    }
                }

                if (SqlContext.Pipe.IsSendingResults)
                    SqlContext.Pipe.SendResultsEnd();

                reader.Close();
            }
            catch (Exception e)
            {
                if (SqlContext.Pipe.IsSendingResults)
                    SqlContext.Pipe.SendResultsEnd();
                
                SqlContext.Pipe.ExecuteAndSend(new SqlCommand($"RAISERROR ('{e.Message}', 11, 1)"));
            }
        }
    }
}

