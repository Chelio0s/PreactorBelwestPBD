using System;

namespace PreactorPBD
{
    /// <summary>
    /// �����, ��� �������� ���� � ��������� ������� ��� OrgUnit + Date
    /// </summary>
    class ShiftSetting
    {
        public ShiftSetting()
        {
            
        }

        public int OrgUnit { get; set; }
        public DateTime DateWorkDay { get; set; }
        public int ShiftId { get; set; }
        public int AreaId { get; set; }
        public TimeSpan TimeStart { get; set; }
    }
}
