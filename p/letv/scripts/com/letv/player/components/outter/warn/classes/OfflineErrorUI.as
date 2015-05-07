package com.letv.player.components.outter.warn.classes
{
   import com.letv.player.components.outter.warn.BaseWarnPopup;
   
   public class OfflineErrorUI extends BaseWarnPopup
   {
      
      public function OfflineErrorUI(param1:Object = null)
      {
         super(param1);
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         try
         {
            skin.back["mouseEnabled"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
