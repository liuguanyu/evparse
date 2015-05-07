package com.letv.player.model.proxy
{
   import com.letv.player.facade.MyProxy;
   import com.letv.player.facade.MyResource;
   import com.alex.rpc.type.ResourceType;
   import com.alex.rpc.AutoLoader;
   import com.alex.rpc.type.LoadOrderType;
   import com.alex.rpc.events.AutoLoaderEvent;
   import com.alex.rpc.media.BaseMedia;
   import com.letv.player.notify.InitNotify;
   import com.letv.pluginsAPI.kernel.PlayerError;
   import com.letv.player.notify.ErrorNotify;
   
   public class PluginProxy extends MyProxy
   {
      
      public static const NAME:String = "pluginProxy";
      
      private var loader:AutoLoader;
      
      private var pluginList:Array;
      
      private var pluginStack:Object;
      
      private var latestErrorCode:String = "0";
      
      public function PluginProxy()
      {
         super(NAME);
      }
      
      public function loadPlugin() : void
      {
         this.latestErrorCode = "0";
         if(R.plugins.skinUrl == null || R.plugins.sdkUrl == null)
         {
            this.errorInit("Skin Or Kernel URL Is Null");
            return;
         }
         this.pluginList = [];
         var _loc1_:Object = {
            "name":MyResource.SDK,
            "type":ResourceType.BINARY,
            "url":R.plugins.sdkUrl,
            "first":8000
         };
         this.pluginList.push(_loc1_);
         _loc1_ = {
            "name":MyResource.SKIN,
            "type":ResourceType.BINARY,
            "url":R.plugins.skinUrl,
            "first":8000,
            "currentDomain":true
         };
         this.pluginList.push(_loc1_);
         this.pluginStack = {};
         var _loc2_:* = 0;
         while(_loc2_ < this.pluginList.length)
         {
            this.pluginStack[this.pluginList[_loc2_]["name"]] = _loc2_;
            _loc2_++;
         }
         R.stat.params.ia = "-";
         this.loader = new AutoLoader(LoadOrderType.LOAD_MULTIPLE);
         this.loader.addEventListener(AutoLoaderEvent.LOAD_ERROR,this.onLoadError);
         this.loader.addEventListener(AutoLoaderEvent.WHOLE_COMPLETE,this.onWholeComplete);
         this.loader.setup(this.pluginList);
      }
      
      private function onLoadError(param1:AutoLoaderEvent) : void
      {
         this.latestErrorCode = "42" + String(param1.errorCode);
         R.stat.sendStat({
            "error":this.latestErrorCode,
            "utime":param1.dataProvider.utime,
            "retry":param1.retry
         });
         this.latestErrorCode = "42" + String(param1.errorCode);
      }
      
      private function onWholeComplete(param1:AutoLoaderEvent) : void
      {
         var result:Array = null;
         var media:BaseMedia = null;
         var event:AutoLoaderEvent = param1;
         R.log.append("[UI V3X] Load Core Plugins Success]");
         var plugins:Object = {};
         try
         {
            result = event.dataProvider as Array;
            if(this.pluginStack.hasOwnProperty(MyResource.SDK))
            {
               media = result[this.pluginStack[MyResource.SDK]];
               if(!(media == null) && !media.hadError)
               {
                  plugins[MyResource.SDK] = media.content.content;
               }
            }
            if(this.pluginStack.hasOwnProperty(MyResource.SKIN))
            {
               media = result[this.pluginStack[MyResource.SKIN]];
               if(!(media == null) && !media.hadError)
               {
                  plugins[MyResource.SKIN] = media.content.content;
                  plugins[MyResource.SKIN_DOMAIN] = media.domain;
               }
            }
            if(plugins[MyResource.SDK] == null || plugins[MyResource.SKIN] == null)
            {
               this.errorInit("Plugin Not Found");
               return;
            }
            this.gc(false);
         }
         catch(e:Error)
         {
            errorInit(e.message);
            return;
         }
         sendNotification(InitNotify.INIT_LAYER,plugins);
      }
      
      private function errorInit(param1:* = null) : void
      {
         R.log.append("[UI V3X] Load Needed Plugins Error: " + param1 + " errorCode: " + this.latestErrorCode,"error");
         this.gc();
         if(this.latestErrorCode == "0" || this.latestErrorCode == null)
         {
            this.latestErrorCode = PlayerError.PLUGINS_OTHER_ERROR;
         }
         sendNotification(ErrorNotify.ERROR_IN_LOAD_SDK,{"errorCode":this.latestErrorCode});
      }
      
      private function gc(param1:Boolean = true) : void
      {
         if(this.loader != null)
         {
            this.loader.removeEventListener(AutoLoaderEvent.LOAD_ERROR,this.onLoadError);
            this.loader.removeEventListener(AutoLoaderEvent.WHOLE_COMPLETE,this.onWholeComplete);
            if(param1)
            {
               this.loader.destroy();
            }
            this.loader = null;
         }
      }
   }
}
