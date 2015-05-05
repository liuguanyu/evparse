package pptv.skin.view.ui
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.StyleSheet;
   import flash.display.SimpleButton;
   import flash.events.TextEvent;
   import pptv.skin.view.events.SkinEvent;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import flash.events.MouseEvent;
   import flash.text.TextFormat;
   
   public class PlayerTipUI extends MovieClip
   {
      
      public var bg:MovieClip;
      
      public var close_btn:Close;
      
      private var $tip:String;
      
      private var $tipTxt:TextField;
      
      private var $interval:Number = 0;
      
      private var $times:Number = 0;
      
      private var $css:StyleSheet;
      
      private var $link:String = "";
      
      private var $close:SimpleButton;
      
      private var $display:Number = 7000;
      
      private var $count:int = 0;
      
      private var _inter:uint;
      
      private var _ct:uint;
      
      public function PlayerTipUI()
      {
         super();
         this.$tipTxt = new TextField();
         addChild(this.$tipTxt);
         this.$tipTxt.x = 10;
         this.$tipTxt.autoSize = "left";
         this.$tipTxt.wordWrap = this.$tipTxt.multiline = false;
         this.$tipTxt.defaultTextFormat = new TextFormat("Arial",12,16777215);
         this.$css = new StyleSheet();
         this.$css.parseCSS("a {color:#0099FF;text-decoration:underline;}");
         this.$css.parseCSS("a:link,a:visited,a:active {color:#0099FF; text-decoration:underline;}");
         this.$tipTxt.addEventListener(TextEvent.LINK,this.onTextLinkHandler);
         this.$close = this.getChildByName("close_btn") as SimpleButton;
         this.$close.addEventListener(MouseEvent.CLICK,this.onCloseHandler);
         this.visible = false;
      }
      
      private function onTextLinkHandler(param1:TextEvent) : void
      {
         this.dispatchEvent(new SkinEvent(SkinEvent.MEDIA_HREF,{
            "value":param1.text,
            "link":this.$link
         }));
      }
      
      public function setObj(param1:Object) : void
      {
         this.$count = 0;
         if(this._ct)
         {
            clearTimeout(this._ct);
         }
         if(this._inter)
         {
            clearTimeout(this._inter);
         }
         if(param1["html"] != undefined)
         {
            this.$tip = param1["html"].toString();
         }
         if(param1["link"] != undefined)
         {
            this.$link = param1["link"].toString();
         }
         if(param1["times"] != undefined)
         {
            this.$times = Number(param1["times"]);
            if(isNaN(this.$times))
            {
               this.$times = 0;
            }
         }
         if(param1["display"] != undefined)
         {
            this.$display = Number(param1["display"]);
            if(isNaN(this.$display))
            {
               this.$display = 5000;
            }
         }
         if(param1["interval"] != undefined)
         {
            this.$interval = Number(param1["interval"]);
            if(isNaN(this.$interval))
            {
               this.$interval = 5000;
            }
         }
         this.$tipTxt.styleSheet = this.$css;
         this.$tipTxt.htmlText = this.$tip;
         if(this.$tipTxt.width > 280)
         {
            this.$tipTxt.width = 280;
            this.$tipTxt.wordWrap = this.$tipTxt.multiline = true;
            this.$tipTxt.htmlText = this.$tip;
         }
         this.$tipTxt.y = 5;
         this["bg"].width = this.$tipTxt.x + this.$tipTxt.width + 5 + this.$close.width;
         this["bg"].height = this.$tipTxt.y * 2 + this.$tipTxt.height;
         if(this["bg"].height < this.$close.height)
         {
            this.$close.height = this["bg"].height;
         }
         this.$close.x = this["bg"].width - this.$close.width;
         this.showTip();
      }
      
      private function showTip() : void
      {
         this.visible = true;
         if(this.$times > 0)
         {
            this.hideTip(this.$display);
         }
      }
      
      private function hideTip(param1:Number = 5000) : void
      {
         var self:* = undefined;
         var num:Number = param1;
         self = this;
         this._ct = setTimeout(function():void
         {
            self.visible = false;
            if($count < $times - 1)
            {
               $count++;
               _inter = setTimeout(showTip,$interval);
            }
         },num);
      }
      
      private function onCloseHandler(param1:MouseEvent) : void
      {
         this.$times = 0;
         this.hideTip(1);
      }
      
      override public function get width() : Number
      {
         return this["bg"].width;
      }
      
      override public function get height() : Number
      {
         return this["bg"].height;
      }
   }
}
