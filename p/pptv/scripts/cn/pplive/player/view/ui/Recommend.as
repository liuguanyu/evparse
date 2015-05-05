package cn.pplive.player.view.ui
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import cn.pplive.player.utils.loader.DisplayLoader;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.display.Sprite;
   import cn.pplive.player.utils.CommonUtils;
   
   public dynamic class Recommend extends MovieClip
   {
      
      private var $ow:Number = 124;
      
      private var $oh:Number = 94;
      
      private var $tH:Number = 30;
      
      private var $text:String;
      
      private var $txt:TextField;
      
      private var $lo:DisplayLoader;
      
      private var $url:String;
      
      private var $box:MovieClip;
      
      private var $content;
      
      public function Recommend()
      {
         super();
         with(this)
         {
            
            graphics.beginFill(3355443,0);
            graphics.lineStyle(1,6710886,1);
            graphics.drawRect(0,0,$ow,$oh);
            graphics.endFill();
         }
         this.$box = new MovieClip();
         addChild(this.$box);
      }
      
      override public function get width() : Number
      {
         return this.$ow;
      }
      
      override public function get height() : Number
      {
         return this.$oh;
      }
      
      public function set recom(param1:Object) : void
      {
         this.$url = param1["url"];
         this.$text = param1["text"];
         if(!this.$url || this.$url.length == 0)
         {
            return;
         }
         this.$lo = new DisplayLoader(this.$url,10);
         this.$lo.addEventListener("_complete_",this.onRecommendHandler);
         this.$lo.addEventListener("_ioerror_",this.onRecommendHandler);
         this.$lo.addEventListener("_securityerror_",this.onRecommendHandler);
         this.$lo.addEventListener("_timeout_",this.onRecommendHandler);
      }
      
      private function onRecommendHandler(param1:Event) : void
      {
         var per:Number = NaN;
         var $rect:Rectangle = null;
         var $sp:Sprite = null;
         var e:Event = param1;
         switch(e.type)
         {
            case "_ioerror_":
            case "_securityerror_":
            case "_timeout_":
               this.$lo.clear();
               break;
            case "_complete_":
               this.$content = this.$lo.content;
               this.$box.addChild(this.$content);
               per = this.$content.width / this.$content.height;
               if(120 / 90 > per)
               {
                  this.$content.width = 120;
                  this.$content.height = this.$content.width / per >> 0;
               }
               else
               {
                  this.$content.height = 90;
                  this.$content.width = this.$content.height * per >> 0;
               }
               $rect = new Rectangle(Math.abs(this.$content.width - 120) / 2,Math.abs(this.$content.height - 90) / 2,Math.min(this.$content.width,120),Math.min(this.$content.height,90));
               this.$box.scrollRect = $rect;
               this.$box.x = this.$ow - $rect.width >> 1;
               this.$box.y = this.$oh - $rect.height >> 1;
               $sp = new Sprite();
               addChild($sp);
               $sp.y = this.$oh - this.$tH;
               with($sp)
               {
                  
                  graphics.beginFill(3355443,0.6);
                  graphics.drawRect(0,0,$ow,$tH);
                  graphics.endFill();
               }
               this.$txt = CommonUtils.addDynamicTxt();
               $sp.addChild(this.$txt);
               this.$txt.wordWrap = this.$txt.multiline = false;
               this.$txt.htmlText = CommonUtils.getHtml(CommonUtils.getActionStr(this.$text,22),"#ffffff");
               this.$txt.x = this.$ow - this.$txt.textWidth >> 1;
               this.$txt.y = this.$tH - this.$txt.height >> 1;
               break;
         }
      }
   }
}
