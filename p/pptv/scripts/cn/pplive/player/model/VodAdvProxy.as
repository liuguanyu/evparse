package cn.pplive.player.model
{
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
   import cn.pplive.player.utils.loader.DisplayLoader;
   import cn.pplive.player.common.VodCommon;
   import cn.pplive.player.common.VodParser;
   import cn.pplive.player.utils.PrintDebug;
   import cn.pplive.player.common.VodNotification;
   import flash.events.Event;
   
   public class VodAdvProxy extends FabricationProxy
   {
      
      public static const NAME:String = "vod_adv_proxy";
      
      private var $lo:DisplayLoader = null;
      
      public function VodAdvProxy(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function onRegister() : void
      {
      }
      
      public function initData() : void
      {
         if((VodCommon.playStr) || (VodCommon.smart) || (VodCommon.priplay))
         {
            VodParser.acb = VodParser.afp = null;
         }
         if(!VodParser.acb || !VodParser.afp)
         {
            PrintDebug.Trace("广告插件 plugin 请求不存在  ===>>>");
            sendNotification(VodNotification.VOD_ADVER_FAILED);
            return;
         }
         var _loc1_:String = VodParser.afp + "?acb=" + VodParser.acb;
         this.$lo = new DisplayLoader(_loc1_,10);
         this.$lo.addEventListener("_complete_",this.onTargetHandler);
         this.$lo.addEventListener("_ioerror_",this.onTargetHandler);
         this.$lo.addEventListener("_securityerror_",this.onTargetHandler);
         this.$lo.addEventListener("_timeout_",this.onTargetHandler);
         PrintDebug.Trace("广告插件 plugin 请求  ===>>>  " + _loc1_);
      }
      
      private function onTargetHandler(param1:Event) : void
      {
         switch(param1.type)
         {
            case "_ioerror_":
            case "_securityerror_":
            case "_timeout_":
               this.$lo.clear();
               sendNotification(VodNotification.VOD_ADVER_FAILED,param1.type);
               break;
            case "_complete_":
               sendNotification(VodNotification.VOD_ADVER_SUCCESS,this.$lo.content);
               break;
         }
      }
   }
}
