package com.letv.player.model.proxy
{
   import com.letv.player.facade.MyProxy;
   import com.letv.player.model.proxy.loadingAd.LoadingAd;
   import com.alex.rpc.type.ResourceType;
   import com.letv.player.model.EmbedConfig;
   import com.alex.rpc.AutoLoader;
   import com.alex.rpc.type.LoadOrderType;
   import com.alex.rpc.events.AutoLoaderEvent;
   import com.alex.rpc.media.BaseMedia;
   import com.letv.player.components.MainLoading;
   import flash.geom.Rectangle;
   import com.letv.player.notify.InitNotify;
   
   public class ConfigProxy extends MyProxy
   {
      
      public static const NAME:String = "letvConfigProxy";
      
      private var loader:AutoLoader;
      
      private var adSysMemory:Object;
      
      private var loadLenMemory:int;
      
      private var loadLenObject:Object;
      
      private var pccs:XML;
      
      public const TYPE_PCCS:String = "pccs";
      
      public const TYPE_LOADING:String = "loading";
      
      public function ConfigProxy()
      {
         super(NAME);
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         this.gc(false);
      }
      
      public function load(param1:Object) : void
      {
         var item:String = null;
         var loadingUrl:Object = param1;
         this.gc();
         this.loadLenObject = {};
         var arr:Array = [];
         if(R.flashvars.skinnable)
         {
            this.loadLenObject[this.TYPE_LOADING] = arr.length;
            if(R.flashvars.loadingUrl != null)
            {
               loadingUrl = R.flashvars.loadingUrl;
            }
            if(loadingUrl == null || loadingUrl == "")
            {
               loadingUrl = LoadingAd.URL;
               arr.push({
                  "type":ResourceType.TEXT,
                  "url":loadingUrl,
                  "retryMax":1,
                  "cacheControl":300
               });
            }
            else
            {
               arr.push({
                  "type":ResourceType.FLASH,
                  "url":loadingUrl,
                  "retryMax":1,
                  "checkPolicy":true
               });
            }
         }
         if(R.flashvars.pccsData != null)
         {
            try
            {
               this.pccs = XML(R.flashvars.pccsData);
            }
            catch(e:Error)
            {
               pccs = EmbedConfig.PCCS;
            }
         }
         else if(R.flashvars.pccsUrl != null)
         {
            this.loadLenObject[this.TYPE_PCCS] = arr.length;
            arr.push({
               "type":ResourceType.TEXT,
               "url":R.flashvars.pccsUrl,
               "cacheControl":30,
               "checkPolicy":true
            });
         }
         else
         {
            this.pccs = EmbedConfig.PCCS;
         }
         
         this.loadLenMemory = arr.length;
         var logString:String = "Load Config PCCS " + R.flashvars.pccsUrl + " Len " + this.loadLenMemory;
         for(item in this.loadLenObject)
         {
            logString = logString + (" [" + item + ":" + this.loadLenObject[item] + "]");
         }
         R.log.append(logString);
         if(arr.length > 0)
         {
            this.loader = new AutoLoader(LoadOrderType.LOAD_MULTIPLE);
            this.loader.addEventListener(AutoLoaderEvent.WHOLE_COMPLETE,this.onLoadSystemComplete);
            this.loader.setup(arr);
         }
         else
         {
            this.onLoadSystemComplete();
         }
      }
      
      private function onLoadSystemComplete(param1:AutoLoaderEvent = null) : void
      {
         var media:BaseMedia = null;
         var event:AutoLoaderEvent = param1;
         if(this.loader != null)
         {
            this.loader.removeEventListener(AutoLoaderEvent.WHOLE_COMPLETE,this.onLoadSystemComplete);
         }
         var logstring:String = "Load Config Complete ";
         try
         {
            if(this.loadLenMemory == 0)
            {
               logstring = logstring + "None";
            }
            else
            {
               if(this.loadLenObject.hasOwnProperty(this.TYPE_PCCS))
               {
                  media = event.dataProvider[this.loadLenObject[this.TYPE_PCCS]] as BaseMedia;
                  if(!(media == null) && (media.hadUsed))
                  {
                     try
                     {
                        this.pccs = XML(media.content);
                        logstring = logstring + "[PCCS Loaded] ";
                     }
                     catch(e:Error)
                     {
                        pccs = EmbedConfig.PCCS;
                     }
                  }
                  else
                  {
                     this.pccs = EmbedConfig.PCCS;
                  }
               }
               if(this.loadLenObject.hasOwnProperty(this.TYPE_LOADING))
               {
                  media = event.dataProvider[this.loadLenObject[this.TYPE_LOADING]] as BaseMedia;
                  if(!(media == null) && (media.hadUsed))
                  {
                     logstring = logstring + ("[Loading " + media.resourceType + " Loaded]");
                     if(media.resourceType == ResourceType.FLASH)
                     {
                        this.sendCreationState(media.content.content,media.rect);
                        return;
                     }
                     this.adSysMemory = LoadingAd.parser(media.content);
                     if(this.adSysMemory != null)
                     {
                        R.log.append(logstring);
                        this.loadLoading(this.adSysMemory["source"]);
                        return;
                     }
                  }
               }
            }
         }
         catch(e:Error)
         {
            R.log.append("Config System Loaded Analy Error","error");
         }
         R.log.append(logstring);
         this.onLoadLoadingError();
      }
      
      private function loadLoading(param1:String) : void
      {
         R.log.append("[Load Loading] " + param1);
         this.loader = new AutoLoader();
         this.loader.addEventListener(AutoLoaderEvent.LOAD_ERROR,this.onLoadLoadingError);
         this.loader.addEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.onLoadLoadingComplete);
         this.loader.setup([{
            "type":ResourceType.FLASH,
            "url":param1,
            "retryMax":1,
            "first":4000,
            "checkPolicy":true
         }]);
      }
      
      private function onLoadLoadingError(param1:* = null) : void
      {
         var _loc2_:MainLoading = null;
         if(param1 != null)
         {
            R.log.append("[Load Loading Error]","error");
         }
         if(R.flashvars.skinnable)
         {
            _loc2_ = new MainLoading();
            this.sendCreationState(_loc2_,new Rectangle(0,0,_loc2_.back.width,_loc2_.back.height));
         }
         else
         {
            this.sendCreationState(null,null);
         }
      }
      
      private function onLoadLoadingComplete(param1:AutoLoaderEvent) : void
      {
         var event:AutoLoaderEvent = param1;
         R.log.append("[Load Loading Success]");
         try
         {
            this.sendCreationState(event.dataProvider.content.content,event.dataProvider.rect);
         }
         catch(e:Error)
         {
            onLoadLoadingError();
         }
      }
      
      private function sendCreationState(param1:Object, param2:Rectangle) : void
      {
         var _loc3_:Object = {};
         _loc3_["pccs"] = this.pccs;
         _loc3_["instance"] = param1;
         _loc3_["rect"] = param2;
         _loc3_["sys"] = this.adSysMemory;
         this.gc(false);
         sendNotification(InitNotify.INIT_PLUGIN,_loc3_);
      }
      
      private function gc(param1:Boolean = true) : void
      {
         if(this.loader != null)
         {
            if(param1)
            {
               this.loader.destroy();
            }
            this.loader.removeEventListener(AutoLoaderEvent.WHOLE_COMPLETE,this.onLoadSystemComplete);
            this.loader.removeEventListener(AutoLoaderEvent.LOAD_ERROR,this.onLoadLoadingError);
            this.loader.removeEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.onLoadLoadingComplete);
            this.loader = null;
         }
      }
   }
}
