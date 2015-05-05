package cn.pplive.player.model
{
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
   import cn.pplive.player.utils.loader.DisplayLoader;
   import cn.pplive.player.common.VodCommon;
   import cn.pplive.player.utils.PrintDebug;
   import flash.events.Event;
   import cn.pplive.player.common.VodNotification;
   
   public class VodSmartProxy extends FabricationProxy
   {
      
      public static const NAME:String = "vod_smart_proxy";
      
      private var $lo:DisplayLoader = null;
      
      public function VodSmartProxy(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function onRegister() : void
      {
      }
      
      public function initData() : void
      {
         if(!VodCommon.smart)
         {
            PrintDebug.Trace("smartclick打点工具请求不存在  ====>>>>");
            return;
         }
         var _loc1_:String = VodCommon.smart;
         PrintDebug.Trace("smartclick打点工具请求  ===>>>  " + _loc1_);
         this.$lo = new DisplayLoader(_loc1_,10);
         this.$lo.addEventListener("_complete_",this.onTargetHandler);
         this.$lo.addEventListener("_ioerror_",this.onTargetHandler);
         this.$lo.addEventListener("_securityerror_",this.onTargetHandler);
         this.$lo.addEventListener("_timeout_",this.onTargetHandler);
      }
      
      private function onTargetHandler(param1:Event) : void
      {
         switch(param1.type)
         {
            case "_ioerror_":
            case "_securityerror_":
            case "_timeout_":
               this.$lo.clear();
               break;
            case "_complete_":
               PrintDebug.Trace("smartclick打点工具请求成功  ====>>>>");
               sendNotification(VodNotification.VOD_SMART,this.$lo.content);
               break;
         }
      }
   }
}
