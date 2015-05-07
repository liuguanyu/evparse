package com.letv.player.model.proxy
{
   import com.letv.player.facade.MyProxy;
   import com.alex.rpc.type.ResourceType;
   import com.alex.rpc.AutoLoader;
   import com.alex.rpc.events.AutoLoaderEvent;
   import com.letv.player.notify.LoadNotify;
   
   public class PluginSetupProxy extends MyProxy
   {
      
      public static const NAME:String = "pluginSetupProxy";
      
      private var _pluginName:String;
      
      private var _loader:AutoLoader;
      
      public function PluginSetupProxy()
      {
         super(NAME);
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         this.gc(false);
      }
      
      public function loadPlugin(param1:String, param2:String) : void
      {
         R.log.append("[UI V2]PluginSetupProxy Load Plugin " + param2);
         this._pluginName = param1;
         var _loc3_:Object = {
            "type":ResourceType.BINARY,
            "url":param2,
            "first":8000
         };
         this._loader = new AutoLoader();
         this._loader.addEventListener(AutoLoaderEvent.LOAD_ERROR,this.onLoadError);
         this._loader.addEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.onLoadComplete);
         this._loader.setup([_loc3_]);
      }
      
      private function onLoadError(param1:AutoLoaderEvent = null) : void
      {
         R.log.append("[UI V3X]Load Plugin " + this._pluginName + " Error","error");
         sendNotification(LoadNotify.PLUGIN_LOAD_FAILED,{"name":this._pluginName});
      }
      
      private function onLoadComplete(param1:AutoLoaderEvent) : void
      {
         var plugin:Object = null;
         var event:AutoLoaderEvent = param1;
         R.log.append("[UI V3X]Load Plugin " + this._pluginName + " Success");
         try
         {
            plugin = event.dataProvider.content.content;
            this.gc(false);
         }
         catch(e:Error)
         {
            onLoadError();
            return;
         }
         sendNotification(LoadNotify.PLUGIN_LOAD_SUCCESS,{
            "content":plugin,
            "name":this._pluginName
         });
      }
      
      private function gc(param1:Boolean = true) : void
      {
         if(this._loader != null)
         {
            this._loader.removeEventListener(AutoLoaderEvent.LOAD_ERROR,this.onLoadError);
            this._loader.removeEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.onLoadComplete);
            if(param1)
            {
               this._loader.destroy();
            }
            this._loader = null;
         }
      }
   }
}
