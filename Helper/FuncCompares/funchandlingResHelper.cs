using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using xNet;

namespace _AutoTx_Projecgt.Helper
{
    interface IfunchandlingResHelper
    {
        string compareCircle(List<_1circleOne> listCircle, string stringCircleMoment10s);
        string getHictoryAboutNWhenStart(HttpRequest request);
        string getResultPushhictory10Before(string res, string hictory15);
        void funcPauseandGetResult(string res, ref string hictory15, ref int totalPause);
        int getResultSesionTX(string resultSesionTX);
        string getSessionNewTX(string resultSesionTX);
        void readTextCircle(setCommonCircles setCommonCircles, string textCircle);
        void checkWinOrLoseAndRemoveCircleWin1(List<_1circleOne> lsCircleOnes, int resultTx);
        bool checkLoseWinASession(List<_1circleOne> listCircle, int indexCircle, string res);


        //UD
        void UDfuncHanldingResultAfterSession(List<_1circleOne> listCircle, int indexCircle, string res);

        //Random
        int randomTorX();
    }
    public class funchandlingResHelper : IfunchandlingResHelper
    {
        Random rd = new Random();
        public static string momentSession;
        public bool checkLoseWinASession(List<_1circleOne> listCircle, int indexCircle, string res)
        {
            int restx = getResultSesionTX(res);
            if (setCommonCircles.betFollowTXNotChange)
            {
                if (restx < 11)
                {
                    if (setCommonCircles.isLastCirToBet)
                    {
                        return true;
                    }
                    return false;
                }
                else
                {
                    if (!setCommonCircles.isLastCirToBet)
                    {
                        return true;
                    }
                    return false;
                }
            }
            if (restx < 11)
            {
                if (listCircle[indexCircle]._TorXIfTrue == "X")
                {
                    return true;
                }
                return false;
            }
            else
            {
                if (listCircle[indexCircle]._TorXIfTrue == "T")
                {
                    return true;
                }
                return false;
            }

        }

        public void checkWinOrLoseAndRemoveCircleWin1(List<_1circleOne> lsCircleOnes, int resultTx)
        {

            for (int i = 0; i < lsCircleOnes.Count; i++)
            {
                if (lsCircleOnes[i].statusCheck)
                {
                    if (setCommonCircles.betFollowTXNotChange)
                    {
                        break;
                    }
                    else if (lsCircleOnes[i]._TorXIfTrue == "X")
                    {
                        if (resultTx < 11)
                        {
                            setCommonCircles.totalWin++;
                            lsCircleOnes[i].momentTotalWin++;

                            if (setCommonCircles.betUpDownMoneyDefault) UDHanldingMoney(true);
                            if (setCommonCircles.betFollowLastBefore) UDHanldingMoney(true);
                            if (setCommonCircles.betFollowRowsMoney && setCommonCircles.listCirecleRowWait.Count > 0) followRowsMoney(true, setCommonCircles.listCirecleRowWait[0].isBetorPause);
                        }
                        else
                        {
                            setCommonCircles.totalLose++;
                            lsCircleOnes[i].momentTotalLose++;

                            if (setCommonCircles.betUpDownMoneyDefault) UDHanldingMoney(false);
                            if (setCommonCircles.betFollowLastBefore) UDHanldingMoney(false);
                            if (setCommonCircles.betFollowRowsMoney && setCommonCircles.listCirecleRowWait.Count > 0) followRowsMoney(false, setCommonCircles.listCirecleRowWait[0].isBetorPause);
                        }
                    }
                    else
                    {
                        if (resultTx > 10)
                        {
                            setCommonCircles.totalWin++;
                            lsCircleOnes[i].momentTotalWin++;

                            if (setCommonCircles.betUpDownMoneyDefault) UDHanldingMoney(true);
                            if (setCommonCircles.betFollowLastBefore) UDHanldingMoney(true);
                            if (setCommonCircles.betFollowRowsMoney && setCommonCircles.listCirecleRowWait.Count > 0) followRowsMoney(true, setCommonCircles.listCirecleRowWait[0].isBetorPause);
                        }
                        else
                        {
                            setCommonCircles.totalLose++;
                            lsCircleOnes[i].momentTotalLose++;

                            if (setCommonCircles.betUpDownMoneyDefault) UDHanldingMoney(false);
                            if (setCommonCircles.betFollowLastBefore) UDHanldingMoney(false);
                            if (setCommonCircles.betFollowRowsMoney && setCommonCircles.listCirecleRowWait.Count > 0) followRowsMoney(false, setCommonCircles.listCirecleRowWait[0].isBetorPause);
                        }
                    }
                    lsCircleOnes[i].statusCheck = false;
                    if (lsCircleOnes[i].momentTotalWin - lsCircleOnes[i].momentTotalLose >= 1) lsCircleOnes[i].checkStopWhenWonOneThep1van = true;
                    Console.WriteLine("Win: " + lsCircleOnes[i].momentTotalWin);
                    Console.WriteLine("lose: " + lsCircleOnes[i].momentTotalLose);
                    break;
                }

            }
        }
        bool isCheckChangeTorX = false;
        public string compareCircle(List<_1circleOne> listCircle, string stringCircleMoment10s)
        {

            for (int i = 0; i < listCircle.Count; i++)
            {
                if (setCommonCircles.betOneMoney)
                {
                    isCheckChangeTorX = false;
                    string tempsom = stringCircleMoment10s.Substring(stringCircleMoment10s.Length - listCircle[i].circleCompare.Length, listCircle[i].circleCompare.Length);
                    if (listCircle[i].circleCompare == tempsom)
                    {

                        listCircle[i].statusCheck = true;
                        listCircle[i].momentTotalBet++;

                        for (int j = 2; j < listCircle.Count; j++)
                        {
                            tempsom = stringCircleMoment10s.Substring(stringCircleMoment10s.Length - listCircle[j].circleCompare.Length, listCircle[j].circleCompare.Length);
                            if (listCircle[j].circleCompare == tempsom)
                            {
                                isCheckChangeTorX = true;
                                listCircle[i]._TorXIfTrue = listCircle[j]._TorXIfTrue;
                                listCircle[j].momentTotalBet++;
                                break;
                            }
                        }
                        if (!isCheckChangeTorX)
                        {
                            listCircle[i]._TorXIfTrue = listCircle[i]._TorXNotDefault;
                        }
                        Console.WriteLine("Van nay danh " + listCircle[i]._TorXIfTrue);
                        if (listCircle[i]._TorXIfTrue == "P")
                        {
                            listCircle[i].statusCheck = false;
                            i = -1;
                            return i + "-" + "P";
                        }
                        //
                        return i + "-" + listCircle[i]._TorXIfTrue;


                    }

                }
                else if (setCommonCircles.betThepTachBietMoiCau)
                {
                    string tempsom = stringCircleMoment10s.Substring(stringCircleMoment10s.Length - listCircle[i].circleCompare.Length, listCircle[i].circleCompare.Length);
                    if (listCircle[i].circleCompare == tempsom)
                    {

                        listCircle[i].statusCheck = true;
                        listCircle[i].momentTotalBet++;
                        return i + "-" + listCircle[i]._TorXIfTrue;

                    }
                }
                else if (setCommonCircles.betThepAllCau)
                {
                    isCheckChangeTorX = false;
                    string tempsom = stringCircleMoment10s.Substring(stringCircleMoment10s.Length - listCircle[i].circleCompare.Length, listCircle[i].circleCompare.Length);

                    if (listCircle[i].circleCompare == tempsom)
                    {
                        listCircle[i].statusCheck = true;
                        listCircle[i].momentTotalBet++;

                        //
                        for (int j = 2; j < listCircle.Count; j++)
                        {
                            tempsom = stringCircleMoment10s.Substring(stringCircleMoment10s.Length - listCircle[j].circleCompare.Length, listCircle[j].circleCompare.Length);
                            if (listCircle[j].circleCompare == tempsom)
                            {
                                isCheckChangeTorX = true;
                                listCircle[i]._TorXIfTrue = listCircle[j]._TorXIfTrue;
                                listCircle[j].momentTotalBet++;
                                break;
                            }
                        }
                        if (!isCheckChangeTorX)
                        {
                            listCircle[i]._TorXIfTrue = listCircle[i]._TorXNotDefault;
                        }
                        Console.WriteLine("Van nay danh " + listCircle[i]._TorXIfTrue);
                        if (listCircle[i]._TorXIfTrue == "P")
                        {
                            listCircle[i].statusCheck = false;
                            i = -1;
                            return i + "-" + "P";
                        }
                        //
                        return i + "-" + listCircle[i]._TorXIfTrue;

                    }
                }
                else if (setCommonCircles.betUpDownMoneyDefault)
                {
                    isCheckChangeTorX = false;
                    string tempsom = stringCircleMoment10s.Substring(stringCircleMoment10s.Length - listCircle[i].circleCompare.Length, listCircle[i].circleCompare.Length);
                    if (listCircle[i].circleCompare == tempsom)
                    {
                        listCircle[i].statusCheck = true;
                        listCircle[i].momentTotalBet++;
                        for (int j = 2; j < listCircle.Count; j++)
                        {
                            tempsom = stringCircleMoment10s.Substring(stringCircleMoment10s.Length - listCircle[j].circleCompare.Length, listCircle[j].circleCompare.Length);
                            if (listCircle[j].circleCompare == tempsom)
                            {
                                isCheckChangeTorX = true;
                                listCircle[i]._TorXIfTrue = listCircle[j]._TorXIfTrue;
                                listCircle[j].momentTotalBet++;
                                break;
                            }
                        }
                        if (!isCheckChangeTorX)
                        {
                            int resRd = randomTorX();
                            if (resRd > 10)
                            {
                                listCircle[i]._TorXIfTrue = "T";
                            }
                            else
                            {
                                listCircle[i]._TorXIfTrue = "X";
                            }
                        }
                        Console.WriteLine("Van nay danh " + listCircle[i]._TorXIfTrue);
                        return i + "-" + listCircle[i]._TorXIfTrue;
                    }
                }
                else if (setCommonCircles.betRandom2Col)
                {
                    #region MyRegion
                    //string tempsom = stringCircleMoment10s.Substring(stringCircleMoment10s.Length - listCircle[i].circleCompare.Length, listCircle[i].circleCompare.Length);
                    //if (listCircle[i].circleCompare == tempsom)
                    //{
                    //    listCircle[i].statusCheck = true;
                    //    listCircle[i].momentTotalBet++;
                    //    for (int j = 2; j < listCircle.Count; j++)
                    //    {
                    //        tempsom = stringCircleMoment10s.Substring(stringCircleMoment10s.Length - listCircle[j].circleCompare.Length, listCircle[j].circleCompare.Length);
                    //        if (listCircle[j].circleCompare == tempsom)
                    //        {
                    //            listCircle[i]._TorXIfTrue = listCircle[j]._TorXIfTrue;
                    //            listCircle[j].momentTotalBet++;
                    //        }
                    //    }
                    //    if (listCircle[i]._TorXIfTrue == "R")
                    //    {
                    //        int resRd = randomTorX();
                    //        if (resRd > 10)
                    //        {
                    //            listCircle[i]._TorXIfTrue = "T";
                    //        }
                    //        else
                    //        {
                    //            listCircle[i]._TorXIfTrue = "X";
                    //        }
                    //    }
                    //    Console.WriteLine("Van nay danh " + listCircle[i]._TorXIfTrue);
                    //    return i + "-" + listCircle[i]._TorXIfTrue;
                    //}
                    #endregion

                    isCheckChangeTorX = false;
                    string tempsom = stringCircleMoment10s.Substring(stringCircleMoment10s.Length - listCircle[i].circleCompare.Length, listCircle[i].circleCompare.Length);
                    if (listCircle[i].circleCompare == tempsom)
                    {
                        listCircle[i].statusCheck = true;
                        listCircle[i].momentTotalBet++;
                        for (int j = 2; j < listCircle.Count; j++)
                        {
                            tempsom = stringCircleMoment10s.Substring(stringCircleMoment10s.Length - listCircle[j].circleCompare.Length, listCircle[j].circleCompare.Length);
                            if (listCircle[j].circleCompare == tempsom)
                            {
                                isCheckChangeTorX = true;
                                listCircle[i]._TorXIfTrue = listCircle[j]._TorXIfTrue;
                                listCircle[j].momentTotalBet++;
                                break;
                            }
                        }
                        if (!isCheckChangeTorX)
                        {
                            int resRd = randomTorX();
                            if (resRd > 10)
                            {
                                listCircle[i]._TorXIfTrue = "T";
                            }
                            else
                            {
                                listCircle[i]._TorXIfTrue = "X";
                            }
                        }
                        //if (listCircle[i]._TorXIfTrue == "R")
                        //{
                        //    int resRd = randomTorX();
                        //    if (resRd > 10)
                        //    {
                        //        listCircle[i]._TorXIfTrue = "T";
                        //    }
                        //    else
                        //    {
                        //        listCircle[i]._TorXIfTrue = "X";
                        //    }
                        //}
                        Console.WriteLine("Van nay danh " + listCircle[i]._TorXIfTrue);
                        return i + "-" + listCircle[i]._TorXIfTrue;
                    }
                }
                else if (setCommonCircles.betFollowRowsMoney)
                {
                    string tempsom = stringCircleMoment10s.Substring(stringCircleMoment10s.Length - listCircle[i].circleCompare.Length, listCircle[i].circleCompare.Length);
                    if (listCircle[i].circleCompare == tempsom)
                    {
                        listCircle[i].statusCheck = true;
                        listCircle[i].momentTotalBet++;
                        return i + "-" + listCircle[i]._TorXIfTrue;
                    }
                }
                else if (setCommonCircles.betFollowLastBefore)
                {

                    isCheckChangeTorX = false;
                    string tempsom = stringCircleMoment10s.Substring(stringCircleMoment10s.Length - listCircle[i].circleCompare.Length, listCircle[i].circleCompare.Length);
                    if (listCircle[i].circleCompare == tempsom)
                    {
                        listCircle[i].statusCheck = true;
                        listCircle[i].momentTotalBet++;
                        for (int j = 2; j < listCircle.Count; j++)
                        {
                            tempsom = stringCircleMoment10s.Substring(stringCircleMoment10s.Length - listCircle[j].circleCompare.Length, listCircle[j].circleCompare.Length);
                            if (listCircle[j].circleCompare == tempsom)
                            {
                                isCheckChangeTorX = true;
                                listCircle[i]._TorXIfTrue = listCircle[j]._TorXIfTrue;
                                listCircle[j].momentTotalBet++;
                                break;
                            }
                        }
                        if (!isCheckChangeTorX)
                        {
                            listCircle[i]._TorXIfTrue = listCircle[i]._TorXNotDefault;
                        }
                        Console.WriteLine("Van nay danh " + listCircle[i]._TorXIfTrue);
                        if (listCircle[i]._TorXIfTrue == "P")
                        {
                            listCircle[i].statusCheck = false;
                            i = -1;
                            return i + "-" + "P";
                        }

                        return i + "-" + listCircle[i]._TorXIfTrue;
                    }
                }
                else if (setCommonCircles.betFollowTXNotChange)
                {
                lnla:
                    if (setCommonCircles.allTXDefaultNotCh_isChangeContinute)
                    {
                        setCommonCircles.allTXDefaultNotCh_PauseWhenLose = rd.Next(2, 5);
                        if (setCommonCircles.allTXDefaultNotCh_amountLose > 4)
                        {
                            for (int j = 0; j < listCircle.Count; j++)
                            {
                                string tempsom = stringCircleMoment10s.Substring(stringCircleMoment10s.Length - listCircle[j].circleCompare.Length, listCircle[j].circleCompare.Length);
                                if (listCircle[j].circleCompare == tempsom)
                                {
                                    listCircle[j].momentTotalBet++;
                                    if (listCircle[j].circleCompare == "TX")
                                    {
                                       // setCommonCircles.isLastCirToBet = false;
                                        return "-1-P";
                                    }
                                    else if (listCircle[j].circleCompare == "XT")
                                    {
                                        //setCommonCircles.isLastCirToBet = true;
                                        return "-1-P";
                                    }
                                    return "-1-P";
                                }
                            }

                        }
                        if (setCommonCircles.isLastCirToBet)
                        {
                            setCommonCircles.isLastCirToBet = !setCommonCircles.isLastCirToBet;
                            return "0-T";
                        }
                        else
                        {
                            setCommonCircles.isLastCirToBet = !setCommonCircles.isLastCirToBet;
                            return "0-X";
                        }
                    }
                    else
                    {
                        Console.WriteLine("vo cho : " + setCommonCircles.allTXDefaultNotCh_PauseWhenLose);
                        setCommonCircles.allTXDefaultNotCh_PauseWhenLose--;
                        if (setCommonCircles.allTXDefaultNotCh_PauseWhenLose <= 0)
                        {
                            for (int j = 2; j < listCircle.Count; j++)
                            {
                                string tempsom = stringCircleMoment10s.Substring(stringCircleMoment10s.Length - listCircle[j].circleCompare.Length, listCircle[j].circleCompare.Length);
                                if (listCircle[j].circleCompare == tempsom)
                                {
                                    listCircle[j].momentTotalBet++;
                                    return "-1-P";
                                }
                            }
                            setCommonCircles.allTXDefaultNotCh_isChangeContinute = true;
                            goto lnla;
                        }
                        return "-1-P";
                    }
                }
                else if (setCommonCircles.betFollowTXTTWaitnTobet)
                {
                    isCheckChangeTorX = false;
                    string tempsom = stringCircleMoment10s.Substring(stringCircleMoment10s.Length - listCircle[i].circleCompare.Length, listCircle[i].circleCompare.Length);
                    if (listCircle[i].circleCompare == tempsom)
                    {
                        listCircle[i].statusCheck = true;
                        listCircle[i].momentTotalBet++;
                        listCircle[i].BetFollowTXTTWaitNumber++;
                        if (listCircle[i].BetFollowTXTTWaitNumber < 2)
                        {
                            foreach (var item in listCircle)
                            {
                                if (item != listCircle[i])
                                {
                                    item.BetFollowTXTTWaitNumber = 0;
                                }
                            }
                        }
                        if (listCircle[i].BetFollowTXTTWaitNumber == setCommonCircles.betFollowTXTTWaitnTobetANumbertext)
                        {
                            return i + "-" + listCircle[i]._TorXIfTrue;
                        }                      
                    }
                }
            }

            return null;
        }

        void UDHanldingMoney(bool isWL)
        {
            Console.WriteLine("vo handing money ud");
            if (isWL)
            {
                setCommonCircles.UDmoneyWillBetNextSession = setCommonCircles.UDmoneyBetBeforeSession - setCommonCircles.UDmoney;
                if (setCommonCircles.UDmoneyWillBetNextSession < setCommonCircles.UDmoneyMin) setCommonCircles.UDmoneyWillBetNextSession = setCommonCircles.UDmoneyMin;
                setCommonCircles.UDmoneyBetBeforeSession = setCommonCircles.UDmoneyWillBetNextSession;
            }
            else
            {
                setCommonCircles.UDmoneyWillBetNextSession = setCommonCircles.UDmoneyBetBeforeSession + setCommonCircles.UDmoney;
                setCommonCircles.UDmoneyBetBeforeSession = setCommonCircles.UDmoneyWillBetNextSession;
            }
        }
        void followRowsMoney(bool isWL, bool isPlaying)
        {
            if (isWL && isPlaying)
            {
                setCommonCircles.listCirecleRowWait.RemoveAt(0);
            }
            else
            {
                if (isPlaying)
                {
                    setCommonCircles.listCirecleRowWait[0].countLoses++;
                }

                if (setCommonCircles.listCirecleRowWait[0].listwaitNumberWhenLoses[0] > 0)
                {
                    setCommonCircles.listCirecleRowWait[0].listwaitNumberWhenLoses[0]--;
                    setCommonCircles.listCirecleRowWait[0].isBetorPause = false;
                }
                else
                {
                    setCommonCircles.listCirecleRowWait[0].listwaitNumberWhenLoses.RemoveAt(0);
                    setCommonCircles.listCirecleRowWait[0].isBetorPause = true;
                }

            }
        }
        public void UDfuncHanldingResultAfterSession(List<_1circleOne> listCircle, int indexCircle, string res)
        {
            bool isWL = checkLoseWinASession(listCircle, indexCircle, res);
            if (isWL)
            {
                setCommonCircles.UDmoneyWillBetNextSession = setCommonCircles.UDmoneyBetBeforeSession - setCommonCircles.UDmoneyMin;
                if (setCommonCircles.UDmoneyWillBetNextSession < setCommonCircles.UDmoneyMin) setCommonCircles.UDmoneyWillBetNextSession = setCommonCircles.UDmoneyMin;
            }
            else
            {
                setCommonCircles.UDmoneyWillBetNextSession = setCommonCircles.UDmoneyBetBeforeSession + setCommonCircles.UDmoneyMin;
            }
        }

        public void funcPauseandGetResult(string res, ref string hictory15, ref int totalPause)
        {
            int resTX = getResultSesionTX(res);
            if (resTX < 11)
            {
                hictory15 += "X";
            }
            else
            {
                hictory15 += "T";
            }
            totalPause--;

        }

        public string getHictoryAboutNWhenStart(HttpRequest request)
        {
            var res = request.Get("https://huno.club/w-taixiu/api/GetListSoiCau").ToString();
            JArray textArray = JArray.Parse(res);
            string hictory15 = "";
            for (int i = 14; i >= 0; i--)
            {
                string str1 = textArray[i].ToString();
                ClsDice re1 = JsonConvert.DeserializeObject<ClsDice>(str1);
                if (re1.DiceSum < 11)
                {
                    hictory15 += "X";
                }
                else
                {
                    hictory15 += "T";
                }
            }
            return hictory15;
        }

        public string getResultPushhictory10Before(string res, string hictory15)
        {
            int resTX = getResultSesionTX(res);

            //so sanh xu lym kqua cho tung cau
            checkWinOrLoseAndRemoveCircleWin1(setCommonCircles.listAllCircleSetBet, resTX);
            if (resTX < 11)
            {
                hictory15 += "X";
            }
            else
            {
                hictory15 += "T";
            }
            if (hictory15.Length > 15)
            {
                hictory15 = hictory15.Substring(1, 15);
            }
            return hictory15;
        }

        public int getResultSesionTX(string resultSesionTX)
        {
            var res = Regex.Matches(resultSesionTX, @"(?<=Dice\d"":).*?(?=,)", RegexOptions.Singleline);
            int id = 0;
            if (res != null && res.Count > 0)
            {
                id = Convert.ToInt32(res[0].ToString());
                id += Convert.ToInt32(res[1].ToString());
                id += Convert.ToInt32(res[2].ToString());
            }
            return id;
        }

        public string getSessionNewTX(string resultSesionTX)
        {
            momentSession = Regex.Matches(resultSesionTX, @"(?<=GameSessionID"":).*?(?=,)", RegexOptions.Singleline)[0].Value;
            return momentSession;
        }

        public void readTextCircle(setCommonCircles setCommonCircles, string path)
        {
            string[] circles = File.ReadAllLines(path);
            for (int i = 0; i < circles.Length; i++)
            {
                _1circleOne _1CircleOne = new _1circleOne();
                _1CircleOne.idCircle = (i + 1);
                _1CircleOne.circleBETS = circles[i];
                var temp = circles[i].Split('-');
                _1CircleOne._TorXIfTrue = temp[1];
                _1CircleOne._TorXNotDefault = temp[1];
                _1CircleOne.circleCompare = temp[0];
                setCommonCircles.listAllCircleSetBet.Add(_1CircleOne);
            }

        }

        public int randomTorX()
        {
            int indexTx = 3;
            int resRDTX = 0;
            while (indexTx > 0)
            {
                resRDTX += rd.Next(1, 7);
                indexTx--;
            }
            return resRDTX;
        }
        public void print_2circle(int i)
        {

            //Console.WriteLine("So luong cho: "+setCommonCircles.listCirecleRowWait.Count);
            Console.WriteLine("Session: " + setCommonCircles.listCirecleRowWait[i].Session);
            Console.WriteLine("mnstart: " + setCommonCircles.listCirecleRowWait[i].moneyStartWait);
            Console.WriteLine("counts lose: " + setCommonCircles.listCirecleRowWait[i].countLoses);
            Console.WriteLine("moneyWillWaitNextSession: " + setCommonCircles.listCirecleRowWait[i].moneyWillWaitNextSession);
            try
            {
                Console.WriteLine("listwaitNumberWhenLoses: " + setCommonCircles.listCirecleRowWait[i].listwaitNumberWhenLoses[0] + "-" + setCommonCircles.listCirecleRowWait[i].listwaitNumberWhenLoses[1] + "-" + setCommonCircles.listCirecleRowWait[i].listwaitNumberWhenLoses[2]);
            }
            catch (Exception)
            {

            }

        }


    }
}


public class ClsDice
{
    public int Dice1 { get; set; }
    public int Dice2 { get; set; }
    public int Dice3 { get; set; }
    public int DiceSum { get; set; }
    public int GameSessionID { get; set; }
    public int LocationIDWin { get; set; }
}
