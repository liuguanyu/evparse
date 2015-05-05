package pptv.skin.view.ui
{
   import flash.display.*;
   import flash.text.TextField;
   import flash.geom.Point;
   import flash.text.TextFormat;
   import flash.utils.clearTimeout;
   import cn.pplive.player.utils.hash.Global;
   import cn.pplive.player.utils.CommonUtils;
   import flash.utils.setTimeout;
   import cn.pplive.player.common.VodCommon;
   import com.greensock.TweenLite;
   import flash.events.MouseEvent;
   import pptv.skin.view.events.SkinEvent;
   import flash.geom.Rectangle;
   import flash.geom.Matrix;
   
   public class VodProgressUI extends MovieClip
   {
      
      private var $rect:MovieClip;
      
      private var $track:MovieClip;
      
      private var $drag:MovieClip;
      
      private var $slider:MovieClip;
      
      private var $line:MovieClip;
      
      private var $startTime:Number;
      
      private var $endTime:Number;
      
      private var $mouseTime:String;
      
      private var $posiTime:Number;
      
      private var $durTime:Number;
      
      private var $bufferTime:Number;
      
      private var _drag_key:Boolean = false;
      
      private var _bool:Boolean = false;
      
      private var $standardWidth:Number;
      
      private var $sliderWidth:Number = 0;
      
      private var $sliderHeight:Number;
      
      private var $interactive:MovieClip;
      
      private var $buffer:MovieClip;
      
      private var $pointArr:Array;
      
      private var $pointX:Number;
      
      private var $stardardY:Number;
      
      private var $stardardH:Number;
      
      private var $dynamicH:Number;
      
      private var _columnWidth:uint = 6;
      
      private var _columnNumber:Number = 0;
      
      private var _columerate:Number = 0;
      
      private var _columnList:Array;
      
      private var _lGroupInterval:Number = 0;
      
      private var _mapEachGroupSum:Array;
      
      private var _maxIndex:Number = 0;
      
      private var _columnLevel:Array;
      
      private var _maxView:Number = 0;
      
      private var _minView:Number = 0;
      
      private var _columnMax:ColumnMc;
      
      private var $column:MovieClip;
      
      private var $playmodel:String;
      
      private var $dis:Number = 10;
      
      private var $columnW:Number;
      
      private var $isOver:Boolean = false;
      
      private var $isFast:Boolean = false;
      
      private var $tipInter:uint;
      
      private var $seekInter:uint;
      
      public function VodProgressUI()
      {
         this.$pointArr = [];
         this._columnList = [];
         this._columnLevel = [0.4,0.65,0.78,0.83,0.88,0.92,0.96,0.99,1];
         super();
         this.$rect = this.getChildByName("rect") as MovieClip;
         this.$track = this.getChildByName("track") as MovieClip;
         this.$buffer = this.getChildByName("buffer") as MovieClip;
         this.$slider = this.getChildByName("slider") as MovieClip;
         this.$interactive = this.getChildByName("interactive") as MovieClip;
         this.$drag = this.getChildByName("drag") as MovieClip;
         this.$drag.visible = false;
         this.$stardardY = this.$track.y;
         this.$dynamicH = this.$stardardH = this.$track.height;
         this.$rect.x = this.$slider.x = this.$buffer.x = this.$track.x = this.$interactive.x = 0;
         this.$column = new MovieClip();
         addChild(this.$column);
         this.$column.visible = false;
         this.buttonMode = true;
         this.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseHandler);
         this.addEventListener(MouseEvent.ROLL_OUT,this.onMouseHandler);
         this.addEventListener(MouseEvent.CLICK,this.onClickHandler);
         this.$drag.addEventListener(MouseEvent.MOUSE_DOWN,this.onDownHandler);
      }
      
      public function setPoint(param1:Object) : void
      {
         this.clearPoint();
         var _loc2_:* = 0;
         while(_loc2_ < param1["point"].length)
         {
            this.$pointArr[_loc2_] = new Dot("min");
            addChild(this.$pointArr[_loc2_]);
            this.$pointArr[_loc2_].y = this.$slider.y;
            this.$pointArr[_loc2_].visible = param1["skip"];
            this.$pointArr[_loc2_].data = param1["point"][_loc2_];
            _loc2_++;
         }
      }
      
      public function setPreSnapshot(param1:Object) : void
      {
         var $box:MovieClip = null;
         var $label:TextField = null;
         var $posi:Number = NaN;
         var $title:String = null;
         var $stardard:Number = NaN;
         var $global:Point = null;
         var i:int = 0;
         var $ft:TextFormat = null;
         var obj:Object = param1;
         if(this.$tipInter)
         {
            clearTimeout(this.$tipInter);
         }
         if(this.$line)
         {
            this.$line.visible = false;
         }
         this["parent"]["parent"].addChild(Global.getInstance()["tip"]);
         Global.getInstance()["tip"].name = "timestamp_snapshot";
         Global.getInstance()["tip"].visible = false;
         Global.getInstance()["tip"].source = null;
         if((obj) && (this.$isOver))
         {
            $box = new MovieClip();
            $label = CommonUtils.addDynamicTxt();
            $box.addChild($label);
            $label.wordWrap = $label.multiline = false;
            $posi = this.$playmodel == "vod"?obj["posi"]:(obj["posi"] * 1000 - this.$startTime) / 1000 >> 0;
            $title = CommonUtils.setTimeFormat($posi,false);
            if(this.$pointArr.length > 0)
            {
               i = 0;
               while(i < this.$pointArr.length)
               {
                  if(this.$pointArr[i].data["time"] == obj["posi"])
                  {
                     $title = $title + ("<br>" + this.$pointArr[i].data["title"]);
                  }
                  i++;
               }
            }
            if((this._columnMax) && this._columnMax.data["time"] == obj["posi"])
            {
               $title = $title + ("<br>本片云图最高点：" + Math.round(this._maxView) + "人喜欢此处");
            }
            $label.htmlText = CommonUtils.getHtml($title,"#9B999B");
            if(obj["bmp"])
            {
               $box.addChild(obj["bmp"]);
               $label.y = obj["bmp"].height;
               $stardard = obj["bmp"].width;
            }
            else
            {
               $stardard = $label.width;
               if($label.width > 120)
               {
                  $stardard = 120;
               }
            }
            if($label.width > $stardard)
            {
               $ft = new TextFormat();
               $ft.align = "center";
               $label.defaultTextFormat = $ft;
               $label.wordWrap = $label.multiline = true;
               $label.width = $stardard;
               $label.height = $label.textHeight + 5;
               $label.htmlText = CommonUtils.getHtml($title,"#9B999B");
            }
            $label.x = $stardard - $label.width >> 1;
            $global = this["parent"].localToGlobal(new Point(this.x,this.y + this.$rect.y));
            Global.getInstance()["tip"].visible = true;
            Global.getInstance()["tip"].dir = "bottom";
            Global.getInstance()["tip"].source = $box;
            Global.getInstance()["tip"].y = $global.y - Global.getInstance()["tip"].height - 5;
            Global.getInstance()["tip"].x = $global.x + this.$pointX - Global.getInstance()["tip"].width / 2 >> 0;
            Global.getInstance()["tip"].offSet = Global.getInstance()["tip"].width >> 1;
            if(Global.getInstance()["tip"].x + Global.getInstance()["tip"].width >= this.$rect.width)
            {
               Global.getInstance()["tip"].x = this.$rect.width - Global.getInstance()["tip"].width - 0;
            }
            else if(Global.getInstance()["tip"].x <= 0)
            {
               Global.getInstance()["tip"].x = 0;
            }
            
            Global.getInstance()["tip"].offSet = this.$pointX - Global.getInstance()["tip"].x;
            if(!this.$line)
            {
               this.$line = new MovieClip();
               this.$line.mouseEnabled = false;
               with(this.$line)
               {
                  
                  graphics.moveTo(0,0);
                  graphics.lineStyle(1,3381759);
                  graphics.lineTo(0,$rect.height);
               }
            }
            this.$line.visible = true;
            this["parent"]["parent"].addChild(this.$line);
            this.$line.x = this.$pointX;
            this.$line.y = $global.y;
            if(this.$isFast)
            {
               this.$tipInter = setTimeout(function():void
               {
                  $line.visible = false;
                  Global.getInstance()["tip"].visible = false;
                  Global.getInstance()["tip"].source = null;
                  $isFast = false;
               },2 * 1000);
            }
         }
      }
      
      public function get posi() : Number
      {
         var _loc1_:Number = 0;
         try
         {
            if(this.$playmodel == "vod")
            {
               _loc1_ = Math.floor(this.$durTime * (this.mouseX - this.$slider.x) / this.$standardWidth);
            }
            else if(this.$playmodel == "live")
            {
               _loc1_ = Math.floor((this.$endTime - this.$startTime) * (this.mouseX - this.$slider.x) / this.$standardWidth) + this.$startTime;
               if(_loc1_ >= this.$endTime)
               {
                  _loc1_ = this.$endTime;
               }
               if(_loc1_ <= this.$startTime)
               {
                  _loc1_ = this.$startTime;
               }
               return Math.floor(_loc1_ / 1000);
            }
            
         }
         catch(evt:Error)
         {
         }
         return _loc1_;
      }
      
      public function setTimeArea(param1:Object) : void
      {
         if(this._drag_key)
         {
            return;
         }
         try
         {
            this.$playmodel = param1["playmodel"];
            if(this.$playmodel == "vod")
            {
               this.$posiTime = param1["posi"];
               this.$durTime = param1["dur"];
               this.$bufferTime = param1["buffer"];
            }
            else if(this.$playmodel == "live")
            {
               this.$startTime = Math.floor(param1["start"] * 1000);
               this.$endTime = Math.floor(param1["end"] * 1000);
               this.$posiTime = Math.floor(param1["posi"] * 1000);
            }
            
            this.width = this.$rect.width;
         }
         catch(evt:Error)
         {
         }
      }
      
      override public function set width(param1:Number) : void
      {
         var _loc2_:* = 0;
         try
         {
            this.$standardWidth = this.$track.width = this.$interactive.width = this.$rect.width = param1;
            if(this.$playmodel == "vod")
            {
               this.$sliderWidth = this.$standardWidth * this.$posiTime / this.$durTime;
               this.$buffer.width = this.$standardWidth * this.$bufferTime / this.$durTime;
               if(this.$pointArr.length > 0)
               {
                  _loc2_ = 0;
                  while(_loc2_ < this.$pointArr.length)
                  {
                     this.$pointArr[_loc2_].x = this.$pointArr[_loc2_].data["time"] / this.$durTime * this.$standardWidth;
                     _loc2_++;
                  }
               }
               this.resizeColumn();
            }
            else if(this.$playmodel == "live")
            {
               this.$sliderWidth = this.$standardWidth * (this.$posiTime - this.$startTime) / (this.$endTime - this.$startTime);
            }
            
            if(this.$sliderWidth < 0)
            {
               this.$sliderWidth = 0;
            }
            if(this.$sliderWidth > this.$standardWidth)
            {
               this.$sliderWidth = this.$standardWidth;
            }
            this.sliderGraphics();
            this.$drag.x = this.$slider.x + this.$sliderWidth;
         }
         catch(evt:Error)
         {
         }
      }
      
      override public function get height() : Number
      {
         return this.$rect.height;
      }
      
      public function liveStopDrag() : void
      {
         if(this._bool)
         {
            this.onUpHandler();
         }
      }
      
      public function reset() : void
      {
         this.$drag.x = this.$slider.x;
         this.$sliderWidth = 0;
         this.sliderGraphics();
         this.$buffer.width = 0;
         this.clearPoint();
      }
      
      private function clearPoint() : void
      {
         var _loc1_:* = 0;
         if(this.$pointArr.length > 0)
         {
            _loc1_ = 0;
            while(_loc1_ < this.$pointArr.length)
            {
               removeChild(this.$pointArr[_loc1_]);
               _loc1_++;
            }
            this.$pointArr = [];
         }
      }
      
      public function setColumnData(param1:Object) : void
      {
         try
         {
            if(!param1)
            {
               return;
            }
            this._lGroupInterval = param1["interval"];
            this._mapEachGroupSum = param1["mapEachGroupSum"];
            this._maxIndex = param1["maxIndex"];
            this.resizeColumn();
         }
         catch(evt:Error)
         {
         }
      }
      
      private function resizeColumn() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = NaN;
         var _loc3_:* = NaN;
         var _loc4_:* = NaN;
         var _loc5_:* = 0;
         var _loc6_:Array = null;
         var _loc7_:* = 0;
         var _loc8_:ColumnMc = null;
         try
         {
            if(this.$columnW == this.$standardWidth || (isNaN(this.$durTime)))
            {
               return;
            }
            this.clearColumn();
            if(!this._mapEachGroupSum || this._lGroupInterval == 0)
            {
               return;
            }
            this.$columnW = this.$standardWidth;
            _loc1_ = 0;
            _loc2_ = 0;
            _loc3_ = 0;
            this._columnNumber = Math.floor(this.$columnW / this._columnWidth);
            _loc4_ = this._mapEachGroupSum.length / this._columnNumber;
            _loc5_ = 0;
            while(_loc5_ <= this._columnNumber)
            {
               _loc8_ = new ColumnMc();
               _loc8_.data["time"] = _loc5_ * this.$durTime / this._columnNumber;
               _loc8_.data["viewNumber"] = 0;
               _loc8_.data["extract"] = 0;
               _loc8_.buttonMode = true;
               this.$column.addChild(_loc8_);
               _loc8_.x = _loc5_ * this._columnWidth;
               if(_loc2_ > 0 && _loc2_ <= _loc4_ && _loc1_ < this._mapEachGroupSum.length)
               {
                  _loc8_.data["viewNumber"] = _loc8_.data["viewNumber"] + Number(this._mapEachGroupSum[_loc1_] * _loc2_);
                  if(_loc1_ == this._maxIndex)
                  {
                     _loc8_.data["extract"] = _loc8_.data["extract"] + Number(_loc2_);
                  }
                  _loc1_++;
               }
               while(_loc2_ + 1 <= _loc4_ && _loc1_ < this._mapEachGroupSum.length)
               {
                  _loc8_.data["viewNumber"] = _loc8_.data["viewNumber"] + Number(this._mapEachGroupSum[_loc1_]);
                  if(_loc1_ == this._maxIndex)
                  {
                     _loc8_.data["extract"] = 1;
                  }
                  _loc1_++;
                  _loc2_ = _loc2_ + 1;
               }
               if(_loc4_ >= _loc2_)
               {
                  _loc3_ = _loc4_ - _loc2_;
                  _loc2_ = 1 - _loc3_;
               }
               else
               {
                  _loc3_ = _loc4_;
                  _loc2_ = _loc2_ - _loc4_;
               }
               if(_loc1_ < this._mapEachGroupSum.length)
               {
                  _loc8_.data["viewNumber"] = _loc8_.data["viewNumber"] + Number(this._mapEachGroupSum[_loc1_] * _loc3_);
                  if(_loc1_ == this._maxIndex)
                  {
                     _loc8_.data["extract"] = _loc8_.data["extract"] + Number(_loc2_);
                  }
               }
               if(_loc5_ == 0)
               {
                  this._maxView = _loc8_.data["viewNumber"];
                  this._minView = _loc8_.data["viewNumber"];
               }
               else
               {
                  this._maxView = _loc8_.data["viewNumber"] > this._maxView?_loc8_.data["viewNumber"]:this._maxView;
                  this._minView = _loc8_.data["viewNumber"] > this._minView?this._minView:_loc8_.data["viewNumber"];
               }
               if(!this._columnMax || this._columnMax.data["extract"] < _loc8_.data["extract"])
               {
                  this._columnMax = _loc8_;
               }
               this._columnList.push(_loc8_);
               _loc8_.mouseChildren = _loc8_.mouseEnabled = false;
               _loc5_++;
            }
            _loc6_ = [];
            _loc7_ = 0;
            while(_loc7_ < this._columnLevel.length)
            {
               _loc6_[_loc7_] = {
                  "min":(_loc7_ == 0?0:this._columnLevel[_loc7_ - 1]) * (this._maxView - this._minView) + this._minView,
                  "max":this._columnLevel[_loc7_] * (this._maxView - this._minView) + this._minView,
                  "s":_loc7_ + 1
               };
               _loc7_++;
            }
            _loc5_ = 0;
            while(_loc5_ < this._columnList.length)
            {
               _loc8_ = this._columnList[_loc5_];
               _loc7_ = 0;
               while(_loc7_ < _loc6_.length)
               {
                  if(_loc8_.data["viewNumber"] >= _loc6_[_loc7_].min && _loc8_.data["viewNumber"] < _loc6_[_loc7_].max)
                  {
                     _loc8_.setColumLevel(_loc6_[_loc7_].s);
                     break;
                  }
                  if(_loc7_ == _loc6_.length - 1 && _loc8_.data["viewNumber"] == _loc6_[_loc7_].max)
                  {
                     _loc8_.setColumLevel(_loc6_[_loc7_].s);
                     break;
                  }
                  _loc7_++;
               }
               _loc5_++;
            }
            if(this._columnMax)
            {
               this._columnMax.setColumLevel(10);
               this._columnMax.mouseEnabled = true;
            }
         }
         catch(evt:Error)
         {
         }
      }
      
      private function clearColumn() : void
      {
         var _loc1_:* = 0;
         while(_loc1_ < this._columnList.length)
         {
            this.$column.removeChild(this._columnList[_loc1_]);
            _loc1_++;
         }
         this._columnList = [];
         if(this._columnMax)
         {
            this._columnMax = null;
         }
         this._columnNumber = 0;
         this._columerate = 0;
         this._maxView = 0;
         this._minView = 0;
      }
      
      public function setColumnState(param1:Boolean) : void
      {
         var bool:Boolean = param1;
         if(VodCommon.smart)
         {
            return;
         }
         this.$column.visible = bool;
         this.$dynamicH = bool?20:this.$stardardH;
         TweenLite.to(this.$track,0.5,{
            "y":(bool?0:this.$stardardY),
            "height":this.$dynamicH
         });
         TweenLite.to(this.$buffer,0.5,{
            "y":(bool?1:this.$stardardY + 1),
            "height":this.$dynamicH - 2
         });
         TweenLite.to(this.$slider,0.5,{
            "y":(bool?1:this.$stardardY + 1),
            "height":this.$dynamicH - 2,
            "onUpdate":function():void
            {
               var _loc1_:* = undefined;
               try
               {
                  _loc1_ = 0;
                  while(_loc1_ < $pointArr.length)
                  {
                     $pointArr[_loc1_].redraw(bool?"max":"min");
                     $pointArr[_loc1_].y = $slider.y;
                     _loc1_++;
                  }
               }
               catch(evt:Error)
               {
               }
            }
         });
         TweenLite.to(this.$interactive,0.5,{
            "y":(bool?1:this.$stardardY - 2),
            "height":this.$dynamicH + (bool?2:4)
         });
      }
      
      private function onMouseHandler(param1:MouseEvent) : void
      {
         switch(param1.type)
         {
            case MouseEvent.MOUSE_OVER:
               this.setColumnState(true);
               if(this.mouseX >= this.$track.x && this.mouseX <= this.$track.x + this.$track.width)
               {
                  this.$isFast = false;
                  this.$isOver = true;
                  this.$pointX = this.mouseX;
                  this.dispatchEvent(new SkinEvent(SkinEvent.MEDIA_PREVIEW_SNAPSHOT,{"value":((param1.target as Dot) || (param1.target as ColumnMc) && (param1.target.mouseEnabled)?param1.target["data"]["time"]:this.posi)}));
               }
               param1.target.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseHandler);
               break;
            case MouseEvent.ROLL_OUT:
               if(stage.displayState != "fullScreen")
               {
                  this.setColumnState(false);
               }
               this.$isOver = false;
               dispatchEvent(new SkinEvent(SkinEvent.MEDIA_PREVIEW_SNAPSHOT));
               param1.target.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseHandler);
               break;
            case MouseEvent.MOUSE_MOVE:
               if(this.mouseX >= this.$track.x && this.mouseX <= this.$track.x + this.$track.width)
               {
                  this.$isFast = false;
                  this.$isOver = true;
                  this.$pointX = this.mouseX;
                  this.dispatchEvent(new SkinEvent(SkinEvent.MEDIA_PREVIEW_SNAPSHOT,{"value":((param1.target as Dot) || (param1.target as ColumnMc)?param1.target["data"]["time"]:this.posi)}));
               }
               else
               {
                  this.$isOver = false;
                  this.dispatchEvent(new SkinEvent(SkinEvent.MEDIA_PREVIEW_SNAPSHOT));
               }
               break;
         }
      }
      
      public function setPosition(param1:Number) : void
      {
         var posi:Number = param1;
         if(this.$seekInter)
         {
            clearTimeout(this.$seekInter);
         }
         this.$isFast = true;
         this._drag_key = true;
         if(this.$playmodel == "vod")
         {
            this.$posiTime = posi;
         }
         else if(this.$playmodel == "live")
         {
            this.$posiTime = Math.floor(posi * 1000);
         }
         
         this.width = this.$rect.width;
         this.$isOver = true;
         this.$pointX = this.$drag.x;
         this.$seekInter = setTimeout(function():void
         {
            _drag_key = false;
            setPlayPoint();
         },0.2 * 1000);
      }
      
      private function setPlayPoint() : void
      {
         var _loc1_:* = NaN;
         try
         {
            if(this.$playmodel == "vod")
            {
               _loc1_ = this.$durTime * this.$sliderWidth / this.$standardWidth;
               this.dispatchEvent(new SkinEvent(SkinEvent.MEDIA_VOD_POSITION,{"value":Math.floor(_loc1_)}));
            }
            else if(this.$playmodel == "live")
            {
               _loc1_ = (this.$endTime - this.$startTime) * this.$sliderWidth / this.$standardWidth + this.$startTime;
               if(_loc1_ >= this.$endTime)
               {
                  _loc1_ = this.$endTime;
               }
               if(_loc1_ <= this.$startTime)
               {
                  _loc1_ = this.$startTime;
               }
               this.dispatchEvent(new SkinEvent(SkinEvent.MEDIA_VOD_POSITION,{"value":Math.floor(_loc1_ / 1000)}));
            }
            
         }
         catch(evt:Error)
         {
         }
      }
      
      private function onClickHandler(param1:MouseEvent) : void
      {
         this.$drag.x = this.mouseX;
         if(this.$drag.x < this.$slider.x)
         {
            this.$drag.x = this.$slider.x;
         }
         if(this.$drag.x > this.$slider.x + this.$standardWidth)
         {
            this.$drag.x = this.$slider.x + this.$standardWidth;
         }
         this.$sliderWidth = this.$drag.x - this.$slider.x;
         this.sliderGraphics();
         this.setPlayPoint();
         this._bool = false;
      }
      
      private function onDownHandler(param1:MouseEvent) : void
      {
         this._bool = true;
         this._drag_key = true;
         this.$drag.startDrag(false,new Rectangle(this.$slider.x,this.$drag.y,this.$standardWidth,0));
         this.$drag.addEventListener(MouseEvent.MOUSE_UP,this.onUpHandler);
         this.$drag.stage.addEventListener(MouseEvent.MOUSE_UP,this.onUpHandler);
         this.$drag.addEventListener(MouseEvent.MOUSE_MOVE,this.onMoveHandler);
         this.$drag.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMoveHandler);
      }
      
      private function onMoveHandler(param1:*) : void
      {
         if(!this._drag_key)
         {
            return;
         }
         this.$sliderWidth = this.mouseX - this.$slider.x > this.$standardWidth?this.$standardWidth:this.mouseX - this.$slider.x;
         if(this.$sliderWidth < 0)
         {
            this.$sliderWidth = 0;
         }
         if(this.$sliderWidth > this.$standardWidth)
         {
            this.$sliderWidth = this.$standardWidth;
         }
         this.sliderGraphics();
         this.$drag.x = this.$slider.x + this.$sliderWidth;
      }
      
      private function onUpHandler(param1:* = null) : void
      {
         this._drag_key = false;
         this.$drag.x = this.$slider.x + this.$sliderWidth;
         this.setPlayPoint();
         this._bool = false;
         this.$drag.stopDrag();
         this.$drag.removeEventListener(MouseEvent.MOUSE_UP,this.onUpHandler);
         this.$drag.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onUpHandler);
         this.$drag.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMoveHandler);
         this.$drag.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMoveHandler);
      }
      
      private function sliderGraphics() : void
      {
         var $matrix:Matrix = null;
         var $rotios:Array = null;
         try
         {
            $matrix = new Matrix();
            $matrix.createGradientBox(this.$sliderWidth,0);
            $rotios = [0,255];
            if(this.$sliderWidth > 80)
            {
               $rotios = [255 * (this.$sliderWidth - 80) / this.$sliderWidth,255];
            }
            with(this.$slider)
            {
               
               graphics.clear();
               graphics.beginGradientFill("linear",[1529986,6740711],[1,1],$rotios,$matrix);
               graphics.drawRect(0,0,$sliderWidth,$stardardH - 2);
               graphics.endFill();
            }
         }
         catch(evt:Error)
         {
         }
      }
   }
}

import flash.display.*;

dynamic class Dot extends MovieClip
{
   
   function Dot(param1:String)
   {
      super();
      this.redraw(param1);
   }
   
   public function redraw(param1:String) : void
   {
      var type:String = param1;
      var w:int = type == "min"?4:8;
      with(this)
      {
         
         graphics.clear();
         graphics.beginFill(10724259,0.85);
         graphics.drawRect(-w / 2,0,w,w / 2);
         graphics.endFill();
      }
   }
}

import flash.events.Event;

class JEventDelegate extends Object
{
   
   function JEventDelegate()
   {
      super();
   }
   
   public static function create(param1:Function, ... rest) : Function
   {
      var f:Function = param1;
      var arg:Array = rest;
      return function(param1:Event):void
      {
         f.apply(null,[param1].concat(arg));
      };
   }
}
