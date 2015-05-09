package com.letv.speed
{
   import flash.events.EventDispatcher;
   import com.letv.aiLoader.AILoader;
   import com.letv.aiLoader.type.ResourceType;
   import com.letv.aiLoader.events.AILoaderEvent;
   import flash.utils.getTimer;
   
   public class Speed extends EventDispatcher
   {
      
      protected var gslb:Gslb;
      
      protected var loader:AILoader;
      
      protected var statistics:SpeedStatistics;
      
      private var testurl:String;
      
      private var speedXML:XML;
      
      public function Speed()
      {
         this.statistics = SpeedStatistics.getInstance();
         this.statistics.uuid = "uuid_" + getTimer() + "_" + Math.random();
         super();
      }
      
      public function destroy() : void
      {
         this.gslbGc();
         this.speedGc();
      }
      
      public function start(param1:Object, param2:Boolean = false, param3:Boolean = false, param4:String = null, param5:Object = null, param6:String = null) : void
      {
         this.gslbGc();
         this.speedGc();
         this.testurl = param6;
         this.gslb = new Gslb();
         this.gslb.addEventListener(GslbEvent.LOAD_FAILED,this.onGslbFailed);
         this.gslb.addEventListener(GslbEvent.LOAD_SUCCESS,this.onGslbSuccess);
         this.gslb.start(param1,param2,param3,param4,param5,param6);
      }
      
      private function onGslbFailed(param1:GslbEvent = null) : void
      {
         trace("[speedLib onGslbFailed]");
         this.gslbGc();
         this.speedGc();
         var _loc2_:SpeedEvent = new SpeedEvent(SpeedEvent.GSLB_FAILED);
         dispatchEvent(_loc2_);
      }
      
      private function onGslbSuccess(param1:GslbEvent) : void
      {
         var value:XML = null;
         var list:XMLList = null;
         var len:int = 0;
         var arr:Array = null;
         var e:SpeedEvent = null;
         var i:int = 0;
         var url:String = null;
         var event:GslbEvent = param1;
         try
         {
            trace("[speedLib onGslbSuccess]\n",event.dataProvider);
            value = XML(event.dataProvider);
            this.speedXML = value;
            list = value.nodelist[0].node;
            len = list.length();
            arr = [];
            if(len > 0)
            {
               i = 0;
               while(i < len)
               {
                  url = String(list[i]);
                  if(url.indexOf("?") != -1)
                  {
                     if(this.testurl != null)
                     {
                        url = url + ("&rstart=0&rend=524288" + "&tn=" + Math.random());
                     }
                     arr[i] = {
                        "url":url,
                        "type":ResourceType.TEXT,
                        "first":12000,
                        "retryMax":1,
                        "gone":list[i].@gone
                     };
                  }
                  else
                  {
                     if(this.testurl != null)
                     {
                        url = url + "?rstart=0&rend=524288";
                     }
                     arr[i] = {
                        "url":url + "&tn=" + Math.random(),
                        "type":ResourceType.TEXT,
                        "first":12000,
                        "retryMax":1,
                        "gone":list[i].@gone
                     };
                  }
                  i++;
               }
               e = new SpeedEvent(SpeedEvent.GSLB_SUCCESS);
               e.dataProvider = event.dataProvider;
               dispatchEvent(e);
               this.speedStart(arr);
            }
            else
            {
               this.onGslbFailed();
               return;
            }
         }
         catch(e:Error)
         {
            onGslbFailed();
         }
      }
      
      public function speedStart(param1:Array) : void
      {
         this.gslbGc();
         this.speedGc();
         if((param1) && param1.length > 0)
         {
            this.loader = new AILoader();
            this.loader.addEventListener(AILoaderEvent.LOAD_ERROR,this.onSpeedOneFailed);
            this.loader.addEventListener(AILoaderEvent.LOAD_COMPLETE,this.onSpeedOneSuccess);
            this.loader.addEventListener(AILoaderEvent.LOAD_PROGRESS,this.onSpeedOneProgress);
            this.loader.addEventListener(AILoaderEvent.WHOLE_COMPLETE,this.onSpeedAllComplete);
            this.loader.setup(param1);
         }
         else
         {
            this.onGslbFailed();
         }
      }
      
      private function onSpeedOneFailed(param1:AILoaderEvent) : void
      {
         var _loc2_:Object = {};
         _loc2_["err"] = param1.errorCode;
         _loc2_["gone"] = param1.dataProvider.data.gone;
         _loc2_["spd"] = param1.dataProvider.speed;
         _loc2_["utm"] = param1.dataProvider.utime;
         _loc2_["size"] = param1.dataProvider.size;
         _loc2_["url"] = param1.dataProvider.url;
         this.statistics.sendSpeedInfo(_loc2_);
         var _loc3_:SpeedEvent = new SpeedEvent(SpeedEvent.ONE_FAILED);
         _loc3_.dataProvider = {
            "type":0,
            "index":param1.index,
            "errorCode":param1.errorCode,
            "sourceType":param1.sourceType
         };
         dispatchEvent(_loc3_);
      }
      
      private function onSpeedOneSuccess(param1:AILoaderEvent) : void
      {
         var event:AILoaderEvent = param1;
         var nodeinfo:Object = {};
         nodeinfo["err"] = "0";
         nodeinfo["gone"] = event.dataProvider.data.gone;
         nodeinfo["spd"] = event.dataProvider.speed;
         nodeinfo["utm"] = event.dataProvider.utime;
         nodeinfo["size"] = event.dataProvider.size;
         nodeinfo["url"] = event.dataProvider.url;
         this.statistics.sendSpeedInfo(nodeinfo);
         var e:SpeedEvent = new SpeedEvent(SpeedEvent.ONE_SUCCESS);
         e.dataProvider = {
            "type":1,
            "index":event.index,
            "speed":event.dataProvider.speed,
            "sourceType":event.sourceType
         };
         dispatchEvent(e);
         try
         {
            event.dataProvider.destroy();
         }
         catch(e:Error)
         {
         }
      }
      
      private function onSpeedOneProgress(param1:AILoaderEvent) : void
      {
         var _loc2_:SpeedEvent = new SpeedEvent(SpeedEvent.ONE_PROGRESS);
         var _loc3_:Object = param1.dataProvider;
         _loc3_["type"] = 1;
         _loc3_["index"] = param1.index;
         _loc3_["sourceType"] = param1.sourceType;
         _loc2_.dataProvider = _loc3_;
         dispatchEvent(_loc2_);
      }
      
      private function onSpeedAllComplete(param1:AILoaderEvent) : void
      {
         var _loc2_:SpeedEvent = new SpeedEvent(SpeedEvent.COMPLETE);
         _loc2_.dataProvider = param1.dataProvider;
         dispatchEvent(_loc2_);
         this.gslbGc();
         this.speedGc();
      }
      
      public function speedGc() : void
      {
         if(this.loader)
         {
            this.loader.destroy();
            this.loader.removeEventListener(AILoaderEvent.LOAD_ERROR,this.onSpeedOneFailed);
            this.loader.removeEventListener(AILoaderEvent.LOAD_COMPLETE,this.onSpeedOneSuccess);
            this.loader.removeEventListener(AILoaderEvent.LOAD_PROGRESS,this.onSpeedOneProgress);
            this.loader.removeEventListener(AILoaderEvent.WHOLE_COMPLETE,this.onSpeedAllComplete);
         }
         this.loader = null;
      }
      
      public function gslbGc() : void
      {
         try
         {
            this.gslb.destroy();
         }
         catch(e:Error)
         {
         }
         try
         {
            this.gslb.removeEventListener(GslbEvent.LOAD_FAILED,this.onGslbFailed);
            this.gslb.removeEventListener(GslbEvent.LOAD_SUCCESS,this.onGslbSuccess);
         }
         catch(e:Error)
         {
         }
         this.gslb = null;
      }
   }
}
