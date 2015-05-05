package com.gridsum.Tools
{
   import flash.utils.Timer;
   import flash.events.TimerEvent;
   
   public class StopWatch extends Object
   {
      
      private var _baseTimeCount:Number = 0;
      
      private var _timeCount:Number = 0;
      
      private var _timer:Timer = null;
      
      private var _beginTime:Date = null;
      
      private const _timerDelay:Number = 100;
      
      public function StopWatch()
      {
         super();
         this._baseTimeCount = 0;
         this._timeCount = 0;
         this._beginTime = new Date();
         this._timer = new Timer(this._timerDelay);
         this._timer.addEventListener(TimerEvent.TIMER,this.onTimer);
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         this._timeCount = this._timeCount + this._timer.delay;
      }
      
      public function startWatch() : void
      {
         this._timer.start();
         this._beginTime = new Date();
      }
      
      public function pauseWatch() : void
      {
         this._timer.stop();
         this._baseTimeCount = this._baseTimeCount + this.getAdjustTimeElapse();
         this._timeCount = 0;
      }
      
      public function resetWatch() : void
      {
         this._baseTimeCount = 0;
         this._timeCount = 0;
         this._beginTime = new Date();
      }
      
      public function get timeCount() : Number
      {
         return this._baseTimeCount + this.getAdjustTimeElapse();
      }
      
      private function getAdjustTimeElapse() : Number
      {
         var _loc1_:Date = new Date();
         var _loc2_:Number = _loc1_.getTime() - this._beginTime.getTime();
         if(this._timeCount < this._timerDelay / 3)
         {
            if(Math.abs(_loc2_) < 5 * this._timerDelay)
            {
               return _loc2_;
            }
            return this._timeCount;
         }
         if(Math.abs(_loc2_ - this._timeCount) / this._timeCount < 1)
         {
            return _loc2_;
         }
         return this._timeCount;
      }
   }
}
