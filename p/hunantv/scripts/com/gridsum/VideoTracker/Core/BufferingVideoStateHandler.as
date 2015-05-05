package com.gridsum.VideoTracker.Core
{
   import flash.utils.Timer;
   import flash.events.TimerEvent;
   import com.gridsum.Debug.TextTracer;
   
   class BufferingVideoStateHandler extends VideoStateHandler
   {
      
      private static var _prevBufferStartTime:Date = null;
      
      private static const _oneBufferingThreashhold:Number = 1000;
      
      private const _bufferTimeRefreshInterval:Number = 1000;
      
      private var _bufferTimeRefreshTimer:Timer = null;
      
      private var _bufferStartTime:Date = null;
      
      private var _bufferEndTime:Date = null;
      
      function BufferingVideoStateHandler(param1:PlayLogic)
      {
         super(param1);
      }
      
      override public function beginHandle(param1:String) : void
      {
         super.beginHandle(param1);
         this._bufferStartTime = new Date();
         var _loc2_:GeneralStatisticsVideoResult = _playLogic.VideoResult;
         if(_prevBufferStartTime == null || this._bufferStartTime.getTime() - _prevBufferStartTime.getTime() > _oneBufferingThreashhold)
         {
            _loc2_.AddStickTimeSpan(0);
         }
         _prevBufferStartTime = this._bufferStartTime;
         this._bufferTimeRefreshTimer = new Timer(this._bufferTimeRefreshInterval);
         this._bufferTimeRefreshTimer.addEventListener(TimerEvent.TIMER,this.BufferTimeRefreshTimer_Tick);
         this._bufferTimeRefreshTimer.start();
      }
      
      private function BufferTimeRefreshTimer_Tick(param1:TimerEvent) : void
      {
         this._bufferEndTime = new Date();
         var _loc2_:Number = this._bufferEndTime.getTime() - this._bufferStartTime.getTime();
         this._bufferStartTime = this._bufferEndTime;
         if(Math.abs(_loc2_) > 2 * this._bufferTimeRefreshInterval)
         {
            TextTracer.writeLine("buffer增量重置为" + this._bufferTimeRefreshInterval);
            _loc2_ = this._bufferTimeRefreshInterval;
         }
         _playLogic.VideoResult.AddToLastStickTime(_loc2_ / 1000);
      }
      
      override public function endHandle(param1:String) : void
      {
         super.endHandle(param1);
         this.BufferTimeRefreshTimer_Tick(null);
         if(this._bufferTimeRefreshTimer != null)
         {
            this._bufferTimeRefreshTimer.stop();
            this._bufferTimeRefreshTimer = null;
         }
      }
   }
}
