package com.letv.player.components.outter.warn.classes
{
   import com.letv.player.components.outter.warn.BaseWarnPopup;
   
   public class OverSeaErrorUI extends BaseWarnPopup
   {
      
      public function OverSeaErrorUI(param1:Object = null)
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
