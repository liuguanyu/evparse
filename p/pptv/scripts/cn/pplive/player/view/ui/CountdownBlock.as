package cn.pplive.player.view.ui
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.utils.Timer;
   import flash.events.TimerEvent;
   import cn.pplive.player.utils.CommonUtils;
   import flash.events.Event;
   
   public class CountdownBlock extends MovieClip
   {
      
      private var $time:TextField = null;
      
      private var $cdTime:Timer;
      
      private var $cd:Number;
      
      public function CountdownBlock()
      {
         super();
         this.$time = CommonUtils.addDynamicTxt();
         this.$time.wordWrap = this.$time.multiline = false;
         addChild(this.$time);
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
            this.DelTime();
         }
      }
      
      private function countdown(param1:Number) : String
      {
         return CommonUtils.getHtml("节目还有 " + CommonUtils.setTimeFormat(param1,false) + " 开始播放","#FFFFFF",18);
      }
      
      public function AddTime(param1:Number) : void
      {
         this.$cd = param1;
         this.$time.htmlText = this.countdown(this.$cd);
         this.$cdTime = new Timer(1000);
         this.$cdTime.addEventListener(TimerEvent.TIMER,this.onTimerHandler);
         this.$cdTime.start();
      }
      
      private function DelTime() : void
      {
         if(this.$cdTime)
         {
            this.$cdTime.stop();
            this.$cdTime.removeEventListener(TimerEvent.TIMER,this.onTimerHandler);
            this.$cdTime = null;
         }
         dispatchEvent(new Event("countdown_over"));
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
         this.$time.x = param1 - this.$time.width >> 1;
         this.$time.y = (param2 - this.$time.height >> 1) + 110;
      }
   }
}
