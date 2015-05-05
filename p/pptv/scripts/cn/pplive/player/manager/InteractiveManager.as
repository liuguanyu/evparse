package cn.pplive.player.manager
{
   import cn.pplive.player.common.VodCommon;
   import flash.external.ExternalInterface;
   import cn.pplive.player.utils.PrintDebug;
   import cn.pplive.player.utils.hash.Global;
   import cn.pplive.player.events.PPLiveEvent;
   
   public class InteractiveManager extends Object
   {
      
      public function InteractiveManager()
      {
         super();
      }
      
      public static function callEvent(param1:String, param2:Function) : void
      {
         if(VodCommon.allowInteractive == "always")
         {
            try
            {
               ExternalInterface.addCallback(param1,param2);
               PrintDebug.Trace("注册供 JS 调用方法：" + param1);
            }
            catch(evt:Error)
            {
            }
         }
      }
      
      public static function sendEvent(param1:String, ... rest) : void
      {
         var cn:String = null;
         var evt:String = param1;
         if(VodCommon.allowInteractive == "always")
         {
            try
            {
               cn = Global.getInstance()["api"]?Global.getInstance()["api"] + "." + evt:evt;
               rest.unshift(cn);
               ExternalInterface.call.apply(null,rest);
            }
            catch(evt:Error)
            {
            }
         }
         if(VodCommon.allowInteractive == "always")
         {
            if(Global.getInstance()["facade"])
            {
               Global.getInstance()["facade"].dispatchEvent(new PPLiveEvent(evt,rest));
            }
            if(evt != "onProgressChanged")
            {
               try
               {
                  if(rest[1]["header"]["type"] != "position")
                  {
                     PrintDebug.Trace("调用 JS 方法或抛出事件类型" + evt + "   携带参数：",rest);
                  }
               }
               catch(e:Error)
               {
                  PrintDebug.Trace("调用 JS 方法或抛出事件类型" + evt + "   携带参数：",rest);
               }
            }
            if(evt != "onProgressChanged")
            {
               return;
            }
            return;
         }
         if(Global.getInstance()["facade"])
         {
            Global.getInstance()["facade"].dispatchEvent(new PPLiveEvent(evt,rest));
         }
         if(evt != "onProgressChanged")
         {
            if(rest[1]["header"]["type"] != "position")
            {
               PrintDebug.Trace("调用 JS 方法或抛出事件类型" + evt + "   携带参数：",rest);
            }
         }
      }
   }
}
