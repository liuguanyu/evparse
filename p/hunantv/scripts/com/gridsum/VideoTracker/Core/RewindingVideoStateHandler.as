package com.gridsum.VideoTracker.Core
{
   import com.gridsum.Debug.TextTracer;
   
   class RewindingVideoStateHandler extends VideoStateHandler
   {
      
      function RewindingVideoStateHandler(param1:PlayLogic)
      {
         super(param1);
      }
      
      override public function beginHandle(param1:String) : void
      {
         var _loc2_:* = NaN;
         var _loc3_:* = NaN;
         var _loc4_:* = NaN;
         var _loc5_:ClipView = null;
         var _loc6_:ClipView = null;
         var _loc7_:* = NaN;
         var _loc8_:ClipView = null;
         var _loc9_:uint = 0;
         super.beginHandle(param1);
         if(_playLogic.playCmd == CmdType.vodPlay)
         {
            _loc2_ = _playLogic.getVideoPosition();
            _loc3_ = _playLogic.getTotalTime();
            _loc4_ = _playLogic.VideoResult.clipLength;
            _loc5_ = _playLogic.VideoResult.GetClipViewByPosition(_loc2_);
            _loc6_ = _playLogic.VideoResult.GetClipViewByPosition(_loc3_);
            if(_loc2_ < _loc3_)
            {
               _loc7_ = (_loc5_.index + 1) * _loc4_ - _loc2_;
               _loc5_.view(_loc7_ / _loc4_);
               _loc8_ = null;
               _loc9_ = _loc5_.index + 1;
               while(_loc9_ < _loc6_.index)
               {
                  _loc8_ = _playLogic.VideoResult.GetClipViewByIndex(_loc9_);
                  if(_loc8_ != null)
                  {
                     _loc8_.view(1);
                  }
                  else
                  {
                     TextTracer.writeLine("[Error][PlayingVideoStateHandler.Timer_Tick]Cannot find clipViews[" + _loc9_ + "]");
                  }
                  _loc9_++;
               }
            }
            TextTracer.writeLine("Rewinding, position = " + _playLogic.getVideoPosition() + " totalTime = " + _loc3_);
         }
      }
      
      override public function endHandle(param1:String) : void
      {
         var _loc2_:* = NaN;
         var _loc3_:* = NaN;
         var _loc4_:ClipView = null;
         var _loc5_:ClipView = null;
         var _loc6_:uint = 0;
         var _loc7_:* = NaN;
         super.endHandle(param1);
         if(_playLogic.playCmd == CmdType.vodPlay)
         {
            _loc2_ = _playLogic.VideoResult.clipLength;
            _loc3_ = _playLogic.getVideoPosition();
            _loc4_ = _playLogic.VideoResult.GetClipViewByPosition(_loc3_);
            _loc5_ = null;
            _loc6_ = 0;
            while(_loc6_ < _loc4_.index)
            {
               _loc5_ = _playLogic.VideoResult.GetClipViewByIndex(_loc6_);
               _loc6_++;
            }
            _loc7_ = _loc3_ - _loc4_.index * _loc2_;
            _loc4_.view(_loc7_ / _loc2_);
            TextTracer.writeLine("Rewind end, position = " + _playLogic.getVideoPosition());
         }
      }
   }
}
