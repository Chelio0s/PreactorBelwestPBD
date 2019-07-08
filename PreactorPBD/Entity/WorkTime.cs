using System;

readonly struct WorkTime
{
    public WorkTime(DateTime startWork, DateTime endWork)
    {
        StartWork = startWork;
        EndWork = endWork;
    }
    public DateTime StartWork { get;  }
    public DateTime EndWork { get; }
}

