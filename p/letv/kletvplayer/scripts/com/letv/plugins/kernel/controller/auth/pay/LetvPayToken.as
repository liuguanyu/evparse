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
   
   public class LetvPayToken extends EventDispatcher
   {
      
      public static const KEY:String = "37b335ab693a416082b59904fe542b57";
      
      public static const URL:String = "http://yuanxian.letv.com/letv/getService.ldo?from=token";
      
      private var _loader:AutoLoader;
      
      public function LetvPayToken()
      {
         super();
      }
      
      public function destroy() : void
      {
         this.gc();
      }
      
      public function start(param1:Object) : void
      {
         this.gc();
         var _loc2_:String = URL;
         _loc2_ = _loc2_ + ("&pid=" + param1.pid);
         _loc2_ = _loc2_ + ("&userid=" + param1.uid);
         _loc2_ = _loc2_ + ("&storepath=" + param1.storepath);
         _loc2_ = _loc2_ + ("&sign=" + MD5.hash(param1.pid + KEY + param1.uid + param1.storepath));
         this._loader = new AutoLoader();
         this._loader.addEventListener(AutoLoaderEvent.LOAD_ERROR,this.onLoadError);
         this._loader.addEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.onLoadComplete);
         Kernel.sendLog(this + " startPayToken " + _loc2_);
         this._loader.setup([{
            "type":ResourceType.TEXT,
            "url":_loc2_,
            "cacheControl":30
         }]);
      }
      
      private function onLoadComplete(param1:AutoLoaderEvent) : void
      {
         var obj:Object = null;
         var ev:LoadEvent = null;
         var event:AutoLoaderEvent = param1;
         try
         {
            Kernel.sendLog(this + " onLoadComplete " + event.dataProvider.content);
            obj = JSONUtil.decode(String(event.dataProvider.content));
            if((obj.hasOwnProperty("code")) && String(obj["code"]) == "0")
            {
               ev = new LoadEvent(LoadEvent.LOAD_COMPLETE);
               ev.dataProvider = obj.values.token;
               dispatchEvent(ev);
               return;
            }
         }
         catch(e:Error)
         {
         }
         this.gc();
         this.onLoadError();
      }
      
      private function onLoadError(param1:AutoLoaderEvent = null) : void
      {
         this.gc();
         if(param1 != null)
         {
            Kernel.sendLog(this + " onLoadError " + "errorCode:" + param1.errorCode);
         }
         else
         {
            Kernel.sendLog(this + " onLoadError AnalyError");
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
