package pptv.skin.view.ui
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import pptv.skin.view.events.SkinEvent;
   import flash.geom.Rectangle;
   import flash.events.Event;
   
   public class OptionEditorUI extends MovieClip
   {
      
      public var confirm:SimpleButton;
      
      public var default_btn:SimpleButton;
      
      public var cancel:SimpleButton;
      
      public var ct_mc:MovieClip;
      
      public var bt_mc:MovieClip;
      
      private var $confirm_btn:SimpleButton;
      
      private var $cancel_btn:SimpleButton;
      
      private var $typeArr:Array;
      
      private var $drag:MovieClip;
      
      private var $settingData:Object;
      
      private var $bt:Number = 0;
      
      private var $ct:Number = 0;
      
      private var _bt_:Number = 0;
      
      private var _ct_:Number = 0;
      
      private var $currSkipIndex:Number;
      
      private var $changeSkipIndex:Number;
      
      private var tip_arr:Array;
      
      private var $skipArr:Array;
      
      public function OptionEditorUI()
      {
         this.tip_arr = ["允许","不允许"];
         this.$skipArr = [];
         super();
         this["confirm"].addEventListener(MouseEvent.CLICK,this.onClickHandler);
         this["cancel"].addEventListener(MouseEvent.CLICK,this.onClickHandler);
         this["default_btn"].addEventListener(MouseEvent.CLICK,this.onClickHandler);
         this.$typeArr = [this["bt_mc"],this["ct_mc"]];
         var _loc1_:* = 0;
         var _loc2_:int = this.$typeArr.length;
         while(_loc1_ < _loc2_)
         {
            this.$typeArr[_loc1_]["track_mc"].buttonMode = true;
            this.$typeArr[_loc1_]["track_mc"].addEventListener(MouseEvent.CLICK,this.onChangeHandler);
            this.$typeArr[_loc1_]["drag_mc"].buttonMode = true;
            this.$typeArr[_loc1_]["drag_mc"].addEventListener(MouseEvent.MOUSE_DOWN,this.onDragHandler);
            _loc1_++;
         }
      }
      
      public function get settingData() : Object
      {
         return this.$settingData;
      }
      
      public function set settingData(param1:Object) : void
      {
         this.$settingData = param1;
      }
      
      private function onClickHandler(param1:MouseEvent) : void
      {
         switch(param1.currentTarget)
         {
            case this["default_btn"]:
               this._bt_ = this._ct_ = 0;
               this.setBt(this._bt_);
               this.setCt(this._ct_);
               this.dispatchEvent(new SkinEvent(SkinEvent.MEDIA_HUE,{
                  "bt":this._bt_,
                  "ct":this._ct_
               }));
               return;
            case this["confirm"]:
               this.$currSkipIndex = this.$changeSkipIndex;
               this.$bt = this._bt_;
               this.$ct = this._ct_;
               this.$settingData = {
                  "bt":this.$bt,
                  "ct":this.$ct,
                  "skip":this.$currSkipIndex
               };
               break;
            case this["cancel"]:
               this.cancels();
               return;
         }
         this.dispatchEvent(new SkinEvent(SkinEvent.MEDIA_SETTING,this.$settingData));
      }
      
      public function cancels() : void
      {
         this.changeSkipIndex = this.$currSkipIndex;
         this.setBt(this.$bt);
         this.setCt(this.$ct);
         this.$settingData = {
            "bt":this.$bt,
            "ct":this.$ct,
            "skip":this.$currSkipIndex
         };
         this.dispatchEvent(new SkinEvent(SkinEvent.MEDIA_SETTING,this.$settingData));
      }
      
      private function setBt(param1:Number) : void
      {
         this["bt_mc"]["slider_mc"].width = (param1 + 100) / 2 / 100 * this["bt_mc"]["track_mc"].width;
         this["bt_mc"]["drag_mc"].x = this["bt_mc"]["slider_mc"].width - this["bt_mc"]["drag_mc"].width / 2;
      }
      
      private function setCt(param1:Number) : void
      {
         this["ct_mc"]["slider_mc"].width = (param1 + 100) / 2 / 100 * this["ct_mc"]["track_mc"].width;
         this["ct_mc"]["drag_mc"].x = this["ct_mc"]["slider_mc"].width - this["ct_mc"]["drag_mc"].width / 2;
      }
      
      private function onChangeHandler(param1:MouseEvent) : void
      {
         if(param1.target["parent"].mouseX <= 0)
         {
            param1.target["parent"]["slider_mc"].width = 0;
         }
         else if(param1.target["parent"].mouseX >= param1.target["parent"]["track_mc"].width)
         {
            param1.target["parent"]["slider_mc"].width = param1.target["parent"]["track_mc"].width;
         }
         else
         {
            param1.target["parent"]["slider_mc"].width = param1.target["parent"].mouseX;
         }
         
         param1.target["parent"]["drag_mc"].x = param1.target["parent"]["slider_mc"].width - param1.target["parent"]["drag_mc"].width / 2;
         this.dispatch(param1.target);
      }
      
      private function onDragHandler(param1:MouseEvent) : void
      {
         this.$drag = param1.currentTarget as MovieClip;
         this.$drag.startDrag(false,new Rectangle(this.$drag["parent"]["track_mc"].x - this.$drag.width / 2,this.$drag.y,this.$drag["parent"]["track_mc"].width,0));
         this.$drag.addEventListener(MouseEvent.MOUSE_UP,this.onDragUpHandler);
         this.$drag.stage.addEventListener(MouseEvent.MOUSE_UP,this.onDragUpHandler);
         this.$drag.addEventListener(MouseEvent.MOUSE_MOVE,this.onDragMoveHandler);
         this.$drag.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onDragMoveHandler);
      }
      
      private function onDragMoveHandler(param1:MouseEvent) : void
      {
         this.$drag["parent"]["slider_mc"].width = this.$drag.x + this.$drag.width / 2;
         this.dispatch(this.$drag);
      }
      
      private function onDragUpHandler(param1:MouseEvent) : void
      {
         this.$drag.stopDrag();
         this.$drag.removeEventListener(MouseEvent.MOUSE_UP,this.onDragUpHandler);
         this.$drag.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onDragUpHandler);
         this.$drag.removeEventListener(MouseEvent.MOUSE_MOVE,this.onDragMoveHandler);
         this.$drag.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onDragMoveHandler);
      }
      
      private function dispatch(param1:*) : void
      {
         var _loc2_:Number = Math.round(param1["parent"]["slider_mc"].width / param1["parent"]["track_mc"].width * 100);
         _loc2_ = _loc2_ * 2 - 100;
         if(param1["parent"].name == "bt_mc")
         {
            this._bt_ = _loc2_;
         }
         else if(param1["parent"].name == "ct_mc")
         {
            this._ct_ = _loc2_;
         }
         
         this.dispatchEvent(new SkinEvent(SkinEvent.MEDIA_HUE,{
            "bt":this._bt_,
            "ct":this._ct_
         }));
      }
      
      public function setSkipPrelude(param1:Boolean) : void
      {
         var _loc3_:String = null;
         if(this.$skipArr.length > 0)
         {
            for(_loc3_ in this.$skipArr)
            {
               removeChild(this.$skipArr[_loc3_]);
            }
            this.$skipArr = [];
         }
         var _loc2_:* = 0;
         while(_loc2_ < this.tip_arr.length)
         {
            this.$skipArr[_loc2_] = new ButtonBox(this.tip_arr[_loc2_]);
            addChild(this.$skipArr[_loc2_]);
            this.$skipArr[_loc2_].addEventListener("_select_",this.onSelectSkipHandler);
            this.$skipArr[_loc2_].index = _loc2_;
            this.$skipArr[_loc2_].enable = true;
            this.$skipArr[_loc2_].x = _loc2_ > 0?this.$skipArr[_loc2_ - 1].x + this.$skipArr[_loc2_ - 1].width + 10:80;
            this.$skipArr[_loc2_].y = 80;
            _loc2_++;
         }
         this.changeSkipIndex = this.$currSkipIndex = 1 - Number(param1);
      }
      
      private function onSelectSkipHandler(param1:Event) : void
      {
         this.changeSkipIndex = param1.target.index;
      }
      
      public function get currSkipIndex() : Number
      {
         return this.$currSkipIndex;
      }
      
      public function set currSkipIndex(param1:Number) : void
      {
         this.$currSkipIndex = param1;
      }
      
      public function get changeSkipIndex() : Number
      {
         return this.$changeSkipIndex;
      }
      
      public function set changeSkipIndex(param1:Number) : void
      {
         this.$changeSkipIndex = param1;
         this.selectSkip(this.$changeSkipIndex);
      }
      
      private function selectSkip(param1:int) : void
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.$skipArr.length)
         {
            this.$skipArr[_loc2_].select = _loc2_ == param1?3381759:6710886;
            _loc2_++;
         }
      }
   }
}

import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFormat;

dynamic class ButtonBox extends MovieClip
{
   
   private var $w:Number;
   
   private var $h:Number;
   
   private var $color:uint = 6710886;
   
   function ButtonBox(param1:String)
   {
      super();
      var _loc2_:TextField = new TextField();
      addChild(_loc2_);
      _loc2_.mouseEnabled = false;
      _loc2_.autoSize = "left";
      _loc2_.defaultTextFormat = new TextFormat("Microsoft YaHei,微软雅黑,Arial,Tahoma",12,16777215);
      _loc2_.text = param1;
      this.$w = _loc2_.width + 5;
      this.$h = _loc2_.height;
      this.drawUI();
      _loc2_.x = this.width - _loc2_.width >> 1;
      _loc2_.y = this.height - _loc2_.height >> 1;
      this.buttonMode = true;
      this.addEventListener(MouseEvent.CLICK,this.onMouseHandler);
   }
   
   public function set enable(param1:Boolean) : void
   {
      this.mouseEnabled = param1;
      this.alpha = param1?1:0.2;
   }
   
   public function set select(param1:uint) : void
   {
      this.$color = param1;
      this.drawUI();
   }
   
   private function onMouseHandler(param1:MouseEvent) : void
   {
      dispatchEvent(new Event("_select_"));
   }
   
   private function drawUI() : void
   {
      with(this)
      {
         
         graphics.clear();
         graphics.beginFill($color);
         graphics.drawRect(0,0,$w,$h);
         graphics.endFill();
      }
   }
}
