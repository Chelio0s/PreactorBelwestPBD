using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Microsoft.SqlServer.Server;
using PreactorPBD;

public partial class UserDefinedFunctions
{
    [SqlFunction(
        FillRowMethodName = "FillRowWorks", SystemDataAccess = SystemDataAccessKind.Read,
        DataAccess = DataAccessKind.Read,
        TableDefinition =
            "StartWork datetime, " +
            "EndWork datetime")]

    public static IEnumerable ctvf_GetWorkTimeSummAccounting(int orgUnit, DateTime dateWorkDay)
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
                                    ,[InputData].[udf_GetStartTimeForShift] (OrgUnit, wdays.ShiftId, wdays.DateWorkDay) as timeStart
                                   FROM       [SupportData].[OrgUnit] as org
                                   INNER JOIN [InputData].[Areas] as areas ON areas.IdArea = org.AreaId
                                   INNER JOIN [SupportData].[WorkDays] as wdays ON wdays.Crew = org.Crew" +
                             $" WHERE OrgUnit = {orgUnit} and DateWorkDay = @date";

            SqlCommand comm = new SqlCommand(cmdText, con);
            comm.Parameters.Add("@date", SqlDbType.Date);
            comm.Parameters["@date"].Value = dateWorkDay.Date;

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
                        throw new Exception("Ошибка при преобразовании типов после выборки SettingShift" +
                                            Environment.NewLine +
                                            "OrgUnit:" + shiftSetting.OrgUnit + " Date:" +
                                            shiftSetting.DateWorkDay + " ShiftId:" + shiftSetting.ShiftId);
                    }

                    counter++;
                }
                else
                    throw new Exception(
                        "Выборка настройки времени начала смены для OrgUnit + DateWorkDay вернула больше одной строки! " +
                        Environment.NewLine +
                        $"OrgUnit:{orgUnit}, DateWorkDay:{dateWorkDay}");
            }

            if (shiftSetting == null)
                return workTimes;

            cmdText = $@"SELECT    [IdCicle]
                                  ,[AreaId]
                                  ,[DurationWork]
                                  ,[DurationOff]
                                  ,[ShiftId]
                                  ,[StartUseFrom]
								  ,[SpecificOrgUnit]
                            FROM       [SupportData].[Cicle] as cc
                            INNER JOIN [SupportData].[CicleUseFrom] as cuf ON cuf.[CicleId] = cc.IdCicle
                            WHERE AreaId = {shiftSetting.AreaId} AND ShiftId = {shiftSetting.ShiftId} AND [StartUseFrom] <= @date 
						    AND ([SpecificOrgUnit] = {orgUnit} OR [SpecificOrgUnit] is NULL)
                            ORDER BY [SpecificOrgUnit] desc, StartUseFrom DESC";

            comm = new SqlCommand(cmdText, con);
            comm.Parameters.Add("@date", SqlDbType.Date);
            comm.Parameters["@date"].Value = dateWorkDay.Date;
            reader.Close();

            try
            {
                reader = comm.ExecuteReader();
            }
            catch
            {
                throw new Exception($"Ошибка при выполнении запроса {Environment.NewLine} {cmdText}");
            }

            var cicles = new List<CicleWork>();

            while (reader.Read())
            {
                var cw = new CicleWork();
                try
                {
                    if (int.TryParse(reader[6].ToString(), out var xResult))
                    {
                        cw = new CicleWork(Convert.ToInt32(reader[0])
                            , Convert.ToInt32(reader[1])
                            , TimeSpan.Parse(reader[2].ToString())
                            , TimeSpan.Parse(reader[3].ToString())
                            , Convert.ToInt32(reader[4])
                            , Convert.ToDateTime(reader[5])
                            , xResult);
                    }
                    else cw = new CicleWork(Convert.ToInt32(reader[0])
                        , Convert.ToInt32(reader[1])
                        , TimeSpan.Parse(reader[2].ToString())
                        , TimeSpan.Parse(reader[3].ToString())
                        , Convert.ToInt32(reader[4])
                        , Convert.ToDateTime(reader[5])
                        , null);
                }
                catch
                {
                    throw new Exception($"Ошибка при преобразовании типов после выборки Cicle {Environment.NewLine} " +
                                        $" AreaId: {cw.AreaId} ShiftId: {cw.ShiftId}");
                }
                cicles.Add(cw);
            }

            var timeStart = shiftSetting.DateWorkDay + shiftSetting.TimeStart;
            var max = cicles.First().CicleDate;
            if (cicles.First().SpecificOrgUnit != null)
            {
                foreach (var c in cicles.Where(x => x.CicleDate == max
                                                    && x.SpecificOrgUnit != null))
                {
                    var wt = new WorkTime(timeStart, timeStart + c.DurationOn);
                    timeStart = wt.EndWork + c.DurationOff;
                    workTimes.Add(wt);
                }
            }
            else
            {
                foreach (var c in cicles.Where(x => x.CicleDate == max
                                                    && x.SpecificOrgUnit == null))
                {
                    var wt = new WorkTime(timeStart, timeStart + c.DurationOn);
                    timeStart = wt.EndWork + c.DurationOff;
                    workTimes.Add(wt);
                }
            }

        }

        return workTimes;
    }

    public static void FillRowWorks(object obj, out DateTime startWork, out DateTime endWork)
    {
        var wt = (WorkTime)obj;
        startWork = wt.StartWork;
        endWork = wt.EndWork;
    }
}
