package cn.pplive.player.model
{
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
   import cn.pplive.player.utils.loader.DisplayLoader;
   import cn.pplive.player.utils.hash.Global;
   import cn.pplive.player.manager.*;
   import cn.pplive.player.common.VodParser;
   import cn.pplive.player.common.VodCommon;
   import cn.pplive.player.utils.PrintDebug;
   import cn.pplive.player.common.VodNotification;
   import flash.events.Event;
   
   public class VodKernelProxy extends FabricationProxy
   {
      
      public static const NAME:String = "vod_kernel_proxy";
      
      private var $lo:DisplayLoader = null;
      
      public function VodKernelProxy(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function onRegister() : void
      {
      }
      
      public function initData() : void
      {
         var _loc1_:String = null;
         if(Global.getInstance()["playmodel"] == "vod")
         {
            _loc1_ = VodParser.vodcore;
         }
         if(Global.getInstance()["playmodel"] == "live")
         {
            _loc1_ = VodParser.livecore.replace(new RegExp("\\[vs\\]","g"),VodCommon.liveVS);
         }
         if(_loc1_ == null)
         {
            PrintDebug.Trace("内核请求不存在......");
            sendNotification(VodNotification.VOD_KERNEL_FAILED);
            return;
         }
         this.$lo = new DisplayLoader(_loc1_);
         this.$lo.addEventListener("_complete_",this.onTargetHandler);
         this.$lo.addEventListener("_ioerror_",this.onTargetHandler);
         this.$lo.addEventListener("_securityerror_",this.onTargetHandler);
         this.$lo.addEventListener("_timeout_",this.onTargetHandler);
         PrintDebug.Trace("内核请求地址  ===>>>  " + _loc1_);
      }
      
      private function onTargetHandler(param1:Event) : void
      {
         switch(param1.type)
         {
            case "_ioerror_":
            case "_securityerror_":
            case "_timeout_":
               this.$lo.clear();
               sendNotification(VodNotification.VOD_KERNEL_FAILED,param1.type);
               break;
            case "_complete_":
               sendNotification(VodNotification.VOD_KERNEL_SUCCESS,{
                  "kernel":this.$lo.content,
                  "version":this.$lo.content["getVersion"](),
                  "playmodel":Global.getInstance()["playmodel"]
               });
               break;
         }
      }
   }
}
