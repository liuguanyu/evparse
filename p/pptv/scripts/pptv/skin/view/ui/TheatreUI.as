package pptv.skin.view.ui
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import pptv.skin.view.events.SkinEvent;
   
   public class TheatreUI extends MovieClip
   {
      
      public var UntheatreBtn:SimpleButton;
      
      public var TheatreBtn:SimpleButton;
      
      private var _theatrebtn:SimpleButton;
      
      private var _untheatrebtn:SimpleButton;
      
      private var _mode:Boolean = false;
      
      public function TheatreUI()
      {
         super();
         this._theatrebtn = this.getChildByName("TheatreBtn") as SimpleButton;
         this._untheatrebtn = this.getChildByName("UntheatreBtn") as SimpleButton;
         this.addEventListener(MouseEvent.CLICK,this.onClickHandler);
      }
      
      private function onClickHandler(param1:MouseEvent) : void
      {
         try
         {
            this.setTheatre(!this._mode);
            this.dispatchEvent(new SkinEvent(SkinEvent.MEDIA_THEATRE,{"mode":Number(this._mode)}));
         }
         catch(evt:Error)
         {
         }
      }
      
      public function setTheatre(param1:Boolean) : void
      {
         this._mode = param1;
         this._theatrebtn.visible = !this._mode;
         this._untheatrebtn.visible = this._mode;
      }
   }
}
