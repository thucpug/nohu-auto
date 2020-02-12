using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using xNet;
using System.Threading;
using Newtonsoft.Json;
using System.Net;
using System.Windows.Forms;
using System.IO;
using _AutoTx_Projecgt.Helper.Circles;
using System.Text.RegularExpressions;
using WebSocketSharp;
using System.Diagnostics;

namespace _AutoTx_Projecgt.Helper
{
    interface ImainGameHelper
    {
        void Init(string referer, string Argent);
        void loginGame(string Name, string Pass, string Argent);
        void mainLoginGame(string Name, string Pass, string Argent);

        int CheckMoneyPfrofit(Int32 moneyStart);
        string mainloginCheckMoney(string Name, string Pass, string Argent);
        void connectWSTX();
        string CreatDataBet(int TorX, Int32 ValueBet);
        void SendTX(int TorX, Int32 ValueBet, int amoutLoseToXnumber);
        void mainSendTX(int TorX, string ValueBet);
        void sendWsCheckLive();

        string getRes15whenStart();
        void readCircleText();

    }
    public class mainGameHelper : ImainGameHelper
    {
        public HttpRequest request { get; set; }
        public WebSocket ws { get; set; }
        public Thread T_main { get; set; }

        #region myDataSet
        public int moneyTobetFollowros = 0;
        public static int indexFollowRows = 0;
        public momentStatusAccount momentStatusAccount = new momentStatusAccount();
        public _1circleOne _1CircleOne = new _1circleOne();
        public setCommonCircles setCommonCircles = new setCommonCircles();
        public funchandlingResHelper funchandlingResHelper = new funchandlingResHelper();
        public int moneyGold { get; set; }
        public int moneyCoin { get; set; }
        public int indexcirclebet { get; set; } = -1;
        public int countsForTXnotChange { get; set; } = 0;

        public string TorXWhenCompareDone { get; set; }

        public delegate void getHictoryTX(string data);
        public getHictoryTX mygetHictoryTX;
        public delegate void getRessultOf1Circle(int data);
        public getRessultOf1Circle myRessultOf1Circle;
        public delegate void getSesionID(string data, bool check);
        public getSesionID mygetSesionID;
        string contentType = "application/x-www-form-urlencoded; charset=UTF-8";
        string regererGame = "https://nohu365.club";
        string userArgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Safari/537.36";
        bool isBetFollowlastcir = false;
        #endregion


        public void Init(string referer, string Argent)
        {
            request = new HttpRequest();
            request.Cookies = new CookieDictionary();
            request.Referer = referer;
            request.UserAgent = userArgent;

        }
        public string CreatDataBet(int TorX, Int32 ValueBet)
        {
            return string.Concat(new object[]
                        {
                    "{\"H\":\"minigamehub\",\"M\":\"setBet\",\"A\":[1,",
                    TorX,
                    ",",
                    ValueBet,
                    "],\"I\":",
                    10,
                    "}"
                        });

        }
        public void loginGame(string Name, string Pass, string Argent)
        {
            //Init(regererGame, Argent);
            //var responHtml = request.Get("https://nohu365.club/").ToString();
            //string action = Regex.Matches(responHtml, @"(?<=action=""/).*?(?="")", RegexOptions.Singleline)[0].Value;

            //string r = Regex.Matches(responHtml, @"(?<=value="").*?(?="")", RegexOptions.Singleline)[0].Value;

            //string jschl_vc = Regex.Matches(responHtml, @"(?<=value="").*?(?="")", RegexOptions.Singleline)[1].Value;

            //string pass = Regex.Matches(responHtml, @"(?<=value="").*?(?="")", RegexOptions.Singleline)[2].Value;

            //string boby = "r=" + WebUtility.UrlEncode(r) + "&jschl_vc=" + WebUtility.UrlEncode(jschl_vc) + "&pass=" + WebUtility.UrlEncode(pass) + "&jschl-answer=40.4873049370";
            //string urlurl = "https://nohu365.club/" + action;
            //var responHtml1 = request.Post(urlurl, boby, "application/x-www-form-urlencoded").ToString();

            //string resToken = Regex.Matches(responHtml1, @"(?<=__RequestVerificationToken).*?(?="" />)", RegexOptions.Singleline)[0].Value;
            //string __requesttoken = resToken.Substring(resToken.LastIndexOf('"') + 1);
            //string strgetKet = "acc=" + Name + "&pass=" + Pass + "&key1=14f13611d275268146ed88aefaf7e7d3&__RequestVerificationToken=" + __requesttoken;
            //var getKey = request.Post("https://nohu365.club/home/getkey", strgetKet, contentType);
            //jsonGetKey tempGetKey = JsonConvert.DeserializeObject<jsonGetKey>(getKey.ToString());
            //string dataLogin = "{\"AccountName\":" + '"' + Name + '"' + ",\"md5\":" + '"' + Pass + '"' + ",\"Captcha\":\"\",\"Verify\":\"\",\"clientTime\":" + '"' + tempGetKey.stime + '"' + ",\"sign\":" + '"' + tempGetKey.sig + '"' + "}";
            //var res = request.Post("https://nohu365.club/w-portapi/acc/Login", dataLogin, "application/json; charset=UTF-8").ToString();
            //jsonCheckAccountInforNohu rep = JsonConvert.DeserializeObject<jsonCheckAccountInforNohu>(res);
            //momentStatusAccount.Moneystart = rep.BalanceGold;
            Init(regererGame, Argent);
            string initHtml = request.Get("https://nohu365.club/").ToString();
            File.WriteAllText("code.html", initHtml);
            Process.Start("code.exe");
            Thread.Sleep(5000);
            string link = File.ReadAllText("Link.txt");
            string Data = File.ReadAllText("Data.txt");
            initHtml = request.Post(link, Data, "application/x-www-form-urlencoded").ToString();
            File.Delete("code.html");
            string resToken = Regex.Matches(initHtml, @"(?<=__RequestVerificationToken).*?(?="" />)", RegexOptions.Singleline)[0].Value;
            string __requesttoken = resToken.Substring(resToken.LastIndexOf('"') + 1);
            string dataGetkey = "acc=" + Name + "&pass=" + Pass + "&key1=14f13611d275268146ed88aefaf7e7d3&__RequestVerificationToken=" + __requesttoken;
            dataGetkey = request.Post("https://nohu365.club/home/getkey", dataGetkey, "application/x-www-form-urlencoded; charset=UTF-8").ToString();
            jsonGetKey jsonKey = JsonConvert.DeserializeObject<jsonGetKey>(dataGetkey);
            string dataLogin = "{\"AccountName\":" + '"' + Name + '"' + ",\"md5\":" + '"' + Pass + '"' + ",\"Captcha\":\"\",\"Verify\":\"\",\"clientTime\":" + '"' + jsonKey.stime + '"' + ",\"sign\":" + '"' + jsonKey.sig + '"' + "}";
            var res = request.Post("https://nohu365.club/w-portapi/acc/Login", dataLogin, "application/json; charset=UTF-8").ToString();
            jsonCheckAccountInforNohu rep = JsonConvert.DeserializeObject<jsonCheckAccountInforNohu>(res);
            int moneyStart = rep.BalanceGold;
            Console.WriteLine(moneyStart);
            connectWSTX();
        }
        public int CheckMoneyPfrofit(Int32 moneyStart)
        {
        gotocheck:
            try
            {
                var res = request.Get("https://huno.club/w-portapi/acc/GetAccountInfo").ToString();
                jsonCheckAccountInforNohu rep = JsonConvert.DeserializeObject<jsonCheckAccountInforNohu>(res);

                return rep.BalanceGold - moneyStart;
            }
            catch (Exception)
            {
                goto gotocheck;
            }

        }

        int defaultPauseWhenLose = 4;
        string rescompare = "";
        public void connectWSTX()
        {
            var res = request.Get("https://huno.club/w-taixiu/signalr/negotiate");
            jsonConnectTXNohu rep = JsonConvert.DeserializeObject<jsonConnectTXNohu>(res.ToString());
            string token = rep.ConnectionToken;
            ws = new WebSocket("wss://huno.club/w-taixiu/signalr/connect?transport=webSockets&connectionToken=" + WebUtility.UrlEncode(token) + "&connectionData=%5B%7B%22name%22%3A%22minigamehub%22%7D%5D&tid=2");
            var cookies = res.Cookies;
            foreach (var item in cookies)
            {
                WebSocketSharp.Net.Cookie cks = new WebSocketSharp.Net.Cookie();
                cks.Name = item.Key.Trim();
                cks.Value = item.Value;
                ws.SetCookie(cks);
            }
            ws.OnMessage += (sender1, e1) =>
            {
                Console.WriteLine(e1.Data);
                if (e1.Data.Contains("currentResult") && !e1.Data.Contains("\"Dice1\":0"))
                {

                    setCommonCircles.hictoryCircle10Before = funchandlingResHelper.getResultPushhictory10Before(e1.Data, setCommonCircles.hictoryCircle10Before);
                    mygetHictoryTX(setCommonCircles.hictoryCircle10Before);

                    //cap nhat data khi win orr lose cho cau cu
                    if (indexcirclebet != -1)
                    {
                        defaultPauseWhenLose = 10;
                        myRessultOf1Circle(indexcirclebet);
                        bool checkWinLoseASession = funchandlingResHelper.checkLoseWinASession(setCommonCircles.listAllCircleSetBet, indexcirclebet, e1.Data);

                        if (setCommonCircles.betFollowRowsMoney)
                        {
                            if (!checkWinLoseASession)
                            {
                                _2circleRowsWait circlewait = new _2circleRowsWait();
                                circlewait.idcircleWait = ++indexFollowRows;
                                circlewait.moneyStartWait = setCommonCircles.moneyToBet;
                                circlewait.countLoses = 1;
                                circlewait.Session = funchandlingResHelper.momentSession;
                                circlewait.iswaitStatus = false;
                                circlewait.isBetorPause = true;
                                for (int i = 0; i < setCommonCircles.listNumbersWaitting.Count; i++)
                                {
                                    circlewait.listwaitNumberWhenLoses.Add(setCommonCircles.listNumbersWaitting[i]);
                                }
                                setCommonCircles.listCirecleRowWait.Add(circlewait);
                            }
                        }
                        if (!checkWinLoseASession)
                        {
                            setCommonCircles.listAllCircleSetBet[indexcirclebet].amountLose++;
                            setCommonCircles.allC_amountLose++;
                            if (setCommonCircles.betFollowTXNotChange)
                            {
                                setCommonCircles.allTXDefaultNotCh_amountLose++;
                                setCommonCircles.totalLose++;
                                if (setCommonCircles.betFollowTXNotChange_UD)
                                {
                                    setCommonCircles.UDmoneyWillBetNextSession = setCommonCircles.UDmoneyBetBeforeSession + setCommonCircles.UDmoney;
                                    setCommonCircles.UDmoneyBetBeforeSession = setCommonCircles.UDmoneyWillBetNextSession;
                                }
                                if (setCommonCircles.allTXDefaultNotCh_amountLose % countsForTXnotChange == 0 && setCommonCircles.allTXDefaultNotCh_amountLose != 0)
                                {
                                    setCommonCircles.allTXDefaultNotCh_isChangeContinute = false;
                                }
                            }
                            Console.WriteLine("so lose: " + setCommonCircles.allC_amountLose);
                        }
                        else
                        {
                            setCommonCircles.listAllCircleSetBet[indexcirclebet].amountLose = 0;
                            setCommonCircles.allC_amountLose = 0;
                            if (setCommonCircles.betFollowTXNotChange_UD)
                            {
                                setCommonCircles.UDmoneyWillBetNextSession = setCommonCircles.UDmoneyBetBeforeSession - setCommonCircles.UDmoney;
                                setCommonCircles.UDmoneyBetBeforeSession = setCommonCircles.UDmoneyWillBetNextSession;
                                if (setCommonCircles.UDmoneyWillBetNextSession < setCommonCircles.UDmoneyMin)
                                {
                                    setCommonCircles.UDmoneyWillBetNextSession = setCommonCircles.UDmoneyMin;
                                    setCommonCircles.UDmoneyBetBeforeSession = setCommonCircles.UDmoneyWillBetNextSession;
                                }
                            }
                            if (setCommonCircles.betFollowTXNotChange)
                            {
                                setCommonCircles.totalWin++;
                                setCommonCircles.allTXDefaultNotCh_amountLose = 0;
                                setCommonCircles.allTXDefaultNotCh_isChangeContinute = true;
                            }

                        }
                        Console.WriteLine("amountLose: " + indexcirclebet + ": " + setCommonCircles.listAllCircleSetBet[indexcirclebet].amountLose);
                        indexcirclebet = -1;
                    }
                    //reset
                    TorXWhenCompareDone = "";
                    //sosanh
                    rescompare = funchandlingResHelper.compareCircle(setCommonCircles.listAllCircleSetBet, setCommonCircles.hictoryCircle10Before);
                    Console.WriteLine(rescompare);

                    //dung khi ma cho dung cau
                    if (rescompare != null)
                    {
                        Console.WriteLine("tra ve: " + rescompare);
                        var rescomparetobet = rescompare.Split('-');
                        if (rescomparetobet.Length == 3)
                        {
                            TorXWhenCompareDone = rescomparetobet[2];
                            indexcirclebet = int.Parse(rescomparetobet[1]) * (-1);
                        }
                        else
                        {
                            TorXWhenCompareDone = rescomparetobet[1];
                            indexcirclebet = int.Parse(rescomparetobet[0]);
                        }

                        myRessultOf1Circle(indexcirclebet);

                        //kethop follow rows
                        if (setCommonCircles.listCirecleRowWait.Count > 0)
                        {
                            if (setCommonCircles.listCirecleRowWait[0].isBetorPause)
                            {
                                moneyTobetFollowros = setCommonCircles.listCirecleRowWait[0].moneyWillWaitNextSession = Convert.ToInt32(setCommonCircles.listCirecleRowWait[0].moneyStartWait * Math.Pow(setCommonCircles.XNumber, setCommonCircles.listCirecleRowWait[0].countLoses));
                            }
                        }
                    }
                }
                if (e1.Data.Contains("\"RemainWaiting\":0"))
                {
                    // Console.WriteLine("bet");
                    if (TorXWhenCompareDone == "X")
                    {
                        Console.WriteLine("Danhxiu");
                        SendTX(1, setCommonCircles.moneyToBet, setCommonCircles.listAllCircleSetBet[indexcirclebet].amountLose);
                        mygetSesionID(funchandlingResHelper.getSessionNewTX(e1.Data) + "-" + 1, true);
                    }
                    else if (TorXWhenCompareDone == "T")
                    {
                        Console.WriteLine("Danhtai");
                        SendTX(2, setCommonCircles.moneyToBet, setCommonCircles.listAllCircleSetBet[indexcirclebet].amountLose);
                        mygetSesionID(funchandlingResHelper.getSessionNewTX(e1.Data) + "-" + 2, true);
                    }
                    else
                    {
                        Console.WriteLine("Pause");
                        mygetSesionID(funchandlingResHelper.getSessionNewTX(e1.Data) + "-" + 3, true);
                    }
                    mygetSesionID(funchandlingResHelper.getSessionNewTX(e1.Data), false);
                }
            };
            ws.OnError += (sender2, e2) =>
            {
                try
                {
                    if (ws.ReadyState == WebSocketState.Open)
                    {
                        ws.Close();
                    }
                    connectWSTX();
                }
                catch (Exception)
                {

                }

            };
            ws.Connect();
        }
        public void SendTX(int TorX, Int32 ValueBet, int amoutLoseToXnumber)
        {
            if (setCommonCircles.betThepTachBietMoiCau)
            {
                Thread.Sleep(setCommonCircles.betAfterSeconds * 1000);
                Int32 momeybet = Convert.ToInt32(ValueBet * Math.Pow(setCommonCircles.XNumber, amoutLoseToXnumber));
                setCommonCircles.listAllCircleSetBet[indexcirclebet].moneyWillbetNextSeassion = momeybet;
                Console.WriteLine("vao bet theponecau : " + setCommonCircles.XNumber + " tien: " + setCommonCircles.listAllCircleSetBet[indexcirclebet].moneyWillbetNextSeassion);
                ws.Send(CreatDataBet(TorX, momeybet));
            }
            else if (setCommonCircles.betOneMoney)
            {
                Thread.Sleep(setCommonCircles.betAfterSeconds * 1000);
                Console.WriteLine("vao bwet deu : " + setCommonCircles.XNumber + " tien: " + ValueBet);
                ws.Send(CreatDataBet(TorX, ValueBet));
            }
            else if (setCommonCircles.betThepAllCau)
            {
                Thread.Sleep(setCommonCircles.betAfterSeconds * 1000);
                Int32 momeybet = Convert.ToInt32(ValueBet * Math.Pow(setCommonCircles.XNumber, setCommonCircles.allC_amountLose));
                setCommonCircles.allC_moneyWillBet = momeybet;
                Console.WriteLine("vao all thep : " + setCommonCircles.XNumber + " tien: " + setCommonCircles.allC_moneyWillBet);
                ws.Send(CreatDataBet(TorX, setCommonCircles.allC_moneyWillBet));
            }
            else if (setCommonCircles.betUpDownMoneyDefault)
            {
                Thread.Sleep(setCommonCircles.betAfterSeconds * 1000);
                if (setCommonCircles.UDmoneyWillBetNextSession == 0)
                {
                    setCommonCircles.UDmoneyWillBetNextSession = setCommonCircles.moneyToBet;
                    setCommonCircles.UDmoneyBetBeforeSession = setCommonCircles.UDmoneyWillBetNextSession;
                }
                Console.WriteLine("bet money up down:" + setCommonCircles.UDmoneyWillBetNextSession);
                ws.Send(CreatDataBet(TorX, setCommonCircles.UDmoneyWillBetNextSession));
            }
            else if (setCommonCircles.betRandom2Col)
            {
                Thread.Sleep(setCommonCircles.betAfterSeconds * 1000);
                Int32 momeybet = Convert.ToInt32(ValueBet * Math.Pow(setCommonCircles.XNumber, amoutLoseToXnumber));
                setCommonCircles.listAllCircleSetBet[indexcirclebet].moneyWillbetNextSeassion = momeybet;
                Console.WriteLine("vao bet random2col : " + setCommonCircles.XNumber + " tien: " + setCommonCircles.listAllCircleSetBet[indexcirclebet].moneyWillbetNextSeassion);
                ws.Send(CreatDataBet(TorX, setCommonCircles.listAllCircleSetBet[indexcirclebet].moneyWillbetNextSeassion));
            }
            else if (setCommonCircles.betFollowRowsMoney)
            {
                Thread.Sleep(setCommonCircles.betAfterSeconds * 1000);
                if (setCommonCircles.listCirecleRowWait.Count > 0 && setCommonCircles.listCirecleRowWait[0].isBetorPause)
                {
                    ValueBet += setCommonCircles.listCirecleRowWait[0].moneyWillWaitNextSession;
                }
                Console.WriteLine("vao bwet followRows : " + setCommonCircles.XNumber + " tien: " + ValueBet);
                ws.Send(CreatDataBet(TorX, ValueBet));
            }
            else if (setCommonCircles.betFollowLastBefore)
            {
                Thread.Sleep(setCommonCircles.betAfterSeconds * 1000);
                if (setCommonCircles.UDmoneyWillBetNextSession == 0)
                {
                    setCommonCircles.UDmoneyWillBetNextSession = setCommonCircles.moneyToBet;
                    setCommonCircles.UDmoneyBetBeforeSession = setCommonCircles.UDmoneyWillBetNextSession;
                }
                Console.WriteLine("bet money up down:" + setCommonCircles.UDmoneyWillBetNextSession);
                ws.Send(CreatDataBet(TorX, setCommonCircles.UDmoneyWillBetNextSession));
            }
            else if (setCommonCircles.betFollowTXNotChange)
            {
                Thread.Sleep(setCommonCircles.betAfterSeconds * 1000);
                if (!setCommonCircles.betFollowTXNotChange_UD)
                {
                    Int32 momeybet = Convert.ToInt32(ValueBet * Math.Pow(setCommonCircles.XNumber, setCommonCircles.allTXDefaultNotCh_amountLose));
                    setCommonCircles.allTXDefaultNotCh_moneyWillBet = momeybet;
                    Console.WriteLine("bet money up down:" + setCommonCircles.allTXDefaultNotCh_moneyWillBet);
                    ws.Send(CreatDataBet(TorX, setCommonCircles.allTXDefaultNotCh_moneyWillBet));
                }
                else
                {
                    if (setCommonCircles.UDmoneyWillBetNextSession == 0)
                    {
                        setCommonCircles.UDmoneyWillBetNextSession = setCommonCircles.moneyToBet;
                        setCommonCircles.UDmoneyBetBeforeSession = setCommonCircles.UDmoneyWillBetNextSession;
                    }
                    Console.WriteLine("bet money up down not change:" + setCommonCircles.UDmoneyWillBetNextSession);
                    ws.Send(CreatDataBet(TorX, setCommonCircles.UDmoneyWillBetNextSession));
                }

            }

        }

        public void sendWsCheckLive()
        {
            ws.Send(CreatDataBet(1, 0));
        }
        public string mainloginCheckMoney(string Name, string Pass, string Argent)
        {
            throw new NotImplementedException();
        }

        public void mainLoginGame(string Name, string Pass, string Argent)
        {
            throw new NotImplementedException();
        }
        public void mainSendTX(int TorX, string ValueBet)
        {
            throw new NotImplementedException();
        }



        public string getRes15whenStart()
        {
            string res = funchandlingResHelper.getHictoryAboutNWhenStart(request);
            setCommonCircles.hictoryCircle10Before = res;
            return res;
        }

        public void readCircleText()
        {
            OpenFileDialog op = new OpenFileDialog();
            var dialogresult = op.ShowDialog();
            if (dialogresult == DialogResult.OK)
            {
                funchandlingResHelper.readTextCircle(setCommonCircles, op.FileName);
            }

        }


    }
}


public class jsonConnectTXNohu
{
    public string Url { get; set; }
    public string ConnectionToken { get; set; }
    public string ConnectionId { get; set; }
    public float KeepAliveTimeout { get; set; }
    public float DisconnectTimeout { get; set; }
    public float ConnectionTimeout { get; set; }
    public bool TryWebSockets { get; set; }
    public string ProtocolVersion { get; set; }
    public float TransportConnectTimeout { get; set; }
    public float LongPollDelay { get; set; }
}

public class jsonCheckAccountInforNohu
{
    public string Username { get; set; }
    public string Nickname { get; set; }
    public int AccountID { get; set; }
    public object Password { get; set; }
    public int IsCheckOTP { get; set; }
    public int BalanceGold { get; set; }
    public int BalanceXu { get; set; }
    public object ClientIP { get; set; }
    public object Description { get; set; }
    public int ResponseCode { get; set; }
    public string PhoneNumber { get; set; }
    public int VerifyStatus { get; set; }
    public int VipPoint { get; set; }
    public int Level { get; set; }
    public bool IsCaptcha { get; set; }
    public int Status { get; set; }
}

public class jsonGetKey
{
    public int stime { get; set; }
    public string sig { get; set; }
}
