using System.Collections;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using Oracle.ManagedDataAccess.Client;
using PreactorPBD;

public partial class UserDefinedFunctions
{
    [Microsoft.SqlServer.Server.SqlFunction(
        FillRowMethodName = "FillRowMkz_Art", SystemDataAccess = SystemDataAccessKind.Read,
        DataAccess = DataAccessKind.Read,
        TableDefinition =
            "ID nvarchar(100), " +
            "ID_Model nvarchar(150), " +
            "ART nvarchar(150), " +
            "NUMBER_ART nvarchar(100)," +
            "COLOR nvarchar(150), " +
            "NAME_MATERIAL nvarchar(150), " +
            "COLOR_EGLANDED nvarchar(150), "+
            "MAT_UP nvarchar(150), "+
            "SEASON nvarchar(150)")]

    public static IEnumerable ctvf_GetMkz_Art()
    {
        
        using (OracleConnection con = new OracleConnection(OracleSettings.GetConnectionString(OracleDataBase.SAP)))
        {
            con.Open();

            string commandStr = @"SELECT
            *
                FROM
            gui_sap.MKZ_ART";

            OracleCommand comm = new OracleCommand(commandStr, con);
            var reader = comm.ExecuteReader();
            ArrayList list = new ArrayList();
            
            while (reader.Read())
            {
                
                list.Add(new
                {
                    ID = reader[0].ToString(), 
                    ID_Model = reader[1].ToString(),
                    ART = reader[2].ToString(),
                    Number_art = reader[3].ToString(),
                    Color = reader[4].ToString(),
                    Name_material = reader[5].ToString(),
                    Color_enlarged = reader[6].ToString(),
                    Mat_up = reader[7].ToString(),
                    Season   = reader[8].ToString()
                });
            }
            return list;
        }
    }

    public static void FillRowMkz_Art(object obj, out SqlString ID, out SqlString ID_Model, out SqlString ART, out SqlString NUMBER_ART,
        out SqlString COLOR,
        out SqlString NAME_MATERIAL, out SqlString COLOR_EGLANDED, out SqlString MAT_UP, out SqlString SEASON)
    {
        var type = obj.GetType();
        ID = type.GetProperty("ID").GetValue(obj).ToString();
        ID_Model = type.GetProperty("ID_Model").GetValue(obj).ToString();
        ART = type.GetProperty("ART").GetValue(obj).ToString();
        NUMBER_ART = type.GetProperty("Number_art").GetValue(obj).ToString();
        COLOR = type.GetProperty("Color").GetValue(obj).ToString();
        NAME_MATERIAL = type.GetProperty("Name_material").GetValue(obj).ToString();
        COLOR_EGLANDED = type.GetProperty("Color_enlarged").GetValue(obj).ToString();
        MAT_UP = type.GetProperty("Mat_up").GetValue(obj).ToString();
        SEASON = type.GetProperty("Season").GetValue(obj).ToString();
    }
}
