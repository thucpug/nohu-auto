using _AutoTx_Projecgt.Helper;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace _AutoTx_Projecgt
{
    public partial class AutoBet : Form
    {
        public AutoBet()
        {
            InitializeComponent();
            Control.CheckForIllegalCrossThreadCalls = false;
        }
        mainGameHelper mainGameHelper = new mainGameHelper();
        private void AutoBet_Load(object sender, EventArgs e)
        {
            //chkbetdeu.Visible = false;
            //chkbetupdown.Visible = false;
            //chkFollowsRow.Visible = false;
            //chkthepallcau.Visible = false;
            //chktheptachbietcau.Visible = false;
            //button1.Visible = false;
        }
        #region MyfunchandingForm
        void wrToListBoxCircleHigh(string a)
        {
            lsbCircleAdd.Items.Add(a);
            lsbCircleAdd.SelectedIndex = lsbCircleAdd.Items.Count - 1;
        }
        void wrOnlistViewHictorycirclehigh(_1circleOne a)
        {
            ListViewItem item = new ListViewItem(a.idCircle.ToString());
            item.SubItems.Add(a.circleBETS);
            item.SubItems.Add(a.momentTotalWin.ToString());
            item.SubItems.Add(a.momentTotalLose.ToString());
            item.SubItems.Add((a.momentTotalWin - a.momentTotalLose).ToString());
            item.ForeColor = Color.Blue;
            lsvhicCircle.Items.Add(item);
        }
        void setHictoryTX(string data)
        {
            Invoke((MethodInvoker)delegate
            {
                linkLabel1.Text = data;
                string azzz = data.Substring(data.Length - 1, 1);
                if (lsvBet.Items.Count > 0)
                {
                    string a = lblSessionat.Text;
                    string b = lsvBet.Items[lsvBet.Items.Count - 1].SubItems[1].Text;
                    if (azzz == lsvBet.Items[lsvBet.Items.Count - 1].SubItems[2].Text && a == b)
                    {
                        lsvBet.Items[lsvBet.Items.Count - 1].SubItems[4].Text = "Won";
                        lsvBet.Items[lsvBet.Items.Count - 1].UseItemStyleForSubItems = false;
                        lsvBet.Items[lsvBet.Items.Count - 1].SubItems[4].ForeColor = Color.DarkGreen;
                    }
                    else if (lsvBet.Items[lsvBet.Items.Count - 1].SubItems[2].Text == "P" && a == b)
                    {
                        lsvBet.Items[lsvBet.Items.Count - 1].SubItems[4].Text = "Pause";
                        lsvBet.Items[lsvBet.Items.Count - 1].UseItemStyleForSubItems = false;
                        lsvBet.Items[lsvBet.Items.Count - 1].SubItems[4].ForeColor = Color.DarkGray;
                    }
                    else if (a == b)
                    {
                        lsvBet.Items[lsvBet.Items.Count - 1].SubItems[4].Text = "Lose";
                        lsvBet.Items[lsvBet.Items.Count - 1].UseItemStyleForSubItems = false;
                        lsvBet.Items[lsvBet.Items.Count - 1].SubItems[4].ForeColor = Color.Red;
                    }
                }



            });
        }
        void settotalbetOne(int data)
        {
            Invoke((MethodInvoker)delegate
            {
                if (data != -1)
                {
                    if (!setCommonCircles.betFollowTXNotChange)
                    {
                        lsvhicCircle.Items[data].SubItems[2].Text = setCommonCircles.listAllCircleSetBet[data].momentTotalWin.ToString();
                        lsvhicCircle.Items[data].SubItems[3].Text = setCommonCircles.listAllCircleSetBet[data].momentTotalLose.ToString();
                        lsvhicCircle.Items[data].SubItems[4].Text = setCommonCircles.listAllCircleSetBet[data].momentTotalBet.ToString();
                    }

                }

            });
        }
        int indexIncre = 0;
        bool checkIn = false;
        int profits = 0;
        void setSesionid(string data, bool check)
        {
            Invoke((MethodInvoker)delegate
            {
                profits = mainGameHelper.CheckMoneyPfrofit(Int32.Parse(lblmoneystart.Text));
                lblprofits.Text = profits.ToString("N2");
                if (profits >= mainGameHelper.setCommonCircles.amountMoneyWonToStop)
                {
                    this.Close();
                }
                lbltotalwin.Text = setCommonCircles.totalWin.ToString();
                lbltotallose.Text = setCommonCircles.totalLose.ToString();
                if (check)
                {
                    checkIn = true;
                    var temp = data.Split('-');
                    indexIncre++;
                    ListViewItem item = new ListViewItem(indexIncre.ToString());
                    item.SubItems.Add(temp[0]);
                    if (temp[1] == "1")
                    {
                        lbltripStatuslogin.Text = "Session betting: Xiu";
                        item.SubItems.Add("X");
                    }
                    else if (temp[1] == "2")
                    {
                        lbltripStatuslogin.Text = "Session betting: Tai";
                        item.SubItems.Add("T");
                    }
                    else
                    {
                        lbltripStatuslogin.Text = "Session betting: Pause";
                        item.SubItems.Add("P");
                    }
                    if (chkbetdeu.Checked)
                    {
                        item.SubItems.Add(mainGameHelper.setCommonCircles.moneyToBet.ToString());
                    }
                    else if (chktheptachbietcau.Checked == true)
                    {
                        string money = (Convert.ToInt32(mainGameHelper.setCommonCircles.moneyToBet * Math.Pow(mainGameHelper.setCommonCircles.XNumber, setCommonCircles.listAllCircleSetBet[mainGameHelper.indexcirclebet].amountLose))).ToString();
                        item.SubItems.Add(money);
                    }
                    else if (chkthepallcau.Checked)
                    {
                        //canfix  nhe!
                        string money = setCommonCircles.allC_moneyWillBet.ToString();
                        item.SubItems.Add(money);
                    }
                    else if (chkbetupdown.Checked)
                    {
                        string money = setCommonCircles.UDmoneyWillBetNextSession.ToString();
                        item.SubItems.Add(money);
                    }
                    else if (chkrd2Col.Checked)
                    {
                        // string money = (Convert.ToInt32(mainGameHelper.setCommonCircles.moneyToBet * Math.Pow(mainGameHelper.setCommonCircles.XNumber, setCommonCircles.listAllCircleSetBet[mainGameHelper.indexcirclebet].amountLose))).ToString();
                        string money = setCommonCircles.listAllCircleSetBet[mainGameHelper.indexcirclebet].moneyWillbetNextSeassion.ToString();

                        item.SubItems.Add(money);
                    }
                    else if (chkFollowSBefore.Checked)
                    {
                        string money = setCommonCircles.UDmoneyWillBetNextSession.ToString();
                        item.SubItems.Add(money);
                    }
                    else if (chkFollowsRow.Checked)
                    {
                        int money = mainGameHelper.setCommonCircles.moneyToBet;
                        try
                        {
                            money += setCommonCircles.listCirecleRowWait[0].moneyWillWaitNextSession;
                        }
                        catch (Exception)
                        {

                            throw;
                        }
                        item.SubItems.Add(money.ToString());
                    }
                    else if (chkTxBNotchange.Checked)
                    {
                        if (!setCommonCircles.betFollowTXNotChange_UD)
                        {
                            string money = setCommonCircles.allTXDefaultNotCh_moneyWillBet.ToString();
                            item.SubItems.Add(money);
                        }
                        else
                        {
                           // string money =;
                            item.SubItems.Add(setCommonCircles.UDmoneyWillBetNextSession.ToString());
                        }
                    
                    }
                    item.SubItems.Add("Betting...");

                    item.ForeColor = Color.DarkOrange;
                    lsvBet.Items.Add(item);
                    this.lsvBet.Items[this.lsvBet.Items.Count - 1].EnsureVisible();
                }
                else
                {
                    if (!checkIn) lbltripStatuslogin.Text = "Session betting: Pause";
                    checkIn = false;
                    lblSessionat.Text = data;

                    //update followRowsMoney
                    try
                    {
                        for (int i = 0; i <= lsvRowMoneyWaits.Items.Count; i++)
                        {
                            lsvRowMoneyWaits.Items.RemoveAt(i);
                        }
                    }
                    catch (Exception)
                    {

                    }

                    for (int i = 0; i < setCommonCircles.listCirecleRowWait.Count; i++)
                    {
                        ListViewItem item = new ListViewItem(i.ToString());
                        item.SubItems.Add(setCommonCircles.listCirecleRowWait[i].Session);
                        item.SubItems.Add(setCommonCircles.listCirecleRowWait[i].moneyWillWaitNextSession.ToString());
                        try
                        {
                            item.SubItems.Add(setCommonCircles.listCirecleRowWait[i].listwaitNumberWhenLoses[0].ToString());
                        }
                        catch (Exception)
                        {

                        }

                        if (i == 0)
                        {
                            item.SubItems.Add(setCommonCircles.listCirecleRowWait[0].isBetorPause ? "Running..." : "Waitting...");
                        }
                        else
                        {
                            item.SubItems.Add("Wait");
                        }
                        item.ForeColor = Color.Red;
                        lsvRowMoneyWaits.Items.Add(item);
                    }
                }

            });
        }
        #endregion


        private void button1_Click(object sender, EventArgs e)
        {
            ListViewItem item = new ListViewItem("1");
            item.SubItems.Add("thuc");
            item.SubItems.Add("thuc24324");
            item.ForeColor = Color.Red;
            lsvBet.Items.Add(item);
        }

        private void button2_Click(object sender, EventArgs e)
        {
            //var items = listView1.Items;
            //var last = items[items.Count - 1];
            //last.EnsureVisible();
            this.lsvBet.Items[this.lsvBet.Items.Count - 1].EnsureVisible();
        }
        private void btnlogin_Click_1(object sender, EventArgs e)
        {
            btnlogin.Enabled = false;
            btnlogin.BackColor = Color.Green;
            timer1.Start();
            mainGameHelper.loginGame(txtnameuser.Text.Trim(), txtpassuser.Text.Trim(), null);
            mainGameHelper.mygetHictoryTX = new mainGameHelper.getHictoryTX(setHictoryTX);
            mainGameHelper.myRessultOf1Circle = new mainGameHelper.getRessultOf1Circle(settotalbetOne);
            mainGameHelper.mygetSesionID = new mainGameHelper.getSesionID(setSesionid);

            string xx = mainGameHelper.getRes15whenStart();
            lblmoneystart.Text = mainGameHelper.momentStatusAccount.Moneystart.ToString();
            linkLabel1.Text = xx;
        }
        #region MySettingCircle
        private void btnaddcirclehigh_Click(object sender, EventArgs e)
        {
            mainGameHelper.readCircleText();
            for (int i = 0; i < setCommonCircles.listAllCircleSetBet.Count; i++)
            {
                wrToListBoxCircleHigh(setCommonCircles.listAllCircleSetBet[i].circleBETS);
                wrOnlistViewHictorycirclehigh(setCommonCircles.listAllCircleSetBet[i]);
            }
            lblalCircle.Text = "All-Circle: " + setCommonCircles.listAllCircleSetBet.Count.ToString();
        }

        private void btnClear_Click(object sender, EventArgs e)
        {
            lsbCircleAdd.Items.Clear();
            setCommonCircles.listAllCircleSetBet.Clear();
            lblalCircle.Text = "All-Circle: " + setCommonCircles.listAllCircleSetBet.Count.ToString();
        }

        private void nbrbetafter_ValueChanged(object sender, EventArgs e)
        {
            mainGameHelper.setCommonCircles.betAfterSeconds = Convert.ToInt32(nbrbetafter.Value);
        }

        private void nbrbaseMoney_ValueChanged(object sender, EventArgs e)
        {
            mainGameHelper.setCommonCircles.moneyToBet = Convert.ToInt32(nbrbaseMoney.Value);
        }

        private void nbrMoneyWon_ValueChanged(object sender, EventArgs e)
        {
            mainGameHelper.setCommonCircles.amountMoneyWonToStop = Convert.ToInt32(nbrMoneyWon.Value);
        }

        private void nbrXnumber_ValueChanged(object sender, EventArgs e)
        {
            mainGameHelper.setCommonCircles.XNumber = Convert.ToDouble(nbrXnumber.Value);
        }
        #endregion

        private void button1_Click_2(object sender, EventArgs e)
        {
            Console.WriteLine("mainGameHelper.setCommonCircles.betAfterSeconds: " + mainGameHelper.setCommonCircles.betAfterSeconds);
            Console.WriteLine("mainGameHelper.setCommonCircles.moneyToBet: " + mainGameHelper.setCommonCircles.moneyToBet);
            Console.WriteLine("mainGameHelper.setCommonCircles.moneyToBet: " + mainGameHelper.setCommonCircles.XNumber);
        }
        private void timer1_Tick(object sender, EventArgs e)
        {
            Console.WriteLine("vo live");
            mainGameHelper.sendWsCheckLive();

        }

        private void Chktheptachbietcau_CheckedChanged(object sender, EventArgs e)
        {
            if (chktheptachbietcau.Checked)
            {
                setCommonCircles.betThepTachBietMoiCau = true;
            }
            else
            {
                setCommonCircles.betThepTachBietMoiCau = false;
            }

        }

        private void Chkthepallcau_CheckedChanged(object sender, EventArgs e)
        {
            if (chkthepallcau.Checked)
            {
                setCommonCircles.betThepAllCau = true;
            }
            else
            {
                setCommonCircles.betThepAllCau = false;
            }
        }

        private void Chkbetdeu_CheckedChanged(object sender, EventArgs e)
        {
            if (chkbetdeu.Checked)
            {
                setCommonCircles.betOneMoney = true;
            }
            else
            {
                setCommonCircles.betOneMoney = false;
            }
        }



        private void NbrmoneyminUD_ValueChanged(object sender, EventArgs e)
        {
            setCommonCircles.UDmoneyMin = Convert.ToInt32(nbrmoneyminUD.Value);
        }

        private void NbrMoneyUD_ValueChanged(object sender, EventArgs e)
        {
            setCommonCircles.UDmoney = Convert.ToInt32(nbrMoneyUD.Value);
        }

        private void Chkbetupdown_CheckedChanged(object sender, EventArgs e)
        {
            if (chkbetupdown.Checked)
            {
                setCommonCircles.betUpDownMoneyDefault = true;
            }
            else
            {
                setCommonCircles.betUpDownMoneyDefault = false;
            }

        }

        private void Chkrd2Col_CheckedChanged(object sender, EventArgs e)
        {
            if (chkrd2Col.Checked)
            {
                setCommonCircles.betRandom2Col = true;
            }
            else
            {
                setCommonCircles.betRandom2Col = false;
            }
        }

        private void ChkFollowsRow_CheckedChanged(object sender, EventArgs e)
        {
            if (chkFollowsRow.Checked)
            {
                setCommonCircles.betFollowRowsMoney = true;
            }
            else
            {
                setCommonCircles.betFollowRowsMoney = false;
            }
        }
        private void BtnsubmitWait_Click(object sender, EventArgs e)
        {
            btnsubmitWait.Enabled = false;
            string strTemp = txtNumberWaitting.Text.Trim();
            var arrTemp = strTemp.Split(' ');
            foreach (var item in arrTemp)
            {
                mainGameHelper.setCommonCircles.listNumbersWaitting.Add(Convert.ToInt32(item));
            }
        }
        private void Button1_Click_3(object sender, EventArgs e)
        {
            for (int i = 0; i < setCommonCircles.listCirecleRowWait.Count; i++)
            {
                mainGameHelper.funchandlingResHelper.print_2circle(i);
            }
        }

        private void ChkFollowSBefore_CheckedChanged(object sender, EventArgs e)
        {
            if (chkFollowSBefore.Checked)
            {
                setCommonCircles.betFollowLastBefore = true;
            }
            else
            {
                setCommonCircles.betFollowLastBefore = false;
            }
        }
        private void btnTxnochange_CheckedChanged(object sender, EventArgs e)
        {
            if (chkTxBNotchange.Checked)
            {
                mainGameHelper.countsForTXnotChange = int.Parse(txtbettxnotchange.Text.Trim());
                setCommonCircles.betFollowTXNotChange = true;
            }
            else
            {
                setCommonCircles.betFollowTXNotChange = false;
            }
        }

        private void chkUDbettxnotchange_CheckedChanged(object sender, EventArgs e)
        {
            if (chkUDbettxnotchange.Checked)
            {
                setCommonCircles.betFollowTXNotChange_UD = true;
            }
            else
            {
                setCommonCircles.betFollowTXNotChange_UD = false;
            }
        }

     

        private void chkBetTXTT_CheckedChanged(object sender, EventArgs e)
        {
            if (chkBetTXTT.Checked)
            {
                setCommonCircles.betFollowTXTTWaitnTobetANumbertext = int.Parse(txtWaitTXTT.Text.Trim());
                setCommonCircles.betFollowTXTTWaitnTobet = true;
            }
            else
            {
                setCommonCircles.betFollowTXTTWaitnTobet = false;
            }
        }
      
    }
}
