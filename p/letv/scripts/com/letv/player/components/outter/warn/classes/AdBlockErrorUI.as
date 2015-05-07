package com.letv.player.components.outter.warn.classes
{
   import com.letv.player.components.outter.warn.BaseWarnPopup;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import com.alex.utils.BrowserUtil;
   import com.letv.pluginsAPI.pay.Pay;
   
   public class AdBlockErrorUI extends BaseWarnPopup
   {
      
      public function AdBlockErrorUI(param1:Object = null)
      {
         super(param1);
      }
      
      override protected function onAddedToStage(param1:Event = null) : void
      {
         if(skin.skipAd != null)
         {
            skin.skipAd.addEventListener(MouseEvent.CLICK,this.onSkipAd);
         }
         if(skin.clickHere != null)
         {
            skin.clickHere.addEventListener(MouseEvent.CLICK,this.onHelpCenter);
         }
         if(skin.tellUsHere != null)
         {
            skin.tellUsHere.addEventListener(MouseEvent.CLICK,this.onFeedBack);
         }
      }
      
      override protected function onRemovedFromStage(param1:Event = null) : void
      {
         if(skin.skipAd != null)
         {
            skin.skipAd.removeEventListener(MouseEvent.CLICK,this.onSkipAd);
         }
         if(skin.clickHere != null)
         {
            skin.clickHere.removeEventListener(MouseEvent.CLICK,this.onHelpCenter);
         }
         if(skin.tellUsHere != null)
         {
            skin.tellUsHere.removeEventListener(MouseEvent.CLICK,this.onFeedBack);
         }
      }
      
      private function onSkipAd(param1:MouseEvent) : void
      {
         BrowserUtil.openBlankWindow(Pay.PAY_AD_URL + "&from=" + R.coops.typeFrom,stage);
      }
      
      private function onHelpCenter(param1:MouseEvent) : void
      {
         BrowserUtil.openBlankWindow("http://www.letv.com/help/index.html?type=2-8",stage);
      }
      
      private function onFeedBack(param1:MouseEvent) : void
      {
         BrowserUtil.openBlankWindow("http://www.letv.com/help/feedback.html?type=3-7",stage);
      }
   }
}
