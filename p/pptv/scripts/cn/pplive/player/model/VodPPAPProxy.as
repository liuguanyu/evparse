package cn.pplive.player.model
{
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
   import cn.pplive.player.utils.loader.DataLoader;
   import cn.pplive.player.dac.DACNotification;
   import cn.pplive.player.dac.DACCommon;
   import flash.net.URLRequest;
   import cn.pplive.player.utils.PrintDebug;
   import flash.events.Event;
   import cn.pplive.player.manager.*;
   import cn.pplive.player.common.VodNotification;
   
   public class VodPPAPProxy extends FabricationProxy
   {
      
      public static const NAME:String = "vod_ppap_proxy";
      
      private var $lo:DataLoader;
      
      public function VodPPAPProxy(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function onRegister() : void
      {
      }
      
      public function initData() : void
      {
         sendNotification(DACNotification.START_RECORD,null,DACCommon.VST);
         var _loc1_:* = "http://127.0.0.1:9000/synacast.xml";
         this.$lo = new DataLoader(new URLRequest(_loc1_));
         this.$lo.addEventListener("_complete_",this.onContentHandler);
         this.$lo.addEventListener("_ioerror_",this.onContentHandler);
         this.$lo.addEventListener("_securityerror_",this.onContentHandler);
         this.$lo.addEventListener("_timeout_",this.onContentHandler);
         PrintDebug.Trace("ppap插件  请求  ===>>>  " + _loc1_);
      }
      
      private function onContentHandler(param1:Event) : void
      {
         var _loc2_:XML = null;
         var _loc3_:Object = null;
         switch(param1.type)
         {
            case "_ioerror_":
            case "_securityerror_":
            case "_timeout_":
               PrintDebug.Trace("9000端口没有检测到PPAP  ===>>>  ",param1.toString());
               this.$lo.clear();
               break;
            case "_complete_":
               sendNotification(DACNotification.STOP_RECORD,null,DACCommon.VST);
               try
               {
                  PrintDebug.Trace("9000端口检测到PPAP->",param1.target.content);
                  _loc2_ = XML(param1.target.content);
                  if(_loc2_["PPVA"].hasOwnProperty("@k"))
                  {
                     _loc3_ = {"k":_loc2_["PPVA"]["@k"].toString()};
                  }
                  sendNotification(VodNotification.VOD_PPAP,_loc3_);
               }
               catch(evt:Error)
               {
               }
               break;
         }
      }
   }
}
