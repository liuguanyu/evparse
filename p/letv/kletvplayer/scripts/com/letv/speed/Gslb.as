package com.letv.speed
{
   import flash.events.EventDispatcher;
   import com.letv.aiLoader.AILoader;
   import com.letv.aiLoader.events.AILoaderEvent;
   
   public class Gslb extends EventDispatcher
   {
      
      public static const URL:String = "http://g3.letv.cn/recommend?format=2";
      
      private var loader:AILoader;
      
      public function Gslb()
      {
         super();
      }
      
      public function destroy() : void
      {
         this.gc();
      }
      
      public function start(param1:Object, param2:Boolean = false, param3:Boolean = false, param4:String = null, param5:Object = null, param6:String = null) : void
      {
         this.gc();
         this.loader = new AILoader();
         this.loader.addEventListener(AILoaderEvent.LOAD_ERROR,this.onLoadError);
         this.loader.addEventListener(AILoaderEvent.LOAD_COMPLETE,this.onLoadComplete);
         var _loc7_:String = URL + "&tn=" + Math.random();
         if(param6 != null)
         {
            _loc7_ = param6;
         }
         if(param1 == "node" && (param5))
         {
            _loc7_ = _loc7_ + ("&random=2&nodeid=" + param5);
            trace("[Speed.Core]",_loc7_);
            this.loader.setup([{
               "url":_loc7_,
               "type":"text"
            }]);
            return;
         }
         if((param3) && (param4))
         {
            _loc7_ = _loc7_ + ("&mode=" + param1 + "&size=1");
            _loc7_ = _loc7_ + ("&tag=live&stream_id=" + param4);
            _loc7_ = _loc7_ + (param2?"&random=1":"");
            trace("[Speed.Core]",_loc7_);
            this.loader.setup([{
               "url":_loc7_,
               "type":"text"
            }]);
         }
         else
         {
            _loc7_ = _loc7_ + ("&mode=" + param1 + "&size=1");
            _loc7_ = _loc7_ + (param2?"&random=1":"");
            trace("[Speed.Core]",_loc7_);
            this.loader.setup([{
               "url":_loc7_,
               "type":"text"
            }]);
         }
      }
      
      private function onLoadComplete(param1:AILoaderEvent) : void
      {
         var result:XML = null;
         var event:AILoaderEvent = param1;
         try
         {
            result = XML(event.dataProvider.content);
            this.sendState(GslbEvent.LOAD_SUCCESS,result);
         }
         catch(e:Error)
         {
            onLoadError("Analy Error " + e.message);
         }
      }
      
      private function onLoadError(param1:* = null) : void
      {
         this.sendState(GslbEvent.LOAD_FAILED);
      }
      
      private function sendState(param1:String, param2:Object = null) : void
      {
         var _loc3_:GslbEvent = new GslbEvent(param1);
         _loc3_.dataProvider = param2;
         dispatchEvent(_loc3_);
         this.gc();
      }
      
      private function gc() : void
      {
         if(this.loader)
         {
            this.loader.destroy();
            this.loader.removeEventListener(AILoaderEvent.LOAD_COMPLETE,this.onLoadComplete);
            this.loader.removeEventListener(AILoaderEvent.LOAD_ERROR,this.onLoadError);
         }
         this.loader = null;
      }
   }
}
