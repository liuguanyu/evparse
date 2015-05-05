package cn.pplive.player.model
{
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
   import cn.pplive.player.utils.loader.DisplayLoader;
   import cn.pplive.player.common.VodParser;
   import cn.pplive.player.common.VodPlay;
   import cn.pplive.player.utils.PrintDebug;
   import flash.events.Event;
   import cn.pplive.player.common.VodNotification;
   
   public class VodMarkProxy extends FabricationProxy
   {
      
      public static const NAME:String = "vod_mark_proxy";
      
      private var $lo:DisplayLoader = null;
      
      private var $per:Number;
      
      private var $content = null;
      
      public function VodMarkProxy(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function onRegister() : void
      {
      }
      
      public function initData() : void
      {
         /*
          * Decompilation error
          * Code may be obfuscated
          * Tip: You can try enabling "Automatic deobfuscation" in Settings
          * Error type: NullPointerException (null)
          */
         throw new flash.errors.IllegalOperationError("Not decompiled due to error");
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
               sendNotification(VodNotification.VOD_MARK,{"content":this.$lo.content});
               break;
         }
      }
   }
}
