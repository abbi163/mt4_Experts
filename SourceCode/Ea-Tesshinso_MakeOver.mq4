//+------------------------------------------------------------------+
//|                                        Ea-Tesshinso_MakeOver.mq4 |
//|                                                   Anand Abhijeet |
//|                                https://www.mql5.com/en/code/9827 |
//+------------------------------------------------------------------+
#property copyright "Anand Abhijeet"
#property link      "https://www.mql5.com/en/code/9827"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Expert include function                                          |
//+------------------------------------------------------------------+

// TODO: Check Exactly which error is occuring and just use that error. 
#include <stderror.mqh>
#include <stdlib.mqh>

//+------------------------------------------------------------------+
//| Expert input function                                            |
//+------------------------------------------------------------------+
int Slippage=3;
input string Ordercomment="EA Tesshinso";
input int MagicID=12345678;
input double LOTS=0.01;
input int risk=40;//risk: 0-->fixed lots
input double SL=50;
input double TP=100;
extern bool Trailing = true;
extern double TrailingExtra = 50.0;

//+------------------------------------------------------------------+
//| global parameters                                                |
//+------------------------------------------------------------------+

double data[][2];
int BytesToRead;
string    datapath;
string    result;
double g_Point;
int    ticket=0;


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   g_Point=Point;
   if(Digits==5 || Digits==3)
     {
      g_Point *= 10;
      Slippage*=10;

     }
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {

   if(CheckMarketBuyOrders()<1 && CheckMarketSellOrders()<1)
   {  
   if(IsBuyPinbar())   
      {
      double BuySL=NormalizeDouble(Ask - SL*g_Point,Digits);
      double BuyTP=NormalizeDouble(Ask + TP*g_Point,Digits);
      if(AccountFreeMarginCheck(Symbol(),OP_BUY,GetLots())>0)
         {
         ticket=OrderSend(Symbol(),OP_BUY,GetLots(),Ask,Slippage,BuySL,BuyTP,"",MagicID,0,clrGreen);
         //MainOrders(0,Ask,BuyTP,BuySL);
         CloseSell();
         }
      }
   
   
   if(IsSellPinbar())
   {
      double SellSL=NormalizeDouble(Bid + SL*g_Point,Digits);
      double SellTP=NormalizeDouble(Bid - TP*g_Point,Digits);
      if(AccountFreeMarginCheck(Symbol(),OP_SELL,GetLots())>0)
         {
         ticket=OrderSend(Symbol(),OP_SELL,GetLots(),Bid,Slippage,SellSL,SellTP,"",MagicID,0,clrGreen);
         //MainOrders(1,Bid,SellTP,SellSL);
         CloseBuy();
         
         }
   }
   }
   return;
   
  }
  
 
//+------------------------------------------------------------------+
//| CheckMarketSellOrder function gets total Open Sell Order         |
//+------------------------------------------------------------------+
int CheckMarketSellOrders()
  {
   int _open=0;

   for(int i=OrdersTotal()-1; i>=0; i--)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      int status=OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderMagicNumber()!=MagicID)
         continue;
      if(OrderSymbol()==Symbol())
        {
         if(OrderType()==OP_SELL)
           {
            _open++;
           }
        }
     }
   return(_open);
  }
//+------------------------------------------------------------------+
//| CheckMarketSellOrder function gets total Open Sell Order         |
//+------------------------------------------------------------------+
int CheckMarketBuyOrders()
  {
   int _open=0;

   for(int i=OrdersTotal()-1; i>=0; i--)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      int status=OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderMagicNumber()!=MagicID)
         continue;
      if(OrderSymbol()==Symbol())
        {
         if(OrderType()==OP_BUY)
           {
            _open++;
           }
        }
     }
   return(_open);
  }  
//+------------------------------------------------------------------+
//| Function to Close Buy and Sell Order                             |
//+------------------------------------------------------------------+
void CloseBuy()
  {
  bool clo;
  while(CheckMarketBuyOrders()>0)
     {
      for(int i=OrdersTotal()-1; i>=0; i--)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
            if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicID)
               if(OrderType()==OP_BUY)
                  clo=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,clrAqua);
        }
     }
  }
//+------------------------------------------------------------------+
void CloseSell()
  {
   bool clo;
   while(CheckMarketSellOrders()>0)
     {
      for(int i=OrdersTotal()-1; i>=0; i--)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
            if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicID)
               if(OrderType()==OP_SELL)
                  clo=OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,clrAqua);

        }
     }
  }  
  
//+------------------------------------------------------------------+
//| User function Get Lot Size ()                                    |  
//+------------------------------------------------------------------+
double GetLots()
  {
   double lot;
   double minlot=MarketInfo(Symbol(),MODE_MINLOT);
   double maxlot=MarketInfo(Symbol(),MODE_MAXLOT);
   if(risk!=0)
     {
      lot=NormalizeDouble(AccountBalance()*risk/100/10000,2);
      if(lot<minlot)
         lot=minlot;
      if(lot>maxlot)
         lot=maxlot;
     }
   else
      lot=LOTS;
   return(lot);
  }
//+------------------------------------------------------------------+



  
//+------------------------------------------------------------------+
//| User function IsPinbar                                           |
//+------------------------------------------------------------------+
bool IsBuyPinbar()
  {
//start of declarations
   double actOp,actCl,actHi,actLo,preHi,preLo,preCl,preOp,actRange,preRange,actHigherPart,actHigherPart1;
   actOp=Open[1];
   actCl=Close[1];
   actHi=High[0];
   actLo=Low[1];
   preOp=Open[2];
   preCl=Close[2];
   preHi=High[2];
   preLo=Low[2];
//SetProxy(preHi,preLo,preOp,preCl);//Check proxy
   actRange=actHi-actLo;
   preRange=preHi-preLo;
   actHigherPart=actHi-actRange*0.4;//helping variable to not have too much counting in IF part
   actHigherPart1=actHi-actRange*0.4;//helping variable to not have too much counting in IF part
//end of declaratins
//start function body
   double dayRange=AveRange4();
   if((actCl>actHigherPart1&&actOp>actHigherPart)&&  //Close&Open of PB is in higher 1/3 of PB
      (actRange>dayRange*0.5)&& //PB is not too small
//(actHi<(preHi-preRange*0.3))&& //High of PB is NOT higher than 1/2 of previous Bar
      (actLo+actRange*0.25<preLo)) //Nose of the PB is at least 1/3 lower than previous bar
     {

      if(Low[ArrayMinimum(Low,3,3)]>Low[1])
         return (true);
     }
   return(false);

  }//------------END FUNCTION-------------


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsSellPinbar()
  {
//start of declarations
   double actOp,actCl,actHi,actLo,preHi,preLo,preCl,preOp,actRange,preRange,actLowerPart, actLowerPart1;
   actOp=Open[1];
   actCl=Close[1];
   actHi=High[1];
   actLo=Low[1];
   preOp=Open[2];
   preCl=Close[2];
   preHi=High[2];
   preLo=Low[2];
//SetProxy(preHi,preLo,preOp,preCl);//Check proxy
   actRange=actHi-actLo;
   preRange=preHi-preLo;
   actLowerPart=actLo+actRange*0.4;//helping variable to not have too much counting in IF part
   actLowerPart1=actLo+actRange*0.4;//helping variable to not have too much counting in IF part
//end of declaratins

//start function body

   double dayRange=AveRange4();
   if((actCl<actLowerPart1&&actOp<actLowerPart)&&  //Close&Open of PB is in higher 1/3 of PB
      (actRange>dayRange*0.5)&& //PB is not too small
//(actLo>(preLo+preRange/3.0))&& //Low of PB is NOT lower than 1/2 of previous Bar
      (actHi-actRange*0.25>preHi)) //Nose of the PB is at least 1/3 lower than previous bar

     {
      if(High[ArrayMaximum(High,3,3)]<High[1])
         return (true);
     }
   return false;
  }//------------END FUNCTION-------------
  
  
//+------------------------------------------------------------------+
//| User function AveRange4                                          |
//+------------------------------------------------------------------+
double AveRange4()
  {
   double sum=0;
   double rangeSerie[4];

   int i=0;
   int ind=1;
   int startYear=1995;


   while(i<4)
     {
      //datetime pok=Time[pos+ind];
      if(TimeDayOfWeek(Time[ind])!=0)
        {
         sum+=High[ind]-Low[ind];//make summation
         i++;
        }
      ind++;
      //i++;
     } 
//Comment(sum/4.0);
   return (sum/4.0);//make average, don't count min and max, this is why I divide by 4 and not by 6


  }//------------END FUNCTION-------------
