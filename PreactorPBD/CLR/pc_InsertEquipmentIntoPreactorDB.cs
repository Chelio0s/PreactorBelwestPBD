using System;

using System.Collections.Generic;
using System.Data.SqlClient;
using Oracle.ManagedDataAccess.Client;
using PreactorPBD;

public partial class StoredProcedures
{
    [Microsoft.SqlServer.Server.SqlProcedure]
    public static void pc_InsertEquipmentIntoPreactorDB()
    {

        using (OracleConnection oracleConnection
            = new OracleConnection(OracleSettings.GetConnectionString(OracleDataBase.MPU)))
        {
            using (SqlConnection sqlConnection
                = new SqlConnection("context connection=true"))
            {
                string commandStr = @"SELECT KPLOT, WP, bind.KOB, obor.mob FROM belwpr.ri_bind_ob bind 
                INNER JOIN belwpr.st_obor obor ON bind.KOB = obor.KOB";
                oracleConnection.Open();
                OracleCommand oracleCommand = new OracleCommand(commandStr, oracleConnection);
                List<Equipment> equipmetList = new List<Equipment>();
                var READER = oracleCommand.ExecuteReader();
                int id = 0;
                sqlConnection.Open();
                while (READER.Read())
                {
                    equipmetList.Add(new Equipment
                    {
                        ID = id++,
                        KPLOT = READER[0].ToString(),
                        WP = Convert.ToInt32(READER[1]),
                        KOB = Convert.ToInt32(READER[2]),
                        MOB = READER[3].ToString().Trim()
                    });
                }
                SqlCommand sqlCommand = new SqlCommand("", sqlConnection);
                foreach (Equipment equipment in equipmetList)
                {
                    string commStr = string.Format("INSERT INTO [InputData].[Resources] " +
                           "([IdResource] " +
                            ",[Title]" +
                            ",[TitleWorkPlace]" +
                            ",[DepartmentId]" +
                            ",[KOB])" +
                    "VALUES" +
                    $"({equipment.ID}" +
                    $",'{equipment.MOB}: Уч-ок {equipment.KPLOT} : Раб. место: {equipment.WP}'" +
                    $",'{equipment.WP}'" +
                    $",{equipment.KPLOT}" +
                    $",{equipment.KOB}) ");

                    sqlCommand.CommandText = commStr;
                    sqlCommand.ExecuteNonQuery();
                }
            }

        }
    }
}
