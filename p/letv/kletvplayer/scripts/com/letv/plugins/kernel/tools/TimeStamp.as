package com.letv.plugins.kernel.tools
{
   import flash.events.EventDispatcher;
   import flash.events.Event;
   import com.alex.rpc.AutoLoader;
   import com.alex.rpc.events.AutoLoaderEvent;
   import com.alex.rpc.type.ResourceType;
   import com.letv.plugins.kernel.Kernel;
   import flash.utils.getTimer;
   
   public class TimeStamp extends EventDispatcher
   {
      
      public static const SETUP_INIT:String = "setupInit";
      
      public static const SETUP_ERROR:String = "setupError";
      
      private static var instance:TimeStamp;
      
      private var _inited:Boolean;
      
      private var loader:AutoLoader;
      
      private var _stime:int;
      
      private var lib:Object;
      
      private var nowTime:int;
      
      private const FLASCC:Class = TimeStamp_FLASCC;
      
      public function TimeStamp()
      {
         super();
      }
      
      public static function getInstance() : TimeStamp
      {
         if(instance == null)
         {
            instance = new TimeStamp();
         }
         return instance;
      }
      
      public function init() : void
      {
         if(this._inited)
         {
            dispatchEvent(new Event(TimeStamp.SETUP_INIT));
         }
         else
         {
            this.gc();
            this.loader = new AutoLoader();
            this.loader.addEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.onLoadComplete);
            this.loader.addEventListener(AutoLoaderEvent.LOAD_ERROR,this.onLoadError);
            this.loader.setup([{
               "type":ResourceType.BYTES,
               "bytes":new this.FLASCC()
            }]);
         }
      }
      
      private function onLoadComplete(param1:AutoLoaderEvent) : void
      {
         this.lib = param1.dataProvider.content["lib"];
         this.gc();
         if(this.lib)
         {
            this._inited = true;
            dispatchEvent(new Event(TimeStamp.SETUP_INIT));
         }
         else
         {
            dispatchEvent(new Event(TimeStamp.SETUP_ERROR));
         }
      }
      
      private function onLoadError(param1:AutoLoaderEvent) : void
      {
         this.gc();
         dispatchEvent(new Event(TimeStamp.SETUP_ERROR));
      }
      
      private function get tm() : int
      {
         if(this._stime > 0)
         {
            Kernel.sendLog("Server Time: " + this._stime + " " + (getTimer() - this.nowTime));
            return this._stime + int((getTimer() - this.nowTime) * 0.001);
         }
         Kernel.sendLog("Local Time: " + new Date().getTime());
         return int(new Date().getTime() * 0.001);
      }
      
      public function calcTimeKey() : String
      {
         var _loc1_:String = this.lib.calcTimeKey(this.tm);
         return _loc1_;
      }
      
      private function gc() : void
      {
         if(this.loader != null)
         {
            this.loader.removeEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.onLoadComplete);
            this.loader.removeEventListener(AutoLoaderEvent.LOAD_ERROR,this.onLoadError);
            this.loader.destroy();
            this.loader = null;
         }
      }
      
      public function get stime() : int
      {
         return this._stime;
      }
      
      public function set stime(param1:int) : void
      {
         this.nowTime = getTimer();
         this._stime = param1;
      }
   }
}
