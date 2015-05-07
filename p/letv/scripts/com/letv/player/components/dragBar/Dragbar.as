package com.letv.player.components.dragBar
{
   import com.letv.player.components.UIComponent;
   import com.greensock.TweenLite;
   import com.letv.player.components.errors.ComponentError;
   import flash.display.Sprite;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.geom.Rectangle;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.display.DisplayObject;
   
   public class Dragbar extends UIComponent
   {
      
      public static const DRAGBAR_MOVE_SPEED:Number = 0.2;
      
      private var downSliderPoint:Point;
      
      private var downLocalPoint:Point;
      
      protected var slider:MovieClip;
      
      protected var track:DisplayObject;
      
      protected var virtualTrack:Sprite;
      
      protected var maskTrack:Sprite;
      
      protected var txt:TextField;
      
      private var _direction:String = "horizontal";
      
      private var _sliderFlag:Boolean;
      
      private var horizontalRect:Rectangle;
      
      private var verticalRect:Rectangle;
      
      private var _percent:Number = 0.5;
      
      private var _tweenAction:Boolean = true;
      
      private var _moveDefaultAction:Boolean = true;
      
      private const SLIDER_MIN_RECT:uint = 5;
      
      public function Dragbar(param1:Object, param2:String = "horizontal", param3:Boolean = false)
      {
         this.downSliderPoint = new Point(0,0);
         this.downLocalPoint = new Point(0,0);
         super(param1);
         this._direction = param2;
         this._sliderFlag = param3;
      }
      
      override public function destroy() : void
      {
         TweenLite.killTweensOf(this.slider);
         TweenLite.killTweensOf(this.maskTrack);
         this.removeListener();
         this.onTrackUp();
         this.slider = null;
         this.track = null;
         this.maskTrack = null;
         this.txt = null;
         super.destroy();
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
         if(skin != null)
         {
            this.renderer();
         }
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
      }
      
      public function get percent() : Number
      {
         return this._percent;
      }
      
      override public function get width() : Number
      {
         return this.virtualTrack.width;
      }
      
      override public function get height() : Number
      {
         return this.virtualTrack.height;
      }
      
      public function set thumbVerticalPercent(param1:Number) : void
      {
         if(this._direction == DragbarDirection.VERTICAL && !(this.track == null) && !(this.slider == null))
         {
            if(param1 < 0)
            {
               this.sliderHeight = 0;
               return;
            }
            var param1:Number = this.track.height * param1;
            if(param1 < 20)
            {
               param1 = 20;
            }
            this.sliderHeight = param1;
            this.renderer();
         }
      }
      
      public function set thumbHorizontalPercent(param1:Number) : void
      {
         if(this._direction == DragbarDirection.HORIZONTAL && !(this.track == null) && !(this.slider == null))
         {
            if(param1 < 0)
            {
               this.sliderWidth = 0;
               return;
            }
            var param1:Number = this.track.width * param1;
            if(param1 < 20)
            {
               param1 = 20;
            }
            this.sliderWidth = param1;
            this.renderer();
         }
      }
      
      public function set width(param1:Number) : void
      {
         skin.track.width = param1;
         this.virtualTrack.graphics.clear();
         this.virtualTrack.graphics.beginFill(16711680,0);
         this.virtualTrack.graphics.drawRect(0,0,skin.track.width,skin.track.height);
         this.virtualTrack.graphics.endFill();
      }
      
      public function set height(param1:Number) : void
      {
         skin.track.height = param1;
         this.virtualTrack.graphics.clear();
         this.virtualTrack.graphics.beginFill(0,0);
         this.virtualTrack.graphics.drawRect(0,0,skin.track.width,skin.track.height);
         this.virtualTrack.graphics.endFill();
      }
      
      public function setEnabled(param1:Boolean) : void
      {
         if(skin)
         {
            if(param1)
            {
               skin.mouseChildren = true;
               skin.mouseEnabled = true;
            }
            else
            {
               skin.mouseChildren = false;
               skin.mouseEnabled = false;
            }
         }
      }
      
      public function set tweenAction(param1:Boolean) : void
      {
         this._tweenAction = param1;
      }
      
      public function get tweenAction() : Boolean
      {
         return this._tweenAction;
      }
      
      public function set moveDefaultAction(param1:Boolean) : void
      {
         this._moveDefaultAction = param1;
      }
      
      public function get moveDefaultAction() : Boolean
      {
         return this._moveDefaultAction;
      }
      
      protected function get useTrackWid() : Number
      {
         if(this._sliderFlag)
         {
            return this.virtualTrack.width - this.slider.width;
         }
         return this.virtualTrack.width;
      }
      
      protected function get useTrackHei() : Number
      {
         if(this._sliderFlag)
         {
            return this.virtualTrack.height - this.slider.height;
         }
         return this.virtualTrack.height;
      }
      
      override protected function init() : void
      {
         if(skin != null)
         {
            this.track = skin.getChildByName("track");
            if(this.track == null)
            {
               throw new ComponentError("[Component DragBarUI Error DragBar Has Not Slider]");
            }
            else
            {
               this.virtualTrack = new Sprite();
               this.virtualTrack.graphics.clear();
               this.virtualTrack.graphics.beginFill(16711680,0);
               this.virtualTrack.graphics.drawRect(0,0,this.track.width,this.track.height);
               this.virtualTrack.graphics.endFill();
               this.virtualTrack.x = this.track.x;
               this.virtualTrack.y = this.track.y;
               this.slider = skin.getChildByName("slider") as MovieClip;
               try
               {
                  skin.sliderOver.visible = false;
                  skin.sliderOver.mouseEnabled = false;
                  skin.sliderOver.mouseChildren = false;
               }
               catch(e:Error)
               {
               }
               if(this.slider != null)
               {
                  this.slider.buttonMode = true;
               }
               else
               {
                  this.slider = new MovieClip();
                  skin.slider = this.slider;
                  skin.addChild(this.slider);
               }
               this.maskTrack = skin.getChildByName("maskTrack") as Sprite;
               if(this.maskTrack != null)
               {
                  this.maskTrack.mouseEnabled = false;
                  this.maskTrack.mouseChildren = false;
               }
               skin.addChild(this.virtualTrack);
               skin.addChild(this.slider);
               try
               {
                  skin.addChild(skin.sliderOver);
               }
               catch(e:Error)
               {
               }
               this.txt = skin.getChildByName("txt") as TextField;
               this.horizontalRect = new Rectangle(this.track.x,this.slider.y,this.useTrackWid,0);
               this.verticalRect = new Rectangle(this.slider.x,this.track.y,0,this.useTrackHei);
               if(this._direction == DragbarDirection.HORIZONTAL)
               {
                  if(this.slider.width < this.SLIDER_MIN_RECT)
                  {
                     this.sliderWidth = this.SLIDER_MIN_RECT;
                  }
               }
               else if(this._direction == DragbarDirection.VERTICAL)
               {
                  if(this.slider.height < this.SLIDER_MIN_RECT)
                  {
                     this.sliderHeight = this.SLIDER_MIN_RECT;
                  }
               }
               
               this.addListener();
            }
         }
      }
      
      protected function set sliderX(param1:Number) : void
      {
         var value:Number = param1;
         try
         {
            this.slider.x = value;
         }
         catch(e:Error)
         {
         }
         try
         {
            skin.sliderOver.x = value;
         }
         catch(e:Error)
         {
         }
      }
      
      protected function set sliderY(param1:Number) : void
      {
         var value:Number = param1;
         try
         {
            this.slider.y = value;
         }
         catch(e:Error)
         {
         }
         try
         {
            skin.sliderOver.y = value;
         }
         catch(e:Error)
         {
         }
      }
      
      protected function set sliderWidth(param1:Number) : void
      {
         var value:Number = param1;
         try
         {
            this.slider.width = value;
         }
         catch(e:Error)
         {
         }
         try
         {
            skin.sliderOver.width = value;
         }
         catch(e:Error)
         {
         }
      }
      
      protected function set sliderHeight(param1:Number) : void
      {
         var value:Number = param1;
         try
         {
            this.slider.height = value;
         }
         catch(e:Error)
         {
         }
         try
         {
            skin.sliderOver.height = value;
         }
         catch(e:Error)
         {
         }
      }
      
      private function addListener() : void
      {
         if(this.slider != null)
         {
            this.slider.addEventListener(MouseEvent.MOUSE_DOWN,this.onSliderDown);
            this.slider.addEventListener(MouseEvent.ROLL_OVER,this.onSliderOver);
            this.slider.addEventListener(MouseEvent.ROLL_OUT,this.onSliderOut);
         }
         this.virtualTrack.addEventListener(MouseEvent.MOUSE_DOWN,this.onTrackDown);
         this.virtualTrack.addEventListener(MouseEvent.ROLL_OVER,this.onTrackOver);
         this.virtualTrack.addEventListener(MouseEvent.ROLL_OUT,this.onTrackOut);
      }
      
      protected function onSliderOver(param1:MouseEvent) : void
      {
         var event:MouseEvent = param1;
         try
         {
            skin.sliderOver.visible = true;
         }
         catch(e:Error)
         {
         }
      }
      
      protected function onSliderOut(param1:MouseEvent) : void
      {
         var event:MouseEvent = param1;
         try
         {
            skin.sliderOver.visible = false;
         }
         catch(e:Error)
         {
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
         if(this.slider != null)
         {
            this.slider.removeEventListener(MouseEvent.MOUSE_DOWN,this.onSliderDown);
            this.slider.removeEventListener(MouseEvent.ROLL_OVER,this.onSliderOver);
            this.slider.removeEventListener(MouseEvent.ROLL_OUT,this.onSliderOut);
         }
         this.virtualTrack.removeEventListener(MouseEvent.MOUSE_DOWN,this.onTrackDown);
         this.virtualTrack.removeEventListener(MouseEvent.ROLL_OVER,this.onTrackOver);
         this.virtualTrack.removeEventListener(MouseEvent.ROLL_OUT,this.onTrackOut);
         if(this.virtualTrack.stage)
         {
            this.virtualTrack.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onTrackMove);
            this.virtualTrack.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onTrackUp);
         }
      }
      
      protected function onSliderDown(param1:MouseEvent) : void
      {
         this.downLocalPoint = skin.globalToLocal(new Point(param1.stageX,param1.stageY));
         this.downSliderPoint = new Point(this.slider.x,this.slider.y);
         if(this._direction == DragbarDirection.HORIZONTAL)
         {
            this.horizontalRect = new Rectangle(0,this.slider.y,this.useTrackWid,0);
         }
         else
         {
            this.verticalRect = new Rectangle(this.slider.x,0,0,this.useTrackHei);
         }
         skin.drag = true;
         this.slider.drag = true;
         if(this.virtualTrack.stage != null)
         {
            this.virtualTrack.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onTrackMove);
            this.virtualTrack.stage.addEventListener(MouseEvent.MOUSE_UP,this.onTrackUp);
         }
      }
      
      protected function onTrackDown(param1:MouseEvent) : void
      {
         if(this.virtualTrack.stage)
         {
            this.virtualTrack.stage.addEventListener(MouseEvent.MOUSE_UP,this.onTrackUp);
         }
      }
      
      protected function onTrackMove(param1:MouseEvent) : void
      {
         var _loc3_:* = NaN;
         var _loc4_:* = NaN;
         var _loc5_:* = NaN;
         var _loc6_:* = NaN;
         var _loc2_:Point = skin.globalToLocal(new Point(param1.stageX,param1.stageY));
         if(this._direction == DragbarDirection.HORIZONTAL)
         {
            _loc3_ = _loc2_.x - this.downLocalPoint.x;
            _loc4_ = this.downSliderPoint.x + _loc3_;
            if(_loc4_ < this.horizontalRect.x)
            {
               this.sliderX = this.horizontalRect.x;
            }
            else if(_loc4_ > this.horizontalRect.x + this.horizontalRect.width)
            {
               this.sliderX = this.horizontalRect.x + this.horizontalRect.width;
            }
            else
            {
               this.sliderX = _loc4_;
            }
            
            if(skin.maskTrack != null)
            {
               skin.maskTrack.width = this.slider.x - this.virtualTrack.x;
            }
            this._percent = (this.slider.x - this.virtualTrack.x) / this.useTrackWid;
         }
         else if(this._direction == DragbarDirection.VERTICAL)
         {
            _loc5_ = _loc2_.y - this.downLocalPoint.y;
            _loc6_ = this.downSliderPoint.y + _loc5_;
            if(_loc6_ < this.verticalRect.y)
            {
               this.sliderY = this.verticalRect.y;
            }
            else if(_loc6_ > this.verticalRect.y + this.verticalRect.height)
            {
               this.sliderY = this.verticalRect.y + this.verticalRect.height;
            }
            else
            {
               this.sliderY = _loc6_;
            }
            
            if(skin.maskTrack != null)
            {
               skin.maskTrack.height = this.slider.y - this.virtualTrack.y;
            }
            this._percent = (this.slider.y - this.virtualTrack.y) / this.useTrackHei;
         }
         
         if(this._percent < 0)
         {
            this._percent = 0;
         }
         if(this._percent > 1)
         {
            this._percent = 1;
         }
         if(this._moveDefaultAction)
         {
            this.sendChange();
         }
      }
      
      protected function onTrackUp(param1:MouseEvent = null) : void
      {
         if(this.virtualTrack.stage)
         {
            this.virtualTrack.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onTrackMove);
            this.virtualTrack.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onTrackUp);
         }
         var _loc2_:Number = 0;
         if(this._direction == DragbarDirection.HORIZONTAL)
         {
            if(!this.slider.hasOwnProperty("drag") || this.slider.drag == false)
            {
               _loc2_ = skin.mouseX;
               if(_loc2_ > this.virtualTrack.x + this.useTrackWid)
               {
                  _loc2_ = this.virtualTrack.x + this.useTrackWid;
               }
               else if(_loc2_ < this.virtualTrack.x)
               {
                  _loc2_ = this.virtualTrack.x;
               }
               
               if(this.tweenAction)
               {
                  TweenLite.to(this.slider,0.1,{"x":_loc2_});
                  if(skin.sliderOver != null)
                  {
                     TweenLite.to(skin.sliderOver,0.1,{"x":_loc2_});
                  }
               }
               else
               {
                  this.sliderX = _loc2_;
               }
            }
            else
            {
               _loc2_ = this.virtualTrack.x + this.slider.x;
            }
            this._percent = _loc2_ / this.useTrackWid;
            if(skin.maskTrack)
            {
               skin.maskTrack.width = _loc2_ - this.virtualTrack.x;
            }
         }
         else if(this._direction == DragbarDirection.VERTICAL)
         {
            if(!this.slider.hasOwnProperty("drag") || this.slider.drag == false)
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
                  TweenLite.to(this.slider,0.1,{"y":_loc2_});
                  if(skin.sliderOver != null)
                  {
                     TweenLite.to(skin.sliderOver,0.1,{"y":_loc2_});
                  }
               }
               else
               {
                  this.sliderY = _loc2_;
               }
            }
            else
            {
               _loc2_ = this.virtualTrack.y + this.slider.y;
            }
            this._percent = _loc2_ / this.useTrackHei;
            if(skin.maskTrack)
            {
               skin.maskTrack.height = _loc2_ - this.virtualTrack.y;
            }
         }
         
         skin.drag = true;
         skin.slider.drag = false;
         this.sendChange();
      }
      
      protected function sendChange() : void
      {
         if(this.txt != null)
         {
            this.txt.text = int(this.percent * 100) + "%";
         }
         var _loc1_:DragbarEvent = new DragbarEvent(DragbarEvent.CHANGE);
         _loc1_.percent = this.percent;
         dispatchEvent(_loc1_);
      }
      
      protected function renderer() : void
      {
         var _loc1_:* = NaN;
         var _loc2_:* = NaN;
         if(this._direction == DragbarDirection.HORIZONTAL)
         {
            _loc1_ = this.virtualTrack.x + this.percent * this.useTrackWid;
            TweenLite.to(this.slider,DRAGBAR_MOVE_SPEED,{"x":_loc1_});
            if(skin.sliderOver != null)
            {
               TweenLite.to(skin.sliderOver,DRAGBAR_MOVE_SPEED,{"x":_loc1_});
            }
            if(this.maskTrack)
            {
               if(this.tweenAction)
               {
                  TweenLite.to(this.maskTrack,DRAGBAR_MOVE_SPEED,{"width":_loc1_ - this.virtualTrack.x});
               }
               else
               {
                  this.maskTrack.width = _loc1_ - this.virtualTrack.x;
               }
            }
         }
         else if(this._direction == DragbarDirection.VERTICAL)
         {
            _loc2_ = this.virtualTrack.y + this.percent * this.useTrackHei;
            TweenLite.to(this.slider,DRAGBAR_MOVE_SPEED,{"y":_loc2_});
            if(skin.sliderOver != null)
            {
               TweenLite.to(skin.sliderOver,DRAGBAR_MOVE_SPEED,{"y":_loc2_});
            }
            if(this.maskTrack)
            {
               if(this.tweenAction)
               {
                  TweenLite.to(this.maskTrack,DRAGBAR_MOVE_SPEED,{"height":_loc2_ - this.virtualTrack.y});
               }
               else
               {
                  this.maskTrack.height = _loc2_ - this.virtualTrack.y;
               }
            }
         }
         
         if(this.txt != null)
         {
            this.txt.text = int(this.percent * 100) + "%";
         }
      }
   }
}
