package com.letv.plugins.kernel.controller.gslb
{
   import flash.events.EventDispatcher;
   import com.alex.rpc.type.ResourceType;
   import flash.events.Event;
   import com.alex.rpc.AutoLoader;
   import com.alex.rpc.events.AutoLoaderEvent;
   import com.letv.plugins.kernel.Kernel;
   import com.alex.rpc.media.BaseMedia;
   import flash.events.IEventDispatcher;
   
   public class GslbP2PLibLoader extends EventDispatcher
   {
      
      private var _p2pFlv:Object;
      
      private var _p2pM3u8:Object;
      
      private var _loader:AutoLoader;
      
      private var _temporary:Array;
      
      public function GslbP2PLibLoader(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public function get p2pFlvClass() : Object
      {
         return this._p2pFlv;
      }
      
      public function get p2pM3u8vClass() : Object
      {
         return this._p2pM3u8;
      }
      
      public function destroy() : void
      {
         this.loadGC();
      }
      
      public function load(param1:String, param2:String) : void
      {
         this.loadGC();
         this._temporary = [];
         if(!(param1 == null) && !(param1 == "") && this._p2pFlv == null)
         {
            this._temporary.push({
               "type":ResourceType.FLASH,
               "style":"flv",
               "url":param1,
               "retryMax":2,
               "retryDelayTime":200
            });
         }
         if(!(param2 == null) && !(param2 == "") && this._p2pM3u8 == null)
         {
            this._temporary.push({
               "type":ResourceType.FLASH,
               "style":"m3u8",
               "url":param2,
               "retryMax":2,
               "retryDelayTime":200
            });
         }
         if(this._temporary.length == 0)
         {
            dispatchEvent(new Event(Event.COMPLETE));
            return;
         }
         this._loader = new AutoLoader();
         this._loader.addEventListener(AutoLoaderEvent.WHOLE_COMPLETE,this.onLoadComplete);
         Kernel.sendLog(this + " LIB TYPE " + param1 + " " + param2);
         this._loader.setup(this._temporary);
      }
      
      private function onLoadComplete(param1:AutoLoaderEvent) : void
      {
         var list:Array = null;
         var flvP2PLib:BaseMedia = null;
         var m3u8P2PLib:BaseMedia = null;
         var instance:Object = null;
         var event:AutoLoaderEvent = param1;
         try
         {
            list = event.dataProvider as Array;
            if(this._temporary.length == 2)
            {
               flvP2PLib = list[0];
               m3u8P2PLib = list[1];
            }
            else if(this._temporary[0].style == "flv")
            {
               flvP2PLib = list[0];
            }
            else
            {
               m3u8P2PLib = list[0];
            }
            
            if(!(flvP2PLib == null) && (flvP2PLib.hadUsed))
            {
               instance = flvP2PLib.content.content;
               if(instance.hasOwnProperty("create"))
               {
                  this._p2pFlv = instance;
               }
            }
            if(!(m3u8P2PLib == null) && (m3u8P2PLib.hadUsed))
            {
               instance = m3u8P2PLib.content.content;
               if(instance.hasOwnProperty("create"))
               {
                  this._p2pM3u8 = instance;
               }
            }
         }
         catch(e:Error)
         {
         }
         this.loadGC();
         Kernel.sendLog(this + " Complete " + this._p2pFlv + " " + this._p2pM3u8);
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function loadGC() : void
      {
         if(this._loader != null)
         {
            this._loader.removeEventListener(AutoLoaderEvent.WHOLE_COMPLETE,this.onLoadComplete);
            this._loader.destroy();
            this._loader = null;
         }
      }
   }
}
