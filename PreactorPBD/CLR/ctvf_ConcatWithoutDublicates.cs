using System;
using System.Data.SqlTypes;
using System.IO;
using System.Text;
using Microsoft.SqlServer.Server;
using System.Collections.Generic;

[Serializable]
[SqlUserDefinedAggregate(
    Format.UserDefined, //use clr serialization to serialize the intermediate result  
    IsInvariantToNulls = true, //optimizer property  
    IsInvariantToDuplicates = true, //optimizer property  
    IsInvariantToOrder = false, //optimizer property  
    MaxByteSize = 8000)] //maximum size in bytes of persisted value  



public struct ctvf_ConcatWithoutDublicates : IBinarySerialize
{
    /// <summary>  
    /// The variable that holds the intermediate result of the concatenation  
    /// </summary>  
    private StringBuilder intermediateResult;
    private SortedSet<string> set;
    /// <summary>  
    /// Initialize the internal data structures  
    /// </summary>  
    public void Init()
    {
        this.intermediateResult = new StringBuilder();
        this.set = new SortedSet<string>();
    }



    /// <summary>  
    /// Accumulate the next value, not if the value is null  
    /// </summary>  
    /// <param name="value"></param>  
    public void Accumulate(SqlString value)
    {
        if (value.IsNull)
        {
            return;
        }
        if (set.Contains(value.Value))
        {
            return;
        }
        set.Add(value.Value);
        this.intermediateResult.Append(value.Value).Append(',');
    }

    /// <summary>  
    /// Merge the partially computed aggregate with this aggregate.  
    /// </summary>  
    /// <param name="other"></param>  
    public void Merge(ctvf_ConcatWithoutDublicates other)
    {
        this.intermediateResult.Append(other.intermediateResult);
    }

    /// <summary>  
    /// Called at the end of aggregation, to return the results of the aggregation.  
    /// </summary>  
    /// <returns></returns>  
    public SqlString Terminate()
    {
        string output = string.Empty;
        //delete the trailing comma, if any  
        if (this.intermediateResult != null
            && this.intermediateResult.Length > 0)
        {
            output = this.intermediateResult.ToString(0, this.intermediateResult.Length - 1);
        }

        var result = output.ToString().Split(',');

        return new SqlString(output);
    }

    public void Read(BinaryReader r)
    {
        intermediateResult = new StringBuilder(r.ReadString());
    }

    public void Write(BinaryWriter w)
    {
        w.Write(this.intermediateResult.ToString());
    }
}
