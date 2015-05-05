package pptv.skin.view.ui
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.events.MouseEvent;
   import flash.events.Event;
   import cn.pplive.player.utils.CommonUtils;
   
   public dynamic class RadioBox extends MovieClip
   {
      
      private var $label:TextField;
      
      private var $radio:Radio;
      
      private var $w:Number;
      
      private var $h:Number;
      
      private var $dis:Number = 5;
      
      private var $color:String = "#9d9d9d";
      
      public function RadioBox()
      {
         super();
         this.$radio = new Radio();
         addChild(this.$radio);
         this.$label = CommonUtils.addDynamicTxt();
         addChild(this.$label);
         this.$label.wordWrap = this.$label.multiline = false;
         mouseChildren = false;
         buttonMode = true;
         addEventListener(MouseEvent.CLICK,this.onClickHandler);
         this.select = false;
      }
      
      private function onClickHandler(param1:MouseEvent) : void
      {
         this.select = true;
         dispatchEvent(new Event("_select_"));
      }
      
      public function set text(param1:String) : void
      {
         var value:String = param1;
         this.$label.htmlText = CommonUtils.getHtml(value,this.$color);
         this.$w = this.$radio.width + this.$label.width + this.$dis * 2;
         this.$h = Math.max(this.$radio.height,this.$label.height);
         with(this)
         {
            
            graphics.clear();
            graphics.beginFill(0,0);
            graphics.drawRect(0,0,$w,$h);
            graphics.endFill();
         }
         this.$radio.x = this.$dis;
         this.$radio.y = this.$h - this.$radio.height >> 1;
         this.$label.x = this.$radio.x + this.$radio.width;
         this.$label.y = this.$h - this.$label.height >> 1;
      }
      
      public function set select(param1:Boolean) : void
      {
         this.$radio.gotoAndStop(Number(param1) + 1);
      }
      
      override public function get width() : Number
      {
         return this.$w;
      }
      
      public function set color(param1:String) : void
      {
         this.$color = param1;
         this.$label.htmlText = CommonUtils.getHtml(this.$label.text,this.$color);
      }
   }
}
