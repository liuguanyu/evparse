package com.gridsum.VideoTracker.Core
{
   class LoadingVideoStateHandler extends VideoStateHandler
   {
      
      function LoadingVideoStateHandler(param1:PlayLogic)
      {
         super(param1);
      }
      
      override public function beginHandle(param1:String) : void
      {
         var _loc2_:Date = null;
         super.beginHandle(param1);
         if(_playLogic.VideoResult.loadingBeginTime == null)
         {
            _loc2_ = new Date();
            _playLogic.VideoResult.loadingBeginTime = _loc2_;
         }
      }
      
      override public function endHandle(param1:String) : void
      {
         var _loc2_:Date = null;
         super.endHandle(param1);
         if(_playLogic.VideoResult.loadingEndTime == null)
         {
            _loc2_ = new Date();
            _playLogic.VideoResult.loadingEndTime = _loc2_;
         }
         _playLogic.VideoResult.endLoading(true);
      }
   }
}
