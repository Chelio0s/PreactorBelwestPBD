using System;

namespace PreactorPBD
{
    /// <summary>
    /// ����� ��� �������� �������� ����� ��� Shft + Area
    /// </summary>
    internal class CicleWork
    {
        public int IdCicle { get; set; }
        public int ShiftId { get; set; }
        public TimeSpan DurationOn { get; set; }
        public TimeSpan DurationOff { get; set; }
        public int AreaId { get; set; }
    }
}
