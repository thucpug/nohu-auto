using _AutoTx_Projecgt.Helper.Circles;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _AutoTx_Projecgt.Helper
{
    public class setCommonCircles
    {
        public static List<_1circleOne> listAllCircleSetBet = new List<_1circleOne>();
        public string hictoryCircle10Before { get; set; }
        public int amountMoneyWonToStop { get; set; } = 50000000;
        public List<int> listAmountPausewhenLose = new List<int>();
        public int moneyToBet { get; set; }
        public Int32 moneyWillbetThepAll { get; set; }
        public double XNumber { get; set; }
        public int betAfterSeconds { get; set; }


        public static int totalWin { get; set; }
        public static int totalLose { get; set; }

        #region ifbetthepallcau
        public static int allC_amountLose { get; set; } = 0;
        public static Int32 allC_moneyWillBet { get; set; } = 0;

        #endregion
        #region betUpDown
        public static int UDmoneyWillBetNextSession { get; set; } = 0;
        public static int UDmoneyBetBeforeSession { get; set; } = 0;
        public static int UDmoneyMin { get; set; }
        public static int UDmoney { get; set; }
        #endregion

        #region betFollowsRowsMoney
        public static List<_2circleRowsWait> listCirecleRowWait = new List<_2circleRowsWait>();
        public List<int> listNumbersWaitting = new List<int>();
        #endregion
        #region KindofBet
        public static bool betOneMoney = false;
        public static bool betThepTachBietMoiCau = false;
        public static bool betThepAllCau = false;
        public static bool betUpDownMoneyDefault = false;
        public static bool betRandom2Col = false;
        public static bool betFollowRowsMoney = false;
        public static bool betFollowLastBefore= false;

        public static bool betFollowTXNotChange = false;
        public static bool betFollowTXNotChange_UD = false;

        public static bool betFollowTXTTWaitnTobet = false;
        #endregion
        #region betTXNotchange_Thep
        public static bool isLastCirToBet = false;
        public static int allTXDefaultNotCh_amountLose { get; set; } = 0;
        public static Int32 allTXDefaultNotCh_moneyWillBet { get; set; } = 0;
        public static bool allTXDefaultNotCh_isChangeContinute = true;
        public static int allTXDefaultNotCh_PauseWhenLose { get; set; } = 10;
        #endregion
        #region betFollowTXTTWaitnTobet
        public static int betFollowTXTTWaitnTobetANumbertext { get; set; } = 4;
        public static int betFollowTXTTWaitnMoeny { get; set; } = 4;
        #endregion
    }
}
