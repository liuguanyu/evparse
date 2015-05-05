package pptv.skin.view.ui
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import pptv.skin.view.events.SkinEvent;
   
   public class SoundChangeUI extends MovieClip
   {
      
      public var soundDotMc:MovieClip;
      
      public var soundSliderMc:MovieClip;
      
      public var soundDragBtn:MovieClip;
      
      public var soundsdMc:MovieClip;
      
      public var click:Boolean = false;
      
      private var _soundSlider:MovieClip;
      
      private var _soundSd:MovieClip;
      
      private var _soundDot:MovieClip;
      
      private var _soundDrag:MovieClip;
      
      private var _volumeHeight:Number;
      
      private var _volume:Number;
      
      private var _isMute:Boolean = false;
      
      public function SoundChangeUI()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._soundSlider = this["soundSliderMc"];
         this._soundSd = this["soundsdMc"];
         this._soundDot = this["soundDotMc"];
         this._soundDrag = this["soundDragBtn"];
         this._soundDot.addEventListener(MouseEvent.CLICK,this.onDotClickHandler);
         this._soundSlider.y = this._soundSd.y + this._soundSd.height / 2;
         this._soundSlider.height = this._soundSd.height / 2;
         this._volumeHeight = this._soundSlider.height;
         this._soundDrag.buttonMode = true;
         this._soundDrag.addEventListener(MouseEvent.MOUSE_DOWN,this.onDragHandler);
      }
      
      private function onDragHandler(param1:MouseEvent) : void
      {
         switch(param1.type)
         {
            case MouseEvent.MOUSE_DOWN:
               this._soundDrag.addEventListener(MouseEvent.MOUSE_MOVE,this.onDragHandler);
               this._soundDrag.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onDragHandler);
               this._soundDrag.addEventListener(MouseEvent.MOUSE_UP,this.onDragHandler);
               this._soundDrag.stage.addEventListener(MouseEvent.MOUSE_UP,this.onDragHandler);
               break;
            case MouseEvent.MOUSE_MOVE:
               this._soundDrag.startDrag(false,new Rectangle(this._soundSd.x,this._soundSd.y,0,this._soundSd.height));
               this.setDrag(this._soundDrag.y);
               break;
            case MouseEvent.MOUSE_UP:
               this._soundDrag.stopDrag();
               this.setDrag(this._soundDrag.y);
               this._soundDrag.removeEventListener(MouseEvent.MOUSE_MOVE,this.onDragHandler);
               this._soundDrag.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onDragHandler);
               this._soundDrag.removeEventListener(MouseEvent.MOUSE_UP,this.onDragHandler);
               this._soundDrag.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onDragHandler);
               break;
         }
      }
      
      private function onDotClickHandler(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         this.setDrag(this.mouseY);
      }
      
      private function setDrag(param1:Number) : void
      {
         this._isMute = false;
         this.click = true;
         if(param1 > this._soundSd.y + this._soundSd.height)
         {
            this._soundSlider.height = 0;
            this._soundSlider.y = this._soundSd.y + this._soundSd.height;
            this.setSound(0);
         }
         else if(param1 < this._soundSd.y)
         {
            this._soundSlider.height = this._soundSd.height;
            this._soundSlider.y = this._soundSd.y;
            this._volumeHeight = this._soundSlider.height;
            this.setSound(this._volumeHeight);
         }
         else
         {
            this._soundSlider.height = this._soundSd.height - (param1 - this._soundSd.y);
            this._soundSlider.y = this._soundSd.y + (param1 - this._soundSd.y);
            this._volumeHeight = this._soundSlider.height;
            this.setSound(this._volumeHeight);
         }
         
         this.click = false;
      }
      
      public function setSlider(param1:Number) : void
      {
         if(param1 == 0)
         {
            this._soundSlider.height = 0;
         }
         else if(param1 > 0 && param1 <= 100)
         {
            this._soundSlider.height = param1 / 100 * this._soundSd.height;
            this._volumeHeight = this._soundSlider.height;
         }
         else
         {
            this._soundSlider.height = this._soundSd.height;
            this._volumeHeight = this._soundSlider.height;
         }
         
         this._soundSlider.y = this._soundSd.y + (this._soundSd.height - this._soundSlider.height);
         this._soundDrag.y = this._soundSlider.y;
      }
      
      public function setSound(param1:Number) : void
      {
         this._volume = Math.round(param1 / this._soundSd.height * 100);
         this._soundSlider.height = param1;
         this._soundSlider.y = this._soundSd.y + (this._soundSd.height - this._soundSlider.height);
         this._soundDrag.y = this._soundSlider.y;
         this.dispatchEvent(new SkinEvent(SkinEvent.MEDIA_SOUND,{
            "value":this._volume,
            "click":this.click
         }));
      }
      
      public function get volumeHeight() : Number
      {
         return this._volumeHeight;
      }
      
      public function set isMute(param1:Boolean) : void
      {
         this._isMute = param1;
      }
      
      public function get soundDrag() : MovieClip
      {
         return this._soundDrag;
      }
   }
}
