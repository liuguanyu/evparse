package com.letv.player.components.outter.warn.classes
{
   import com.letv.player.components.outter.warn.BaseWarnPopup;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import com.letv.player.components.outter.warn.OutterWarnEvent;
   
   public class OtherErrorUI extends BaseWarnPopup
   {
      
      public function OtherErrorUI(param1:Object = null)
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
      
      override protected function onAddedToStage(param1:Event = null) : void
      {
         if(skin != null)
         {
            if(skin.refresh != null)
            {
               skin.refresh.addEventListener(MouseEvent.CLICK,this.onRefresh);
            }
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
            if(skin.refresh != null)
            {
               skin.refresh.removeEventListener(MouseEvent.CLICK,this.onRefresh);
            }
            if(skin.feedback != null)
            {
               skin.feedback.removeEventListener(MouseEvent.CLICK,this.onFeedback);
            }
         }
      }
      
      private function onRefresh(param1:MouseEvent) : void
      {
         dispatchEvent(new OutterWarnEvent(OutterWarnEvent.REFRESH));
      }
      
      private function onFeedback(param1:MouseEvent) : void
      {
         dispatchEvent(new OutterWarnEvent(OutterWarnEvent.FEEDBACK));
      }
   }
}
