package pptv.skin.view.ui
{
   import flash.display.MovieClip;
   import cn.pplive.player.utils.PrintDebug;
   import cn.pplive.player.view.ui.ToolTips;
   import flash.events.MouseEvent;
   import cn.pplive.player.utils.hash.Global;
   import pptv.skin.view.events.SkinEvent;
   import cn.pplive.player.common.VodCommon;
   import flash.geom.Point;
   import flash.filters.DropShadowFilter;
   import flash.geom.ColorTransform;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import cn.pplive.player.utils.CommonUtils;
   
   public class AccelerateUI extends MovieClip
   {
      
      public static const NO_MEMBER:String = "no_member";
      
      public static const VIP_NO_PPVA:String = "vip_no_ppva";
      
      public static const VIP_PPVA:String = "vip_ppva";
      
      private var $isAccelerate:Boolean = false;
      
      private var $home:MovieClip;
      
      public var states:String = "no_member";
      
      private var $accTip:ToolTips;
      
      private var _accTxt:TextField;
      
      private var _speed:Number = 0;
      
      private var _accSpeed:Number = 0;
      
      private var _bit:Number = 0;
      
      public function AccelerateUI()
      {
         super();
         this.buttonMode = true;
         this.addEventListener(MouseEvent.CLICK,this.onMouseHandler);
         this.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseHandler);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseHandler);
         this.setAccelerate(this.$isAccelerate);
      }
      
      public function setAccelerateState(param1:String = "no_member") : void
      {
         this.states = param1;
         PrintDebug.Trace("加速UI更新加速状态 ===>",this.states);
         switch(this.states)
         {
            case NO_MEMBER:
            case VIP_NO_PPVA:
               this.$isAccelerate = false;
               break;
            case VIP_PPVA:
               this.$isAccelerate = true;
               break;
         }
         this.setAccelerate(this.$isAccelerate);
      }
      
      private function onMouseHandler(param1:MouseEvent) : void
      {
         switch(param1.type)
         {
            case MouseEvent.CLICK:
               try
               {
                  Global.getInstance()["tip"].visible = false;
               }
               catch(evt:Error)
               {
               }
               if(this.$isAccelerate)
               {
                  if(!this.$accTip)
                  {
                     this.$accTip = new ToolTips();
                     this.$accTip.bgColor = 2236962;
                     this.$accTip.bgAlpha = 0.95;
                     this.$accTip.cornerRadius = 0;
                     this.$accTip.hookSize = 8;
                     this.$accTip.spacing = 0;
                  }
                  this.$accTip.visible = false;
                  this.$accTip.source = null;
                  this.reposition();
                  this.$accTip.visible = true;
               }
               if(this.states == VIP_NO_PPVA)
               {
                  dispatchEvent(new SkinEvent(SkinEvent.MEDIA_HREF,{
                     "value":"click",
                     "link":VodCommon.purl
                  }));
               }
               else if(this.states == NO_MEMBER)
               {
                  this.dispatchEvent(new SkinEvent(SkinEvent.MEDIA_HREF,{"value":NO_MEMBER}));
               }
               
               this.dispatchEvent(new SkinEvent(SkinEvent.MEDIA_ACCELERATE));
               break;
            case MouseEvent.MOUSE_OVER:
               break;
            case MouseEvent.MOUSE_OUT:
               try
               {
                  this.$accTip.visible = false;
                  this.$accTip.source = null;
               }
               catch(evt:Error)
               {
               }
               break;
         }
      }
      
      private function reposition() : void
      {
         var _loc1_:Point = null;
         if((this.$home) && (this.$accTip))
         {
            this["parent"]["parent"]["parent"].addChild(this.$accTip);
            _loc1_ = this["parent"].localToGlobal(new Point(this.x,this.y));
            this.$accTip.source = this.$home;
            this.$accTip.x = _loc1_.x - (this.$accTip.width - this.width) / 2 >> 0;
            this.$accTip.y = _loc1_.y - this.$accTip.height - 10;
            this.$accTip.offSet = this.$accTip.width >> 1;
            this.$accTip.filters = [new DropShadowFilter(2,90,0,1,15,15,0.4,3)];
         }
      }
      
      private function setAccelerate(param1:Boolean) : void
      {
         this.$isAccelerate = param1;
         var _loc2_:ColorTransform = new ColorTransform();
         _loc2_.color = param1?3381759:10066329;
         this.transform.colorTransform = _loc2_;
         this.gotoAndStop(1);
         this.filters = param1?[new GlowFilter(1530524,1,13,13,2,3)]:null;
      }
      
      public function setAccSpeed(param1:Object) : void
      {
         try
         {
            this._speed = param1["speed"];
            this._accSpeed = param1["accSpeed"];
            this._bit = param1["bit"];
            if(!this.$home)
            {
               this.$home = new MovieClip();
               this._accTxt = CommonUtils.addDynamicTxt();
               this._accTxt.width = 120;
               this.$home.addChild(this._accTxt);
            }
            if(this._bit > 0 && this._speed > 0 && !(this.states == VIP_NO_PPVA))
            {
               this.filters = null;
               if(this._speed < this._bit / 2)
               {
                  this.gotoAndStop(3);
               }
               else if(this._speed >= this._bit / 2 && this._speed < this._bit * 1.1)
               {
                  this.gotoAndStop(2);
               }
               else if(this._speed >= this._bit * 1.1)
               {
                  this.gotoAndStop(1);
                  this.filters = [new GlowFilter(1530524,1,13,13,2,3)];
               }
               
               
            }
            this._accTxt.htmlText = CommonUtils.getHtml("下载速度：" + (this._speed > 0?CommonUtils.getNetSpeed(this._speed):"缓冲中..."),"#979797") + "<br>" + CommonUtils.getHtml("会员速度：","#979797") + CommonUtils.getHtml(this._accSpeed > 0?CommonUtils.getNetSpeed(this._accSpeed):"已完成","#EE7303");
            if(!(this._speed > 0) && (this.$isAccelerate))
            {
               this.gotoAndStop(1);
            }
         }
         catch(evt:Error)
         {
         }
      }
   }
}
