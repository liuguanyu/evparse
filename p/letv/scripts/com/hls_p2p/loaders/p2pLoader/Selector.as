package com.hls_p2p.loaders.p2pLoader
{
   import flash.events.EventDispatcher;
   import flash.utils.Timer;
   import flash.events.TimerEvent;
   import com.p2p.utils.console;
   import com.hls_p2p.statistics.Statistic;
   import com.hls_p2p.data.vo.LiveVodConfig;
   import flash.events.Event;
   
   public class Selector extends EventDispatcher
   {
      
      public var isDebug:Boolean = true;
      
      public var groupID:String;
      
      public var gatherName:String;
      
      public var var_206:uint;
      
      public var rtmfpName:String;
      
      public var var_207:uint;
      
      public var maxQPeers:uint = 0;
      
      public var hbInterval:uint = 11;
      
      private var var_208:Timer;
      
      private var var_189:Selector_Loader;
      
      private var var_209:String = "selector.webp2p.letv.com";
      
      private var var_210:uint = 80;
      
      private var var_211:uint = 0;
      
      private var geo:String = "";
      
      public var var_212:String = "rtmfp";
      
      public var var_213:int = 0;
      
      public function Selector(param1:String, param2:String, param3:String, param4:int)
      {
         super();
         this.groupID = param1;
         this.geo = param2;
         this.var_212 = param3;
         this.var_213 = param4;
      }
      
      public function load() : void
      {
         if(!this.var_208)
         {
            this.var_208 = new Timer(0);
            this.var_208.addEventListener(TimerEvent.TIMER,this.method_227);
            this.var_208.start();
         }
      }
      
      public function method_226() : void
      {
         this.var_208.start();
      }
      
      public function clear() : void
      {
         if(this.var_208)
         {
            this.var_208.stop();
            this.var_208.removeEventListener(TimerEvent.TIMER,this.method_227);
            this.var_208 = null;
         }
      }
      
      private function method_227(param1:* = null) : void
      {
         if(this.var_189)
         {
            if(this.var_189.var_242 == true)
            {
               return;
            }
            if(true == this.var_189.var_247)
            {
               this.var_208.stop();
               return;
            }
            this.var_208.delay = 100;
            if(this.var_189.error)
            {
               if(this.var_211 <= 3)
               {
                  this.var_211++;
               }
               if(this.var_189)
               {
                  this.var_189.clear();
                  this.var_189 = null;
               }
               this.var_208.reset();
               this.var_208.delay = this.var_211 * 8 * 1000;
               this.var_208.start();
               return;
            }
            if(this.var_189.var_243)
            {
               if(this.var_212 == "rtmfp")
               {
                  this.rtmfpName = this.var_189.var_239;
                  this.var_207 = this.var_189.var_207;
                  this.gatherName = this.var_189.var_237;
                  this.var_206 = this.var_189.var_238;
                  console.log(this,"rtmfp");
               }
               else
               {
                  this.var_207 = this.var_189.var_207;
                  this.rtmfpName = this.var_189.var_239;
                  this.gatherName = this.var_189.var_237;
                  this.var_206 = this.var_189.var_238;
                  console.log(this,"socket||gather");
                  Statistic.method_261().method_103(this.gatherName,this.var_206,this.groupID);
               }
               if(true == this.var_189.sharePeers)
               {
                  LiveVodConfig.IS_SHARE_PEERS = this.var_189.sharePeers;
               }
               if(this.var_189.maxQPeers > 0)
               {
                  this.maxQPeers = this.var_189.maxQPeers;
               }
               if(this.var_189.hbInterval > 0)
               {
                  this.hbInterval = this.var_189.hbInterval;
               }
               console.log(this,"param: " + this.gatherName + ":" + this.var_206 + "sharePeers" + this.var_189.sharePeers + " maxQPeers:" + this.maxQPeers + " hbInterval:" + this.hbInterval);
               Statistic.method_261().method_97(this.groupID);
               this.var_208.stop();
               this.var_189.clear();
               this.var_189 = null;
               dispatchEvent(new Event(Event.COMPLETE));
               return;
            }
            if(this.var_189.var_244)
            {
               this.var_209 = this.var_189.var_240;
               this.var_210 = this.var_189.var_241;
               this.var_189.init(this.groupID,this.var_209,this.var_210,this.var_212,this.geo);
               return;
            }
         }
         this.var_189 = new Selector_Loader();
         this.var_189.init(this.groupID,this.var_209,this.var_210,this.var_212,this.geo,this.var_213);
      }
   }
}
