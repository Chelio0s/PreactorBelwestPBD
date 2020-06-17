using Microsoft.SqlServer.Server;
using PreactorPBD;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Linq;

public partial class UserDefinedFunctions
{
    [Microsoft.SqlServer.Server.SqlFunction(
        FillRowMethodName = "FillAltRouteForFirstFloor",
        SystemDataAccess = SystemDataAccessKind.Read,
        DataAccess = DataAccessKind.Read,
        TableDefinition = @"IdRule              int
                            ,AreaId             int
                            ,TimeCoefficient    decimal(6,2)
                            ,TimeAddiction      decimal(6,2)
                            ,NeedCountDetails   bit
                            ,KOBParent          int
                            ,KOBChild           int
                            ,KTOPParent         int
                            ,KTOPChild          int
                            ,NormaTimeOld       decimal(6,2)
                            ,NormaTimeNew       decimal(6,2)
                            ,IdSemiProduct      int
                            ,IdRout             int
                            ,SimpleProductId    int
                            ,CategoryOperation  int
                            ,KPROF              int
                            ,REL                int")]
    public static IEnumerable ctvf_GetAltRouteForFirstFloor(int idRoute)
    {
        string Article = null;
        using (SqlConnection sqlConnection = new SqlConnection("context connection=true"))
        {
            SqlCommand command = new SqlCommand(
                @"SELECT [IdRule]
                    ,[AreaId]
                    ,[TimeCoefficient]
                    ,[TimeAddiction]
                    ,[NeedCountDetails]
                    ,[ResParentTitle]
                    ,[ResChildTitle]
                    ,[KOBParent]
                    ,[KOBChild]
                    ,[OpParentTitle]
                    ,[OpChildTitle]
                    ,[KTOPParent]
                    ,[KTOPChild]
                    ,[KTOPOriginal]
                    ,[KobOriginal]
                    ,[NormaTimeOld]
                    ,[NormaTimeNew]
                    ,[IdSemiProduct]
                    ,[IdRout]
                    ,[SimpleProductId]
                    ,[CategoryOperation]
                    ,[IdProfession]
                    ,[REL]
                FROM [InputData].[VI_MappingRuleForFirstFloor] " +
                $"WHERE IdRout =  {idRoute}", sqlConnection);
            sqlConnection.Open();

            var reader = command.ExecuteReader();

            var rules = new List<MappingRuleFull>();

            while (reader.Read())
            {
                rules.Add(new MappingRuleFull(Convert.ToInt32(reader[1]),
                    Convert.ToInt32(reader[18]),
                    Convert.ToInt32(reader[0]),
                    Convert.ToInt32(reader[17]),
                    Convert.ToInt32(reader[8]),
                    Convert.ToInt32(reader[7]),
                    Convert.ToInt32(reader[12]),
                    Convert.ToInt32(reader[11]),
                    Convert.ToBoolean(reader[4]),
                    Convert.ToDecimal(reader[16]),
                    Convert.ToDecimal(reader[15]),
                    Convert.ToDecimal(reader[3]),
                    Convert.ToDecimal(reader[2]),
                    Convert.ToInt32(reader[19]),
                    Convert.ToInt32(reader[20]),
                    Convert.ToInt32(reader[21]),
                    Convert.ToInt32(reader[22])));
            }

            if (rules.Count == 0)
            {
                return null;
            }
            else reader.Close();



            if (rules.Any(x => x.KTOPParent == 276 || x.KTOPParent == 182 ||
                               //If it is 6 simple product we will add extra operation
                               x.SimpleProductId == 6 ||
                               //If it is 1 simple product we will add extra operation
                               x.SimpleProductId == 1))
            {
                // Common operations for many RULES 
                // Getting article number

                command = new SqlCommand(@"SELECT TOP(1) [TitleArticle]
                                                     FROM [InputData].[VI_RoutesWithArticle] " +
                                         $"WHERE IdRout = {idRoute}", sqlConnection);
                reader = command.ExecuteReader();
                while (reader.Read())
                {
                    Article = reader[0].ToString();
                    reader.Close();
                    break;
                }

                // Getting all KTOPs for article
                command = new SqlCommand(@"SELECT 
                                                [KTOPN]
                                                FROM [InputData].[VI_OperationArticle_FAST] " +
                                         $"WHERE Article = '{Article}' and KPO = 'П9101'", sqlConnection);

                reader = command.ExecuteReader();
                // Fill KTOPs
                List<int> KTOPS = new List<int>();
                while (reader.Read())
                {
                    KTOPS.Add(Convert.ToInt32(reader[0]));
                }

                reader.Close();

                // Concrete rules for 6 semi product
                if (rules.Any(x => //If it is 6 simple product we will add extra operation
                    x.SimpleProductId == 6))
                {
                    //If rules is working
                    //If there are operations 
                    //Add operation is 
                    if (KTOPS.Any(x => x == 225 || x == 220 || x == 274 ||
                                       x == 163 || x == 129 || x == 265 ||
                                       x == 275 || x == 192 || x == 164))
                    {
                        //need to select operations 
                        //401 or 475 or 594 
                        //from second Area
                        //getting all KTOPs for article
                        command = new SqlCommand(@"SELECT 
                                                              [KTOPN]
                                                             ,[KOB]
                                                             ,[NORMATIME]
                                                             ,[CategoryOperation]
                                                             ,[KPROF]
                                                             ,[REL]
                                                        FROM [InputData].[VI_OperationArticle_FAST] " +
                                                 $"WHERE Article = '{Article}' and KPO = 'П9121'", sqlConnection);
                        // Fill KTOPs second floor
                        Dictionary<int, OperationWithTimeAndProffs> KTOPSSecond = new Dictionary<int, OperationWithTimeAndProffs>();
                        reader = command.ExecuteReader();
                        while (reader.Read())
                        {
                            KTOPSSecond.Add(Convert.ToInt32(reader[0]), new OperationWithTimeAndProffs(Convert.ToInt32(reader[0]),
                                                                                                        Convert.ToInt32(reader[1]),
                                                                                                        Convert.ToDecimal(reader[2]),
                                                                                                        Convert.ToInt32(reader[3]),
                                                                                                        Convert.ToInt32(reader[4]),
                                                                                                        Convert.ToInt32(reader[5])));
                        }

                        reader.Close();

                        if (KTOPSSecond.Any(x => x.Key == 401 || x.Key == 475 || x.Key == 594))
                        {
                            var maxtime = KTOPSSecond
                                .Where(x => x.Key == 401 || x.Key == 475 || x.Key == 594)
                                .Max(x => x.Value.Time);
                            var ktopsecondValue = KTOPSSecond.FirstOrDefault(x => x.Value.Time == maxtime
                                && (x.Key == 401 || x.Key == 475 || x.Key == 594));
                            var temprule = rules.FirstOrDefault();
                            //add extra operations
                            rules.Add(new MappingRuleFull(temprule.AreaId, temprule.IdRout, 0,
                                temprule.IdSemiProduct, 92, 0,
                                5216, 0, false, ktopsecondValue.Value.Time,
                                ktopsecondValue.Value.Time, 0, 1, temprule.SimpleProductId, 
                                temprule.CategoryOperation, 
                                temprule.CodeProff, 
                                ktopsecondValue.Value.REL));
                            rules.Add(new MappingRuleFull(temprule.AreaId, temprule.IdRout, 0,
                                temprule.IdSemiProduct, 179, 0,
                                5216, 0, false, ktopsecondValue.Value.Time,
                                ktopsecondValue.Value.Time, 0, 1, temprule.SimpleProductId,
                                temprule.CategoryOperation,
                                temprule.CodeProff,
                                ktopsecondValue.Value.REL));
                        }
                    }
                }

                // Concrete rules for 1 semi product
                if (rules.Any(x => //If it is 1 simple product we will add extra operation
                    x.SimpleProductId == 1))
                {
                    //need to select operations 
                    //494 or 360 
                    //5494 or 5360 
                    //from second Area or 9/2 Area
                    //getting all KTOPs for article
                    command = new SqlCommand(@"SELECT 
                                                              [KTOPN]
                                                             ,[KOB]
                                                             ,[NORMATIME]
                                                             ,[CategoryOperation]
                                                             ,[KPROF]
                                                             ,[REL]
                                                        FROM [InputData].[VI_OperationArticle_FAST] " +
                                             $"WHERE Article = '{Article}' and (KPO = 'П9121' or KPO = 'П9130') ", sqlConnection);
                    // Fill KTOPs second floor
                    Dictionary<int, OperationWithTimeAndProffs> KTOPSSecond = new Dictionary<int, OperationWithTimeAndProffs>();
                    reader = command.ExecuteReader();
                    while (reader.Read())
                    {
                        KTOPSSecond.Add(Convert.ToInt32(reader[0]), new OperationWithTimeAndProffs(Convert.ToInt32(reader[0]),
                            Convert.ToInt32(reader[1]),
                            Convert.ToDecimal(reader[2]),
                            Convert.ToInt32(reader[3]),
                            Convert.ToInt32(reader[4]),
                            Convert.ToInt32(reader[5])));
                    }

                    reader.Close();

                    if (KTOPSSecond.Any(x => x.Key == 494 || x.Key == 360 ||
                                             x.Key == 5494 || x.Key == 5360))
                    {
                        var maxtime = KTOPSSecond
                            .Where(x => x.Key == 494 || x.Key == 360 ||
                                        x.Key == 5494 || x.Key == 5360)
                            .Max(x => x.Value.Time);

                        var ktopsecondValue = KTOPSSecond.FirstOrDefault(x =>
                            x.Value.Time == maxtime
                            && (x.Key == 494 || x.Key == 360 ||
                                x.Key == 5494 || x.Key == 5360));

                        var temprule = rules.FirstOrDefault();
                        //add extra operations
                        rules.Add(new MappingRuleFull(temprule.AreaId, temprule.IdRout, 0,
                            temprule.IdSemiProduct, 93, 0,
                            5251, 0, false, ktopsecondValue.Value.Time,
                            ktopsecondValue.Value.Time, 0, 1, temprule.SimpleProductId,
                            temprule.CategoryOperation,
                            temprule.CodeProff,
                            ktopsecondValue.Value.REL));
                    }

                }

                // Concrete rules for 126 macro operation
                if (rules.Any(x => x.KTOPParent == 276 || x.KTOPParent == 182))
                {
                    var tempRules = rules.Where(x => x.KTOPParent == 276 || x.KTOPParent == 182).ToList();
                    var rulesFinal = rules.Where(x => x.KTOPParent != 276 && x.KTOPParent != 182).ToList();


                    // RULE 1 From excel
                    if (KTOPS.Any(x => x == 102)) //276 => 5179 + 5287 + 5288 + 5289 and 182 => 5182
                    {
                        //There is operation is 276
                        if (KTOPS.Any(x => x == 276))
                        {
                            var result = tempRules.Where(x => (x.KTOPParent == 182 && x.KTOPChild == 5182) ||
                                                              (x.KTOPParent == 276 &&
                                                               (x.KTOPChild == 5179 || x.KTOPChild == 5287
                                                                                    || x.KTOPChild == 5288
                                                                                    || x.KTOPChild == 5289)))
                                .ToList();
                            rulesFinal.AddRange(result);
                        }
                        //if is no
                        else // 182=> 5182 + 5287 + 5288 + 5289;
                        {
                            var result = tempRules.Where(x => (x.KTOPParent == 182 &&
                                                               (x.KTOPChild == 5179 || x.KTOPChild == 5287
                                                                                    || x.KTOPChild == 5288
                                                                                    || x.KTOPChild == 5289)))
                                .ToList();
                            rulesFinal.AddRange(result);
                        }

                        return rulesFinal;
                    }
                    // RULE 2 from excel
                    else if (KTOPS.Any(x => x == 225 || x == 220))
                    {
                        // if there is operation 276
                        //276 => 5179 + 5287 + 5234 + 5288 + 5289 and 182 => 5182
                        if (KTOPS.Any(x => x == 276))
                        {
                            var result = tempRules.Where(x => (x.KTOPParent == 182 && x.KTOPChild == 5182) ||
                                                              (x.KTOPParent == 276 &&
                                                               (x.KTOPChild == 5179 || x.KTOPChild == 5287
                                                                                    || x.KTOPChild == 5288
                                                                                    || x.KTOPChild == 5289
                                                                                    || x.KTOPChild == 5234)))
                                .ToList();
                            rulesFinal.AddRange(result);
                        }
                        //if is not
                        //182 => 5182 + 5287 + 5234 + 5288+ 5289;
                        else
                        {
                            var result = tempRules.Where(x => (x.KTOPParent == 182 &&
                                                               (x.KTOPChild == 5179 || x.KTOPChild == 5287
                                                                                    || x.KTOPChild == 5288
                                                                                    || x.KTOPChild == 5289
                                                                                    || x.KTOPChild == 5234)))
                                .ToList();
                            rulesFinal.AddRange(result);
                        }

                        return rulesFinal;
                    }
                    //RULE 3 from excel
                    else if (KTOPS.Any(
                        x => x == 163 || x == 128 || x == 129 || x == 265 || x == 192 || x == 164))
                    {
                        // if there is operation 276
                        //  276 => 5179 + 5287  + 5234 and 182 => 5182,
                        if (KTOPS.Any(x => x == 276))
                        {
                            var result = tempRules.Where(x => (x.KTOPParent == 182 && x.KTOPChild == 5182) ||
                                                              (x.KTOPParent == 276 &&
                                                               (x.KTOPChild == 5179 || x.KTOPChild == 5287 ||
                                                                x.KTOPChild == 5234))).ToList();
                            rulesFinal.AddRange(result);
                        }
                        //if not
                        // 182 => 5182 + 5287 + 5234;
                        else
                        {
                            var result = tempRules.Where(x => (x.KTOPParent == 182 &&
                                                               (x.KTOPChild == 5182 || x.KTOPChild == 5287 ||
                                                                x.KTOPChild == 5234))).ToList();
                            rulesFinal.AddRange(result);
                        }
                        return rulesFinal;
                    }

                }
            }

            //Delete dublicates if there are two the same operations for KOB = 227 and kob =  265
            //if route contains 265 KOB
            if (rules.Any(x => x.KOBParent == 265))
            {
                var operaTionsWithDublicates = rules.GroupBy(x => x.KTOPChild)
                    .Where(x => x.Count() > 1)
                    .Where(predicate: x => x.Select(y => y.KOBParent).Count(z => z == 227 || z == 265) == 2)
                    .Select(x => x.Key);

                foreach (var dublicate in operaTionsWithDublicates)
                {
                    var r = rules.FirstOrDefault(x => x.KOBParent == 265 && x.KTOPChild == dublicate);
                    rules.Remove(r);
                }
            }

            return rules;
        }
    }
    public static void FillAltRouteForFirstFloor(object obj
        , out SqlInt32 IdRule
        , out SqlInt32 AreaId
        , out SqlDecimal TimeCoefficient
        , out SqlDecimal TimeAddiction
        , out SqlBoolean NeedCountDetails
        , out SqlInt32 KOBParent
        , out SqlInt32 KOBChild
        , out SqlInt32 KTOPParent
        , out SqlInt32 KTOPChild
        , out SqlDecimal NormaTimeOld
        , out SqlDecimal NormaTimeNew
        , out SqlInt32 IdSemiProduct
        , out SqlInt32 IdRout
        , out SqlInt32 SimpleProductId
        , out SqlInt32 CategoryProff
        , out SqlInt32 KPROF
        , out SqlInt32 REL)
    {
        if (obj is MappingRuleFull item)
        {
            IdRule = item.IdRule;
            AreaId = item.AreaId;
            TimeCoefficient = item.TimeCoefficient;
            TimeAddiction = item.TimeAddiction;
            NeedCountDetails = item.NeedCountDetails;
            KOBParent = item.KOBParent;
            KOBChild = item.KOBChild;
            KTOPParent = item.KTOPParent;
            KTOPChild = item.KTOPChild;
            NormaTimeOld = item.NormaTimeOld;
            NormaTimeNew = item.NormaTimeNew;
            IdSemiProduct = item.IdSemiProduct;
            IdRout = item.IdRout;
            SimpleProductId = item.SimpleProductId;
            KPROF = item.CodeProff;
            CategoryProff = item.CategoryOperation;
            REL = item.REL;
        }
        else
        {
            throw new InvalidCastException("Ошибка преобразования в CLR методе FillAltRouteForFirstFloor");
        }
    }
}
