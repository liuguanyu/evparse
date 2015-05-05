package cn.pplive.player.view.ui
{
   import flash.display.Sprite;
   import flash.display.MovieClip;
   import cn.pplive.player.common.RecommendItem;
   import flash.events.MouseEvent;
   import flash.events.Event;
   import pptv.skin.view.events.SkinEvent;
   
   public class RecommendBox extends Sprite
   {
      
      private var $item:Array;
      
      private var $w:Number;
      
      private var $h:Number;
      
      private var $box:MovieClip = null;
      
      private var $col:Number;
      
      private var $row:Number;
      
      private var $recom:Vector.<RecommendItem>;
      
      private var $recomBtn:RecomBtn;
      
      public var requestUUID:String = "";
      
      public function RecommendBox()
      {
         super();
         this.$box = new MovieClip();
         addChild(this.$box);
         this.$item = [];
      }
      
      public function set recom(param1:Vector.<RecommendItem>) : void
      {
         this.$recom = param1;
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
         var w:Number = param1;
         var h:Number = param2;
         this.$w = w;
         this.$h = h;
         with(this)
         {
            
            graphics.clear();
            graphics.beginFill(0,1);
            graphics.drawRect(0,0,$w,$h);
            graphics.endFill();
         }
         this.$col = stage.displayState == "fullScreen"?5:(this.$w - 100 * 2) / 140 >> 0;
         if(this.$col < 1)
         {
            this.$col = 1;
         }
         this.$row = stage.displayState == "fullScreen"?4:(this.$h - 100 * 2) / 105 >> 0;
         if(this.$row < 1)
         {
            this.$row = 1;
         }
         var len:int = Math.min(this.$recom.length,this.$col * this.$row);
         this.$row = Math.floor((len - 1) / this.$col) + 1;
         var i:int = 0;
         while(i < this.$recom.length)
         {
            if(!this.$item[i])
            {
               this.$item[i] = new Recommend();
               this.$box.addChild(this.$item[i]);
               this.$item[i].buttonMode = true;
               this.$item[i].addEventListener(MouseEvent.CLICK,this.onClickHandler);
            }
            this.$item[i].link = this.$recom[i]["link"] + "?rcc_src=vodplayer_recommend";
            this.$item[i].id = this.$recom[i]["id"];
            this.$item[i].recom = {
               "url":this.$recom[i]["capture"],
               "text":this.$recom[i]["title"]
            };
            this.$item[i].x = (this.$item[i].width + 5) * (i % this.$col) + 5;
            this.$item[i].y = (this.$item[i].height + 5) * Math.floor(i / this.$col) + 5;
            this.$item[i].visible = !(i > this.$col * this.$row - 1);
            i++;
         }
         var $bw:Number = this.$col * (this.$item[0].width + 5) + 5;
         var $bh:Number = this.$row * (this.$item[0].height + 5) + 5;
         if(!this.$recomBtn)
         {
            this.$recomBtn = new RecomBtn();
            this.$box.addChild(this.$recomBtn);
            this.$recomBtn.share_mc.addEventListener(MouseEvent.CLICK,this.onClickHandler);
            this.$recomBtn.replay_mc.addEventListener(MouseEvent.CLICK,this.onClickHandler);
         }
         this.$recomBtn.x = 0;
         this.$recomBtn.y = $bh;
         this.$box.x = this.$w - $bw >> 1;
         this.$box.y = this.$h - $bh >> 1;
      }
      
      public function shareDisable(param1:Boolean) : void
      {
         this.$recomBtn.share_mc.enabled = this.$recomBtn.share_mc.mouseEnabled = !param1;
         this.$recomBtn.share_mc.alpha = !param1?1:0.4;
      }
      
      private function onClickHandler(param1:MouseEvent) : void
      {
         switch(param1.target)
         {
            case this.$recomBtn.share_mc:
               this.dispatchEvent(new Event("_share_"));
               break;
            case this.$recomBtn.replay_mc:
               this.dispatchEvent(new Event("_replay_"));
               break;
            default:
               this.dispatchEvent(new SkinEvent(SkinEvent.MEDIA_RECOMMEND_CLICK,{
                  "channeled":param1.currentTarget.id,
                  "link":param1.currentTarget.link,
                  "title":param1.currentTarget.title,
                  "Uuid":this.requestUUID
               }));
         }
      }
   }
}
