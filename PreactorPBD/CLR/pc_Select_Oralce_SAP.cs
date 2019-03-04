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
    public static void pc_Select_Oralce_SAP (SqlString selectCommandText)
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
                    case "TIMESTAMP": type = SqlDbType.DateTime; break;
                    default: type = SqlDbType.NVarChar; break;
                }

                if (type == SqlDbType.NVarChar || type == SqlDbType.Char || type == SqlDbType.NChar)
                {
                    metaDatas[i] = new SqlMetaData(reader.GetName(i), type, 150);
                }
                else metaDatas[i] = new SqlMetaData(reader.GetName(i), type);
            }

            bool first = true;
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
                            case "INT16": record.SetSqlInt16(i, reader[i] == DBNull.Value ? (Int16)0 : (Int16)reader[i]); break;
                            case "INT32": record.SetSqlInt32(i, (int)reader[i]); break;
                            case "INT64": record.SetSqlInt64(i, (long)reader[i]); break;
                            case "DOUBLE": record.SetSqlDouble(i, (double)reader[i]); break;
                            case "FLOAT": record.SetSqlDecimal(i, (decimal)reader[i]); break;
                            case "NCHAR": record.SetSqlString(i, Convert.ToString(reader[i])); break;
                            case "CHAR": record.SetSqlString(i, Convert.ToString(reader[i])); break;
                            case "TIMESTAMP": record.SetSqlDateTime(i, (DateTime)reader[i]); break;
                            default: record.SetSqlString(i, Convert.ToString(reader[i])); break;
                        }
                    }
                    if (first)
                    {
                        SqlContext.Pipe.SendResultsStart(record);
                        first = false;
                    }
                    else
                    {
                        SqlContext.Pipe.SendResultsRow(record);
                    }
                }
                SqlContext.Pipe.SendResultsEnd();
            }
            catch (Exception e)
            {
                SqlContext.Pipe.ExecuteAndSend(new SqlCommand(string.Format("RAISERROR ( '{0}', 11, 1)", e.Message)));
            }

        }
    }
}

