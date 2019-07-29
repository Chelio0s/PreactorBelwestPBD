using System;
using System.Collections;
using System.Collections.Generic;
using System.Data.SqlTypes;
using System.Globalization;
using System.Linq;
using Microsoft.SqlServer.Server;
using Oracle.ManagedDataAccess.Client;
using PreactorPBD;

public partial class UserDefinedFunctions
{
    [Microsoft.SqlServer.Server.SqlFunction(
        FillRowMethodName = "FillRowSizes", SystemDataAccess = SystemDataAccessKind.Read,
        DataAccess = DataAccessKind.Read,
        TableDefinition =
            "SIZE decimal(6,2), " +
            "Percents decimal(6,2)")]
    public static IEnumerable ctvf_GetSizes(SqlString article)
    {
        using (OracleConnection con = new OracleConnection(OracleSettings.GetConnectionString(OracleDataBase.SAP)))
        {
            con.Open();
            string commandStr =
                "SELECT distinct a.ID,c.art,INDEX_MODEL,FASON_MODEL,LAST,FASON_LAST,SIZE_RANGE " +
                "FROM gui_sap.MKZ_MAIN a " +
                "LEFT JOIN gui_sap.MKZ_SECOND_STEP b ON a.id = b.id_model " +
                "LEFT JOIN gui_sap.MKZ_ART c ON a.id = c.id_model " +
                $"where a.index_model_parent is not null and ART = '{article}'";


            OracleCommand comm = new OracleCommand(commandStr, con);
            var reader = comm.ExecuteReader();
            string sizes = string.Empty;
            string kolodka = string.Empty;

            while (reader.Read())
            {
                try
                {
                    var index = reader[6].ToString().IndexOfAny(new char[] { '3', '4' });
                    if (index < 0)
                        continue;

                    sizes = reader[6].ToString()
                        .Substring(index)
                        .Trim();
                    kolodka = reader[4].ToString();
                }
                catch (Exception e)
                {
                    throw new Exception(e + "id mkz_main:" + reader[0].ToString());
                }
            }

            if (sizes == string.Empty)
            {
                return null;
            }

            if (kolodka != string.Empty)
            {
                commandStr = "select * " +
                             "from gui_sap.OMTS_SIZE_RANGE " +
                             $"WHERE INDEX_LAST = '{kolodka}' and size_range = '{sizes}'";
            }
            else
            {
                commandStr = "select * " +
                             "from gui_sap.OMTS_SIZE_RANGE " +
                             $"WHERE size_range = '{sizes}'";
            }

            comm = new OracleCommand(commandStr, con);
            reader = comm.ExecuteReader();

            var list = new List<Sizes>();

            if (!reader.HasRows)
            {
                commandStr = "select * " +
                             "from gui_sap.OMTS_SIZE_RANGE " +
                             $"WHERE size_range like '%{sizes}%' and INDEX_LAST is null";
                comm = new OracleCommand(commandStr, con);
                reader = comm.ExecuteReader();

            }

            if (reader.HasRows)
            {
                while (reader.Read())
                {
                    for (int i = 0; i < reader.FieldCount; i++)
                    {

                        if (reader.GetName(i).ToUpper().StartsWith("SIZE_") && !reader.GetName(i).ToUpper().StartsWith("SIZE_RANGE"))
                        {
                            var val = decimal.Parse(reader.GetName(i).Substring(5));
                            var count = reader[i] == DBNull.Value ? 0 : Convert.ToDecimal(reader[i]);
                            list.Add(new Sizes(val, count));
                        }
                    }
                }
            }
            else
            {
                if (sizes != string.Empty)
                {
                    var sizesArray = sizes.Split('-');
                    if (sizesArray.Length == 2)
                    {
                        string decimalSeparator = NumberFormatInfo.CurrentInfo.CurrencyDecimalSeparator;

                        var s1 = decimal.Parse(sizesArray[0].Replace(".", decimalSeparator).Replace(",", decimalSeparator));
                        var s2 = decimal.Parse(sizesArray[1].Replace(".", decimalSeparator).Replace(",", decimalSeparator));
                        if (sizesArray[0].Contains(",") || sizesArray[0].Contains("."))
                        {
                            var count = (s2 - s1) * 2 + 1;
                            int percent = (int)(100 / count);
                            int finalpercent = (int)(100 - (count - 1) * percent);

                            for (decimal i = s1; i <= s2; i = i + 0.5m)
                            {
                                if (i < s2)
                                {
                                    list.Add(new Sizes(i, percent));
                                }
                                else
                                {
                                    list.Add(new Sizes(i, finalpercent));
                                }
                            }

                        }
                        else
                        {
                            var count = (s2 - s1) + 1;
                            int percent = (int)(100 / count);
                            int finalpercent = (int)(100 - (count - 1) * percent);

                            if (s1 < s2 && s1 > 30 && s2 > 30 && s2 < 50)
                            {
                                for (int i = (int)s1; i <= s2; i++)
                                {
                                    if (i < s2)
                                    {
                                        list.Add(new Sizes(i, percent));
                                    }
                                    else list.Add(new Sizes(i, finalpercent));
                                }
                            }
                        }
                    }
                }
            }
            return list.Where(x => x.Count != 0).ToList();
        }
    }

    public static void FillRowSizes(object obj, out SqlDecimal SIZE, out SqlDecimal Percents)
    {
        var s = (Sizes)obj;
        SIZE = s.Value;
        Percents = s.Count;
    }
}
