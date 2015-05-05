package cn.pplive.player.model
{
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
   import cn.pplive.player.utils.loader.DisplayLoader;
   import cn.pplive.player.common.VodParser;
   import cn.pplive.player.utils.PrintDebug;
   import flash.events.Event;
   import cn.pplive.player.common.VodNotification;
   
   public class VodWaterMarkAdvProxy extends FabricationProxy
   {
      
      public static const NAME:String = "vod_markads_proxy";
      
      private var $lo:DisplayLoader = null;
      
      private var $content = null;
      
      public function VodWaterMarkAdvProxy(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function onRegister() : void
      {
      }
      
      public function initData() : void
      {
         if((VodParser.markAdv) && VodParser.markAdv.length > 0)
         {
            this.$lo = new DisplayLoader(VodParser.markAdv,10);
            this.$lo.addEventListener("_complete_",this.onTargetHandler);
            this.$lo.addEventListener("_ioerror_",this.onTargetHandler);
            this.$lo.addEventListener("_securityerror_",this.onTargetHandler);
            this.$lo.addEventListener("_timeout_",this.onTargetHandler);
            PrintDebug.Trace("水印广告打标请求地址  ===>>>  " + VodParser.markAdv);
         }
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
               PrintDebug.Trace("水印广告打标请求成功 >>>>>> ");
               sendNotification(VodNotification.VOD_MARK_ADV,{"content":this.$lo.content});
               break;
         }
      }
   }
}
