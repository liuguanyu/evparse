package com.letv.player.components.outter.warn
{
   import com.letv.player.components.BaseAutoScalePopup;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import com.alex.utils.BrowserUtil;
   
   public class BaseWarnPopup extends BaseAutoScalePopup
   {
      
      public function BaseWarnPopup(param1:Object = null)
      {
         super(param1);
      }
      
      public function set errorCode(param1:String) : void
      {
         var value:String = param1;
         try
         {
            skin.errorCode.text = "< " + value + " >";
         }
         catch(e:Error)
         {
         }
      }
      
      override protected function get stageChanged() : Boolean
      {
         return true;
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         if(skin.back != null)
         {
            skin.back["mouseEnabled"] = false;
         }
      }
      
      override protected function onAddedToStage(param1:Event = null) : void
      {
         if(skin.home != null)
         {
            skin.home.addEventListener(MouseEvent.CLICK,this.onHome);
         }
      }
      
      override protected function onRemovedFromStage(param1:Event = null) : void
      {
         if(skin.home != null)
         {
            skin.home.removeEventListener(MouseEvent.CLICK,this.onHome);
         }
      }
      
      private function onHome(param1:MouseEvent) : void
      {
         BrowserUtil.openSelfWindow("http://www.letv.com/",stage);
      }
   }
}
