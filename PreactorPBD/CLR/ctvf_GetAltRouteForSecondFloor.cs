using System;
using System.Collections;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Linq;
using Microsoft.SqlServer.Server;
using PreactorPBD;

public partial class UserDefinedFunctions
{
    [Microsoft.SqlServer.Server.SqlFunction(
        FillRowMethodName = "FillAltRouteForSecondFloor",
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
                            ,KPROF              int")]
    public static IEnumerable ctvf_GetAltRouteForSecondFloor(int idRoute, int idArea)
    {
        using (SqlConnection sqlConnection = new SqlConnection("context connection = true"))
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
                FROM [InputData].[VI_MappingRuleForSecondFloor] " +
                $"WHERE IdRout =  {idRoute} AND AreaId = {idArea}", sqlConnection);
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
                    Convert.ToInt32(reader[21])));
            }

            if (rules.Count == 0)
            {
                return null;
            }
            else reader.Close();

            //Если есть операции машинного вклеивания, нужно проверить, есть ли в оригинальном ТМ ручные 415 или 572
            if (rules.Where(x=>(x.KTOPParent == 347 && (x.KTOPParent == 348 || x.KTOPParent == 503))).Any())
            {
                command = new SqlCommand("SELECT KTOP FROM [InputData].[VI_OperationsWithSemiProducts_FAST]" +
                                         $"      WHERE SemiProductId = {rules.FirstOrDefault().IdSemiProduct}" +
                                         $"      AND KTOP IN (415, 572)", sqlConnection);
                
                //Если такие операции есть, то удаляем правила маппинга машина - ручное, т.к. ручные уже есть в другом 
                //варианте ТМ, а этот ТМ мы дропнем в итоге
                if (command.ExecuteScalar()==null)
                {
                    throw new Exception("Ошибка в алгоритме, есть машинное вклеивание и нет ручного!");
                    //Если когда то вылетит ошибка, сделать алгоритм, взять операции из 2го цеха машинные и 
                    // посчитать машинные по формуле  415(572)=347*1,48+348(503)*1,48  <-- проверить в алгоритме технологов
                }
            }

            return rules;
        }
    }

    public static void FillAltRouteForSecondFloor(object obj
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
        , out SqlInt32 KPROF)
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
        }
        else
        {
            throw new InvalidCastException("Ошибка преобразования в CLR методе FillAltRouteForSecondFloor");
        }
    }
}
