using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _AutoTx_Projecgt.Helper.Circles
{
    public class _2circleRowsWait
    {
        public int idcircleWait { get; set; }
        public int indexlistWait { get; set; } = 0;
        public string Session { get; set; }
        public int moneyStartWait { get; set; }
        public int moneyWillWaitNextSession { get; set; }
        public List<int> listwaitNumberWhenLoses = new List<int>();
        public int countLoses { get; set; }
        public bool isBetorPause { get; set; }
        public bool iswaitStatus { get; set; }
    }
}
