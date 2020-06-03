using System;

namespace PreactorPBD
{
    /// <summary>
    /// Класс для хранения рабочего цикла для Shft + Area
    /// </summary>
    readonly struct CicleWork
    {
        public CicleWork( int idCicle
                        , int shiftId 
                        , TimeSpan durationOn
                        , TimeSpan durationOff
                        , int areaId
                        , DateTime cicleDate
                        , int? specificOrgUnit)
        {
            IdCicle = idCicle;
            ShiftId = shiftId;
            DurationOn = durationOn;
            DurationOff = durationOff;
            AreaId = areaId;
            CicleDate = cicleDate;
            SpecificOrgUnit = specificOrgUnit;
        }
        public int IdCicle { get;  }
        public int ShiftId { get; }
        public TimeSpan DurationOn { get;  }
        public TimeSpan DurationOff { get;  }
        public int AreaId { get;  }
        public DateTime CicleDate { get; }
        public int? SpecificOrgUnit { get; }
    }
}
