package com.letv.player.components.outter.warn.classes
{
   import com.letv.player.components.outter.warn.BaseWarnPopup;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import com.letv.player.components.outter.warn.OutterWarnEvent;
   
   public class BlackErrorUI extends BaseWarnPopup
   {
      
      public function BlackErrorUI(param1:Object = null)
      {
         super(param1);
      }
      
      override protected function onAddedToStage(param1:Event = null) : void
      {
         super.onAddedToStage(param1);
         if(skin != null)
         {
            if(skin.feedback != null)
            {
               skin.feedback.addEventListener(MouseEvent.CLICK,this.onFeedback);
            }
         }
      }
      
      override protected function onRemovedFromStage(param1:Event = null) : void
      {
         if(skin != null)
         {
            if(skin.feedback != null)
            {
               skin.feedback.removeEventListener(MouseEvent.CLICK,this.onFeedback);
            }
         }
      }
      
      private function onFeedback(param1:MouseEvent) : void
      {
         dispatchEvent(new OutterWarnEvent(OutterWarnEvent.FEEDBACK));
      }
   }
}
