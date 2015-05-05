package com.hls_p2p.loaders.cdnLoader
{
   import flash.utils.Timer;
   import com.hls_p2p.data.vo.LiveVodConfig;
   import flash.events.TimerEvent;
   
   public class CDNRateStrategy extends Object
   {
      
      private static var var_267:CDNRateStrategy = null;
      
      {
         var_267 = null;
      }
      
      private const const_1:Number = 0.5;
      
      private const const_2:Number = 0.05;
      
      private var var_12:uint = 90000.0;
      
      private var var_13:Number = 0.5;
      
      private var var_14:int = 1;
      
      private var var_15:int = 3;
      
      private var var_16:Number = 0.05;
      
      private var timer:Timer;
      
      private var httpSize:Number = 0;
      
      private var p2pSize:Number = 0;
      
      private var var_17:Number = 0;
      
      private var var_18:Number = 0;
      
      private var var_19:Number = 0;
      
      private var var_20:Number = 0;
      
      public var var_21:Number;
      
      public var isDebug:Boolean = true;
      
      public function CDNRateStrategy(param1:Singleton)
      {
         this.var_21 = LiveVodConfig.DAT_LOAD_RATE;
         super();
         if(true == LiveVodConfig.var_276 && LiveVodConfig.TYPE == LiveVodConfig.LIVE)
         {
            this.timer = new Timer(this.var_12,1);
            this.timer.addEventListener(TimerEvent.TIMER,this.method_45);
            this.timer.start();
         }
      }
      
      public static function method_261() : CDNRateStrategy
      {
         if(var_267 == null)
         {
            var_267 = new CDNRateStrategy(new Singleton());
         }
         return var_267;
      }
      
      public function method_42(param1:Number) : void
      {
         if(LiveVodConfig.TYPE == LiveVodConfig.LIVE)
         {
            this.httpSize = this.httpSize + param1;
         }
      }
      
      public function method_43(param1:Number) : void
      {
         if(LiveVodConfig.TYPE == LiveVodConfig.LIVE)
         {
            this.p2pSize = this.p2pSize + param1;
         }
      }
      
      public function method_44(param1:Number) : void
      {
         if(LiveVodConfig.TYPE == LiveVodConfig.LIVE)
         {
            this.var_17 = this.var_17 + param1;
         }
      }
      
      private function reset() : void
      {
         this.httpSize = 0;
         this.p2pSize = 0;
         this.var_17 = 0;
      }
      
      private function init() : void
      {
         this.reset();
         this.var_16 = this.const_2;
         this.var_18 = 0;
         this.var_19 = 0;
         this.var_20 = 0;
         LiveVodConfig.DAT_LOAD_RATE = this.var_21;
      }
      
      public function clear() : void
      {
         if(this.timer)
         {
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this.method_45);
            this.timer = null;
         }
      }
      
      private function method_45(param1:TimerEvent) : void
      {
      }
   }
}

class Singleton extends Object
{
   
   function Singleton()
   {
      super();
   }
}
