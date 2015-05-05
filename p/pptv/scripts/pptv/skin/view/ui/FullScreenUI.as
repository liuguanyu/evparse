package pptv.skin.view.ui
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   
   public class FullScreenUI extends MovieClip
   {
      
      public var NormalBtn:SimpleButton;
      
      public var FullscreenBtn:SimpleButton;
      
      private var _fullscreenbtn:SimpleButton;
      
      private var _normalbtn:SimpleButton;
      
      public function FullScreenUI()
      {
         super();
         this._fullscreenbtn = this.getChildByName("FullscreenBtn") as SimpleButton;
         this._normalbtn = this.getChildByName("NormalBtn") as SimpleButton;
         this.addEventListener(MouseEvent.CLICK,this.onClickHandler);
      }
      
      private function onClickHandler(param1:MouseEvent) : void
      {
         try
         {
            if(stage.displayState == "fullScreen")
            {
               stage.displayState = "normal";
               this.setDisplayState(false);
            }
            else
            {
               stage.displayState = "fullScreen";
               this.setDisplayState(true);
            }
         }
         catch(evt:Error)
         {
         }
      }
      
      public function setDisplayState(param1:Boolean) : void
      {
         if(param1)
         {
            this._fullscreenbtn.visible = false;
            this._normalbtn.visible = true;
         }
         else
         {
            this._fullscreenbtn.visible = true;
            this._normalbtn.visible = false;
         }
      }
   }
}
