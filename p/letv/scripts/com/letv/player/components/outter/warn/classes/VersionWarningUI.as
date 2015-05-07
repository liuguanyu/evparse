package com.letv.player.components.outter.warn.classes
{
   import com.letv.player.components.outter.warn.BaseWarnPopup;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import com.alex.utils.BrowserUtil;
   import com.letv.player.components.outter.warn.OutterWarnEvent;
   
   public class VersionWarningUI extends BaseWarnPopup
   {
      
      public function VersionWarningUI(param1:Object = null)
      {
         super(param1);
      }
      
      override protected function onAddedToStage(param1:Event = null) : void
      {
         if(skin.updateBtn != null)
         {
            skin.updateBtn.addEventListener(MouseEvent.CLICK,this.onUpdate);
         }
         if(skin.continueBtn != null)
         {
            skin.continueBtn.addEventListener(MouseEvent.CLICK,this.onContinue);
         }
      }
      
      override protected function onRemovedFromStage(param1:Event = null) : void
      {
         if(skin.updateBtn != null)
         {
            skin.updateBtn.removeEventListener(MouseEvent.CLICK,this.onUpdate);
         }
         if(skin.continueBtn != null)
         {
            skin.continueBtn.removeEventListener(MouseEvent.CLICK,this.onContinue);
         }
      }
      
      private function onUpdate(param1:MouseEvent) : void
      {
         BrowserUtil.openBlankWindow("http://get.adobe.com/cn/flashplayer/",stage);
      }
      
      private function onContinue(param1:MouseEvent) : void
      {
         dispatchEvent(new OutterWarnEvent(OutterWarnEvent.REFRESH));
      }
   }
}
