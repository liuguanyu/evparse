package pptv.skin.view.ui
{
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   import pptv.skin.view.events.SkinEvent;
   import flash.events.MouseEvent;
   import cn.pplive.player.view.ui.ToolTips;
   import flash.utils.clearTimeout;
   import flash.geom.Point;
   import flash.filters.DropShadowFilter;
   import flash.utils.setTimeout;
   import flash.text.TextField;
   import cn.pplive.player.utils.hash.Global;
   import cn.pplive.player.utils.CommonUtils;
   
   public class SoundUI extends MovieClip
   {
      
      private var _muteMc:MovieClip;
      
      private var _unmuteMc:MovieClip;
      
      private var _soundChangeMc:SoundChangeMc;
      
      private var _cft:ColorTransform;
      
      private var $inter:uint;
      
      private var $sdTip:ToolTips;
      
      private var $interval:uint;
      
      private var $volume:Number;
      
      public function SoundUI()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._muteMc = this.getChildByName("MuteMc") as MovieClip;
         this._unmuteMc = this.getChildByName("UnmuteMc") as MovieClip;
         this._unmuteMc["line_mc"].mouseEnabled = false;
         this._cft = this._unmuteMc["line_mc"].transform.colorTransform;
         this._soundChangeMc = new SoundChangeMc();
         this._soundChangeMc.addEventListener(SkinEvent.MEDIA_SOUND,this.onChangHandler);
         this._muteMc.visible = false;
         this._unmuteMc.visible = true;
         this._muteMc.buttonMode = true;
         this._muteMc.addEventListener(MouseEvent.CLICK,this.onClickHandler);
         this._unmuteMc.buttonMode = true;
         this._unmuteMc.addEventListener(MouseEvent.CLICK,this.onClickHandler);
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseHandler);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseHandler);
      }
      
      private function onMouseHandler(param1:MouseEvent) : void
      {
         var _loc2_:ColorTransform = null;
         switch(param1.type)
         {
            case MouseEvent.MOUSE_OVER:
               if(this.$inter)
               {
                  clearTimeout(this.$inter);
               }
               if(!this.$sdTip)
               {
                  this.$sdTip = new ToolTips();
                  this.$sdTip.bgColor = 2236962;
                  this.$sdTip.bgAlpha = 0.95;
                  this.$sdTip.cornerRadius = 0;
                  this.$sdTip.hookSize = 8;
                  this.$sdTip.spacing = 0;
               }
               this.$sdTip.addEventListener(MouseEvent.MOUSE_OVER,this.onSdTipHandler);
               this.$sdTip.addEventListener(MouseEvent.MOUSE_OUT,this.onSdTipHandler);
               this.$sdTip.visible = false;
               this.$sdTip.source = null;
               this.reposition();
               _loc2_ = new ColorTransform();
               _loc2_.color = 3381759;
               this._unmuteMc["line_mc"].transform.colorTransform = _loc2_;
               break;
            case MouseEvent.MOUSE_OUT:
               this.hideTip();
               this._unmuteMc["line_mc"].transform.colorTransform = this._cft;
               break;
         }
      }
      
      private function onSdTipHandler(param1:MouseEvent) : void
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
      
      private function reposition() : void
      {
         var _loc1_:Point = null;
         try
         {
            this["parent"]["parent"]["parent"].addChild(this.$sdTip);
            _loc1_ = this["parent"].localToGlobal(new Point(this.x,this.y));
            this.$sdTip.visible = true;
            this.$sdTip.source = this._soundChangeMc;
            this.$sdTip.x = _loc1_.x - (this.$sdTip.width - this.width) / 2 >> 0;
            this.$sdTip.y = _loc1_.y - this.$sdTip.height;
            this.$sdTip.offSet = this.$sdTip.width >> 1;
            this.$sdTip.filters = [new DropShadowFilter(2,90,0,1,15,15,0.4,3)];
         }
         catch(evt:Error)
         {
         }
      }
      
      private function hideTip() : void
      {
         this.$inter = setTimeout(function():void
         {
            if($sdTip)
            {
               $sdTip.visible = false;
            }
         },0.3 * 1000);
      }
      
      private function onChangHandler(param1:SkinEvent) : void
      {
         this.goto(param1.currObj["value"]);
         if(param1.currObj["value"] == 0)
         {
            this.setMute(true);
         }
         else
         {
            this.setMute(false);
            if(param1.currObj["value"] == 100 && this.$volume > 100)
            {
               param1.currObj["value"] = this.$volume;
            }
         }
         this.dispatchEvent(new SkinEvent(SkinEvent.MEDIA_SOUND,param1.currObj));
      }
      
      private function onClickHandler(param1:MouseEvent) : void
      {
         this._soundChangeMc.click = true;
         switch(param1.currentTarget)
         {
            case this._muteMc:
               this.setMute(false);
               this._soundChangeMc.setSound(this._soundChangeMc.volumeHeight);
               break;
            case this._unmuteMc:
               this.setMute(true);
               this._soundChangeMc.setSound(0);
               break;
         }
         this._soundChangeMc.click = false;
      }
      
      private function setMute(param1:Boolean) : void
      {
         this._muteMc.visible = param1;
         this._unmuteMc.visible = !param1;
      }
      
      public function goto(param1:Number) : void
      {
         if(param1 > 0)
         {
            this.setMute(false);
            if(param1 <= 30)
            {
               this._unmuteMc["line_mc"].gotoAndStop(1);
            }
            else if(param1 > 30 && param1 <= 60)
            {
               this._unmuteMc["line_mc"].gotoAndStop(2);
            }
            else if(param1 > 60 && param1 <= 100)
            {
               this._unmuteMc["line_mc"].gotoAndStop(3);
            }
            else if(param1 > 100)
            {
               this._unmuteMc["line_mc"].gotoAndStop(4);
            }
            
            
            
         }
         else
         {
            this.setMute(true);
         }
      }
      
      public function setSound(param1:Number) : void
      {
         var value:Number = param1;
         this.goto(value);
         this._soundChangeMc.setSlider(value);
         if(value != 0)
         {
            this.$volume = value;
         }
         if(this.$interval)
         {
            clearTimeout(this.$interval);
         }
         this["parent"]["parent"]["parent"].addChild(Global.getInstance()["tip"]);
         Global.getInstance()["tip"].name = "soundtip";
         Global.getInstance()["tip"].visible = false;
         Global.getInstance()["tip"].source = null;
         var $label:TextField = new TextField();
         $label.autoSize = "left";
         $label.htmlText = CommonUtils.getHtml(value + "%","#ffffff");
         var $global:Point = this._soundChangeMc["parent"].localToGlobal(new Point(this._soundChangeMc.x,this._soundChangeMc["soundDrag"].y));
         Global.getInstance()["tip"].dir = "right";
         Global.getInstance()["tip"].visible = true;
         Global.getInstance()["tip"].source = $label;
         Global.getInstance()["tip"].x = $global.x - Global.getInstance()["tip"].width - 5;
         Global.getInstance()["tip"].y = $global.y - Global.getInstance()["tip"].height / 2 >> 0;
         Global.getInstance()["tip"].offSet = Global.getInstance()["tip"].height >> 1;
         this.$interval = setTimeout(function():void
         {
            Global.getInstance()["tip"].visible = false;
            Global.getInstance()["tip"].source = null;
         },0.5 * 1000);
      }
   }
}
