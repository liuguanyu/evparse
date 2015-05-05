package cn.pplive.player.view.ui
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.display.Sprite;
   import flash.utils.Timer;
   import cn.pplive.player.utils.CommonUtils;
   import flash.events.TimerEvent;
   import flash.events.TextEvent;
   import cn.pplive.player.manager.InteractiveManager;
   import cn.pplive.player.events.PPLiveEvent;
   import flash.events.Event;
   
   public class AdvBlock extends MovieClip
   {
      
      private var $txt:TextField = null;
      
      private var $count:Sprite = null;
      
      private var $time:TextField = null;
      
      private var $initW:Number = 620;
      
      private var $cdTime:Timer;
      
      private var $cd:Number;
      
      public function AdvBlock()
      {
         super();
         this.$txt = CommonUtils.addDynamicTxt();
         addChild(this.$txt);
         this.$txt.width = this.$initW;
         this.$txt.htmlText = this.getTipStr();
         this.$count = new Sprite();
         addChild(this.$count);
         var skip:TextField = CommonUtils.addDynamicTxt();
         this.$count.addChild(skip);
         skip.mouseEnabled = true;
         skip.wordWrap = skip.multiline = false;
         skip.htmlText = this.descriSkip();
         skip.addEventListener(TextEvent.LINK,this.onLinkHandler);
         with(this.$count)
         {
            
            graphics.clear();
            graphics.lineStyle(1,16777215,0.1);
            graphics.beginFill(3355443,0.5);
            graphics.drawRoundRect(0,0,skip.width + 10,30,5,5);
            graphics.endFill();
         }
         skip.x = Math.floor((this.$count.width - skip.width) / 2);
         skip.y = Math.floor((this.$count.height - skip.height) / 2);
         this.$time = CommonUtils.addDynamicTxt();
         this.$count.addChild(this.$time);
         this.$time.x = this.$count.width / 3;
         this.$time.y = 0;
      }
      
      private function getTipStr() : String
      {
         var _loc1_:* = "";
         _loc1_ = _loc1_ + "<textformat leading=\"6\">";
         _loc1_ = _loc1_ + ("<b>" + CommonUtils.getHtml("呃，广告无法正常播放了...","#f4f4f4",24) + "</b><br><br>");
         _loc1_ = _loc1_ + CommonUtils.getHtml("由于广告合作伙伴的大力支持，PPTV才能为您提供免费的视频服务。<br>请尝试关闭广告屏蔽插件或更换浏览器，收看合作方的广告，<br>让PPTV继续为您提供正版、高清、流畅的视频服务。","#CCCCCC",20);
         _loc1_ = _loc1_ + "</textformat>";
         return _loc1_;
      }
      
      private function onTimerHandler(param1:TimerEvent) : void
      {
         if(this.$cd > 0)
         {
            this.$cd--;
            if(this.$time)
            {
               this.$time.htmlText = this.countdown(this.$cd);
            }
         }
         else
         {
            this.DelAFP();
         }
      }
      
      private function onLinkHandler(param1:TextEvent) : void
      {
         if(param1.text == "skip")
         {
            InteractiveManager.sendEvent(PPLiveEvent.VOD_ONVIP_VALIDATE,"1");
         }
      }
      
      private function descriSkip() : String
      {
         return CommonUtils.getHtml("广告还有    ","#ffffff") + CommonUtils.getHtml("    秒   ","#ffffff") + CommonUtils.getHtml("<a target=\"_blank\" href=\"event:skip\">跳过广告</a>","#FFFF00");
      }
      
      private function countdown(param1:Number) : String
      {
         return CommonUtils.getHtml((param1 < 10?"0":"") + param1,"#FFFF00",20);
      }
      
      public function AddAFP() : void
      {
         this.$cd = 30;
         this.$time.htmlText = this.countdown(this.$cd);
         this.$cdTime = new Timer(1000);
         this.$cdTime.addEventListener(TimerEvent.TIMER,this.onTimerHandler);
         this.$cdTime.start();
      }
      
      public function DelAFP() : void
      {
         if(this.$cdTime)
         {
            this.$cdTime.stop();
            this.$cdTime.removeEventListener(TimerEvent.TIMER,this.onTimerHandler);
            this.$cdTime = null;
         }
         dispatchEvent(new Event("remove_barriers"));
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
         var w:Number = param1;
         var h:Number = param2;
         with(this)
         {
            
            graphics.clear();
            graphics.beginFill(3355443,1);
            graphics.drawRect(0,0,w,h);
            graphics.endFill();
         }
         this.$count.x = w - this.$count.width - 10;
         this.$count.y = 10;
         this.$txt.x = w - this.$txt.width >> 1;
         if(this.$txt.x < 80)
         {
            this.$txt.x = 80;
            this.$txt.width = w - this.$txt.x * 2;
         }
         else
         {
            this.$txt.width = this.$initW;
         }
         this.$txt.x = w - this.$txt.width >> 1;
         this.$txt.y = h - this.$txt.height >> 1;
      }
   }
}
