package com.letv.plugins.kernel.controller.gslb
{
   import flash.events.EventDispatcher;
   import com.alex.rpc.AutoLoader;
   import com.alex.rpc.events.AutoLoaderEvent;
   import com.alex.rpc.type.ResourceType;
   import com.letv.plugins.kernel.Kernel;
   import com.alex.rpc.type.StateType;
   import com.alex.utils.JSONUtil;
   import flash.net.URLVariables;
   
   public class GslbControl extends EventDispatcher
   {
      
      public static var hadControl:Boolean;
      
      protected var defintion:String;
      
      protected var loader:AutoLoader;
      
      public function GslbControl()
      {
         super();
      }
      
      public function destroy() : void
      {
         this.loaderGC();
      }
      
      public function start(param1:Array, param2:String) : void
      {
         this.defintion = param2;
         this.loaderGC();
         this.loader = new AutoLoader();
         this.loader.addEventListener(AutoLoaderEvent.LOAD_ERROR,this.onError);
         this.loader.addEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.onLoadComplete);
         this.loader.addEventListener(AutoLoaderEvent.LOAD_STATE_CHANGE,this.onLoadState);
         var _loc3_:Array = [];
         var _loc4_:* = 0;
         while(_loc4_ < param1.length)
         {
            param1[_loc4_] = param1[_loc4_] + ("&rateid=" + param2);
            _loc3_.push({
               "url":param1[_loc4_],
               "type":ResourceType.TEXT,
               "retryMax":1,
               "frist":4000
            });
            _loc4_++;
         }
         this.loader.setup(_loc3_);
      }
      
      private function onError(param1:AutoLoaderEvent) : void
      {
         if(param1.index == param1.total - 1)
         {
            this.destroy();
            this.onLoadError(param1);
         }
         else
         {
            Kernel.sendLog(this + " error index:" + param1.index + " errorcode:" + param1.errorCode,"error");
         }
      }
      
      protected function onLoadError(param1:*) : void
      {
      }
      
      protected function onLoadComplete(param1:AutoLoaderEvent) : Object
      {
         var _loc2_:String = param1.dataProvider.content;
         this.destroy();
         return this.resultFilter(_loc2_);
      }
      
      private function onLoadState(param1:AutoLoaderEvent) : void
      {
         if(param1.infoCode == StateType.INFO_START)
         {
            Kernel.sendLog(this + " open index:" + param1.index + " " + param1.dataProvider.url);
         }
      }
      
      private function loaderGC() : void
      {
         if(this.loader != null)
         {
            this.loader.destroy();
            this.loader.removeEventListener(AutoLoaderEvent.LOAD_ERROR,this.onError);
            this.loader.removeEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.onLoadComplete);
            this.loader.removeEventListener(AutoLoaderEvent.LOAD_STATE_CHANGE,this.onLoadState);
            this.loader = null;
         }
      }
      
      private function resultFilter(param1:String) : Object
      {
         var obj:Object = null;
         var list:Array = null;
         var playlevel:int = 0;
         var item:Object = null;
         var value:String = param1;
         try
         {
            obj = JSONUtil.decode(value);
            if((obj.hasOwnProperty("status")) && int(obj.status) >= 400)
            {
               return {
                  "data":obj,
                  "list":{}
               };
            }
            if(!obj.hasOwnProperty("nodelist"))
            {
               item = {};
               if((obj.hasOwnProperty("location")) && !(obj.location == ""))
               {
                  item.location = obj.location;
               }
               if(obj.hasOwnProperty("gone"))
               {
                  item.gone = obj.gone;
               }
               if(obj.hasOwnProperty("playlevel"))
               {
                  item.playlevel = obj.playlevel;
               }
               obj.nodelist = [item];
            }
            list = this.getlist(obj);
            playlevel = list[0][this.defintion].playlevel;
            return {
               "data":obj,
               "list":list,
               "playlevel":playlevel
            };
         }
         catch(e:Error)
         {
            trace("[Error In GslbControl.resultFilter]",e.message + "\n" + value);
         }
         return {
            "data":null,
            "list":{}
         };
      }
      
      private function getlist(param1:Object) : Array
      {
         var _loc3_:Array = null;
         var _loc4_:* = 0;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc2_:Array = [];
         if(param1 != null)
         {
            _loc3_ = param1.nodelist as Array;
            if(_loc3_ != null)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc3_.length)
               {
                  _loc5_ = {};
                  _loc6_ = this.getItem(_loc3_[_loc4_].location);
                  if(_loc6_ != null)
                  {
                     _loc6_["gone"] = _loc3_[_loc4_].gone;
                     _loc6_["playlevel"] = _loc3_[_loc4_].playlevel;
                     _loc5_[_loc6_.rateid] = _loc6_;
                  }
                  _loc2_.push(_loc5_);
                  _loc4_++;
               }
            }
         }
         return _loc2_;
      }
      
      private function getItem(param1:String) : Object
      {
         var result:Object = null;
         var vars:URLVariables = null;
         var value:String = param1;
         try
         {
            vars = new URLVariables(value);
            result = {
               "rateid":vars.rateid,
               "type":vars.rateid,
               "location":value
            };
         }
         catch(e:Error)
         {
         }
         return result;
      }
   }
}
