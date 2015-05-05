package pptv.skin.view.ui
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import pptv.skin.view.events.SkinEvent;
   import flash.display.Loader;
   import flash.net.URLRequest;
   
   public class LogoUI extends MovieClip
   {
      
      public function LogoUI()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.graphics.clear();
         this.graphics.beginFill(0,0);
         this.graphics.drawRect(0,0,70,28);
         this.graphics.endFill();
         this.buttonMode = true;
         this.addEventListener(MouseEvent.CLICK,this.onClickHandler);
      }
      
      private function onClickHandler(param1:MouseEvent) : void
      {
         this.dispatchEvent(new SkinEvent(SkinEvent.MEDIA_LOGO));
      }
      
      public function changeRU(param1:String) : void
      {
         while(this.numChildren > 0)
         {
            this.removeChildAt(0);
         }
         var _loc2_:Loader = new Loader();
         this.addChild(_loc2_);
         try
         {
            _loc2_.load(new URLRequest(param1));
         }
         catch(e:Error)
         {
         }
      }
   }
}
