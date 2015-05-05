package cn.pplive.player.view.ui
{
   import flash.display.Sprite;
   import flash.text.StyleSheet;
   import flash.display.DisplayObject;
   import flash.text.TextField;
   
   public class ToolTips extends Sprite
   {
      
      private var $bw:Number;
      
      private var $bh:Number;
      
      private var $css:StyleSheet;
      
      private var $source:DisplayObject;
      
      private var $offSet:Number;
      
      private var $hook:Boolean = true;
      
      private var $bgColor:uint = 0;
      
      private var $bgAlpha:Number = 1;
      
      private var $lineColor:uint = 10066329;
      
      private var $lineAlpha:Number = 0;
      
      private var $dir:String = "bottom";
      
      private var $cornerRadius:Number = 10;
      
      private var $hookSize:Number = 6;
      
      private var $spacing:Number = 0;
      
      public function ToolTips()
      {
         super();
      }
      
      public function set source(param1:DisplayObject) : void
      {
         if(!param1)
         {
            if(this.$source)
            {
               removeChild(this.$source);
               this.$source = null;
            }
            return;
         }
         if(this.$source)
         {
            removeChild(this.$source);
            this.$source = null;
         }
         this.$source = param1;
         addChild(this.$source);
         if(this.$source is TextField)
         {
            this.$source["autoSize"] = "left";
            this.$source["antiAliasType"] = "advanced";
            if(this.$source.width > 220)
            {
               this.$source.width = 220;
               this.$source["wordWrap"] = true;
            }
            this.$css = new StyleSheet();
            this.$css.parseCSS("a {color:#0099FF;text-decoration:underline;}");
            this.$css.parseCSS("a:link,a:visited,a:active {color:#0099FF; text-decoration:underline;}");
            this.$source["styleSheet"] = this.$css;
         }
         this.$bw = this.$source.width + this.$spacing * 2;
         this.$bh = this.$source.height + this.$spacing * 2;
         if(this.$dir == "top")
         {
            this.$source.x = this.width - this.$source.width >> 1;
            this.$source.y = this.$hookSize + (this.height - this.$hookSize - this.$source.height >> 1);
         }
         else if(this.$dir == "right")
         {
            this.$source.x = this.width - this.$hookSize - this.$source.width >> 1;
            this.$source.y = this.height - this.$source.height >> 1;
         }
         else if(this.$dir == "bottom")
         {
            this.$source.x = this.width - this.$source.width >> 1;
            this.$source.y = this.height - this.$hookSize - this.$source.height >> 1;
         }
         else if(this.$dir == "left")
         {
            this.$source.x = this.$hookSize + (this.width - this.$hookSize - this.$source.width >> 1);
            this.$source.y = this.height - this.$source.height >> 1;
         }
         
         
         
      }
      
      override public function get height() : Number
      {
         return this.$bh + (this.$dir == "top" || this.$dir == "bottom"?this.$hookSize:0);
      }
      
      override public function get width() : Number
      {
         return this.$bw + (this.$dir == "left" || this.$dir == "right"?this.$hookSize:0);
      }
      
      public function set offSet(param1:Number) : void
      {
         this.$offSet = param1;
         this.draw();
      }
      
      private function draw() : void
      {
         if(this.$lineAlpha == 0)
         {
            this.$lineColor = this.$bgColor;
            this.$lineAlpha = 1;
         }
         var bc:uint = this.$bgColor;
         var lc:uint = this.$lineColor;
         var ba:Number = this.$bgAlpha;
         var la:Number = this.$lineAlpha;
         var xp:Number = 0;
         var yp:Number = 0;
         var w:Number = this.$bw;
         var h:Number = this.$bh;
         if(this.$dir == "top")
         {
            yp = this.$hookSize;
         }
         if(this.$dir == "left")
         {
            xp = this.$hookSize;
         }
         if(this.$offSet < this.$cornerRadius + this.$hookSize)
         {
            this.$offSet = this.$cornerRadius + this.$hookSize;
         }
         if((this.$dir == "top" || this.$dir == "bottom") && this.$offSet > this.$bw - this.$cornerRadius - this.$hookSize)
         {
            this.$offSet = this.$bw - this.$cornerRadius - this.$hookSize;
         }
         if((this.$dir == "left" || this.$dir == "right") && this.$offSet > this.$bh - this.$cornerRadius - this.$hookSize)
         {
            this.$offSet = this.$bh - this.$cornerRadius - this.$hookSize;
         }
         with(_loc2_)
         {
            
            graphics.clear();
            graphics.beginFill(bc,ba);
            if($hook)
            {
               graphics.moveTo(xp + $cornerRadius,yp);
               if($dir == "top")
               {
                  graphics.lineTo(xp + $offSet + $hookSize,yp);
                  graphics.lineTo(xp + $offSet,yp - $hookSize);
                  graphics.lineTo(xp + $offSet - $hookSize,yp);
               }
               graphics.lineTo(xp + w - $cornerRadius,yp);
               graphics.curveTo(xp + w,yp,xp + w,yp + $cornerRadius);
               if($dir == "right")
               {
                  graphics.lineTo(xp + w,yp + $offSet + $hookSize);
                  graphics.lineTo(xp + w + $hookSize,yp + $offSet);
                  graphics.lineTo(xp + w,yp + $offSet - $hookSize);
               }
               graphics.lineTo(xp + w,yp + h - $cornerRadius);
               graphics.curveTo(xp + w,yp + h,xp + w - $cornerRadius,yp + h);
               if($dir == "bottom")
               {
                  graphics.lineTo(xp + $offSet + $hookSize,yp + h);
                  graphics.lineTo(xp + $offSet,$hookSize + yp + h);
                  graphics.lineTo(xp + $offSet - $hookSize,yp + h);
               }
               graphics.lineTo(xp + $cornerRadius,yp + h);
               graphics.curveTo(xp,yp + h,xp,yp + h - $cornerRadius);
               if($dir == "left")
               {
                  graphics.lineTo(xp,yp + $offSet + $hookSize);
                  graphics.lineTo(xp - $hookSize,yp + $offSet);
                  graphics.lineTo(xp,yp + $offSet - $hookSize);
               }
               graphics.lineTo(xp,yp + $cornerRadius);
               graphics.curveTo(xp,yp,xp + $cornerRadius,yp);
            }
            else
            {
               graphics.drawRoundRect(xp,yp,w,h,$cornerRadius);
            }
            graphics.endFill();
         }
      }
      
      public function set hook(param1:Boolean) : void
      {
         this.$hook = param1;
      }
      
      public function set bgColor(param1:uint) : void
      {
         this.$bgColor = param1;
      }
      
      public function set bgAlpha(param1:Number) : void
      {
         this.$bgAlpha = param1;
      }
      
      public function set lineColor(param1:uint) : void
      {
         this.$lineColor = param1;
      }
      
      public function set lineAlpha(param1:Number) : void
      {
         this.$lineAlpha = param1;
      }
      
      public function set dir(param1:String) : void
      {
         this.$dir = param1;
      }
      
      public function set cornerRadius(param1:Number) : void
      {
         this.$cornerRadius = param1;
      }
      
      public function set hookSize(param1:Number) : void
      {
         this.$hookSize = param1;
      }
      
      public function set spacing(param1:Number) : void
      {
         this.$spacing = param1;
      }
   }
}
