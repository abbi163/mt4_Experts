//+------------------------------------------------------------------+
//|                                            HunterScalperFTMO.mq4 |
//|                                                   Anand Abhijeet |
//|                                https://www.mql5.com/en/code/9827 |
//+------------------------------------------------------------------+

//+-------------------------------------------------------------------------------------------------------------+
// VAMPIRE 1.0 EXPERT ADVISER FOR MT4                                                                           |
// Expert is similar to HunterScalper Scalper Source Code however,                                              |
// This Expert doesn't open trade on Friday night and Saturday                                                  |
// Check Function FridayTrade() for more details                                                                |
//+-------------------------------------------------------------------------------------------------------------+

#property  copyright "Copyright 2022，Abhijeet Anand"
#property version    "1.00"
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
        
    if (!(Ask>=iBands(NULL,0,20,2.0,0,4,2,0)) && !(iATR(NULL,0,14,0)>= gThresholdATR * 15.0 * Point()) && (FridayTrade()== false))
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
        
        
    if ( !(Bid<=iBands(NULL,0,20,2.0,0,4,1,0)) && !(iATR(NULL,0,14,0)>=gThresholdATR * 15.0 * Point())&& (FridayTrade()== false))
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
 if ( (Ask - Bid<=MaxSpread * gThresholdATR * Point()) && (FridayTrade()== false) )
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
 if ((Ask - Bid<=MaxSpread * gThresholdATR * Point()) && (FridayTrade()== false))
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


   double    sl;
   double    tp;
   int       ticket;
   int        order;
   bool      order_modify_res;
   datetime   current_time;
   datetime   order_close_time;

   
   current_time = TimeCurrent();
   order_close_time = 0;
   
   if ( OrdersHistoryTotal() >  0 )
   {
      for (order = OrdersHistoryTotal() - 1 ; order >= 0 ; order=order - 1)
      {
         if ( OrderSelect(order,SELECT_BY_POS,MODE_HISTORY) == true && OrderSymbol() == Symbol() && ( OrderMagicNumber() == 1 || OrderMagicNumber() == 2 ) )
         {
         if ( !(OrderProfit()<0.0) )   break;
         order_close_time = OrderCloseTime();
         break;
         }
      }
   }
   else
   {
   order_close_time = -3600;
   }
   if ( current_time < order_close_time + 3600 || Ask - Bid>MaxSpread * gThresholdATR * Point() )   return;
   if ( gStopLoss == 0 )
   {
   Print("OrderSend() error - gStopLoss can not be zero"); 
   }
   
   
   sl = Ask - gStopLoss * gThresholdATR * Point() ;
   if ( gStopLoss == 0 )
   {
   sl = 0.0 ;
   }
   tp = gTakeProfit * gThresholdATR * Point() + Ask ;
   if ( gTakeProfit == 0 )
   {
      tp = 0.0 ;
   }
   
   Lots = GetLots();
   ticket = -1 ;
   ticket = OrderSend(Symbol(),OP_BUY,Lots,Ask,MaxSlippage,0.0,0.0,gOrderSendComment,1,0,Blue) ;
   if ( ticket >  -1 )
   {
   if ( OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES) )
   {
   order_modify_res = OrderModify(OrderTicket(),OrderOpenPrice(),sl,tp,0,Blue) ;
   }
   if ( order_modify_res != false )   return;
   Print("OrderModify() error - ",ErrorDescription(GetLastError())); 
   return;
   }
   Print("OrderSend() error - ",ErrorDescription(GetLastError())); 
   }
   //DynamicLotBuyOrder <<==--------   --------

void DynamicLotSellOrder()
{  

   double    sl;
   double    tp;
   int        order ;
   int       ticket;
   bool      order_modify_res;
   datetime   current_time;
   datetime   order_close_time;

   
   current_time = TimeCurrent();
   order_close_time = 0;
   
   
   if (OrdersHistoryTotal() > 0)
   {
      for (order = OrdersHistoryTotal() - 1 ; order >= 0 ; order = order - 1)
      {
         if ( OrderSelect(order,SELECT_BY_POS,MODE_HISTORY) == true && OrderSymbol() == Symbol() && ( OrderMagicNumber() == 1 || OrderMagicNumber() == 2 ) )
          {
             if ( !(OrderProfit()<0.0) )   break;
             order_close_time = OrderCloseTime();
             break;
          }
      }
   }
   else
   {
      order_close_time = -3600;
   }
   if ( current_time < order_close_time + 3600 || Ask - Bid > MaxSpread * gThresholdATR * Point() )  return;
   
   if ( gStopLoss == 0 )
   {
      Print("OrderSend() error - gStopLoss can not be zero"); 
   }
   
   
   sl = gStopLoss * gThresholdATR * Point() + Bid ;
   if ( gStopLoss == 0 )
   {
      sl = 0.0 ;
   }
   tp = Bid - gTakeProfit * gThresholdATR * Point() ;
   if ( gTakeProfit == 0 )
   {
      tp = 0.0 ;
   }
   Lots = GetLots();
   ticket = -1 ;
   ticket = OrderSend(Symbol(),OP_SELL,Lots,Bid,MaxSlippage,0.0,0.0,gOrderSendComment,2,0,Red) ;
   if ( ticket >  -1 )
   {
      if ( OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES))
      {
         order_modify_res = OrderModify(OrderTicket(),OrderOpenPrice(),sl,tp,0,Red) ;
      }
      if ( order_modify_res != false ) return;
      Print("OrderModify() error - ",ErrorDescription(GetLastError())); 
      return;
   }
   Print("OrderSend() error - ",ErrorDescription(GetLastError())); 
}
//DynamicLotSellOrder <<==--------   --------



void FixedLotBuyOrder()
{
   // In this function we will create a fix lot size Buy Order. 
   
   double     sl;
   double     tp;
   int        ticket;
   int        order ;
   bool       order_modify_res;
   datetime   current_time;
   datetime   order_close_time;

   // Initialize the variables
   current_time = TimeCurrent();
   order_close_time = 0;
   
   if (OrdersHistoryTotal() > 0)
   {
      for (order = OrdersHistoryTotal() - 1 ; order >= 0 ; order = order - 1)
      {
         if (OrderSelect(order ,SELECT_BY_POS,MODE_HISTORY) == true && OrderSymbol() == Symbol() && (OrderMagicNumber() == 1 || OrderMagicNumber() == 2 ))
         {
            if (!(OrderProfit()<0.0)) break;
            order_close_time = OrderCloseTime();
            break;
         }
      }
   }
   
   else
   {
      order_close_time = -3600;
   }
   
   if ( current_time < order_close_time + 3600 || Ask - Bid>MaxSpread * gThresholdATR * Point()) return;
   sl = Ask - gStopLoss * gThresholdATR * Point() ;
   if ( gStopLoss == 0 )
   {
      sl = 0.0 ;
   }
   
   tp = gTakeProfit * gThresholdATR * Point() + Ask ;
   if ( gTakeProfit == 0 )
   {
      tp = 0.0 ;
   }
   
   ticket = -1 ;
   ticket = OrderSend(Symbol(),OP_BUY,Lots,Ask,MaxSlippage,0.0,0.0,gOrderSendComment,1,0,Blue) ;
   
   if ( ticket > -1 )
   {
      if ( OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES) )
      {
         order_modify_res = OrderModify(OrderTicket(),OrderOpenPrice(),sl,tp,0,Blue) ;
      }
      if ( order_modify_res != false )  return;
      Print("OrderModify() error - ",ErrorDescription(GetLastError())); 
      return;
   }
   Print("OrderSend() error - ",ErrorDescription(GetLastError())); 
}
//FixedLotBuyOrder <<==--------   --------

void FixedLotSellOrder()
{
   // In this function we will create a fix lot size sell order !!
   double    sl;
   double    tp;
   int       ticket;
   int        order ;
   bool      order_modify_res;
   datetime   current_time;
   datetime   order_close_time;
   
   
   current_time = TimeCurrent();
   order_close_time = 0;
   
   if ( OrdersHistoryTotal() > 0 )
   {
      for (order = OrdersHistoryTotal() - 1 ; order >= 0 ; order=order - 1)
      {
         if ( OrderSelect(order,SELECT_BY_POS,MODE_HISTORY) == true && OrderSymbol() == Symbol() && ( OrderMagicNumber() == 1 || OrderMagicNumber() == 2 ) )
         {
            if ( !(OrderProfit()<0.0) )   break;
            order_close_time = OrderCloseTime();
            break;
         }
      }
   }
   else
   {
      order_close_time = -3600;
   }
   if ( current_time < order_close_time + 3600 || Ask - Bid>MaxSpread * gThresholdATR * Point()) return;
   sl = gStopLoss * gThresholdATR * Point() + Bid ;
   if ( gStopLoss == 0 )
   {
      sl = 0.0 ;
   }
   tp = Bid - gTakeProfit * gThresholdATR * Point() ;
   if ( gTakeProfit == 0 )
   {
      tp = 0.0 ;
   }
   ticket = -1 ;
   ticket = OrderSend(Symbol(),OP_SELL,Lots,Bid,MaxSlippage,0.0,0.0,gOrderSendComment,2,0,Red) ;
   if ( ticket >  -1 )
   {
      if ( OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES) )
      {
         order_modify_res = OrderModify(OrderTicket(),OrderOpenPrice(),sl,tp,0,Red) ;
      }
      if ( order_modify_res != false ) return;
      Print("OrderModify() error - ",ErrorDescription(GetLastError())); 
      return;
   }
   Print("OrderSend() error - ",ErrorDescription(GetLastError())); 
}
//<<==FixedLotSellOrder <<==

double GetLots()
{
   // risk in base currency is total risk in the base currency!!
   // lots is the final lot size 
   // minlot is the minimum amount of lot allowed fot the symbol
   // lot_intermediate_value is the intermediated value before the final lot value
   // exponent is the exponent in the MathPow
   
   double    risk_base_currency;
   double    lots;
   double    minlot;
   double    lot_intermediate_value;
   int       exponent;
   
   risk_base_currency = AccountFreeMargin() / 100.0 * gMaxAllowedRisk ;
   lot_intermediate_value = risk_base_currency / gStopLoss / gThresholdATR ;
   lots = 0.001 ;
   minlot = MarketInfo(Symbol(),MODE_MINLOT) ;
   exponent = 0 ;
   while (minlot<1.0)
   {
      minlot = minlot * MathPow(10.0,exponent) ;
      exponent = exponent + 1;
   }
   lots = NormalizeDouble(lot_intermediate_value,exponent - 1) ;
   if ( lots < MarketInfo(Symbol(),MODE_MINLOT) )
   {
      lots = MarketInfo(Symbol(),MODE_MAXLOT) ;
   }
   if ( lots > MarketInfo(Symbol(),MODE_MAXLOT) )
   {
      lots = MarketInfo(Symbol(),MODE_MAXLOT) ;
   }
   return lots ;
}

// --- Function to select DayOfWeek and Hour 
// --- Can be used in FTMO mode 
bool FridayTrade()
   {
   //---------------------------------------------------
   // Only trade if FridayTrade() is false. 
   // FTMO() == true if it's friday and hour > 15 or it's saturday.
   // Since our trade is only open between hour 23 to 1, it's a safe bet
   
      if ((Hour()>=15 && DayOfWeek()==5)|| DayOfWeek()==6)
      {
         return true;
      } 
      else 
      {
         return false ;
      }  
   }
