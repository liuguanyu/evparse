package com.letv.player.components.outter.warn.classes
{
   import com.letv.player.components.outter.warn.BaseWarnPopup;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import com.alex.utils.BrowserUtil;
   
   public class AdBlockEnvErrorUI extends BaseWarnPopup
   {
      
      public function AdBlockEnvErrorUI(param1:Object = null)
      {
         super(param1);
      }
      
      override protected function onAddedToStage(param1:Event = null) : void
      {
         if(skin.feedback != null)
         {
            skin.feedback.addEventListener(MouseEvent.CLICK,this.onFeedback);
         }
         if(skin.regular != null)
         {
            skin.regular.addEventListener(MouseEvent.CLICK,this.onRegular);
         }
      }
      
      override protected function onRemovedFromStage(param1:Event = null) : void
      {
         if(skin.feedback != null)
         {
            skin.feedback.removeEventListener(MouseEvent.CLICK,this.onFeedback);
         }
         if(skin.regular != null)
         {
            skin.regular.removeEventListener(MouseEvent.CLICK,this.onRegular);
         }
      }
      
      private function onFeedback(param1:MouseEvent) : void
      {
         BrowserUtil.openBlankWindow("http://www.letv.com/help/feedback.html",stage);
      }
      
      private function onRegular(param1:MouseEvent) : void
      {
         BrowserUtil.openBlankWindow("http://zhifu.letv.com/tobuy/regular?ref=pquad&from=let",stage);
      }
   }
}
