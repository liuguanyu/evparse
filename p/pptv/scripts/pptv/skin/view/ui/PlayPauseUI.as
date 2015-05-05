package pptv.skin.view.ui
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import pptv.skin.view.events.SkinEvent;
   
   public class PlayPauseUI extends MovieClip
   {
      
      public var PlayBtn:SimpleButton;
      
      public var PauseBtn:SimpleButton;
      
      private var _playbtn:SimpleButton;
      
      private var _pausebtn:SimpleButton;
      
      public function PlayPauseUI()
      {
         super();
         this._playbtn = this.getChildByName("PlayBtn") as SimpleButton;
         this._pausebtn = this.getChildByName("PauseBtn") as SimpleButton;
         this._playbtn.addEventListener(MouseEvent.CLICK,this.onClickHandler);
         this._pausebtn.addEventListener(MouseEvent.CLICK,this.onClickHandler);
         this.playstate = "paused";
      }
      
      private function onClickHandler(param1:MouseEvent) : void
      {
         switch(param1.currentTarget)
         {
            case this._playbtn:
               this.dispatchEvent(new SkinEvent(SkinEvent.MEDIA_PLAY));
               break;
            case this._pausebtn:
               this.dispatchEvent(new SkinEvent(SkinEvent.MEDIA_PAUSE));
               break;
         }
      }
      
      public function set playstate(param1:String) : void
      {
         if(param1 == "playing")
         {
            this._playbtn.visible = false;
            this._pausebtn.visible = true;
         }
         else
         {
            this._playbtn.visible = true;
            this._pausebtn.visible = false;
         }
      }
   }
}
