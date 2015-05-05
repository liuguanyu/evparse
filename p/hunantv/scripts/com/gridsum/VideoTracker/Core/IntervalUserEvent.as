package com.gridsum.VideoTracker.Core
{
   import com.gridsum.Tools.StopWatch;
   
   class IntervalUserEvent extends UserEvent
   {
      
      private var _stopWatch:StopWatch = null;
      
      function IntervalUserEvent()
      {
         super();
         this._stopWatch = new StopWatch();
      }
      
      override public function get type() : int
      {
         return 1;
      }
      
      override public function get duration() : Number
      {
         return this._stopWatch.timeCount / 1000;
      }
      
      public function beginEvent() : void
      {
         this._stopWatch.startWatch();
      }
      
      public function endEvent() : void
      {
         this._stopWatch.pauseWatch();
      }
   }
}
