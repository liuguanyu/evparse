package pptv.skin.view.ui
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import pptv.skin.view.events.SkinEvent;
   
   public class BarrageUI extends MovieClip
   {
      
      public var OpenBtn:SimpleButton;
      
      public var CloseBtn:SimpleButton;
      
      private var _openbtn:SimpleButton;
      
      private var _closebtn:SimpleButton;
      
      private var _display:Boolean = false;
      
      private var _click:Boolean = false;
      
      public function BarrageUI()
      {
         super();
         this._openbtn = this.getChildByName("OpenBtn") as SimpleButton;
         this._closebtn = this.getChildByName("CloseBtn") as SimpleButton;
         this.setBarrage(this._display);
         this.addEventListener(MouseEvent.CLICK,this.onClickHandler);
      }
      
      private function onClickHandler(param1:MouseEvent) : void
      {
         this._click = true;
         this.setBarrage(!this._display);
         this._click = false;
      }
      
      public function setBarrage(param1:Boolean) : void
      {
         this._display = param1;
         if(this._display)
         {
            this._openbtn.visible = true;
            this._closebtn.visible = false;
         }
         else
         {
            this._openbtn.visible = false;
            this._closebtn.visible = true;
         }
         this.dispatchEvent(new SkinEvent(SkinEvent.MEDIA_BARRAGE,{
            "display":this._display,
            "click":this._click
         }));
      }
   }
}
