package com.letv.plugins.kernel.controller.auth.pay
{
   import flash.events.EventDispatcher;
   import com.adobe.crypto.MD5;
   import com.alex.rpc.AutoLoader;
   import com.alex.rpc.events.AutoLoaderEvent;
   import com.letv.plugins.kernel.Kernel;
   import com.alex.rpc.type.ResourceType;
   import com.letv.plugins.kernel.controller.LoadEvent;
   import com.alex.utils.JSONUtil;
   
   public class LetvPayAuth extends EventDispatcher
   {
      
      public static const KEY:String = "f8da39f11dbdafc03efa1ad0250c9ae6";
      
      public static const URL:String = "http://yuanxian.letv.com/letv/getService.ldo?from=play&end=5&termid=1";
      
      private var _loader:AutoLoader;
      
      public function LetvPayAuth()
      {
         super();
      }
      
      public function destroy() : void
      {
         this.gc();
      }
      
      public function start(param1:Object) : void
      {
         var url:String = null;
         var info:Object = param1;
         this.gc();
         if(info != null)
         {
            try
            {
               url = URL;
               url = url + ("&pid=" + info.pid);
               url = url + ("&userid=" + info.uid);
               url = url + ("&ispay=" + info.ispay);
               url = url + ("&sign=" + MD5.hash(info.pid + KEY + info.uid));
               if(info.hasOwnProperty("platfrom"))
               {
                  url = url + ("&platfrom=" + info.platfrom);
               }
               if(info.hasOwnProperty("platuid"))
               {
                  url = url + ("&platuid=" + info.platuid);
               }
               this._loader = new AutoLoader();
               this._loader.addEventListener(AutoLoaderEvent.LOAD_ERROR,this.onLoadError);
               this._loader.addEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.onLoadComplete);
               Kernel.sendLog(this + " start " + url);
               this._loader.setup([{
                  "type":ResourceType.TEXT,
                  "url":url,
                  "cacheControl":30
               }]);
            }
            catch(e:Error)
            {
               onLoadError(e.message);
            }
         }
         else
         {
            this.onLoadError();
         }
         if(info != null)
         {
            return;
         }
      }
      
      private function onLoadComplete(param1:AutoLoaderEvent) : void
      {
         var obj:Object = null;
         var event:AutoLoaderEvent = param1;
         try
         {
            Kernel.sendLog(this + " onLoadComplete " + event.dataProvider.content);
            obj = JSONUtil.decode(String(event.dataProvider.content));
            if(obj.hasOwnProperty("error"))
            {
               this.onLoadError("pay return error");
               return;
            }
         }
         catch(e:Error)
         {
            onLoadError(e.message);
            return;
         }
         this.gc();
         var ev:LoadEvent = new LoadEvent(LoadEvent.LOAD_COMPLETE);
         ev.dataProvider = obj;
         dispatchEvent(ev);
      }
      
      private function onLoadError(param1:* = null) : void
      {
         this.gc();
         if(!(param1 == null) && param1 is AutoLoaderEvent)
         {
            Kernel.sendLog(this + " onLoadError " + "errorCode:" + param1.errorCode);
         }
         else
         {
            Kernel.sendLog(this + " onLoadError " + param1);
         }
         dispatchEvent(new LoadEvent(LoadEvent.LOAD_ERROR));
      }
      
      private function gc() : void
      {
         if(this._loader != null)
         {
            this._loader.removeEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.onLoadComplete);
            this._loader.removeEventListener(AutoLoaderEvent.LOAD_ERROR,this.onLoadError);
            this._loader.destroy();
            this._loader = null;
         }
      }
   }
}
