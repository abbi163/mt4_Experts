#property copyright "Copyright 2019, Aleksandr Shurgin( Singh's )"
#property link "" 
#property strict
#property version "1.00"
enum manager {P=0, B=1,};

extern string T1 = "Singh's"; //Crack By 
extern bool Use_LOGO = true;
extern int Signal = 16; 
extern int Signal_Period = 2;
extern int Signal_2 = 47; 
extern int Signal_2_Period = 91;
extern int TakeProfit  = 147;
extern int StopLoss = 72;
extern int TrailingStart = 0;
extern int TrailingStop = 41; 
extern double FixedLot = 0.1;
extern bool Use_AutoMM= true;
extern double AutoMM = 7.0; 
extern int Max_Spread = 20;
extern int Slippage = 10;
extern int Magic = 56342; 
extern string Open_Comment = "Virtuoso"; 


int TradeDeviation = 3;  
int TradeDelta = 12;
int VelocityTime = 7;  
int DeleteRatio = 30;  
int TickSample = 100;
int TrailingLoss = 100; 
manager TradeManager = 0; 
int r, gmt, brokerOffset, size, digits, stoplevel;
double marginRequirement, maxLot, minLot, lotSize, points, currentSpread, avgSpread, maxSpread, initialBalance, rateChange, rateTrigger, deleteRatio, commissionPoints;

double spreadSize[]; 
double tick[];
double avgtick[];
int tickTime[];   

string testerStartDate, testerEndDate; 

int lastBuyOrder, lastSellOrder;

bool calculateCommission = true;

double max = 0;

int init() {   
   marginRequirement = MarketInfo( Symbol(), MODE_MARGINREQUIRED ) * 0.01;
   maxLot = ( double ) MarketInfo( Symbol(), MODE_MAXLOT );  
   minLot = ( double ) MarketInfo( Symbol(), MODE_MINLOT );  
   currentSpread = NormalizeDouble( Ask - Bid, Digits ); 
   stoplevel = ( int ) MathMax( MarketInfo( Symbol(), MODE_FREEZELEVEL ), MarketInfo( Symbol(), MODE_STOPLEVEL ) );
   if( stoplevel > TradeDelta ) TradeDelta = stoplevel;
   if( stoplevel > TrailingStop ) TrailingStop = stoplevel;
   avgSpread = currentSpread; 
   size = TickSample;
   ArrayResize( spreadSize, size ); 
   ArrayFill( spreadSize, 0, size, avgSpread );
   maxSpread = NormalizeDouble( Max_Spread * Point, Digits );
   deleteRatio = NormalizeDouble( ( double ) DeleteRatio / 100, 2 );
   rateTrigger = NormalizeDouble( ( double ) Signal_2_Period * Point, Digits );
   testerStartDate = StringConcatenate( Year(), "-", Month(), "-", Day() );
   initialBalance = AccountBalance();  
  
   return ( 0 );
}

void OnDeinit( const int reason ){ 
 
} 

void commission(){ 
   if( !IsTesting() ){ 
      double rate = 0;
      for( int pos = OrdersHistoryTotal() - 1; pos >= 0; pos-- ) {
         if( OrderSelect( pos, SELECT_BY_POS, MODE_HISTORY ) ) {
            if( OrderProfit() != 0.0 ) {
               if( OrderClosePrice() != OrderOpenPrice() ) {
                  if( OrderSymbol() == Symbol() ) {
                     calculateCommission = false;
                     rate = MathAbs( OrderProfit() / MathAbs( OrderClosePrice() - OrderOpenPrice() ) );
                     commissionPoints = ( -OrderCommission() ) / rate;
                     break;
                  }
               }
            }
         }
      } 
   }
}

int start() {   
   int totalBuyStop = 0;
   int totalSellStop = 0;  
   int ticket;  
   if( calculateCommission ) commission();
   prepareSpread();
   manageTicks(); 
   int totalTrades = 0;
   for( int pos = 0; pos < OrdersTotal(); pos++ ) {
      r = OrderSelect( pos, SELECT_BY_POS, MODE_TRADES );
      if( OrderSymbol() != Symbol() ) continue;   
      if( OrderMagicNumber() == Magic ){ 
         totalTrades++;
         switch ( OrderType() ) {
            case OP_BUYSTOP:
               if( (int) TimeCurrent() - lastBuyOrder > VelocityTime && rateChange < Signal_2_Period * Point * deleteRatio )
                  r = OrderDelete( OrderTicket() );
               totalBuyStop++;
            break;
            case OP_SELLSTOP:
               if( (int) TimeCurrent() - lastSellOrder > VelocityTime && rateChange > -Signal_2_Period * Point * deleteRatio )
                  r = OrderDelete( OrderTicket() );
               totalSellStop++;
            break;
            case OP_BUY:    
               if( Bid - OrderOpenPrice() + commissionPoints > TrailingStop * Point ){  
                  if( OrderStopLoss() == 0.0 || Bid - OrderStopLoss() > TrailingStop * Point )
                     if( NormalizeDouble( Bid - ( TrailingStop * Point ), Digits ) != OrderStopLoss() )
                        r = OrderModify( OrderTicket(), OrderOpenPrice(), NormalizeDouble( Bid - ( TrailingStop * Point ), Digits ), OrderTakeProfit(), 0 );                  
               } else {
                  if( AccountEquity() > max || AccountEquity() / AccountBalance() < ( double ) StopLoss / 100 ){
                     if( rateChange < -Signal_2 * Point && Bid < OrderOpenPrice() - ( Signal_2_Period * Point ) )
                        if( OrderStopLoss() == 0.0 || Bid - OrderStopLoss() > ( TrailingStop * Point * TrailingLoss ) )
                           if( NormalizeDouble( Bid - ( TrailingStop * Point * TrailingLoss ), Digits ) != OrderStopLoss() )
                              r = OrderModify( OrderTicket(), OrderOpenPrice(), NormalizeDouble( Bid - ( TrailingStop * Point * TrailingLoss ), Digits ), OrderTakeProfit(), 0 ); 
                  }
               } 
            break;
            case OP_SELL:    
               if( OrderOpenPrice() - commissionPoints - Ask > TrailingStop * Point ){  
                  if( OrderStopLoss() == 0.0 || OrderStopLoss() - Ask > TrailingStop * Point ) 
                     if( NormalizeDouble( Ask + ( TrailingStop * Point ), Digits ) != OrderStopLoss() )
                        r = OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble( Ask + ( TrailingStop * Point ), Digits ), OrderTakeProfit(), 0 );                    
               } else {
                  if( AccountEquity() > max || AccountEquity() / AccountBalance() < ( double ) StopLoss / 100 ){
                     if( rateChange > Signal_2 * Point  && Ask > OrderOpenPrice() + ( Signal_2_Period * Point ) )
                        if( OrderStopLoss() == 0.0 || OrderStopLoss() - Ask > ( TrailingStop * Point * TrailingLoss ) ) 
                           if( NormalizeDouble( Ask + ( TrailingStop * Point * TrailingLoss ), Digits ) != OrderStopLoss() )
                              r = OrderModify(OrderTicket(), OrderOpenPrice(), NormalizeDouble( Ask + ( TrailingStop * Point * TrailingLoss ), Digits ), OrderTakeProfit(), 0 );
                  }
               } 
            break;
         }  
      }
   }  
   
   if( totalTrades == 0 ){
      if( AccountBalance() > max ) max = AccountBalance();
   }
    
   if( TradeManager == 0 && totalTrades < TradeDeviation ) { 
      if( rateChange > Signal_2_Period * Point && avgSpread <= maxSpread && totalBuyStop < TradeDeviation ) {
         if( AccountFreeMarginCheck( Symbol(), OP_BUY, lotSize() ) <= 0 || GetLastError() == 134 ) {
            Print( "Notice: Not enough free margin to open trade. Expert is removed." );
            ExpertRemove();
            return ( 0 ); 
         }
         ticket = OrderSend( Symbol(), OP_BUYSTOP, lotSize(), Ask + ( totalBuyStop + 1.0 ) * ( Point * TradeDelta ), Slippage, 0, 0, Open_Comment, Magic, 0 );
         lastBuyOrder = ( int ) TimeCurrent();
      } 
      if( rateChange < -Signal_2_Period * Point && avgSpread <= maxSpread && totalSellStop < TradeDeviation ) {
         if( AccountFreeMarginCheck( Symbol(), OP_SELL, lotSize() ) <= 0 || GetLastError() == 134 ) {
            Print( "Notice: Not enough free margin to open trade. Expert is removed." );
            ExpertRemove();
            return ( 0 );
         }
         ticket = OrderSend(Symbol(), OP_SELLSTOP, lotSize(), Bid - ( totalSellStop + 1.0 ) * ( Point * TradeDelta ), Slippage, 0, 0, Open_Comment, Magic, 0 );
         lastSellOrder = ( int ) TimeCurrent();
      }    
   }  
    
  
   return ( 0 );
} 

double lotSize(){  
   if( FixedLot > 0 ){
      lotSize = NormalizeDouble( FixedLot, 2 );
   } else {
      if( marginRequirement > 0 ) 
         lotSize = MathMax( MathMin( NormalizeDouble( ( AccountBalance() * ( ( double ) AutoMM / 1000 ) * 0.01 / marginRequirement ), 2 ), maxLot ), minLot );    
   }  
   return ( NormalizeLots( lotSize ) ); 
}  

double NormalizeLots( double p ){
    double ls = MarketInfo( Symbol(), MODE_LOTSTEP );
    return( MathRound( p / ls ) * ls );
}

void prepareSpread(){
   if( !IsTesting() ){  
      double spreadSize_temp[];
      ArrayResize( spreadSize_temp, size - 1 );
      ArrayCopy( spreadSize_temp, spreadSize, 0, 1, size - 1 );
      ArrayResize( spreadSize_temp, size ); 
      spreadSize_temp[size-1] = NormalizeDouble( Ask - Bid, Digits ); 
      ArrayCopy( spreadSize, spreadSize_temp, 0, 0 ); 
      avgSpread = iMAOnArray( spreadSize, size, size, 0, MODE_LWMA, 0 );  
   }
}       

void manageTicks(){    
   double tick_temp[], tickTime_temp[], avgtick_temp[];
   ArrayResize( tick_temp, size - 1 );
   ArrayResize( tickTime_temp, size - 1 );
   ArrayCopy( tick_temp, tick, 0, 1, size - 1 ); 
   ArrayCopy( tickTime_temp, tickTime, 0, 1, size - 1 ); 
   ArrayResize( tick_temp, size ); 
   ArrayResize( tickTime_temp, size );
   tick_temp[size-1] = Bid;
   tickTime_temp[size-1] = ( int ) TimeCurrent();
   ArrayCopy( tick, tick_temp, 0, 0 );    
   ArrayCopy( tickTime, tickTime_temp, 0, 0 ); 
   int timeNow = tickTime[size-1];
   double priceNow = tick[size-1];
   double priceThen = 0;   
   int period = 0;
   for( int i = size - 1; i >= 0; i-- ){ 
      period++;
      if( timeNow - tickTime[i] > VelocityTime ){
         priceThen = tick[i]; 
         break;
      }  
   }     
    
   rateChange = ( priceNow - priceThen );
   if( rateChange / Point > 5000 ) rateChange = 0;     
} 
