package com.letv.player.components.outter.warn.classes
{
   import com.letv.player.components.outter.warn.BaseWarnPopup;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import com.alex.utils.BrowserUtil;
   
   public class CNErrorUI extends BaseWarnPopup
   {
      
      public function CNErrorUI(param1:Object = null)
      {
         super(param1);
      }
      
      override protected function onAddedToStage(param1:Event = null) : void
      {
         super.onAddedToStage(param1);
         if(skin.letv != null)
         {
            skin.letv.addEventListener(MouseEvent.CLICK,this.onLetv);
         }
      }
      
      override protected function onRemovedFromStage(param1:Event = null) : void
      {
         super.onRemovedFromStage(param1);
         if(skin.letv != null)
         {
            skin.letv.removeEventListener(MouseEvent.CLICK,this.onLetv);
         }
      }
      
      private function onLetv(param1:MouseEvent) : void
      {
         BrowserUtil.openBlankWindow("http://www.letv.com",stage);
      }
   }
}
