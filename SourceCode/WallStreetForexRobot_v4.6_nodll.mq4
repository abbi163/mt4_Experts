
#property copyright "外汇联盟 www.FXunion.com QQ群144033"
#property link      ""

#import "wininet.dll"
   int InternetOpenA(string a0, int a1, string a2, string a3, int a4);
   int InternetOpenUrlA(int a0, string a1, string a2, int a3, int a4, int a5);
   int InternetReadFile(int a0, string a1, int a2, int& a3[]);
   int InternetCloseHandle(int a0);
#import /*"WALLSTREET.dll"
   int SessionInit(int a0, int a1, int a2, int a3, string a4);
   int SessionDeinit(int a0, int a1, int a2, int a3, string a4);
   int ParamValue(int a0, int a1);
   bool CheckCloseLong(int a0, double a1, double a2, double a3, double a4, double a5, double a6, double a7, double a8, double a9);
   bool CheckCloseShort(int a0, double a1, double a2, double a3, double a4, double a5, double a6, double a7, double a8, double a9);
   bool CheckOpenLong(int a0, double a1, double a2, double a3, double a4, double a5, double a6, double a7, double a8);
   bool CheckOpenShort(int a0, double a1, double a2, double a3, double a4, double a5, double a6, double a7, double a8);
#import*/

extern int Magic = 4698523;
extern string EA_Comment = "";
extern double MaxSpread = 3.5;
extern int Slippage = 2;
int Gi_100 = 3;
int Gi_104 = 3;
extern bool StealthMode = FALSE;
bool Gi_112 = TRUE;
extern bool CloseOnlyOnProfit = FALSE;
extern bool NFA = FALSE;
extern bool No_Hedge = FALSE;
extern string CS = "==== Custom Settings ====";
extern int StopLoss = -1;
extern int TakeProfit = -1;
extern int SecureProfit = -1;
extern int SecureProfitTriger = -1;
extern bool UseCustomPair = TRUE;
extern string UseSettingsFrom = "EURUSD";
extern string MM = "==== Risk Management ====";
extern bool RecoveryMode = FALSE;
extern double FixedLots = 0.1;
extern double AutoMM = 0.0;
extern double AutoMM_Max = 20.0;
extern int MaxAccountTrades = 0;
extern string FE = "==== Monday-Friday Rules ====";
extern int MondayStartHour = 0;
extern bool FridayExit = FALSE;
extern int LastTradeHour = 19;
extern int ExitHour = 20;
extern string NF = "==== News Filter Settings ====";
extern bool Avoid_News = FALSE;
extern int GMT_Offset = 2;
extern bool DST_Usage = TRUE;
extern bool Include_Medium_News = TRUE;
extern int Wait_Before_News = 30;
extern int Wait_After_News = 30;
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////|
extern string O1="==== OPTIMIZATION PARAMETERS ====";///////////////////////////////////////////////////////////////////////////////////////////////////////////|
extern string O2="=========== DISABLED IF ============";///|EURUSD|EURUSD| EUR33 |GBPUSD|GBPUSD| GBP52 |GBP52T| GBP30 |USDJPY|USDJPY|USDCHF|USDCAD|AUDUSD|NZDUSD|
extern string O3="==== <USECUSTOMPAIR> = TRUE ====";///////|------| _new |-------|------| _new |-------|------|-------|------| _new |------|------|------|------|
extern string O4="======= Use it only for optimization ======";///|//////|///////|//////|//////|///////|//////|///////|//////|//////|//////|//////|//////|//////|
extern int iMA_Period = 75;                        //   1  |  75  |  75  |  75   |  75  |  75  |  75   |  75  |  75   |  85  |  85  |  70  |  65  |  75  |  45  |
extern int iMA_Filter_Open_b = 39;                 //   2  |  39  |  30  |  42   |  33  |  34  |  30   |  21  |  39   |  21  |  10  |  25  |  15  |  33  |  70  |
extern int iWPR_Filter_OpenSignal_b = 5;           //   3  |   5  |   5  |   5   |   6  |   6  |   6   |   6  |   6   |   5  |   3  |   9  |  11  |   2  |   2  |
extern int iMA_Filter_Open_a = 15;                 //   4  |  15  |  17  |  42   |  12  |  12  |  12   |   3  |  13   |   5  | -14  |   8  |   5  |  13  |  14  |
extern int iWPR_Filter_OpenSignal_a = 1;           //   5  |   1  |   1  |   5   |   1  |   1  |   2   |   3  |   2   |   1  |   1  |   5  |   1  |   2  |   2  |
extern int iWPR_Filter_Close = 19;                 //   6  |  19  |  15  |  14   |  19  |  19  |  25   |  33  |  22   |  27  |  28  |  22  |   6  |  12  |  -5  |
extern int MaxLossPoints = -65;                    //   7  | -65  |   0  |  -5   |-200  | -30  | -30   | -25  | -50   | -80  |-200  | -40  | -30  | -40  | -40  |
extern int iWPR_Period = 11;                       //   8  |  11  |  11  |  10   |  12  |  12  |  12   |  12  |  22   |  12  |  12  |  12  |  16  |  18  |  15  |
extern int Price_Filter_Close = 14;                //   9  |  14  |  14  |  14   |  18  |  13  |  10   |  13  |  11   |  13  |  10  |  11  |  14  |   8  |  20  |
extern int SecureProfit_ = 1;                      //  10  |   1  |   3  |   5   |   2  |  14  |   4   |   7  |   0   |   2  |  13  |   0  |   2  |   1  |  10  |
extern int SecureProfitTriger_ = 10;               //  11  |  10  |  11  |  13   |  24  |  23  |  20   |  20  |  20   |  14  |  15  |  15  |  10  |  16  |  40  |
extern int iWPR_Filter_Open_unknown = -1;          //  12  |  -1  |  -1  |  -2   |  -1  |  -1  |  -5   |  -3  |  -3   |  -1  |  -1  |  -2  |  -4  |  -1  |  -2  |
extern int iWPR_Filter_Close_unknown = -1;         //  13  |  -1  |  -1  |  -5   |  -1  |   0  |   0   |   0  |   0   |  -2  |  -2  |  -1  |  -1  |  -1  |  -5  |
extern int iWPR_Close_Period = 0;                  //  14  |   0  |   0  |   1   |   0  |   0  |   0   |   0  |   0   |   0  |   1  |   0  |   0  |   0  |   0  |
extern int FilterATR = 6;                          //  15  |   6  |   6  |   6   |   6  |   5  |   5   |   5  |   5   |   0  |   8  |   3  |   4  |   0  |   0  |
extern int iATR_Period = 14;                       //  16  |  14  |  14  |  14   |  14  |  14  |  14   |  14  |  14   |  14  |  36  |  14  |  14  |  14  |  14  |
extern int iCCI_OpenFilter = 150;                  //  17  | 150  | 155  | 190   | 290  | 250  | 240   | 160  | 240   |2000  | 190  | 170  | 130  | 140  | 120  |
extern int iCCI_Period = 18;                       //  18  |  18  |  18  |   5   |  12  |  11  |  10   |  12  |  10   |  12  |  12  |  14  |  12  |  18  |  18  |
extern int Unknown_1 = 0;                          //  19  |   0  |   0  |   0   |   0  |   0  |   0   |   0  |   0   |   0  |   0  |   0  |   0  |   0  |   0  |
extern int Unknown_2 = 0;                          //  20  |   0  |   0  |   0   |   0  |   0  |   0   |   0  |   0   |   0  |   0  |   0  |   0  |   0  |   0  |
extern int StopLoss_ = 120;                        //  21  | 120  |  80  |  33   | 120  |  95  |  52   |  52  |  30   | 130  | 120  | 120  | 150  | 150  | 130  |
extern int TakeProfit_ = 26;                       //  22  |  26  |  30  |  30   |  50  |  50  |  70   |  40  |  90   |  27  |  65  |  17  |  14  |  70  |  50  |
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////|
int Gi_260 = 50;
double Gd_264 = 25.0;
double Gd_272 = 1.1;
int p1 = 0;
int p2 = 0;
int p3 = 0;
int p4 = 0;
int p5 = 0;
int p6 = 0;
int p7 = 0;
int p8 = 0;
int p9 = 0;
int p10;
int p11;
int p12 = 0;
int p13 = 0;
int p14 = 0;
int p15 = 0;
int p16 = 0;
int p17 = 0;
int p18 = 0;
int p19 = 0;
int p20 = 0;
int p21;
int p22;
int Gi_352 = -1;
string Gs_356 = "";
bool Gi_364 = TRUE;
bool Gi_368 = FALSE;
int G_stoplevel_372 = 0;
double G_minlot_376 = 0.01;
double G_maxlot_384 = 0.01;
double G_lotstep_392 = 0.01;
int G_lotsize_400 = 100000;
double G_marginrequired_404 = 1000.0;
double Gd_412 = 0.0001;
double Gd_unused_420 = 0.1;
string Gs_428 = "";
string Gs_436 = "";
int G_datetime_444 = 0;
double Gd_448 = 1.0;
int G_datetime_456 = 0;
int G_datetime_460 = 0;
double Gd_unused_464 = 1.0;
int G_index_472 = 0;
int Gia_476[1000];
string Gsa_480[1000];
string Gsa_484[1000];
/*
int f0_0() {
   int Li_20;
   bool Li_ret_0 = TRUE;
   string Ls_4 = "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; Q312461)";
   bool Li_12 = FALSE;
   int Li_16 = InternetOpenA(Ls_4, Li_12, "0", "0", 0);
   if (Li_16 != 0) {
      Li_20 = InternetOpenUrlA(Li_16, "http://www.wallstreet-forex.com", "0", 0, -2080374528, 0);
      if (Li_20 == 0) Li_ret_0 = FALSE;
      else InternetCloseHandle(Li_20);
      InternetCloseHandle(Li_16);
   } else Li_ret_0 = FALSE;
   return (Li_ret_0);
}
*/	     	 			 							  	 		   	  							  	       			 	 			  	 	     		 	   	  	 	 							 			  		 	 	 		 	  	  		 	 	 		    	 						  	   	 	  			
void init() {
   Gi_364 = TRUE;
   Gi_352 = -1;
   Comment("");
   if (ObjectFind("BKGR") >= 0) ObjectDelete("BKGR");
   if (ObjectFind("BKGR2") >= 0) ObjectDelete("BKGR2");
   if (ObjectFind("BKGR3") >= 0) ObjectDelete("BKGR3");
   if (ObjectFind("BKGR4") >= 0) ObjectDelete("BKGR4");
   if (ObjectFind("LV") >= 0) ObjectDelete("LV");
}

int deinit() {
   Comment("");
   if (ObjectFind("BKGR") >= 0) ObjectDelete("BKGR");
   if (ObjectFind("BKGR2") >= 0) ObjectDelete("BKGR2");
   if (ObjectFind("BKGR3") >= 0) ObjectDelete("BKGR3");
   if (ObjectFind("BKGR4") >= 0) ObjectDelete("BKGR4");
   if (ObjectFind("LV") >= 0) ObjectDelete("LV");
   if (Gi_352 != -1) Gi_352 = f0_7();
   return (0);
}

int start() {
   double price_8;
   double Ld_16;
   double Ld_24;
   color color_32;
   double lots_40;
   int Li_72;
   int Li_76;
   int Li_84;
   string Ls_88;
   int ticket_164;
   double price_176;
   double price_184;
   int Li_200;
   string Ls_204;
   string Ls_0 = "";
   double Ld_48 = 0;
   double Ld_56 = 0;
   double Ld_64 = 0;
   if (DayOfWeek() == 1 && iVolume(NULL, PERIOD_D1, 0) < 5.0) return (0);
   if (StringLen(Symbol()) < 6) return (0);
   if (Gi_364) {
      Comment("\nInitializing ...");
      Sleep(1000);
      RefreshRates();
      Gi_364 = FALSE;
      Gs_428 = "";
      Gs_436 = "";
      G_datetime_444 = 0;
      G_stoplevel_372 = MarketInfo(Symbol(), MODE_STOPLEVEL);
      G_minlot_376 = MarketInfo(Symbol(), MODE_MINLOT);
      G_maxlot_384 = MarketInfo(Symbol(), MODE_MAXLOT);
      G_lotsize_400 = MarketInfo(Symbol(), MODE_LOTSIZE);
      G_lotstep_392 = MarketInfo(Symbol(), MODE_LOTSTEP);
      G_marginrequired_404 = MarketInfo(Symbol(), MODE_MARGINREQUIRED);
      if (Digits <= 3) Gd_412 = 0.01;
      else Gd_412 = 0.0001;
      if (Digits == 3 || Digits == 5) Gd_unused_420 = 0.1;
      else Gd_unused_420 = 1;
      Sleep(1000);
      Gi_368 = 1;//f0_0();
      Sleep(1000);
      if (!Gi_368) Gi_364 = TRUE;
   }
   if ((!IsTesting()) && IsStopped()) return (0);
   if ((!IsTesting()) && !IsTradeAllowed()) return (0);
   if ((!IsTesting()) && IsTradeContextBusy()) return (0);
   if (IsDllsAllowed() == FALSE) {
      Comment("\nWarning: Set Parameter **AllowDLL Imports** ON in menu Tools -> Options -> ExpertAdvisors.");
      Print("Warning: Set Parameter **AllowDLL Imports** ON in menu Tools -> Options -> ExpertAdvisors.");
      Alert("Warning: Set Parameter **AllowDLL Imports** ON in menu Tools -> Options -> ExpertAdvisors.");
      Sleep(30000);
      return (0);
   }
   if (Gi_352 <= 0) {
      if (!Gi_368) {
         Comment("\nInternet connection problem");
         Alert("Internet connection problem");
         Sleep(10000);
         return (0);
      }
      Comment("\nUpdating settings. Please, wait! ...");
      Sleep(1000);
      Ls_88 = "";
      Li_72 = 1440 * TimeHour(TimeLocal()) + 60 * TimeMinute(TimeLocal()) + TimeSeconds(TimeLocal()) + MathMod(AccountNumber(), 10000);
      for (int Li_80 = 0; Li_80 < StringLen(Symbol()); Li_80++) {
         Li_84 = StringGetChar(Symbol(), Li_80);
         Li_72 += Li_84;
      }
      MathSrand(Li_72);
      Li_76 = MathMod(MathRand(), 60);
      for (int Li_96 = 1; Li_96 <= Li_76 + 1; Li_96++) {
         if (Li_96 > 2) Ls_88 = Ls_88 + ".";
         Comment("\nUpdating settings. Please, wait! ..." + Ls_88);
         Sleep(1000);
      }
      Gi_352 = f0_5();
      Sleep(1000);
      if (Gi_352 < 0) Comment("\nInitializing ...");
   }
   if (Gi_352 <= 0) {
      if (Gi_352 == -8) {
         Comment("\nUnsupported currency pair " + Gs_356 + ", Bid: " + DoubleToStr(Bid, Digits) + ", Ask: " + DoubleToStr(Ask, Digits));
         Alert("Unsupported currency pair " + Gs_356 + ", Bid: " + DoubleToStr(Bid, Digits) + ", Ask: " + DoubleToStr(Ask, Digits));
      } else {
         Comment("You  must  fill  in  <UseSettingsFrom>  if  <UseCustomPair>  =  true");
         Comment("青镱腠栩?镱脲 <UseSettingsFrom> 羼腓 <UseCustomPair> = true");
//         Comment("\nInitialization is failed with error code " + DoubleToStr(Gi_352, 0));
         Alert("You  must  fill  in  <UseSettingsFrom>  if  <UseCustomPair>  =  true");
         Alert("青镱腠栩?镱脲 <UseSettingsFrom> 羼腓 <UseCustomPair> = true");
//         Alert("Initialization is failed with error code " + DoubleToStr(Gi_352, 0));
      }
      Sleep(10000);
      return (0);
   }
   if (p1 <= 0 || p8 <= 0 || p16 <= 0 || p18 <= 0) {
      Comment("\nWrong initialization parameters for pair " + Symbol());
      Alert("Wrong initialization parameters for pair " + Symbol());
      Sleep(10000);
      return (0);
   }
   if (G_datetime_456 == iTime(NULL, PERIOD_M1, 0)) return (0);
   G_datetime_456 = iTime(NULL, PERIOD_M1, 0);
   HideTestIndicators(TRUE);
   double iclose_100 = iClose(NULL, PERIOD_M15, 1);
   double ima_108 = iMA(NULL, PERIOD_M15, p1, 0, MODE_SMMA, PRICE_CLOSE, 1);
   double iwpr_116 = iWPR(NULL, PERIOD_M15, p8, 1);
   double iatr_124 = iATR(NULL, PERIOD_M15, p16, 1);
   double icci_132 = iCCI(NULL, PERIOD_M15, p18, PRICE_TYPICAL, 1);
   HideTestIndicators(FALSE);
   double Ld_140 = 0;
   if (StringSubstr(AccountCurrency(), 0, 3) == "JPY") {
      Ld_140 = MarketInfo("USDJPY" + StringSubstr(Symbol(), 6), MODE_BID);
      if (Ld_140 > 0.1) Gd_448 = Ld_140;
      else Gd_448 = 94;
   }
   if (StringSubstr(AccountCurrency(), 0, 3) == "GBP") {
      Ld_140 = MarketInfo("GBPUSD" + StringSubstr(Symbol(), 6), MODE_BID);
      if (Ld_140 > 0.1) Gd_448 = 1 / Ld_140;
      else Gd_448 = 0.6622516556;
   }
   if (StringSubstr(AccountCurrency(), 0, 3) == "EUR") {
      Ld_140 = MarketInfo("EURUSD" + StringSubstr(Symbol(), 6), MODE_BID);
      if (Ld_140 > 0.1) Gd_448 = 1 / Ld_140;
      else Gd_448 = 0.78125;
   }
   if (AutoMM > 0.0 && (!RecoveryMode)) lots_40 = MathMax(G_minlot_376, MathMin(G_maxlot_384, MathCeil(MathMin(AutoMM_Max, AutoMM) / Gd_448 / 100.0 * AccountFreeMargin() / G_lotstep_392 / (G_lotsize_400 / 100)) * G_lotstep_392));
   if (AutoMM > 0.0 && RecoveryMode) lots_40 = f0_1();
   if (AutoMM == 0.0) lots_40 = FixedLots;
   Ls_0 = Ls_0 
      + "\n  " 
      + "\n " 
      + "\n  Authorization - OK!" 
      + "\n -----------------------------------------------" 
      + "\n  SL = " + p21 + " pips / TP = " + p22 + " pips" 
   + "\n  Spread = " + DoubleToStr((Ask - Bid) / Gd_412, 1) + " pips";
   if (Ask - Bid > MaxSpread * Gd_412) Ls_0 = Ls_0 + " - TOO HIGH";
   else Ls_0 = Ls_0 + " - NORMAL";
   Ls_0 = Ls_0 
   + "\n -----------------------------------------------";
   if (AutoMM > 0.0) {
      Ls_0 = Ls_0 
         + "\n  AutoMM - ENABLED" 
      + "\n  Risk = " + DoubleToStr(AutoMM, 1) + "%";
   }
   Ls_0 = Ls_0 
   + "\n  Trading Lots = " + DoubleToStr(lots_40, 2);
   Ls_0 = Ls_0 
   + "\n -----------------------------------------------";
   if (RecoveryMode) {
      Ls_0 = Ls_0 
      + "\n  Recovery Mode - ENABLED";
   } else {
      Ls_0 = Ls_0 
      + "\n  Recovery Mode - DISABLED";
   }
   if (StealthMode) {
      Ls_0 = Ls_0 
      + "\n  Stealth Mode - ENABLED";
   } else {
      Ls_0 = Ls_0 
      + "\n  Stealth Mode - DISABLED";
   }
   f0_2();
   Ls_0 = Ls_0 
   + "\n  " + Gs_428;
   Ls_0 = Ls_0 
   + "\n -----------------------------------------------";
   Comment(Ls_0);
   if (ObjectFind("BKGR") < 0) {
      ObjectCreate("BKGR", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("BKGR", "g", 110, "Webdings", LightSlateGray);
      ObjectSet("BKGR", OBJPROP_CORNER, 0);
      ObjectSet("BKGR", OBJPROP_BACK, TRUE);
      ObjectSet("BKGR", OBJPROP_XDISTANCE, 5);
      ObjectSet("BKGR", OBJPROP_YDISTANCE, 15);
   }
   if (ObjectFind("BKGR2") < 0) {
      ObjectCreate("BKGR2", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("BKGR2", "g", 110, "Webdings", DimGray);
      ObjectSet("BKGR2", OBJPROP_BACK, TRUE);
      ObjectSet("BKGR2", OBJPROP_XDISTANCE, 5);
      ObjectSet("BKGR2", OBJPROP_YDISTANCE, 60);
   }
   if (ObjectFind("BKGR3") < 0) {
      ObjectCreate("BKGR3", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("BKGR3", "g", 110, "Webdings", DimGray);
      ObjectSet("BKGR3", OBJPROP_CORNER, 0);
      ObjectSet("BKGR3", OBJPROP_BACK, TRUE);
      ObjectSet("BKGR3", OBJPROP_XDISTANCE, 5);
      ObjectSet("BKGR3", OBJPROP_YDISTANCE, 45);
   }
   if (ObjectFind("LV") < 0) {
      ObjectCreate("LV", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("LV", "WALL STREET ROBOT", 9, "Tahoma Bold", DarkOrange);
      ObjectSet("LV", OBJPROP_CORNER, 0);
      ObjectSet("LV", OBJPROP_BACK, FALSE);
      ObjectSet("LV", OBJPROP_XDISTANCE, 13);
      ObjectSet("LV", OBJPROP_YDISTANCE, 23);
   }
   if (ObjectFind("BKGR4") < 0) {
      ObjectCreate("BKGR4", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("BKGR4", "g", 110, "Webdings", DimGray);
      ObjectSet("BKGR4", OBJPROP_CORNER, 0);
      ObjectSet("BKGR4", OBJPROP_BACK, TRUE);
      ObjectSet("BKGR4", OBJPROP_XDISTANCE, 5);
      ObjectSet("BKGR4", OBJPROP_YDISTANCE, 96);
   }
   if (p22 < G_stoplevel_372 * Point / Gd_412) p22 = G_stoplevel_372 * Point / Gd_412;
   if (p21 < G_stoplevel_372 * Point / Gd_412) p21 = G_stoplevel_372 * Point / Gd_412;
   Slippage = Slippage * Gd_412;
   int count_148 = 0;
   int count_152 = 0;
   int count_156 = 0;
   int count_160 = 0;
   if (CloseOnlyOnProfit) p7 = FALSE;
   for (int pos_172 = OrdersTotal() - 1; pos_172 >= 0; pos_172--) {
      if (!OrderSelect(pos_172, SELECT_BY_POS, MODE_TRADES)) Print("Error in OrderSelect! Position:", pos_172);
      else {
         if (OrderType() <= OP_SELL && OrderSymbol() == Symbol()) {
            if (OrderMagicNumber() != Magic) {
               if (OrderType() == OP_BUY) count_156++;
               else count_160++;
            }
            if (OrderMagicNumber() == Magic) {
               Ld_64 += OrderProfit();
               if (OrderType() == OP_BUY) Ld_48 = (Bid - OrderOpenPrice()) / Gd_412;
               else Ld_48 = (OrderOpenPrice() - Ask) / Gd_412;
               Ld_56 += Ld_48;
               if (OrderType() == OP_BUY) {
                  count_148++;
                  if (OrderStopLoss() == 0.0 && StealthMode == FALSE) {
                     price_176 = NormalizeDouble(Ask - p21 * Gd_412, Digits);
                     price_184 = NormalizeDouble(Ask + p22 * Gd_412, Digits);
                     OrderModify(OrderTicket(), OrderOpenPrice(), price_176, price_184, 0, Green);
                     continue;
                  }
                  if (Bid >= OrderOpenPrice() + p22 * Gd_412 || Bid <= OrderOpenPrice() - p21 * Gd_412 || (f0_10(OrderOpenPrice(), iwpr_116, iclose_100, iOpen(NULL, PERIOD_M1,
                     1), iClose(NULL, PERIOD_M1, 1)) && TimeCurrent() - OrderOpenTime() > 180) || (FridayExit && DayOfWeek() == 5 && Hour() >= ExitHour && TimeCurrent() - OrderOpenTime() > 180)) {
                     for (int Li_168 = 1; Li_168 <= MathMax(1, Gi_100); Li_168++) {
                        RefreshRates();
                        if (OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Bid, Digits), Slippage, Violet)) {
                           count_148--;
                           break;
                        }
                        Sleep(MathMax(100, 1000 * Gi_104));
                     }
                     Sleep(5000);
                     continue;
                  }
                  if (!(Bid - OrderOpenPrice() > p11 * Gd_412 && MathAbs(OrderOpenPrice() + p10 * Gd_412 - OrderStopLoss()) >= Point)) continue;
                  OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(OrderOpenPrice() + p10 * Gd_412, Digits), OrderTakeProfit(), 0, Blue);
                  continue;
               }
               count_152++;
               if (OrderStopLoss() == 0.0 && StealthMode == FALSE) {
                  price_176 = NormalizeDouble(Bid + p21 * Gd_412, Digits);
                  price_184 = NormalizeDouble(Bid - p22 * Gd_412, Digits);
                  OrderModify(OrderTicket(), OrderOpenPrice(), price_176, price_184, 0, Green);
                  continue;
               }
               if (Ask <= OrderOpenPrice() - p22 * Gd_412 || Ask >= OrderOpenPrice() + p21 * Gd_412 || (f0_11(OrderOpenPrice(), iwpr_116, iclose_100, iOpen(NULL, PERIOD_M1,
                  1), iClose(NULL, PERIOD_M1, 1)) && TimeCurrent() - OrderOpenTime() > 180) || (FridayExit && DayOfWeek() == 5 && Hour() >= ExitHour && TimeCurrent() - OrderOpenTime() > 180)) {
                  for (Li_168 = 1; Li_168 <= MathMax(1, Gi_100); Li_168++) {
                     RefreshRates();
                     if (OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Ask, Digits), Slippage, Violet)) {
                        count_152--;
                        break;
                     }
                     Sleep(MathMax(100, 1000 * Gi_104));
                  }
                  Sleep(5000);
                  continue;
               }
               if (OrderOpenPrice() - Ask > p11 * Gd_412 && MathAbs(OrderOpenPrice() - p10 * Gd_412 - OrderStopLoss()) >= Point) OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble(OrderOpenPrice() - p10 * Gd_412, Digits), OrderTakeProfit(), 0, Red);
            }
         }
      }
   }
   Ls_0 = Ls_0 
   + "\n  Account Ballance = " + DoubleToStr(AccountBalance(), 2);
   if (count_148 == 0 && count_152 == 0) {
      Ls_0 = Ls_0 
         + "\n  No active trades" 
      + "\n";
   } else {
      Ls_0 = Ls_0 
         + "\n  Current trade " + DoubleToStr(Ld_56, 1) 
      + "\n  Account Profit = " + DoubleToStr(Ld_64, 2);
   }
   Comment(Ls_0);
   bool Li_192 = TRUE;
   bool Li_196 = TRUE;
   if (NFA == TRUE && count_152 > 0 || count_148 > 0) {
      Li_192 = FALSE;
      Li_196 = FALSE;
   }
   if (NFA == TRUE && count_160 > 0 || count_156 > 0) {
      Li_192 = FALSE;
      Li_196 = FALSE;
   }
   if (No_Hedge == TRUE && count_152 > 0 || count_160 > 0) Li_192 = FALSE;
   if (No_Hedge == TRUE && count_148 > 0 || count_156 > 0) Li_196 = FALSE;
   if (!Gi_112) p17 = 1000;
   else p17 = p17;
   if (iatr_124 <= p15 * Gd_412) return (0);
   if (OrdersTotal() >= MaxAccountTrades && MaxAccountTrades > 0) return (0);
   if (StringSubstr(Symbol(), 0, 6) == "EURUSD" && MondayStartHour == 0) Li_200 = 22;
   else Li_200 = MondayStartHour;
   if (DayOfWeek() == 1 && Hour() < Li_200) return (0);
   if (FridayExit && DayOfWeek() == 5 && Hour() > MathMin(LastTradeHour, ExitHour - 1)) return (0);
   int cmd_36 = -1;
   if (count_148 < 1 && f0_9(iclose_100, ima_108, iwpr_116, icci_132)) {
      if (Ask - Bid > MaxSpread * Gd_412) {
         Print("BUY not taken!!! - High spead...");
         Sleep(1000);
      } else {
         if (!Li_192) {
            Print("BUY not taken!!! - No Hedge, or FIFO restriction ...");
            Sleep(1000);
         } else {
            Ls_204 = "BUY";
            cmd_36 = 0;
            color_32 = Aqua;
            RefreshRates();
            price_8 = NormalizeDouble(Ask, Digits);
            Ld_16 = price_8 - p21 * Gd_412;
            Ld_24 = price_8 + p22 * Gd_412;
         }
      }
   }
   if (count_152 < 1 && f0_4(iclose_100, ima_108, iwpr_116, icci_132)) {
      if (Ask - Bid > MaxSpread * Gd_412) {
         Print("SELL not taken!!! - High spead...");
         Sleep(1000);
      } else {
         if (!Li_196) {
            Print("SELL not taken!!! - No Hedge, or FIFO restriction ...");
            Sleep(1000);
         } else {
            Ls_204 = "SELL";
            cmd_36 = 1;
            color_32 = Red;
            RefreshRates();
            price_8 = NormalizeDouble(Bid, Digits);
            Ld_16 = price_8 + p21 * Gd_412;
            Ld_24 = price_8 - p22 * Gd_412;
         }
      }
   }
   if (cmd_36 >= OP_BUY && f0_3() && f0_6()) {
      for (Li_168 = 1; Li_168 <= MathMax(1, Gi_100); Li_168++) {
         ticket_164 = OrderSend(Symbol(), cmd_36, lots_40, price_8, Slippage, 0, 0, EA_Comment, Magic, 0, color_32);
         if (ticket_164 >= 0) break;
         Sleep(MathMax(100, 1000 * Gi_104));
         RefreshRates();
         if (cmd_36 == OP_BUY) price_8 = NormalizeDouble(Ask, Digits);
         else
            if (cmd_36 == OP_SELL) price_8 = NormalizeDouble(Bid, Digits);
      }
      Sleep(5000);
      if (ticket_164 > 0) {
         G_datetime_456 = 0;
         if (OrderSelect(ticket_164, SELECT_BY_TICKET, MODE_TRADES)) Print("Order " + Ls_204 + " opened!: ", OrderOpenPrice());
      } else Print("Error opening " + Ls_204 + " order!: ", GetLastError());
   } else {
      if (cmd_36 >= OP_BUY && f0_3() && G_datetime_460 != iTime(NULL, PERIOD_M15, 1)) {
         G_datetime_460 = iTime(NULL, PERIOD_M15, 1);
         if (cmd_36 == OP_BUY) Print("BUY skipped: " + Gs_436);
         else Print("SELL skipped: " + Gs_436);
      }
   }
   return (0);
}

double f0_1() {
   double Ld_16;
   int count_24;
   double Ld_28;
   int Li_36;
   double Ld_40;
   int Li_48;
   double Ld_52;
   int Li_60;
   double Ld_8 = 1;
   if (Gd_272 > 0.0 && AutoMM > 0.0) {
      Ld_16 = 0;
      count_24 = 0;
      Ld_28 = 0;
      Li_36 = 0;
      Ld_40 = 0;
      Li_48 = 0;
      for (int pos_64 = OrdersHistoryTotal() - 1; pos_64 >= 0; pos_64--) {
         if (OrderSelect(pos_64, SELECT_BY_POS, MODE_HISTORY)) {
            if (OrderSymbol() == Symbol() && OrderMagicNumber() == Magic) {
               count_24++;
               Ld_16 += OrderProfit();
               if (Ld_16 > Ld_40) {
                  Ld_40 = Ld_16;
                  Li_48 = count_24;
               }
               if (Ld_16 < Ld_28) {
                  Ld_28 = Ld_16;
                  Li_36 = count_24;
               }
               if (count_24 >= Gi_260) break;
            }
         }
      }
      if (Li_48 <= Li_36) Ld_8 = MathPow(Gd_272, Li_36);
      else {
         Ld_16 = Ld_40;
         count_24 = Li_48;
         Ld_52 = Ld_40;
         Li_60 = Li_48;
         for (pos_64 = OrdersHistoryTotal() - Li_48 - 1; pos_64 >= 0; pos_64--) {
            if (OrderSelect(pos_64, SELECT_BY_POS, MODE_HISTORY)) {
               if (OrderSymbol() == Symbol() && OrderMagicNumber() == Magic) {
                  if (count_24 >= Gi_260) break;
                  count_24++;
                  Ld_16 += OrderProfit();
                  if (Ld_16 < Ld_52) {
                     Ld_52 = Ld_16;
                     Li_60 = count_24;
                  }
               }
            }
         }
         if (Li_60 == Li_48 || Ld_52 == Ld_40) Ld_8 = MathPow(Gd_272, Li_36);
         else {
            if (MathAbs(Ld_28 - Ld_40) / MathAbs(Ld_52 - Ld_40) >= (Gd_264 + 100.0) / 100.0) Ld_8 = MathPow(Gd_272, Li_36);
            else Ld_8 = MathPow(Gd_272, Li_60);
         }
      }
   }
   for (double Ld_ret_0 = MathMax(G_minlot_376, MathMin(G_maxlot_384, MathCeil(MathMin(AutoMM_Max, Ld_8 * AutoMM) / Gd_448 / 100.0 * AccountFreeMargin() / G_lotstep_392 / (G_lotsize_400 / 100)) * G_lotstep_392)); Ld_ret_0 >= 2.0 * G_minlot_376 &&
      1.05 * (Ld_ret_0 * G_marginrequired_404) >= AccountFreeMargin(); Ld_ret_0 -= G_minlot_376) {
   }
   return (Ld_ret_0);
}

int f0_3() {
   int datetime_4;
   bool Li_ret_0 = TRUE;
   if (p19 > 0 && p20 > 0) {
      datetime_4 = 0;
      for (int pos_8 = OrdersHistoryTotal() - 1; pos_8 >= 0; pos_8--) {
         if (OrderSelect(pos_8, SELECT_BY_POS, MODE_HISTORY)) {
            if (OrderSymbol() == Symbol() && OrderMagicNumber() == Magic) {
               if (!((OrderType() == OP_BUY && (OrderClosePrice() - OrderOpenPrice()) / Gd_412 <= (-p19)) || (OrderType() == OP_SELL && (OrderOpenPrice() - OrderClosePrice()) / Gd_412 <= (-p19)))) break;
               datetime_4 = OrderCloseTime();
               break;
            }
         }
      }
      if (TimeCurrent() - datetime_4 < 3600 * p20) Li_ret_0 = FALSE;
   }
   return (Li_ret_0);
}

int f0_8() {
   int Li_ret_0 = GMT_Offset;
   if (DST_Usage && (Month() > 3 && Month() < 11)) Li_ret_0++;
   return (Li_ret_0);
}
	 	 		 			      		  	 	 	 	  		 		 	  			 	 						   	  	 			 		  		 	 	    	 	  	 	     	 			   				  		 				   				  	  			   		  	 		 					  	
void f0_2() {
   int file_0;
   int Li_8;
   int Li_12;
   string Ls_16;
   string Ls_24;
   bool Li_32;
   string Ls_44;
   string Ls_52;
   string Ls_60;
   string Ls_68;
   string Ls_76;
   string Ls_84;
   string Ls_92;
   int Li_100;
   string name_104;
   string Ls_112;
   string Ls_120;
   bool Li_128;
   int Li_132;
   int Li_136;
   int Li_140;
   int Li_144;
   string Ls_152;
   int Li_160;
   Gs_428 = "";
   if (!Avoid_News) {
      Gs_428 = "News Filter - OFF";
      return;
   }
   Gs_428 = "News Filter - No Important News";
   if (MathAbs(TimeCurrent() - G_datetime_444) >= 86400.0 || TimeDay(TimeCurrent()) != TimeDay(G_datetime_444)) {
      name_104 = "Wallstreet_Current_News.csv";
      Ls_112 = "http://www.wallstreet-forex.com/calendar.php?all=0";
      G_datetime_444 = TimeCurrent();
      if (IsTesting()) {
         name_104 = "Wallstreet_History_News.csv";
         Ls_112 = "http://www.wallstreet-forex.com/calendar.php?all=1";
      }
      Ls_112 = Ls_112 + "&AccountId=" + DoubleToStr(AccountNumber(), 0) + "&AccountType=";
      if (IsDemo()) Ls_112 = Ls_112 + "1";
      else Ls_112 = Ls_112 + "2";
      Li_32 = TRUE;
      for (int Li_4 = 1; Li_4 <= 3; Li_4++) {
         file_0 = FileOpen(name_104, FILE_CSV|FILE_READ, ';');
         if (file_0 >= 0) break;
         Sleep(1000);
      }
      if (file_0 >= 0) {
         while (!FileIsEnding(file_0)) {
            for (string Ls_36 = FileReadString(file_0); !FileIsEnding(file_0); Ls_36 = FileReadString(file_0))
               if (StringLen(Ls_36) == 10 && StringFind(Ls_36, ".") == 4) break;
            Ls_44 = FileReadString(file_0);
            if (StringLen(Ls_44) != 5 || StringFind(Ls_44, ":") != 2) continue;
            Ls_52 = FileReadString(file_0);
            Ls_60 = FileReadString(file_0);
            Ls_68 = FileReadString(file_0);
            Ls_76 = FileReadString(file_0);
            Ls_84 = FileReadString(file_0);
            Ls_92 = FileReadString(file_0);
            if (StringLen(Ls_36) > 0 && StringLen(Ls_44) > 0) {
               Li_100 = StrToTime(Ls_36 + " " + Ls_44) + 3600 * f0_8();
               if ((IsTesting() && Li_100 >= TimeCurrent() - 86400) || (!IsTesting() && Li_100 >= TimeCurrent() + 86400) || (!IsTesting() && Day() >= 5 && Li_100 - 3600 * f0_8() > iTime(NULL,
                  PERIOD_D1, 0))) {
                  Li_32 = FALSE;
                  break;
               }
            }
         }
         FileClose(file_0);
         if (Li_32) FileDelete(name_104);
      }
      if (Li_32) {
         Li_12 = 0;
         for (Li_4 = 1; Li_4 <= 3; Li_4++) {
            file_0 = FileOpen(name_104, FILE_CSV|FILE_WRITE, ';');
            if (file_0 >= 0) break;
            Sleep(1000);
         }
         if (file_0 >= 0) {
            Ls_120 = "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; Q312461)";
            Li_128 = FALSE;
            Li_144 = 120;
            int Lia_148[] = {1};
            Ls_152 = "                                                                                                                                                                                                                                                           ";
            Ls_16 = "";
            for (Li_4 = 1; Li_4 <= 3; Li_4++) {
               Li_132 = InternetOpenA(Ls_120, Li_128, "0", "0", 0);
               if (Li_132 != 0) break;
               Sleep(1000);
            }
            if (Li_132 != 0) {
               for (Li_4 = 1; Li_4 <= 3; Li_4++) {
                  Li_136 = InternetOpenUrlA(Li_132, Ls_112, "0", 0, -2080374528, 0);
                  if (Li_136 != 0) break;
                  Sleep(1000);
               }
               if (Li_136 != 0) {
                  Li_140 = InternetReadFile(Li_136, Ls_152, Li_144, Lia_148);
                  if (Li_140 != 0) {
                     Ls_16 = StringSubstr(Ls_152, 0, Lia_148[0]);
                     while (Lia_148[0] != 0) {
                        Li_140 = InternetReadFile(Li_136, Ls_152, Li_144, Lia_148);
                        if (Lia_148[0] == 0) break;
                        Ls_16 = Ls_16 + StringSubstr(Ls_152, 0, Lia_148[0]);
                        Li_12 += Lia_148[0];
                        while (true) {
                           Li_8 = -1;
                           for (Li_4 = 0; Li_4 < StringLen(Ls_16); Li_4++) {
                              Li_160 = StringGetChar(Ls_16, Li_4);
                              if (Li_160 == 10 || Li_160 == 13) {
                                 Li_8 = Li_4;
                                 break;
                              }
                           }
                           if (Li_8 < 0) break;
                           if (Li_8 > 0) {
                              Ls_24 = StringSubstr(Ls_16, 0, Li_8);
                              FileWrite(file_0, Ls_24);
                           }
                           Ls_16 = StringSubstr(Ls_16, Li_8 + 1);
                        }
                     }
                     if (StringLen(Ls_16) > 0) FileWrite(file_0, Ls_16);
                     Ls_16 = "";
                  }
                  InternetCloseHandle(Li_136);
               }
               InternetCloseHandle(Li_132);
            }
            FileClose(file_0);
         }
         if (Li_12 <= 10) {
            Alert("Can\'t download " + name_104 + ". News Filter was turned OFF");
            if (IsTesting()) Print("Can\'t download " + name_104 + ". News Filter was turned OFF");
            Sleep(5000);
         } else Print("Downloaded " + DoubleToStr(Li_12, 0) + " bytes (" + name_104 + ")");
      }
      G_index_472 = 0;
      for (Li_4 = 1; Li_4 <= 3; Li_4++) {
         file_0 = FileOpen(name_104, FILE_CSV|FILE_READ, ';');
         if (file_0 >= 0) break;
         Sleep(1000);
      }
      if (file_0 < 0) {
         Alert("Can\'t open " + name_104 + ". Error code: ", GetLastError());
         if (IsTesting()) Print("Can\'t open " + name_104 + ". Error code: ", GetLastError());
         Sleep(5000);
      } else {
         while (!FileIsEnding(file_0)) {
            for (Ls_36 = FileReadString(file_0); !FileIsEnding(file_0); Ls_36 = FileReadString(file_0))
               if (StringLen(Ls_36) == 10 && StringFind(Ls_36, ".") == 4) break;
            Ls_44 = FileReadString(file_0);
            if (StringLen(Ls_44) != 5 || StringFind(Ls_44, ":") != 2) continue;
            Ls_52 = FileReadString(file_0);
            Ls_60 = FileReadString(file_0);
            Ls_68 = FileReadString(file_0);
            Ls_76 = FileReadString(file_0);
            Ls_84 = FileReadString(file_0);
            Ls_92 = FileReadString(file_0);
            if (StringLen(Ls_36) > 0 && StringLen(Ls_44) > 0) {
               Li_100 = StrToTime(Ls_36 + " " + Ls_44) + 3600 * f0_8();
               if (Li_100 >= TimeCurrent() - 86400 && Li_100 <= TimeCurrent() + 86400 && StringFind(Symbol(), Ls_52) >= 0 && Ls_68 == "3" || (Ls_68 == "2" && Include_Medium_News)) {
                  G_index_472++;
                  Gia_476[G_index_472] = Li_100;
                  Gsa_480[G_index_472] = Ls_52;
                  Gsa_484[G_index_472] = Ls_60;
               }
            }
         }
         FileClose(file_0);
      }
   }
   for (Li_4 = 1; Li_4 <= G_index_472; Li_4++) {
      if (Gia_476[Li_4] >= TimeCurrent() && Gia_476[Li_4] <= TimeCurrent() + 86400 && TimeDay(Gia_476[Li_4]) == TimeDay(TimeCurrent())) {
         Gs_428 = TimeToStr(Gia_476[Li_4], TIME_MINUTES) + " " + Gsa_480[Li_4] + " News - " + Gsa_484[Li_4];
         break;
      }
   }
   if (StringLen(Gs_428) > 33) Gs_428 = StringSubstr(Gs_428, 0, 30) + "...";
}
		 	   	  				    		 		  	 		 	   	 				 	 	  		  			    	   					  	  					 		 	 	 		  	 	     	    	 	 	      	    	 			   	    		 				        
int f0_6() {
   bool Li_ret_0 = TRUE;
   if (Avoid_News) {
      Gs_436 = "";
      for (int Li_4 = 1; Li_4 <= G_index_472; Li_4++) {
         if ((Gia_476[Li_4] < TimeCurrent() && Gia_476[Li_4] + 60 * Wait_After_News >= TimeCurrent()) || (Gia_476[Li_4] >= TimeCurrent() && Gia_476[Li_4] - 60 * Wait_Before_News <= TimeCurrent())) {
            Gs_436 = TimeToStr(Gia_476[Li_4], TIME_MINUTES) + " " + Gsa_480[Li_4] + " News - " + Gsa_484[Li_4];
            Li_ret_0 = FALSE;
            break;
         }
      }
   }
   return (Li_ret_0);
}
		     	  	 		    	  		  	  	 	   						 	    		  	 	    	 	 					 		  				  		 	 				  	 		    	  	 	 	 	 	    	  	 	 			 	 	    	  				  	     
int f0_5() {
   if (UseCustomPair) Gs_356 = StringSubstr(UseSettingsFrom, 0, 6);
   else Gs_356 = StringSubstr(Symbol(), 0, 6);
   int Li_ret_0 = 1;//SessionInit(AccountNumber(), IsTesting(), IsDemo(), WindowHandle(Symbol(), Period()), Gs_356);
   if (UseCustomPair && UseSettingsFrom == "")  Li_ret_0 = 0;
/*   if (Li_ret_0 == -8 && StringFind(",EURUSD,GBPUSD,USDCHF,USDJPY,USDCAD,", "," + Gs_356 + ",") >= 0) {
      Comment("\nUpdating settings (" + Gs_356 + ")...");
      Li_ret_0 = SessionDeinit(AccountNumber(), IsTesting(), IsDemo(), WindowHandle(Symbol(), Period()), Gs_356);
      Sleep(3000);
      Li_ret_0 = SessionInit(AccountNumber(), IsTesting(), IsDemo(), WindowHandle(Symbol(), Period()), Gs_356);
   } */
   if (UseCustomPair && UseSettingsFrom == "EURUSD")     {p1=75;p2=39;p3=5; p4=15; p5=1;p6=19;p7=-65; p8=11;p9=14;p10=1; p11=10;p12=-1;p13=-1;p14=0;p15=6;p16=14;p17=150;p18=18;p19=0;p20=0;p21=120;p22=26;}
   if (UseCustomPair && UseSettingsFrom == "EURUSD_new") {p1=75;p2=30;p3=5; p4=17; p5=1;p6=15;p7=0;   p8=11;p9=14;p10=3; p11=11;p12=-1;p13=-1;p14=0;p15=6;p16=14;p17=155;p18=18;p19=0;p20=0;p21=80; p22=30;} 
   if (UseCustomPair && UseSettingsFrom == "EUR33")      {p1=75;p2=42;p3=5; p4=42; p5=5;p6=14;p7=-5;  p8=10;p9=14;p10=5; p11=13;p12=-2;p13=-5;p14=1;p15=6;p16=14;p17=190;p18=5; p19=0;p20=0;p21=33; p22=30;}
   if (UseCustomPair && UseSettingsFrom == "GBPUSD")     {p1=75;p2=33;p3=6; p4=12; p5=1;p6=19;p7=-200;p8=12;p9=18;p10=2; p11=24;p12=-1;p13=-1;p14=0;p15=6;p16=14;p17=290;p18=12;p19=0;p20=0;p21=120;p22=50;}
   if (UseCustomPair && UseSettingsFrom == "GBPUSD_new") {p1=75;p2=34;p3=6; p4=12; p5=1;p6=19;p7=-30; p8=12;p9=13;p10=14;p11=23;p12=-1;p13=0; p14=0;p15=5;p16=14;p17=250;p18=11;p19=0;p20=0;p21=95; p22=50;}
   if (UseCustomPair && UseSettingsFrom == "GBP52")      {p1=75;p2=30;p3=6; p4=12; p5=2;p6=25;p7=-30; p8=12;p9=10;p10=4; p11=20;p12=-5;p13=0; p14=0;p15=5;p16=14;p17=240;p18=10;p19=0;p20=0;p21=52; p22=70;}
   if (UseCustomPair && UseSettingsFrom == "GBP52T")     {p1=75;p2=21;p3=6; p4=3;  p5=3;p6=33;p7=-25; p8=12;p9=13;p10=7; p11=20;p12=-3;p13=0; p14=0;p15=5;p16=14;p17=160;p18=12;p19=0;p20=0;p21=52; p22=40;}
   if (UseCustomPair && UseSettingsFrom == "GBP30")      {p1=75;p2=39;p3=6; p4=13; p5=2;p6=22;p7=-50; p8=22;p9=11;p10=0; p11=20;p12=-3;p13=0; p14=0;p15=5;p16=14;p17=240;p18=10;p19=0;p20=0;p21=30; p22=90;}
   if (UseCustomPair && UseSettingsFrom == "USDJPY")     {p1=85;p2=21;p3=5; p4=5;  p5=1;p6=27;p7=-80; p8=12;p9=13;p10=2; p11=14;p12=-1;p13=-2;p14=0;p15=0;p16=14;p17=2000;p18=12;p19=0;p20=0;p21=130;p22=27;}
   if (UseCustomPair && UseSettingsFrom == "USDJPY_new") {p1=85;p2=10;p3=3; p4=14; p5=1;p6=28;p7=-200;p8=12;p9=10;p10=13;p11=15;p12=-1;p13=-2;p14=1;p15=8;p16=36;p17=190;p18=12;p19=0;p20=0;p21=120;p22=65;}
   if (UseCustomPair && UseSettingsFrom == "USDCHF")     {p1=70;p2=25;p3=9; p4=8;  p5=5;p6=22;p7=-40; p8=12;p9=11;p10=0; p11=15;p12=-2;p13=-1;p14=0;p15=3;p16=14;p17=170;p18=14;p19=0;p20=0;p21=120;p22=17;}
   if (UseCustomPair && UseSettingsFrom == "USDCAD")     {p1=65;p2=15;p3=11;p4=5;  p5=1;p6=6; p7=-30; p8=16;p9=14;p10=2; p11=10;p12=-4;p13=-1;p14=0;p15=4;p16=14;p17=130;p18=12;p19=0;p20=0;p21=150;p22=14;}
   if (UseCustomPair && UseSettingsFrom == "AUDUSD")     {p1=75;p2=33;p3=2; p4=13; p5=2;p6=12;p7=-40; p8=18;p9=8; p10=1; p11=16;p12=-1;p13=-1;p14=0;p15=0;p16=14;p17=140;p18=18;p19=0;p20=0;p21=150;p22=70;}
   if (UseCustomPair && UseSettingsFrom == "NZDUSD")     {p1=45;p2=70;p3=2; p4=14; p5=2;p6=5; p7=-40; p8=15;p9=20;p10=10;p11=40;p12=-2;p13=-5;p14=0;p15=0;p16=14;p17=120;p18=18;p19=0;p20=0;p21=130;p22=50;}
   if (UseCustomPair && UseSettingsFrom == "EURUSD_last"){p1=75;p2=35;p3=5; p4=15; p5=1;p6=15;p7=0;   p8=11;p9=13;p10=2; p11=11;p12=-2;p13=0; p14=1;p15=6;p16=14;p17=155;p18=18;p19=0;p20=0;p21=85; p22=30;}
   
   if (StopLoss >= 0) p21 = StopLoss; if (TakeProfit >= 0) p22 = TakeProfit; if (SecureProfit >= 0) p10 = SecureProfit; if (SecureProfitTriger >= 0) p11 = SecureProfitTriger;
   if (!UseCustomPair ) {
      p1 = iMA_Period;
      p2 = iMA_Filter_Open_b;
      p3 = iWPR_Filter_OpenSignal_b;
      p4 = iMA_Filter_Open_a;
      p5 = iWPR_Filter_OpenSignal_a;
      p6 = iWPR_Filter_Close;
      p7 = MaxLossPoints;
      p8 = iWPR_Period;
      p9 = Price_Filter_Close;
      p10 = SecureProfit_;         
      p11 = SecureProfitTriger_;   
      p12 = iWPR_Filter_Open_unknown; 
      p13 = iWPR_Filter_Close_unknown; 
      p14 = iWPR_Close_Period;
      p15 = FilterATR;
      p16 = iATR_Period;
      p17 = iCCI_OpenFilter;
      p18 = iCCI_Period;
      p19 = Unknown_1;
      p20 = Unknown_2;
      p21 = StopLoss_;             
      p22 = TakeProfit_; 
   }
   return (Li_ret_0);
}
		  	     	  	 	  	 				 	    		  		 		  	  	 	   	    	 	 				 		 	    			 					 		 	 		 			  		  			   	 		  		  			  		 			 	  	 			 	  		  	 
int f0_7() {
   int Li_ret_0;
   if (UseCustomPair) Li_ret_0 = 1;//SessionDeinit(AccountNumber(), IsTesting(), IsDemo(), WindowHandle(Symbol(), Period()), StringSubstr(UseSettingsFrom, 0, 6));
   else Li_ret_0 = 1;//SessionDeinit(AccountNumber(), IsTesting(), IsDemo(), WindowHandle(Symbol(), Period()), StringSubstr(Symbol(), 0, 6));
   return (Li_ret_0);
}
	  	 	   				  	 			  		   					 		 	 	    	 		  					 	      	 	   		  	 		  					 	  				  	 			           	 			      	      	 			  	 		   	 	 
int f0_10(double Ad_0, double Ad_8, double Ad_16, double Ad_24, double Ad_32) {
   bool Li_40 = FALSE;
//   Li_40 = CheckCloseLong(Gi_352, Ad_0, Ad_8, Ad_16, Ad_24, Ad_32, p7, Bid, Ask, Gd_412);
   if ((-p6 < Ad_8 && p13 * Gd_412 + Ad_16 < Bid && p7 * Gd_412 < Bid - Ad_0)
     || (Bid - Ad_0 > p9 * Gd_412 && p14 * Gd_412 + Ad_32 < Ad_24)) Li_40 = TRUE;
   return (Li_40);
}

int f0_11(double Ad_0, double Ad_8, double Ad_16, double Ad_24, double Ad_32) {
   bool Li_40 = FALSE;
//   Li_40 = CheckCloseShort(Gi_352, Ad_0, Ad_8, Ad_16, Ad_24, Ad_32, p7, Bid, Ask, Gd_412);
   if ((p6 - 100 > Ad_8 && (Ad_16 - p13 * Gd_412) > Bid && p7 * Gd_412 < Ad_0 - Ask)
     || (Ad_0 - Ask > p9 * Gd_412 && Ad_32 - p14 * Gd_412 > Ad_24)) Li_40 = TRUE;
   return (Li_40);
}

int f0_9(double Ad_0, double Ad_8, double Ad_16, double Ad_24) {
   bool Li_32 = FALSE;
//   Li_32 = CheckOpenLong(Gi_352, Ad_0, Ad_8, Ad_16, Ad_24, p17, Bid, Ask, Gd_412);
   if (p2 * Gd_412 + Ad_8 >= Ad_0 || ((p3 - 100) <= Ad_16 && -p17 <= Ad_24) || Ad_0 - p12 * Gd_412 <= Bid) {
   if ( p4 * Gd_412 + Ad_8 < Ad_0 && (p5 - 100) > Ad_16 && Ad_0 - p12 * Gd_412 > Bid )Li_32 = TRUE;}
   else Li_32 = TRUE;
   return (Li_32);
}

int f0_4(double Ad_0, double Ad_8, double Ad_16, double Ad_24) {
   bool Li_32 = FALSE;
//   Li_32 = CheckOpenShort(Gi_352, Ad_0, Ad_8, Ad_16, Ad_24, p17, Bid, Ask, Gd_412);
   if (Ad_8 - p2 * Gd_412 <= Ad_0 ||( -p3 >= Ad_16 && Ad_24 <= p17) || p12 * Gd_412 + Ad_0 >= Bid) {
   if ( Ad_8 - p4 * Gd_412 > Ad_0 && -p5 < Ad_16 && p12 * Gd_412 + Ad_0 < Bid )Li_32 = TRUE;}
   else Li_32 = TRUE; 
   return (Li_32);
}