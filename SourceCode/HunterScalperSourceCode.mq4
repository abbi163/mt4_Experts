//+-------------------------------------------------------------------------------------------------------------+
// VAMPIRE 1.0 EXPERT ADVISER FOR MT4                                                                           |
//+-------------------------------------------------------------------------------------------------------------+

#property  copyright "Copyright 2022，Abhijeet Anand"
#property version    " 100.000 "
#property strict
#property description " Property of Abhijeet Anand, Company: Alpha Return, Product: Vampire 1.0 "


//+-------------------------------------------------------------------------------------------------------------+
// EXTERNAL IMPORTS                                                                                             |
//+-------------------------------------------------------------------------------------------------------------+
// NOTE: "#include <stdlib.mqh>" can also do the job, however we just need a subpart of the module <stdlib.mqh> |
//       We need ErrorDescription part from <stdlib.ex4> so we import only subpart and close with import. The   |
//       reason for importing just a subpart is to save time while running the program by importing less codes. |
//+-------------------------------------------------------------------------------------------------------------+

#import   "stdlib.ex4"
   string ErrorDescription( int errorCode);
#import  
 
 
//+-------------------------------------------------------------------------------------------------------------+
// INPUT PARAMETERS : INPUT PARAMETER EXPLANATION                                                               |
//+-------------------------------------------------------------------------------------------------------------+
// 1. MaxSpread     : Maximum Spread allowed where Spread is Bid - Ask                                          |
// 2. MaxSlippage   : Maximum Slippage in the Price                                                             |                                                 |
// 3. UseRisk       : If true, then lot size will be dynamic based on the risk else fixed lot size              |
// 4. Lots          : Fixed lot size for each trade if UseRisk is false                                         |
// 5. MaxRisk       : Maximum Risk allowed in % . Lot size will be calculated factoring gStopLoss and UseRisk   |
//+-------------------------------------------------------------------------------------------------------------+

// INPUT PARAMETERS 

extern double MaxSpread=4 ;   
extern double MaxSlippage=1 ;    
extern bool UseRisk=true ;
extern double Lots=0.01 ;      
extern double MaxRisk = 2 ;

//+------------------------------------------------------------------------------------------------------------------------------+
// GLOBAL VARIABLES  : GLOBAL VARIABLE DESCRIPTION                                                                               |
//+------------------------------------------------------------------------------------------------------------------------------+
// gOrderSendComment : Comment that will be printed on each automated trade traken !!                                            |
// gMaxAllowedRisk   : Maximum risk in % allowed to be taken per trade !!                                                        |
// gDecimalDigits    : Number of Decimal Digits, eg. ASK_EURUSD = 1.10115, here gDecimalDigits = 5                               |
// gHourStart        : Time in hour from when trade will open                                                                    |
// gHourEnd          : Time in hour until when trade will open                                                                   |
// gStopLoss         : Stop loss in pips for any open trade                                                                      |
// gTakeProfit       : Take profit in pips for any open trade                                                                    |
//+------------------------------------------------------------------------------------------------------------------------------+

// GLOBAL VARIABLES STARTING WITH PREFIX "g"

string    gOrderSendComment = "Alpha Return, Vampire 1.0" ;
double    gMaxAllowedRisk = 1.0;
int       gDecimalDigits = 4;
double    gThresholdATR = 1.0;
int       gHourStart=23 ;    
int       gHourEnd=1 ;
int       gStopLoss=30  ;    
int       gTakeProfit=60  ;


// init function !!

int init()
    {
        gDecimalDigits = Digits() ;
        gMaxAllowedRisk = MaxRisk ;
        HideTestIndicators(true); 
        Comment(""); 
        return(0); 
    }

//init <<==--------   --------

int start()
    {
    
     int        lin_in_1;
     int        lin_in_2;
     int        lin_in_3;
     int        lin_in_4;
     
     if ( Bars <  10 )
         {
             Comment("Not enough bars"); 
             return(0); 
         }
     
     if ((gDecimalDigits == 3 || gDecimalDigits == 5))
         {
             gThresholdATR = 10.0 ;
         }
        
    if (!(Ask>=iBands(NULL,0,20,2.0,0,4,2,0)) && !(iATR(NULL,0,14,0)>= gThresholdATR * 15.0 * Point()))
        {
            TimeMinute(TimeCurrent()); 
            
            if (((gHourStart < gHourEnd && TimeHour(TimeCurrent()) >= gHourStart && TimeHour(TimeCurrent()) < gHourEnd ) || (gHourStart > gHourEnd && (TimeHour(TimeCurrent()) < gHourEnd || TimeHour(TimeCurrent()) >= gHourStart)) ) )
                {
                    lin_in_1 = 0;
                
                    for (lin_in_2 = OrdersTotal() - 1 ; lin_in_2 >= 0 ; lin_in_2 = lin_in_2 - 1)
                        {
                            if (OrderSelect(lin_in_2,SELECT_BY_POS,MODE_TRADES))
                                 {
                                     if (OrderSymbol() == Symbol() && OrderMagicNumber() == 1 )
                                          {
                                              lin_in_1 = lin_in_1 + 1;
                                          }
                                 }
                            else
                                 {
                                     Print("OrderSend() error - ", ErrorDescription(GetLastError())); 
                                 }
                        }
                    
                    if (lin_in_1 <  1)
                        {
                            if (UseRisk == false)
                                {
                                     FixedLotBuyOrder(); 
                                }
                            if ( UseRisk == true )
                                 {
                                     DynamicLotBuyOrder(); 
                                 }
                        }
                }
        }
        
        
    if ( !(Bid<=iBands(NULL,0,20,2.0,0,4,1,0)) && !(iATR(NULL,0,14,0)>=gThresholdATR * 15.0 * Point()) )
        {
            TimeMinute(TimeCurrent()); 
            if ( ( ( gHourStart <  gHourEnd && TimeHour(TimeCurrent()) >= gHourStart && TimeHour(TimeCurrent()) < gHourEnd ) || (gHourStart >  gHourEnd && (TimeHour(TimeCurrent()) < gHourEnd || TimeHour(TimeCurrent()) >= gHourStart)) ) )
                {
                    lin_in_3 = 0;
                    for (lin_in_4 = OrdersTotal() - 1 ; lin_in_4 >= 0 ; lin_in_4 = lin_in_4 - 1)
                        {
                            if ( OrderSelect(lin_in_4,SELECT_BY_POS,MODE_TRADES) )
                                 {
                                     if ( OrderSymbol() == Symbol() && OrderMagicNumber() == 2 )
                                        {
                                            lin_in_3 = lin_in_3 + 1;
                                        }
                                 }
                            else
                                {
                                     Print("OrderSend() error - ",ErrorDescription(GetLastError())); 
                                }
                        }
                    
                    if (lin_in_3 < 1)
                    {
                        if ( UseRisk == false )
                            {
                                FixedLotSellOrder(); 
                            }
                        if (UseRisk == true)
                            {
                                DynamicLotSellOrder(); 
                            }
                    }
                }
        }
        
        
        lizong_7(); 
        lizong_8(); 
        return(0); 
    }
    //start <<==--------   --------
    
int deinit()
    {
        return(0); 
    }
//deinit <<==--------   --------

void lizong_7()
 {
  //+------------------------------------------------------------------------------------------------------------------------------+
  // OrderInfoArray is such that OrderInfoArray[OrderIndex][0] -> OrderOpenTime() & OrderInfoArray[OrderIndex][1] -> OrderTicket() |
  // OrderCount implies Total market and pending order count                                                                       |
  // Index implies the index of Open or Pending order, however it's dynamic and change as any Open or Pending orders get closed    |
  // OrderIndex implies the index of the Open or Pending order !!                                                                  |
     
  // TODO: EXPLAIN WHAT THIS FUNCTION DOES !!
     
     
  //+------------------------------------------------------------------------------------------------------------------------------+
     
   
  // Assigning variable names 
     
  int       OrderInfoArray[30][2];
  int       OrderCount;
  int       Index; 
  int       OrderIndex;


 if (Ask >= iMA(NULL,0,20,0,MODE_SMA,PRICE_MEDIAN,0))
    {
    return;
    }
 if ( Ask - Bid<=MaxSpread * gThresholdATR * Point() )
    {
        OrderCount = OrdersTotal() ;
        Index = 0 ;
        for (OrderIndex = 0 ; OrderIndex < OrderCount ; OrderIndex = OrderIndex + 1)
            {
                if (( OrderSelect(OrderIndex,SELECT_BY_POS,MODE_TRADES) && (OrderType() != 1 || OrderSymbol() != Symbol() || OrderMagicNumber() != 2) ))   continue;
                OrderInfoArray[Index][0] = OrderOpenTime();
                OrderInfoArray[Index][1] = OrderTicket();
                Index = Index + 1;
            }
        if (Index > 1)
            {
                ArrayResize(OrderInfoArray,Index,0); 
                ArraySort(OrderInfoArray,0,0,1); 
            }
        for (OrderIndex = 0 ; OrderIndex < Index ; OrderIndex = OrderIndex + 1)
            {
                if ( OrderSelect(OrderInfoArray[OrderIndex][1],SELECT_BY_TICKET,MODE_TRADES) != true || OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),MaxSlippage,Red) != false )   continue;
                Print("OrderClose() error - ",ErrorDescription(GetLastError())); 
            }
    }
 }
 
 void lizong_8()
 {
  //+------------------------------------------------------------------------------------------------------------------------------+
  // OrderInfoArray is such that OrderInfoArray[OrderIndex][0] -> OrderOpenTime() & OrderInfoArray[OrderIndex][1] -> OrderTicket() |
  // OrderCount implies Total market and pending order count                                                                       |
  // Index implies the index of Open or Pending order, however it's dynamic and change as any Open or Pending orders get closed    |
  // OrderIndex implies the index of the Open or Pending order !!                                                                  |

     
  // TODO: EXPLAIN WHAT THIS FUNCTION DOES !!
     
     
  //+------------------------------------------------------------------------------------------------------------------------------+
     
   
  // Assigning variable names 
     
  int       OrderInfoArray[30][2];
  int       OrderCount;
  int       Index;
  int       OrderIndex;

 if (Bid<=iMA(NULL,0,20,0,MODE_SMA,PRICE_MEDIAN,0))
      {
          return;
      }
 if (Ask - Bid<=MaxSpread * gThresholdATR * Point())
      {
          OrderCount = OrdersTotal() ;
          Index = 0 ;
          for (OrderIndex = 0 ; OrderIndex < OrderCount ; OrderIndex = OrderIndex + 1)
               {
                   if ((OrderSelect(OrderIndex,SELECT_BY_POS,MODE_TRADES) && (OrderType() != 0 || OrderSymbol() != Symbol() || OrderMagicNumber() != 1))) continue;
                   OrderInfoArray[Index][0] = OrderOpenTime();
                   OrderInfoArray[Index][1] = OrderTicket();
                   Index = Index + 1;
               }
          if ( Index >  1 )
               {
                   ArrayResize(OrderInfoArray,Index,0); 
                   ArraySort(OrderInfoArray,0,0,1); 
               }
          for (OrderIndex = 0 ; OrderIndex < Index ; OrderIndex = OrderIndex + 1)
               {
                   if ( OrderSelect(OrderInfoArray[OrderIndex][1],SELECT_BY_TICKET,MODE_TRADES) != true || OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),MaxSlippage,Red) != false )  continue;
                   Print("OrderClose() error - ",ErrorDescription(GetLastError())); 
               }
       }
 }
 
 void DynamicLotBuyOrder()
 {
  double    zi_1_do;
  double    zi_2_do;
  double    zi_3_do;
  double    zi_4_do;
  double    zi_5_do;
  double    zi_6_do;
  int       zi_7_in;
  double    zi_8_do;
  double    zi_9_do;
  int       zi_10_in;
  bool      zi_11_bo;
//----- -----
 datetime   lin_da_1;
 datetime   lin_da_2;
 int        lin_in_3;

 lin_da_1 = TimeCurrent();
 lin_da_2 = 0;
 if ( OrdersHistoryTotal() >  0 )
  {
  for (lin_in_3 = OrdersHistoryTotal() - 1 ; lin_in_3 >= 0 ; lin_in_3=lin_in_3 - 1)
   {
   if ( OrderSelect(lin_in_3,SELECT_BY_POS,MODE_HISTORY) == true && OrderSymbol() == Symbol() && ( OrderMagicNumber() == 1 || OrderMagicNumber() == 2 ) )
    {
    if ( !(OrderProfit()<0.0) )   break;
    lin_da_2 = OrderCloseTime();
    break;
    }
   }
  }
 else
  {
  lin_da_2 = -3600;
  }
 if ( lin_da_1 < lin_da_2 + 3600 || Ask - Bid>MaxSpread * gThresholdATR * Point() )   return;
 zi_1_do = MarketInfo(Symbol(),15) ;
 zi_2_do = 1000.0 ;
 zi_3_do = AccountFreeMargin() / 100.0 * gMaxAllowedRisk ;
 if ( gStopLoss == 0 )
  {
  Print("OrderSend() error - gStopLoss can not be zero"); 
  }
 zi_4_do = zi_3_do / gStopLoss / gThresholdATR ;
 zi_5_do = 0.001 ;
 zi_6_do = MarketInfo(Symbol(),23) ;
 zi_7_in = 0 ;
 while (zi_6_do<1.0)
  {
  zi_6_do = zi_6_do * MathPow(10.0,zi_7_in) ;
  zi_7_in = zi_7_in + 1;
  }
 zi_5_do = NormalizeDouble(zi_4_do,zi_7_in - 1) ;
 if ( zi_5_do<MarketInfo(Symbol(),23) )
  {
  zi_5_do = MarketInfo(Symbol(),23) ;
  }
 if ( zi_5_do>MarketInfo(Symbol(),25) )
  {
  zi_5_do = MarketInfo(Symbol(),25) ;
  }
 zi_8_do = Ask - gStopLoss * gThresholdATR * Point() ;
 if ( gStopLoss == 0 )
  {
  zi_8_do = 0.0 ;
  }
 zi_9_do = gTakeProfit * gThresholdATR * Point() + Ask ;
 if ( gTakeProfit == 0 )
  {
  zi_9_do = 0.0 ;
  }
 zi_10_in = -1 ;
 zi_10_in = OrderSend(Symbol(),OP_BUY,zi_5_do,Ask,MaxSlippage,0.0,0.0,gOrderSendComment,1,0,Blue) ;
 if ( zi_10_in >  -1 )
  {
  if ( OrderSelect(zi_10_in,SELECT_BY_TICKET,MODE_TRADES) )
   {
   zi_11_bo = OrderModify(OrderTicket(),OrderOpenPrice(),zi_8_do,zi_9_do,0,Blue) ;
   }
  if ( zi_11_bo != false )   return;
  Print("OrderModify() error - ",ErrorDescription(GetLastError())); 
  return;
  }
 Print("OrderSend() error - ",ErrorDescription(GetLastError())); 
 }
//DynamicLotBuyOrder <<==--------   --------

void DynamicLotSellOrder()
 {
  double    zi_1_do;
  double    zi_2_do;
  double    zi_3_do;
  double    zi_4_do;
  double    zi_5_do;
  double    zi_6_do;
  int       zi_7_in;
  double    zi_8_do;
  double    zi_9_do;
  int       zi_10_in;
  bool      zi_11_bo;
//----- -----
 datetime   lin_da_1;
 datetime   lin_da_2;
 int        lin_in_3;

 lin_da_1 = TimeCurrent();
 lin_da_2 = 0;
 if (OrdersHistoryTotal() > 0)
  {
  for (lin_in_3 = OrdersHistoryTotal() - 1 ; lin_in_3 >= 0 ; lin_in_3=lin_in_3 - 1)
   {
   if ( OrderSelect(lin_in_3,SELECT_BY_POS,MODE_HISTORY) == true && OrderSymbol() == Symbol() && ( OrderMagicNumber() == 1 || OrderMagicNumber() == 2 ) )
    {
    if ( !(OrderProfit()<0.0) )   break;
    lin_da_2 = OrderCloseTime();
    break;
    }
   }
  }
 else
  {
  lin_da_2 = -3600;
  }
 if ( lin_da_1 < lin_da_2 + 3600 || Ask - Bid>MaxSpread * gThresholdATR * Point() )  return;
 zi_1_do = MarketInfo(Symbol(),15) ;
 zi_2_do = 1000.0 ;
 zi_3_do = AccountFreeMargin() / 100.0 * gMaxAllowedRisk ;
 if ( gStopLoss == 0 )
  {
  Print("OrderSend() error - gStopLoss can not be zero"); 
  }
 zi_4_do = zi_3_do / gStopLoss / gThresholdATR ;
 zi_5_do = 0.001 ;
 zi_6_do = MarketInfo(Symbol(),23) ;
 zi_7_in = 0 ;
 while (zi_6_do<1.0)
  {
  zi_6_do = zi_6_do * MathPow(10.0,zi_7_in) ;
  zi_7_in = zi_7_in + 1;
  }
 zi_5_do = NormalizeDouble(zi_4_do,zi_7_in - 1) ;
 if ( zi_5_do<MarketInfo(Symbol(),23) )
  {
  zi_5_do = MarketInfo(Symbol(),23) ;
  }
 if ( zi_5_do>MarketInfo(Symbol(),25) )
  {
  zi_5_do = MarketInfo(Symbol(),25) ;
  }
 zi_8_do = gStopLoss * gThresholdATR * Point() + Bid ;
 if ( gStopLoss == 0 )
  {
  zi_8_do = 0.0 ;
  }
 zi_9_do = Bid - gTakeProfit * gThresholdATR * Point() ;
 if ( gTakeProfit == 0 )
  {
  zi_9_do = 0.0 ;
  }
 zi_10_in = -1 ;
 zi_10_in = OrderSend(Symbol(),OP_SELL,zi_5_do,Bid,MaxSlippage,0.0,0.0,gOrderSendComment,2,0,Red) ;
 if ( zi_10_in >  -1 )
  {
  if ( OrderSelect(zi_10_in,SELECT_BY_TICKET,MODE_TRADES) )
   {
   zi_11_bo = OrderModify(OrderTicket(),OrderOpenPrice(),zi_8_do,zi_9_do,0,Red) ;
   }
  if ( zi_11_bo != false )   return;
  Print("OrderModify() error - ",ErrorDescription(GetLastError())); 
  return;
  }
 Print("OrderSend() error - ",ErrorDescription(GetLastError())); 
 }
//DynamicLotSellOrder <<==--------   --------

void FixedLotBuyOrder()
 {
  double    zi_1_do;
  double    zi_2_do;
  int       zi_3_in;
  bool      zi_4_bo;
//----- -----
 datetime   lin_da_1;
 datetime   lin_da_2;
 int        lin_in_3;

 lin_da_1 = TimeCurrent();
 lin_da_2 = 0;
 if ( OrdersHistoryTotal() >  0 )
  {
  for (lin_in_3 = OrdersHistoryTotal() - 1 ; lin_in_3 >= 0 ; lin_in_3=lin_in_3 - 1)
   {
   if ( OrderSelect(lin_in_3,SELECT_BY_POS,MODE_HISTORY) == true && OrderSymbol() == Symbol() && ( OrderMagicNumber() == 1 || OrderMagicNumber() == 2 ) )
    {
    if ( !(OrderProfit()<0.0) )   break;
    lin_da_2 = OrderCloseTime();
    break;
    }
   }
  }
 else
  {
  lin_da_2 = -3600;
  }
 if ( lin_da_1 < lin_da_2 + 3600 || Ask - Bid>MaxSpread * gThresholdATR * Point() )   return;
 zi_1_do = Ask - gStopLoss * gThresholdATR * Point() ;
 if ( gStopLoss == 0 )
  {
  zi_1_do = 0.0 ;
  }
 zi_2_do = gTakeProfit * gThresholdATR * Point() + Ask ;
 if ( gTakeProfit == 0 )
  {
  zi_2_do = 0.0 ;
  }
 zi_3_in = -1 ;
 zi_3_in = OrderSend(Symbol(),OP_BUY,Lots,Ask,MaxSlippage,0.0,0.0,gOrderSendComment,1,0,Blue) ;
 if ( zi_3_in >  -1 )
  {
  if ( OrderSelect(zi_3_in,SELECT_BY_TICKET,MODE_TRADES) )
   {
   zi_4_bo = OrderModify(OrderTicket(),OrderOpenPrice(),zi_1_do,zi_2_do,0,Blue) ;
   }
  if ( zi_4_bo != false )   return;
  Print("OrderModify() error - ",ErrorDescription(GetLastError())); 
  return;
  }
 Print("OrderSend() error - ",ErrorDescription(GetLastError())); 
 }
//FixedLotBuyOrder <<==--------   --------

void FixedLotSellOrder()
 {
  double    zi_1_do;
  double    zi_2_do;
  int       zi_3_in;
  bool      zi_4_bo;
//----- -----
 datetime   lin_da_1;
 datetime   lin_da_2;
 int        lin_in_3;

 lin_da_1 = TimeCurrent();
 lin_da_2 = 0;
 if ( OrdersHistoryTotal() >  0 )
  {
  for (lin_in_3 = OrdersHistoryTotal() - 1 ; lin_in_3 >= 0 ; lin_in_3=lin_in_3 - 1)
   {
   if ( OrderSelect(lin_in_3,SELECT_BY_POS,MODE_HISTORY) == true && OrderSymbol() == Symbol() && ( OrderMagicNumber() == 1 || OrderMagicNumber() == 2 ) )
    {
    if ( !(OrderProfit()<0.0) )   break;
    lin_da_2 = OrderCloseTime();
    break;
    }
   }
  }
 else
  {
  lin_da_2 = -3600;
  }
 if ( lin_da_1 < lin_da_2 + 3600 || Ask - Bid>MaxSpread * gThresholdATR * Point() )   return;
 zi_1_do = gStopLoss * gThresholdATR * Point() + Bid ;
 if ( gStopLoss == 0 )
  {
  zi_1_do = 0.0 ;
  }
 zi_2_do = Bid - gTakeProfit * gThresholdATR * Point() ;
 if ( gTakeProfit == 0 )
  {
  zi_2_do = 0.0 ;
  }
 zi_3_in = -1 ;
 zi_3_in = OrderSend(Symbol(),OP_SELL,Lots,Bid,MaxSlippage,0.0,0.0,gOrderSendComment,2,0,Red) ;
 if ( zi_3_in >  -1 )
  {
  if ( OrderSelect(zi_3_in,SELECT_BY_TICKET,MODE_TRADES) )
   {
   zi_4_bo = OrderModify(OrderTicket(),OrderOpenPrice(),zi_1_do,zi_2_do,0,Red) ;
   }
  if ( zi_4_bo != false )   return;
  Print("OrderModify() error - ",ErrorDescription(GetLastError())); 
  return;
  }
 Print("OrderSend() error - ",ErrorDescription(GetLastError())); 
 }
//<<==FixedLotSellOrder <<==