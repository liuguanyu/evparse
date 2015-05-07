package com.alex.controls
{
   import com.alex.core.UIComponent;
   import com.greensock.TweenLite;
   import com.alex.surface.ISurface;
   import com.alex.error.SkinError;
   import com.alex.surface.pc.DragBarSurface;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.events.Event;
   import flash.text.TextFieldAutoSize;
   import flash.display.MovieClip;
   
   public class VDragBar extends UIComponent
   {
      
      public static const DRAGBAR_MOVE_SPEED:Number = 0.2;
      
      private var downSliderPoint:Point;
      
      private var downLocalPoint:Point;
      
      private var downTarget:Object;
      
      protected var virtualTrack:Sprite;
      
      protected var s:DragBarSurface;
      
      private var _sliderFlag:Boolean;
      
      private var rect:Rectangle;
      
      private var _percent:Number = 0.5;
      
      private var _tweenAction:Boolean = true;
      
      private const SLIDER_MIN_RECT:uint = 10;
      
      public function VDragBar(param1:MovieClip = null, param2:Boolean = true)
      {
         this.downSliderPoint = new Point(0,0);
         this.downLocalPoint = new Point(0,0);
         if(param1 == null)
         {
            var param1:MovieClip = new Framework_Default_Skin_VDragBar();
         }
         this._sliderFlag = param2;
         super(new DragBarSurface(param1));
      }
      
      override public function destroy() : void
      {
         this.removeListener();
         if(this.s != null)
         {
            this.downTarget = null;
            this.downLocalPoint = null;
            this.downSliderPoint = null;
            TweenLite.killTweensOf(this.s.slider);
            if(this.s.maskTrack != null)
            {
               TweenLite.killTweensOf(this.s.maskTrack);
            }
            this.onTrackUp();
            this.s = null;
         }
         super.destroy();
      }
      
      override public function set surface(param1:ISurface) : void
      {
         if(this.s != null)
         {
            throw new SkinError("该组件不支持动态修改皮肤",SkinError.SKIN_SET_ERROR);
         }
         else
         {
            super.surface = param1;
            this.s = surface as DragBarSurface;
            this.renderer();
            return;
         }
      }
      
      public function set percent(param1:Number) : void
      {
         if(isNaN(param1))
         {
            var param1:Number = 0;
         }
         else if(param1 < 0)
         {
            param1 = 0;
         }
         else if(param1 > 1)
         {
            param1 = 1;
         }
         
         
         this._percent = param1;
         this.renderPercent();
      }
      
      public function get percent() : Number
      {
         return this._percent;
      }
      
      public function set sliderPercent(param1:Number) : void
      {
         if((isNaN(param1)) || param1 < 0)
         {
            return;
         }
         if(param1 > 1)
         {
            var param1:Number = 1;
         }
         param1 = this.s.track.height * param1;
         if(param1 < this.SLIDER_MIN_RECT)
         {
            param1 = this.SLIDER_MIN_RECT;
         }
         this.sliderHeight = param1;
         this.renderPercent();
      }
      
      override public function set height(param1:Number) : void
      {
         this.s.track.height = param1;
         this.virtualTrack.graphics.clear();
         this.virtualTrack.graphics.beginFill(0,0);
         this.virtualTrack.graphics.drawRect(0,0,this.s.track.width,this.s.track.height);
         this.virtualTrack.graphics.endFill();
         this.renderPercent();
      }
      
      public function set tweenAction(param1:Boolean) : void
      {
         this._tweenAction = param1;
      }
      
      public function get tweenAction() : Boolean
      {
         return this._tweenAction;
      }
      
      override public function get height() : Number
      {
         return this.virtualTrack.height;
      }
      
      protected function get useTrackHei() : Number
      {
         if(this._sliderFlag)
         {
            return this.virtualTrack.height - this.s.slider.height;
         }
         return this.virtualTrack.height;
      }
      
      override protected function renderer() : void
      {
         super.renderer();
         this.s.slider.buttonMode = true;
         this.virtualTrack = new Sprite();
         this.virtualTrack.graphics.clear();
         this.virtualTrack.graphics.beginFill(16711680,0);
         this.virtualTrack.graphics.drawRect(0,0,this.s.track.width,this.s.track.height);
         this.virtualTrack.graphics.endFill();
         this.virtualTrack.x = this.s.track.x;
         this.virtualTrack.y = this.s.track.y;
         skin.addChild(this.virtualTrack);
         skin.addChild(this.s.slider);
         if(this.s.sliderOver != null)
         {
            this.s.sliderOver.visible = false;
            this.s.sliderOver.mouseEnabled = false;
            this.s.sliderOver.mouseChildren = false;
            skin.addChild(this.s.sliderOver);
         }
         if(this.s.maskTrack != null)
         {
            this.s.maskTrack.mouseEnabled = false;
            this.s.maskTrack.mouseChildren = false;
         }
         this.rect = new Rectangle(this.s.slider.x,this.s.track.y,0,this.useTrackHei);
         this.addListener();
         this._percent = 0;
         this.renderPercent(false);
      }
      
      protected function set sliderY(param1:Number) : void
      {
         this.s.slider.y = param1;
         if(this.s.sliderOver != null)
         {
            this.s.sliderOver.y = param1;
         }
      }
      
      protected function set sliderHeight(param1:Number) : void
      {
         this.s.slider.height = param1;
         if(this.s.sliderOver != null)
         {
            this.s.sliderOver.height = param1;
         }
      }
      
      private function addListener() : void
      {
         this.s.slider.addEventListener(MouseEvent.MOUSE_DOWN,this.onSliderDown);
         this.s.slider.addEventListener(MouseEvent.ROLL_OVER,this.onSliderOver);
         this.s.slider.addEventListener(MouseEvent.ROLL_OUT,this.onSliderOut);
         this.virtualTrack.addEventListener(MouseEvent.MOUSE_DOWN,this.onTrackDown);
         this.virtualTrack.addEventListener(MouseEvent.ROLL_OVER,this.onTrackOver);
         this.virtualTrack.addEventListener(MouseEvent.ROLL_OUT,this.onTrackOut);
      }
      
      protected function onSliderOver(param1:MouseEvent) : void
      {
         if(this.s.sliderOver != null)
         {
            this.s.sliderOver.visible = true;
         }
      }
      
      protected function onSliderOut(param1:MouseEvent) : void
      {
         if(this.s.sliderOver != null)
         {
            this.s.sliderOver.visible = false;
         }
      }
      
      protected function onTrackOver(param1:MouseEvent) : void
      {
      }
      
      protected function onTrackOut(param1:MouseEvent) : void
      {
      }
      
      private function removeListener() : void
      {
         this.s.slider.removeEventListener(MouseEvent.MOUSE_DOWN,this.onSliderDown);
         this.s.slider.removeEventListener(MouseEvent.ROLL_OVER,this.onSliderOver);
         this.s.slider.removeEventListener(MouseEvent.ROLL_OUT,this.onSliderOut);
         this.virtualTrack.removeEventListener(MouseEvent.MOUSE_DOWN,this.onTrackDown);
         this.virtualTrack.removeEventListener(MouseEvent.ROLL_OVER,this.onTrackOver);
         this.virtualTrack.removeEventListener(MouseEvent.ROLL_OUT,this.onTrackOut);
         if(stage != null)
         {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onTrackMove);
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.onTrackUp);
         }
      }
      
      protected function onSliderDown(param1:MouseEvent) : void
      {
         this.downTarget = param1.currentTarget;
         this.downLocalPoint = skin.globalToLocal(new Point(param1.stageX,param1.stageY));
         this.downSliderPoint = new Point(this.s.slider.x,this.s.slider.y);
         this.rect = new Rectangle(this.s.slider.x,0,0,this.useTrackHei);
         if(stage != null)
         {
            stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onTrackMove);
            stage.addEventListener(MouseEvent.MOUSE_UP,this.onTrackUp);
         }
         dispatchEvent(new Event("dragStart"));
      }
      
      protected function onTrackDown(param1:MouseEvent) : void
      {
         this.downTarget = param1.currentTarget;
         if(stage != null)
         {
            stage.addEventListener(MouseEvent.MOUSE_UP,this.onTrackUp);
         }
         dispatchEvent(new Event("dragStart"));
      }
      
      protected function onTrackMove(param1:MouseEvent) : void
      {
         var _loc2_:Point = skin.globalToLocal(new Point(param1.stageX,param1.stageY));
         var _loc3_:Number = _loc2_.y - this.downLocalPoint.y;
         var _loc4_:Number = this.downSliderPoint.y + _loc3_;
         if(_loc4_ < this.rect.y)
         {
            this.sliderY = this.rect.y;
         }
         else if(_loc4_ > this.rect.y + this.rect.height)
         {
            this.sliderY = this.rect.y + this.rect.height;
         }
         else
         {
            this.sliderY = _loc4_;
         }
         
         if(this.s.maskTrack != null)
         {
            this.s.maskTrack.height = this.s.slider.y - this.virtualTrack.y;
         }
         this._percent = (this.s.slider.y - this.virtualTrack.y) / this.useTrackHei;
         if(this._percent < 0)
         {
            this._percent = 0;
         }
         else if(this._percent > 1)
         {
            this._percent = 1;
         }
         
         this.sendChange();
      }
      
      protected function onTrackUp(param1:MouseEvent = null) : void
      {
         if(stage != null)
         {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onTrackMove);
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.onTrackUp);
         }
         var _loc2_:Number = this.s.slider.y;
         if(this.downTarget == this.virtualTrack)
         {
            _loc2_ = skin.mouseY;
            if(_loc2_ > this.virtualTrack.y + this.useTrackHei)
            {
               _loc2_ = this.virtualTrack.y + this.useTrackHei;
            }
            else if(_loc2_ < this.virtualTrack.y)
            {
               _loc2_ = this.virtualTrack.y;
            }
            
            if(this.tweenAction)
            {
               TweenLite.to(this.s.slider,0.1,{"y":_loc2_});
               if(this.s.sliderOver != null)
               {
                  TweenLite.to(this.s.sliderOver,0.1,{"y":_loc2_});
               }
            }
            else
            {
               this.sliderY = _loc2_;
            }
            if(this.s.maskTrack != null)
            {
               this.s.maskTrack.height = _loc2_ - this.virtualTrack.y;
            }
         }
         this._percent = _loc2_ / this.useTrackHei;
         this.sendChange();
         dispatchEvent(new Event("dragStop"));
      }
      
      protected function sendChange() : void
      {
         if(this.s.label != null)
         {
            this.s.label.text = int(this.percent * 100) + "%";
            this.s.label.autoSize = TextFieldAutoSize.LEFT;
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      protected function renderPercent(param1:Boolean = true) : void
      {
         var _loc2_:Number = this.virtualTrack.y + this.percent * this.useTrackHei;
         if(param1)
         {
            TweenLite.to(this.s.slider,DRAGBAR_MOVE_SPEED,{"y":_loc2_});
            if(this.s.sliderOver != null)
            {
               TweenLite.to(this.s.sliderOver,DRAGBAR_MOVE_SPEED,{"y":_loc2_});
            }
         }
         else
         {
            this.s.slider.y = _loc2_;
            if(this.s.sliderOver != null)
            {
               this.s.sliderOver.y = _loc2_;
            }
         }
         if(this.s.maskTrack != null)
         {
            if((param1) && (this.tweenAction))
            {
               TweenLite.to(this.s.maskTrack,DRAGBAR_MOVE_SPEED,{"height":_loc2_ - this.virtualTrack.y});
            }
            else
            {
               this.s.maskTrack.height = _loc2_ - this.virtualTrack.y;
            }
         }
         if(this.s.label != null)
         {
            this.s.label.text = int(this.percent * 100) + "%";
         }
      }
   }
}
