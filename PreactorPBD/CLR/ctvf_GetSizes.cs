using System;
using System.Collections;
using System.Data.SqlTypes;
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
            ArrayList listFinal = new ArrayList();
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

            if (sizes==string.Empty)
            {
                return listFinal;
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

            ArrayList list = new ArrayList();



            if (!reader.HasRows)
            {
                commandStr = "select * " +
                             "from gui_sap.OMTS_SIZE_RANGE " +
                             $"WHERE size_range like '%{sizes}%' and INDEX_LAST is null";
                comm = new OracleCommand(commandStr, con);
                reader = comm.ExecuteReader();

            }

            while (reader.Read())
            {
                list.Add(new
                {
                    size_32 = reader[3].ToString(),
                    size_33 = reader[4].ToString(),
                    size_34 = reader[5].ToString(),
                    size_35 = reader[6].ToString(),
                    size_36 = reader[7].ToString(),
                    size_37 = reader[8].ToString(),
                    size_38 = reader[9].ToString(),
                    size_39 = reader[10].ToString(),
                    size_40 = reader[11].ToString(),
                    size_41 = reader[12].ToString(),
                    size_42 = reader[13].ToString(),
                    size_43 = reader[14].ToString(),
                    size_44 = reader[15].ToString(),
                    size_45 = reader[16].ToString(),
                    size_46 = reader[17].ToString(),
                    size_47 = reader[18].ToString(),
                    size_48 = reader[19].ToString(),
                    size_49 = reader[20].ToString()

                });
            }
           
            foreach (var obj in list)
            {
                var type = obj.GetType();
                var props = type.GetProperties();
                for (int i = 0; i < props.Length; i++)
                {
                    try
                    {
                        if (props[i].Name.StartsWith("size_3") || props[i].Name.StartsWith("size_4"))
                        {
                            string _size = props[i].Name.Substring(props[i].Name.IndexOfAny(new char[] { '3', '4' }));
                            string _count = props[i].GetValue(obj).ToString();

                            if (_count != string.Empty)
                            {
                                listFinal.Add(new { SIZE = _size, Persents = _count });
                            }
                        }
                    }
                    catch (Exception e)
                    {
                        throw new Exception(e + " " + obj.ToString());
                    }
                }
            }

            return listFinal;
        }
    }

    public static void FillRowSizes(object obj, out SqlDecimal SIZE, out SqlDecimal Percents)
    {
        var type = obj.GetType();

        var size = type.GetProperty("SIZE").GetValue(obj).ToString();
        var percent = type.GetProperty("Persents").GetValue(obj).ToString();

        decimal sizeInt, percentInt;
        decimal.TryParse(size, out sizeInt);
        decimal.TryParse(percent, out percentInt);

        SIZE = sizeInt;
        Percents = percentInt;

    }
}
