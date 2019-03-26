using System;

namespace PreactorPBD
{
    /// <summary>
    /// �����, ��� �������� ���� � ��������� ������� ��� OrgUnit + Date
    /// </summary>
    internal class ShiftSetting
    {
        public int OrgUnit { get; set; }
        public DateTime DateWorkDay { get; set; }
        public int ShiftId { get; set; }
        public int AreaId { get; set; }
        public TimeSpan TimeStart { get; set; }
    }
}
