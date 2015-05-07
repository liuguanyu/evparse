package com.letv.player.model.proxy
{
   import com.letv.player.facade.MyProxy;
   import com.letv.player.notify.LoadNotify;
   import com.alex.rpc.AutoLoader;
   import com.alex.rpc.events.AutoLoaderEvent;
   import com.alex.rpc.type.ResourceType;
   import com.alex.utils.JSONUtil;
   
   public class FilterProxy extends MyProxy
   {
      
      public static var register:Object = {};
      
      public static const NAME:String = "filterProxy";
      
      private var vid:String;
      
      private var loader:AutoLoader;
      
      private const URL:String = "http://rec.letv.com/curve";
      
      public function FilterProxy(param1:Object = null)
      {
         super(NAME,param1);
      }
      
      public function load(param1:Object) : void
      {
         var key:String = null;
         var url:String = null;
         var value:Object = param1;
         this.vid = value + "";
         if(this.vid == null)
         {
            this.onLoadError();
            return;
         }
         if((register.hasOwnProperty(this.vid)) && !(register[this.vid] == null))
         {
            sendNotification(LoadNotify.FILTER_DATA_OVER,this.analy(register[this.vid]));
            return;
         }
         for(key in register)
         {
            delete register[key];
            true;
         }
         try
         {
            url = this.URL;
            url = url + ("?vid=" + this.vid);
            R.log.append(this + " load " + url);
            this.gc();
            this.loader = new AutoLoader();
            this.loader.addEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.onLoadComplete);
            this.loader.addEventListener(AutoLoaderEvent.LOAD_ERROR,this.onLoadError);
            this.loader.setup([{
               "type":ResourceType.TEXT,
               "url":url
            }]);
         }
         catch(e:Error)
         {
            onLoadError(e.message);
         }
      }
      
      private function onLoadComplete(param1:AutoLoaderEvent) : void
      {
         var result:Object = null;
         var obj:Object = null;
         var event:AutoLoaderEvent = param1;
         R.log.append(this + " onLoadComplete " + event.dataProvider.content);
         try
         {
            obj = JSONUtil.decode(String(event.dataProvider.content));
            register[this.vid] = obj;
            this.gc();
            result = this.analy(obj);
         }
         catch(e:Error)
         {
            onLoadError();
            return;
         }
         sendNotification(LoadNotify.FILTER_DATA_OVER,result);
      }
      
      private function onLoadError(param1:* = null) : void
      {
         R.log.append(this + " onLoadError " + param1,"error");
         this.gc();
         facade.removeProxy(NAME);
         sendNotification(LoadNotify.FILTER_DATA_OVER,null);
      }
      
      private function analy(param1:Object) : Object
      {
         if((param1.hasOwnProperty("interval")) && int(param1["interval"]) >= 5 && (param1.hasOwnProperty("values")) && param1["values"] is Array && param1["values"].length > 5)
         {
            return param1;
         }
         return null;
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
      
      override public function onRemove() : void
      {
         super.onRemove();
         this.gc();
      }
   }
}
