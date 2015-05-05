package com.gridsum.VideoTracker.Core
{
   class SeekingVideoStateHandler extends VideoStateHandler
   {
      
      private var _seekingEventId:int = -1;
      
      function SeekingVideoStateHandler(param1:PlayLogic)
      {
         super(param1);
      }
      
      override public function beginHandle(param1:String) : void
      {
         super.beginHandle(param1);
         this._seekingEventId = _playLogic.beginEvent("Seeking","播放状态",_playLogic.VideoResult.vidInfo.cdn,1);
      }
      
      override public function endHandle(param1:String) : void
      {
         super.endHandle(param1);
         _playLogic.endEvent(this._seekingEventId);
      }
   }
}
