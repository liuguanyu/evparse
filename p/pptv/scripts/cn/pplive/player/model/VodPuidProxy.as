package cn.pplive.player.model
{
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;
   import cn.pplive.player.utils.loader.DataLoader;
   import flash.net.URLRequest;
   import flash.events.Event;
   import cn.pplive.player.common.VodNotification;
   import cn.pplive.player.manager.*;
   
   public class VodPuidProxy extends FabricationProxy
   {
      
      public static const NAME:String = "vod_puid_proxy";
      
      private var $lo:DataLoader;
      
      public function VodPuidProxy(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function onRegister() : void
      {
      }
      
      public function initData() : void
      {
         this.$lo = new DataLoader(new URLRequest("http://c1.pptv.com/puid/get?format=xml"));
         this.$lo.addEventListener("_complete_",this.onContentHandler);
         this.$lo.addEventListener("_ioerror_",this.onContentHandler);
         this.$lo.addEventListener("_securityerror_",this.onContentHandler);
         this.$lo.addEventListener("_timeout_",this.onContentHandler);
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
               this.$lo.clear();
               sendNotification(VodNotification.VOD_PUID_COMPLETE);
               break;
            case "_complete_":
               try
               {
                  _loc2_ = XML(param1.target.content);
                  _loc3_ = {};
                  _loc3_["value"] = _loc2_.child("value").toString();
                  if(_loc2_.hasOwnProperty("t"))
                  {
                     _loc3_["rlen"] = _loc2_.child("t").toString();
                  }
                  sendNotification(VodNotification.VOD_PUID_COMPLETE,_loc3_);
               }
               catch(evt:Error)
               {
               }
               break;
         }
      }
   }
}
