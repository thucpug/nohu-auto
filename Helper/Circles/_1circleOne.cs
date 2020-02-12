using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _AutoTx_Projecgt.Helper
{

    public class _1circleOne
    {
        public int idCircle { get; set; }
        public string circleBETS { get; set; }
        public string circleCompare { get; set; }
        public string _TorXIfTrue { get; set; }
        public string _TorXNotDefault { get; set; }
        public string _TorXrandom { get; set; }
        public Int32 moneyWillbetNextSeassion { get; set; }
        public bool statusCheck { get; set; }
        public bool checkStopWhenWonOneThep1van { get; set; } = false;
        //  public bool checkWin { get; set; } = false;

        public int amoutPausewhenLoseAboutNumber { get; set; }
        public int amountLose { get; set; } = 0;

        public int momentTotalWin { get; set; }
        public int momentTotalLose { get; set; }
        public int momentTotalBet { get; set; }

        public int BetFollowTXTTWaitNumber { get; set; }
        public bool BetFollowTXTTWaitNumberStatus { get; set; }

    }
}
