using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using Microsoft.SqlServer.Server;
using PreactorPBD;

public partial class UserDefinedFunctions
{
    [Microsoft.SqlServer.Server.SqlFunction(
        FillRowMethodName = "FillRowWorks", SystemDataAccess = SystemDataAccessKind.Read,
        DataAccess = DataAccessKind.Read,
        TableDefinition =
            "StartWork datetime, " +
            "EndWork datetime")]

    public static IEnumerable ctvf_GetWorkTime2Shifts(int OrgUnit, DateTime DateWorkDay)
    {
        List<WorkTime> workTimes = new List<WorkTime>();

        using (SqlConnection con = new SqlConnection("context connection=true"))
        {
            con.Open();
            string cmdText = @"SELECT [OrgUnit]
                                    , org.[Title]
                                    ,org.Crew
                                    ,wdays.DateWorkDay
                                    ,wdays.ShiftId
                                    ,areas.IdArea
                                    ,[InputData].[udf_GetStartTimeForShift] ([OrgUnit], wdays.ShiftId) as timeStart
                            FROM       [SupportData].[OrgUnit] as org
                            INNER JOIN [InputData].[Areas] as areas ON areas.IdArea = org.AreaId
                            CROSS JOIN [SupportData].[WorkDays] as wdays " +
                     $" WHERE OrgUnit = {OrgUnit} and DateWorkDay = @date and ShiftId = [InputData].[udf_GetShiftNumber](OrgUnit, wdays.DateWorkDay)";

            SqlCommand comm = new SqlCommand(cmdText, con);
            comm.Parameters.Add("@date", SqlDbType.Date);
            comm.Parameters["@date"].Value = DateWorkDay.Date;

            SqlDataReader reader;
            ShiftSetting shiftSetting = null;
            try
            {
                reader = comm.ExecuteReader();
            }
            catch (Exception)
            {
                throw new Exception("Ошибка при выполнении запроса" + Environment.NewLine +
                                    cmdText);
            }

            int counter = 0;

            while (reader.Read())
            {
                if (counter < 1)
                {
                    shiftSetting = new ShiftSetting();

                    try
                    {
                        shiftSetting.OrgUnit = Convert.ToInt32(reader[0]);
                        shiftSetting.DateWorkDay = Convert.ToDateTime(reader[3]);
                        shiftSetting.ShiftId = Convert.ToInt32(reader[4]);
                        shiftSetting.AreaId = Convert.ToInt32(reader[5]);
                        shiftSetting.TimeStart = TimeSpan.Parse(reader[6].ToString());
                    }
                    catch
                    {
                        throw new Exception("Ошибка при преобразовании типов после выборки SettingShift" + Environment.NewLine +
                                            "OrgUnit:" + shiftSetting.OrgUnit + " Date:" + shiftSetting.DateWorkDay + " ShiftId:" + shiftSetting.ShiftId);
                    }

                    counter++;
                }
                else
                    throw new Exception(
                            "Выборка настройки времени начала смены для OrgUnit + DateWorkDay вернула больше одной строки! " + Environment.NewLine +
                             $"OrgUnit:{OrgUnit}, DateWorkDay:{DateWorkDay}");
            }

            if (shiftSetting == null)
                return workTimes;


            cmdText = @"SELECT [IdCicle]
                          ,[AreaId]
                          ,[DurationWork]
                          ,[DurationOff]
                          ,[ShiftId]
                      FROM [SupportData].[Cicle]" +
              $"  WHERE AreaId = {shiftSetting.AreaId} and ShiftId = {shiftSetting.ShiftId}";

            comm = new SqlCommand(cmdText, con);
            reader.Close();

            try
            {
                reader = comm.ExecuteReader();
            }
            catch
            {
                throw new Exception("Ошибка при выполнении запроса" + Environment.NewLine +
                                    cmdText);
            }
            List<CicleWork> cicles = new List<CicleWork>();

            while (reader.Read())
            {
                var cw = new CicleWork();
                try
                {
                    cw = new CicleWork(Convert.ToInt32(reader[0])
                        , Convert.ToInt32(reader[1])
                        , TimeSpan.Parse(reader[2].ToString())
                        , TimeSpan.Parse(reader[3].ToString())
                        , Convert.ToInt32(reader[4]));
                }
                catch
                {
                    throw new Exception("Ошибка при преобразовании типов после выборки Cicle " + Environment.NewLine +
                                        "AreaId:" + cw.AreaId + " ShiftId:" + cw.ShiftId);
                }
                cicles.Add(cw);
            }


            var timeStart = shiftSetting.DateWorkDay + shiftSetting.TimeStart;
            foreach (var c in cicles)
            {
                var wt = new WorkTime(timeStart, timeStart + c.DurationOn);
           
                timeStart = wt.EndWork + c.DurationOff;
                workTimes.Add(wt);

                Console.WriteLine(wt.StartWork + "   " + wt.EndWork);
            }
        }
        return workTimes;
    }


}
