package pptv.skin.view.ui
{
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import pptv.skin.view.events.SkinEvent;
   
   public class PlayUI extends SimpleButton
   {
      
      public function PlayUI()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.visible = false;
         this.addEventListener(MouseEvent.CLICK,this.onClickHandler);
      }
      
      private function onClickHandler(param1:MouseEvent) : void
      {
         this.visible = false;
         this.dispatchEvent(new SkinEvent(SkinEvent.MEDIA_PLAY));
      }
   }
}
