package com.letv.player.components.controlBar.classes
{
   import com.letv.player.components.BaseConfigComponent;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import com.letv.player.components.controlBar.events.TrackEvent;
   import flash.geom.Rectangle;
   
   public class TrackUI extends BaseConfigComponent
   {
      
      private var back:MovieClip;
      
      private var playLine:MovieClip;
      
      private var loadLine:MovieClip;
      
      private var _track:Sprite;
      
      private var recordLoad:Number = 0;
      
      private var recordPlay:Number = 0;
      
      public function TrackUI(param1:Object)
      {
         super(param1);
      }
      
      override public function destroy() : void
      {
         this.removeListener();
         this.back = null;
         this.playLine = null;
         this.loadLine = null;
         super.destroy();
      }
      
      public function resize(param1:Object) : void
      {
         if(skin != null)
         {
            this.width = Number(param1);
            if(this.back != null)
            {
               this.back.width = this.width;
            }
            this.loadPercent = this.recordLoad;
            this.playPercent = this.recordPlay;
         }
      }
      
      public function lock() : void
      {
         try
         {
            skin.slider.visible = false;
         }
         catch(e:Error)
         {
         }
         this.removeListener();
      }
      
      public function unlock() : void
      {
         try
         {
            skin.slider.visible = true;
         }
         catch(e:Error)
         {
         }
         this.addListener();
      }
      
      public function set showSlider(param1:Boolean) : void
      {
         if(skin.slider != null)
         {
            skin.slider.visible = param1;
            if(param1 == false)
            {
               skin.slider.x = 0;
            }
         }
      }
      
      override public function set width(param1:Number) : void
      {
         if(this._track != null)
         {
            this._track.graphics.clear();
            this._track.graphics.beginFill(16711680,0);
            this._track.graphics.drawRect(0,0,param1,this.playLine.height);
            this._track.graphics.endFill();
         }
      }
      
      override public function get width() : Number
      {
         if(this._track != null)
         {
            return this._track.width;
         }
         return 0;
      }
      
      override public function get height() : Number
      {
         if(this._track != null)
         {
            return this._track.height;
         }
         return 0;
      }
      
      public function get mousePercent() : Number
      {
         var _loc1_:* = NaN;
         if(this._track != null)
         {
            _loc1_ = this._track.mouseX / this.width;
            if(_loc1_ < 0)
            {
               return 0;
            }
            if(_loc1_ > 1)
            {
               return 1;
            }
            return _loc1_;
         }
         return 0;
      }
      
      public function set playPercent(param1:Number) : void
      {
         if((isNaN(param1)) || param1 < 0)
         {
            var param1:Number = 0;
         }
         if(param1 > 1)
         {
            param1 = 1;
         }
         this.recordPlay = param1;
         param1 = param1 * this.width;
         if(this.playLine != null)
         {
            this.playLine.width = param1;
         }
         if(skin.slider != null)
         {
            skin.slider.x = param1;
         }
      }
      
      public function get playPercent() : Number
      {
         if(this.playLine != null)
         {
            return this.playLine.width / this.width;
         }
         return 0;
      }
      
      public function set loadPercent(param1:Number) : void
      {
         this.recordLoad = param1;
         var param1:Number = param1 * this.width;
         if(this.loadLine != null)
         {
            this.loadLine.width = param1;
         }
      }
      
      public function get loadPercent() : Number
      {
         if(this.loadLine != null)
         {
            return this.loadLine.width / this.width;
         }
         return 0;
      }
      
      public function get track() : Sprite
      {
         return this._track;
      }
      
      public function get sliderX() : uint
      {
         try
         {
            return skin.slider.x;
         }
         catch(e:Error)
         {
         }
         return 0;
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         buttonMode = true;
         this._track = new Sprite();
         addChild(this._track);
         this.back = skin.back;
         this.loadLine = skin.loadLine;
         this.playLine = skin.playLine;
         if(this.back != null)
         {
            this.back.mouseEnabled = false;
            this.back.mouseChildren = false;
         }
         if(this.loadLine != null)
         {
            this.loadLine.mouseEnabled = false;
            this.loadLine.mouseChildren = false;
         }
         if(this.playLine != null)
         {
            this.playLine.mouseEnabled = false;
            this.playLine.mouseChildren = false;
         }
         if(skin.slider != null)
         {
            skin.slider.buttonMode = true;
            skin.slider.cacheAsBitmap = true;
            skin.slider.mouseEnabled = false;
            skin.slider.mouseChildren = false;
            addChild(skin.slider);
         }
         this.addListener();
      }
      
      private function addListener() : void
      {
         if(skin.slider != null)
         {
            skin.slider.addEventListener(MouseEvent.MOUSE_DOWN,this.onDown);
         }
         if(this._track != null)
         {
            this._track.addEventListener(MouseEvent.ROLL_OVER,this.onDragBarOver);
            this._track.addEventListener(MouseEvent.MOUSE_DOWN,this.onDown);
            addEventListener(MouseEvent.ROLL_OUT,this.onDragBarOut);
         }
      }
      
      private function removeListener() : void
      {
         if(skin.slider != null)
         {
            skin.slider.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDown);
         }
         if(this._track != null)
         {
            this._track.removeEventListener(MouseEvent.ROLL_OVER,this.onDragBarOver);
            this._track.removeEventListener(MouseEvent.MOUSE_MOVE,this.onDragBarMove);
            this._track.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDown);
            removeEventListener(MouseEvent.ROLL_OUT,this.onDragBarOut);
         }
         if(stage != null)
         {
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.onUp);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMove);
         }
      }
      
      private function onDragBarOver(param1:MouseEvent) : void
      {
         this._track.addEventListener(MouseEvent.MOUSE_MOVE,this.onDragBarMove);
         this.sendState(TrackEvent.CHANGE_PREVIEW,true);
      }
      
      private function onDragBarOut(param1:MouseEvent) : void
      {
         this._track.removeEventListener(MouseEvent.MOUSE_MOVE,this.onDragBarMove);
         this.sendState(TrackEvent.CHANGE_PREVIEW,false);
      }
      
      private function onDragBarMove(param1:MouseEvent) : void
      {
         this.sendState(TrackEvent.CHANGE_PREVIEW,true);
      }
      
      private function onDown(param1:MouseEvent) : void
      {
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onUp);
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMove);
         skin.slider.x = skin.mouseX;
         this.onMove();
         if(skin.slider != null)
         {
            skin.slider.startDrag(false,new Rectangle(0,skin.slider.y,this.width,0));
         }
      }
      
      private function onMove(param1:MouseEvent = null) : void
      {
         this.playPercent = skin.slider.x / this.width;
         this.sendState(TrackEvent.CHANGE_TRACK);
      }
      
      public function onUp(param1:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onUp);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMove);
         if(skin.slider != null)
         {
            skin.slider.stopDrag();
         }
         this.onMove();
         this.sendState(TrackEvent.SEEK);
      }
      
      private function sendState(param1:String, param2:Object = null) : void
      {
         var _loc3_:TrackEvent = new TrackEvent(param1);
         _loc3_.dataProvider = param2;
         dispatchEvent(_loc3_);
      }
   }
}
