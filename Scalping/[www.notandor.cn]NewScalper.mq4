//+------------------------------------------------------------------+
//|                                                  FZ EA TRALL.mq4 |
//|                                                     ForexZona.ru |
//|                                             https://ForexZona.ru |
//+------------------------------------------------------------------+
#property copyright "ForexZona.ru"
#property link      "https://ForexZona.ru"
#property version   "1.00"
#property description "Заходите на сайт ForexZona.ru" 
//+------------------------------------------------------------------+
input double    Risk             =1;           //Риск
extern double   MinProfit        =0.05;        //Множитель лота
input int       Dist             =20;          //Расстояние "трала" линий
input int       Step             =10;          //Минимальный шаг для второго и следуующих колен
extern double   UpLot            =1.2;         //Множитель лота
input color     BuyLine          =Blue;        //Цвет линии покупок
input color     SellLine         =Red;         //Цвет линии продаж
input int       Magic            =2017;        //Уникальный номер ордеров
//+------------------------------------------------------------------+
string comment ="ForexZona.ru";
int r, D;
double PricSellLine, PricBuyLine, NewLot, NewProfProc;
//+------------------------------------------------------------------+
int OnInit()
{
//---
D=1;
if (Digits==5 || Digits==3)D=10;
//---
HLineCreate("LineBuy",Ask+Dist*D*Point,BuyLine); 
HLineCreate("LineSell",Bid-Dist*D*Point,SellLine);  
//---
return(INIT_SUCCEEDED);}
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
ObjectsDeleteAll(0,OBJ_HLINE);
}
//+------------------------------------------------------------------+
void OnTick(){
//+------------------------------------------------------------------+
double Lot=0;
Lot=NormalizeDouble(AccountBalance()/100*Risk/(MarketInfo(Symbol(),MODE_TICKVALUE)*100*D),2);
if (Lot<MarketInfo(Symbol(),MODE_MINLOT))Lot=MarketInfo(Symbol(),MODE_MINLOT);
//+------------------------------------------------------------------+
//---Находим цены линий
for(int i=ObjectsTotal()-1;i>=0;i--)
{
PricBuyLine=ObjectGetDouble(0,"LineBuy",OBJPROP_PRICE);
PricSellLine=ObjectGetDouble(0,"LineSell",OBJPROP_PRICE);
}
//---Тралим линии     
if(Ask+Dist*D*Point<PricBuyLine)
{HLineMove("LineBuy",Ask+Dist*D*Point);}

if(Bid-Dist*D*Point>PricSellLine)
{HLineMove("LineSell",Bid-Dist*D*Point);}
//---Переносим линии если цена идет в плюс после последней
if(Ask<PricSellLine && Bid-Dist*D*Point>PricBuyLine)
{HLineMove("LineBuy",Ask+Dist*D*Point);}

if(Bid>PricBuyLine && Ask+Dist*D*Point<PricSellLine)
{HLineMove("LineSell",Bid-Dist*D*Point);}
//---Открываем ордера
if(Open[0]>Close[0] && Ask<=PricSellLine && LastType()!=OP_SELL && Count(-1)==0)
{r=OrderSend(Symbol(),OP_SELL,Lot,Bid,10,0,0,comment,Magic,0,Red);
 HLineMove("LineBuy",Ask+Dist*D*Point);}

if(Open[0]<Close[0] && Bid>=PricBuyLine && LastType()!=OP_BUY && Count(-1)==0)
{r=OrderSend(Symbol(),OP_BUY,Lot,Ask,10,0,0,comment,Magic,0,Green);
 HLineMove("LineSell",Bid-Dist*D*Point);}
//---Усреднение
NewLot=Lot*(MathPow(UpLot,Count(-1)));

if(Open[0]>Close[0] && Ask<=PricSellLine && Count(OP_SELL)>0 && Bid-Step*D*Point>SellPric())
{r=OrderSend(Symbol(),OP_SELL,NewLot,Bid,10,0,0,comment,Magic,0,Red);
 HLineMove("LineBuy",Ask+Dist*D*Point);}

if(Open[0]<Close[0] && Bid>=PricBuyLine && Count(OP_BUY)>0 && Ask+Step*D*Point<BuyPric())
{r=OrderSend(Symbol(),OP_BUY,NewLot,Ask,10,0,0,comment,Magic,0,Green);
 HLineMove("LineSell",Bid-Dist*D*Point);}
//---
NewProfProc=Profit(-1)/(AccountBalance()/100);
//+------------------------------------------------------------------+
if(Count(OP_BUY)>0 && Ask<=PricSellLine && NewProfProc>=MinProfit)
{{CloseMinus(-1); ClosePlus(-1);}}
   
if(Count(OP_SELL)>0 && Bid>=PricBuyLine && NewProfProc>=MinProfit)
{{CloseMinus(-1); ClosePlus(-1);}}
//+------------------------------------------------------------------+
Comment("" 
      + "\n"  
      + "FOREXZONA.RU           "
      + "\n"  
      + "____________________________           "
      + "\n" 
      + "\n"  
      + "Цена линии бай           "   + PricBuyLine 
      + "\n"  
      + "Цена линии селл          "   + PricSellLine 
      + "\n"  
      + "Баланс                        "   + DoubleToStr(AccountBalance(),2) 
      + "\n"  
      + "Средства                    "   + DoubleToStr(AccountEquity(),2)
      + "\n"  
      + "Тeкущая прибыль %    "   + DoubleToStr(NewProfProc, 2) 
      + "\n"       
      );
//+------------------------------------------------------------------+   
}
//+------------------------------------------------------------------+ 
//| Считаем общий профит                                             | 
//+------------------------------------------------------------------+    
double Profit(int type) 
{double Profit = 0;
   for (int cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
      if(OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES))
      {if (OrderSymbol()==Symbol() && (OrderType() == type || type==-1) && Magic==OrderMagicNumber()) Profit += OrderProfit()+OrderSwap()+OrderCommission();}}
return (Profit);} 
//+------------------------------------------------------------------+ 
//| Функция закрытия ордеров                                         |
//+------------------------------------------------------------------+
void ClosePlus(int ot)
{bool cl;
 for(int i=OrdersTotal()-1;i>=0;i--)
{if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
{if(OrderSymbol()==Symbol() && OrderMagicNumber()==Magic && OrderProfit()+OrderSwap()+OrderCommission()>0)
{if(OrderType()==0 && (ot==0 || ot==-1))
{RefreshRates();
 cl=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Bid,Digits),10,White);}
if(OrderType()==1 && (ot==1 || ot==-1))
{RefreshRates();
 cl=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Ask,Digits),10,White);}}}}}
 
void CloseMinus(int ot)
{bool cl;
 for(int i=OrdersTotal()-1;i>=0;i--)
{if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
{if(OrderSymbol()==Symbol() && OrderMagicNumber()==Magic && OrderProfit()+OrderSwap()+OrderCommission()<0)
{if(OrderType()==0 && (ot==0 || ot==-1))
{RefreshRates();
 cl=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Bid,Digits),10,White);}
if(OrderType()==1 && (ot==1 || ot==-1))
{RefreshRates();
 cl=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Ask,Digits),10,White);}}}}}
//+------------------------------------------------------------------+ 
//| Создает горизонтальную линию                                     | 
//+------------------------------------------------------------------+ 
bool HLineCreate(string name,double price,color clr)
{//--- если цена не задана, то установим ее на уровне текущей цены Bid 
if(!price) 
   price=SymbolInfoDouble(Symbol(),SYMBOL_BID); 
//--- сбросим значение ошибки 
   ResetLastError(); 
//--- создадим горизонтальную линию 
if(!ObjectCreate(0,name,OBJ_HLINE,0,0,price)) 
  {Print(__FUNCTION__,": не удалось создать горизонтальную линию! Код ошибки = ",GetLastError()); 
return(false);} 
//--- установим цвет линии 
   ObjectSetInteger(0,name,OBJPROP_COLOR,clr); 
//--- установим стиль отображения линии 
   ObjectSetInteger(0,name,OBJPROP_STYLE,STYLE_SOLID); 
//--- установим толщину линии 
   ObjectSetInteger(0,name,OBJPROP_WIDTH,1); 
//--- отобразим на переднем (false) или заднем (true) плане 
   ObjectSetInteger(0,name,OBJPROP_BACK,false); 
//--- включим (true) или отключим (false) режим перемещения линии мышью 
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,true); 
   ObjectSetInteger(0,name,OBJPROP_SELECTED,true); 
//--- скроем (true) или отобразим (false) имя графического объекта в списке объектов 
   ObjectSetInteger(0,name,OBJPROP_HIDDEN,false); 
//--- установим приоритет на получение события нажатия мыши на графике 
   ObjectSetInteger(0,name,OBJPROP_ZORDER,0); 
//--- успешное выполнение 
return(true);} 
//+------------------------------------------------------------------+ 
//| Перемещение горизонтальной линии                                 | 
//+------------------------------------------------------------------+ 
bool HLineMove(string name,double price)
{if(!price) 
      price=SymbolInfoDouble(Symbol(),SYMBOL_BID); 
//--- сбросим значение ошибки 
   ResetLastError(); 
//--- переместим горизонтальную линию 
if(!ObjectMove(0,name,0,0,price)) 
  {Print(__FUNCTION__,": не удалось переместить горизонтальную линию! Код ошибки = ",GetLastError()); 
return(false);} 
//--- успешное выполнение 
return(true);} 
//+------------------------------------------------------------------+ 
//| Определяем тип последнего ордера                                 | 
//+------------------------------------------------------------------+ 
int LastType()
{int type=-1;
datetime dt=0;
for(int i=OrdersHistoryTotal()-1;i>=0;i--)
 if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
  {if(Symbol()==OrderSymbol() && OrderMagicNumber()==Magic) 
   {if(OrderOpenTime()>dt)
   {dt=OrderOpenTime();
    type=OrderType();}}}
return(type);}
//+------------------------------------------------------------------+ 
//| Определяем цену последнего ордера бай                            | 
//+------------------------------------------------------------------+ 
double BuyPric() {
   double oldorderopenprice;
   int oldticketnumber;
   double unused = 0;
   int ticketnumber = 0;
   for (int cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
      bool clos=OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != Magic) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == Magic && OrderType() == OP_BUY) {
         oldticketnumber = OrderTicket();
         if (oldticketnumber > ticketnumber) {
            oldorderopenprice = OrderOpenPrice();
            unused = oldorderopenprice;
            ticketnumber = oldticketnumber;}}}
   return (oldorderopenprice);}
//+------------------------------------------------------------------+ 
//| Определяем цену последнего ордера селл                           | 
//+------------------------------------------------------------------+ 
double SellPric() {
   double oldorderopenprice;
   int oldticketnumber;
   double unused = 0;
   int ticketnumber = 0;
   for (int cnt = OrdersTotal() - 1; cnt >= 0; cnt--) {
      bool clos=OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != Magic) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == Magic && OrderType() == OP_SELL) {
         oldticketnumber = OrderTicket();
         if (oldticketnumber > ticketnumber) {
            oldorderopenprice = OrderOpenPrice();
            unused = oldorderopenprice;
            ticketnumber = oldticketnumber;}}}
   return (oldorderopenprice);}
//+------------------------------------------------------------------+ 
//| Считаем количество ордеров по типу                               | 
//+------------------------------------------------------------------+ 
int Count(int type)
{int count=0;
 for(int i=OrdersTotal()-1;i>=0;i--)
 if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
  {if(Symbol()==OrderSymbol() && Magic==OrderMagicNumber() && (type==-1 || OrderType()==type)) count++;}
   return(count);}
