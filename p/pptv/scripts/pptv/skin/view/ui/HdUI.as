package pptv.skin.view.ui
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import cn.pplive.player.utils.CommonUtils;
   import cn.pplive.player.view.ui.ToolTips;
   import flash.events.MouseEvent;
   import cn.pplive.player.utils.hash.Global;
   import flash.geom.Point;
   import flash.filters.DropShadowFilter;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import flash.events.Event;
   import pptv.skin.view.events.SkinEvent;
   
   public class HdUI extends MovieClip
   {
      
      private var _status:Number;
      
      private var _arr:Array;
      
      private var $smooth_txt:TextField;
      
      private var title_arr:Array;
      
      private var $home:MovieClip;
      
      private var $w:Number;
      
      private var $h:Number;
      
      private var $inter:uint;
      
      private var $hdTip:ToolTips;
      
      private var $currStreamIndex:Number = 1;
      
      private var $changeStreamIndex:Number;
      
      private var $streamArr:Array;
      
      private var $sw:Number = NaN;
      
      public function HdUI()
      {
         this.title_arr = ["流畅","高清","超清","蓝光"];
         this.$streamArr = [];
         super();
         this.$w = this.width;
         this.$h = this.height;
         this.$smooth_txt = CommonUtils.addDynamicTxt();
         this.$smooth_txt.wordWrap = this.$smooth_txt.multiline = false;
         addChild(this.$smooth_txt);
         this.setHdTitle(this.$currStreamIndex);
         this.$smooth_txt.x = this.$w - this.$smooth_txt.width >> 1;
         this.$smooth_txt.y = this.$h - this.$smooth_txt.height >> 1;
         addEventListener(MouseEvent.CLICK,this.onSmoothHandler);
         addEventListener(MouseEvent.MOUSE_OVER,this.onSmoothHandler);
         addEventListener(MouseEvent.MOUSE_OUT,this.onSmoothHandler);
      }
      
      public function setHdTitle(param1:int, param2:String = "#999999") : void
      {
         this.changeStreamIndex = this.$currStreamIndex = param1;
         this.$smooth_txt.htmlText = CommonUtils.getHtml(this.title_arr[param1],param2);
      }
      
      private function onSmoothHandler(param1:MouseEvent) : void
      {
         switch(param1.type)
         {
            case MouseEvent.CLICK:
               Global.getInstance()["tip"].visible = false;
               if(!this.$hdTip)
               {
                  this.$hdTip = new ToolTips();
                  this.$hdTip.bgColor = 2236962;
                  this.$hdTip.bgAlpha = 0.95;
                  this.$hdTip.cornerRadius = 0;
                  this.$hdTip.hookSize = 8;
                  this.$hdTip.spacing = 0;
               }
               this.$hdTip.addEventListener(MouseEvent.MOUSE_OVER,this.onHdTipHandler);
               this.$hdTip.addEventListener(MouseEvent.MOUSE_OUT,this.onHdTipHandler);
               this.$hdTip.visible = false;
               this.$hdTip.source = null;
               this.reposition();
               this.$hdTip.visible = true;
               break;
            case MouseEvent.MOUSE_OVER:
               this.setHdTitle(this.$currStreamIndex,"#ffffff");
               break;
            case MouseEvent.MOUSE_OUT:
               this.setHdTitle(this.$currStreamIndex);
               this.hideTip();
               break;
         }
      }
      
      private function reposition() : void
      {
         var _loc1_:Point = null;
         if((this.$home) && (this.$hdTip))
         {
            this["parent"]["parent"]["parent"].addChild(this.$hdTip);
            _loc1_ = this["parent"].localToGlobal(new Point(this.x,this.y));
            this.$hdTip.source = this.$home;
            this.$hdTip.x = _loc1_.x - (this.$hdTip.width - this.width) / 2 >> 0;
            this.$hdTip.y = _loc1_.y - this.$hdTip.height;
            this.$hdTip.offSet = this.$hdTip.width >> 1;
            this.$hdTip.filters = [new DropShadowFilter(2,90,0,1,15,15,0.4,3)];
         }
      }
      
      private function onHdTipHandler(param1:MouseEvent) : void
      {
         switch(param1.type)
         {
            case MouseEvent.MOUSE_OVER:
               if(this.$inter)
               {
                  clearTimeout(this.$inter);
               }
               break;
            case MouseEvent.MOUSE_OUT:
               this.hideTip();
               break;
         }
      }
      
      private function hideTip() : void
      {
         this.$inter = setTimeout(function():void
         {
            if($hdTip)
            {
               $hdTip.visible = false;
            }
         },0.3 * 1000);
      }
      
      public function setStream(param1:Array, param2:int) : void
      {
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         var _loc7_:Object = null;
         if(!this.$home)
         {
            this.$home = new MovieClip();
         }
         if(this.$streamArr.length > 0)
         {
            for(_loc3_ in this.$streamArr)
            {
               this.$home.removeChild(this.$streamArr[_loc3_]);
            }
            this.$streamArr = [];
         }
         try
         {
            _loc4_ = [];
            _loc5_ = 0;
            while(_loc5_ < param1.length)
            {
               if(Number(param1[_loc5_]["enabled"] == 1))
               {
                  _loc4_.push(param1[_loc5_]);
               }
               _loc5_++;
            }
            _loc6_ = _loc4_.length;
            _loc5_ = _loc6_ - 1;
            while(_loc5_ >= 0)
            {
               this.$streamArr[_loc5_] = new ButtonBox();
               this.$home.addChild(this.$streamArr[_loc5_]);
               _loc7_ = {
                  "label":this.title_arr[_loc4_[_loc5_]["ft"]] + (_loc4_[_loc5_]["vip"] != "0"?"（会员）":""),
                  "color":(_loc4_[_loc5_]["vip"] != "0"?"#FF7200":"#999999")
               };
               if(!isNaN(this.$sw))
               {
                  _loc7_["sw"] = this.$sw;
               }
               this.$streamArr[_loc5_].text = _loc7_;
               if(_loc4_[_loc5_]["vip"] != "0")
               {
                  this.$sw = this.$streamArr[_loc5_].width;
               }
               this.$streamArr[_loc5_].addEventListener(MouseEvent.CLICK,this.onSelectStreamHandler);
               this.$streamArr[_loc5_].addEventListener(MouseEvent.MOUSE_OVER,this.onSelectStreamHandler);
               this.$streamArr[_loc5_].addEventListener(MouseEvent.MOUSE_OUT,this.onSelectStreamHandler);
               this.$streamArr[_loc5_].dataObj = _loc4_[_loc5_];
               this.$streamArr[_loc5_].enable = _loc4_[_loc5_]["enabled"];
               this.$streamArr[_loc5_].y = this.$streamArr[_loc5_].height * (_loc6_ - 1 - _loc5_);
               _loc5_--;
            }
            this.changeStreamIndex = this.$currStreamIndex = param2;
            this.setHdTitle(this.$currStreamIndex);
         }
         catch(evt:Error)
         {
         }
         this.reposition();
      }
      
      private function onSelectStreamHandler(param1:Event) : void
      {
         switch(param1.type)
         {
            case MouseEvent.CLICK:
               this.changeStreamIndex = param1.target.dataObj["ft"];
               this.dispatchEvent(new SkinEvent(SkinEvent.MEDIA_STREAM,{"stream":this.$changeStreamIndex}));
               break;
            case MouseEvent.MOUSE_OVER:
               param1.target.drawUI(1);
               break;
            case MouseEvent.MOUSE_OUT:
               param1.target.drawUI(0);
               break;
         }
      }
      
      public function get currStreamIndex() : Number
      {
         return this.$currStreamIndex;
      }
      
      public function set currStreamIndex(param1:Number) : void
      {
         this.$currStreamIndex = param1;
      }
      
      public function get changeStreamIndex() : Number
      {
         return this.$changeStreamIndex;
      }
      
      public function set changeStreamIndex(param1:Number) : void
      {
         this.$changeStreamIndex = param1;
         this.selectStream(this.$changeStreamIndex);
      }
      
      private function selectStream(param1:int) : void
      {
         var _loc2_:* = 0;
         try
         {
            _loc2_ = 0;
            while(_loc2_ < this.$streamArr.length)
            {
               this.$streamArr[_loc2_].select = this.$streamArr[_loc2_]["dataObj"]["ft"] == param1?"#3399FF":this.$streamArr[_loc2_]["dataObj"]["vip"] != "0"?"#FF7200":"#999999";
               _loc2_++;
            }
         }
         catch(evt:Error)
         {
         }
      }
   }
}

import flash.display.MovieClip;
import flash.text.TextField;
import cn.pplive.player.utils.CommonUtils;

dynamic class ButtonBox extends MovieClip
{
   
   private var $label:TextField;
   
   private var $w:Number = NaN;
   
   private var $h:Number = 30;
   
   private var $dis:Number = 12;
   
   private var $dataObj:Object;
   
   function ButtonBox()
   {
      super();
      this.$label = new TextField();
      addChild(this.$label);
      this.$label.mouseEnabled = false;
      this.$label.autoSize = "left";
      this.buttonMode = true;
   }
   
   public function set enable(param1:Boolean) : void
   {
      this.mouseEnabled = param1;
      this.alpha = param1?1:0.2;
   }
   
   public function set select(param1:String) : void
   {
      this.$dataObj["color"] = param1;
      this.text = this.$dataObj;
   }
   
   public function set text(param1:Object) : void
   {
      this.$dataObj = param1;
      if(this.$label)
      {
         this.$label.htmlText = CommonUtils.getHtml(param1["label"],param1["color"]);
         if(!param1["sw"])
         {
            this.$w = this.$label.width + this.$dis * 2;
         }
         else
         {
            this.$w = param1["sw"];
         }
         this.drawUI();
         this.$label.x = this.$dis;
         this.$label.y = this.height - this.$label.height >> 1;
      }
   }
   
   override public function get width() : Number
   {
      return this.$w;
   }
   
   public function drawUI(param1:Number = 0) : void
   {
      var alp:Number = param1;
      with(this)
      {
         
         graphics.clear();
         graphics.beginFill(3381759,alp);
         graphics.drawRect(0,0,$w,$h);
         graphics.endFill();
      }
      if((this.$dataObj) && (this.$label))
      {
         this.$label.htmlText = CommonUtils.getHtml(this.$dataObj["label"],Boolean(alp)?"#ffffff":this.$dataObj["color"]);
      }
   }
}
