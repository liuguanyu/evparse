package com.gridsum.VideoTracker.Core
{
   import flash.utils.Timer;
   import flash.events.TimerEvent;
   import com.gridsum.Debug.TextTracer;
   
   class PlayingVideoStateHandler extends VideoStateHandler
   {
      
      private const _checkingIntervalSeconds:Number = 100;
      
      private const _checkingBitrateInterval:Number = 1000;
      
      private const _checkingFramerateInterval:Number = 1000;
      
      private var _cvcsTimer:Timer = null;
      
      private var _bitrateTimer:Timer = null;
      
      private var _framerateTimer:Timer = null;
      
      private var _prevClipView:ClipView = null;
      
      private var _prevPosition:Number = 0;
      
      private var _prevDate:Date = null;
      
      private var _diffThreshold:Number = 1;
      
      private var _prevTime:Date = null;
      
      function PlayingVideoStateHandler(param1:PlayLogic)
      {
         super(param1);
         _isBeginCalled = false;
         _isEndCalled = false;
      }
      
      override public function beginHandle(param1:String) : void
      {
         super.beginHandle(param1);
         if(!_playLogic.IsVideoReady)
         {
            return;
         }
         var _loc2_:GeneralStatisticsVideoResult = _playLogic.VideoResult;
         _loc2_.startPlayingTimer();
         if(_playLogic.playCmd != CmdType.livePlay)
         {
            this._prevPosition = _playLogic.getVideoPosition();
            this._prevClipView = _playLogic.VideoResult.GetClipViewByPosition(this._prevPosition);
            this._cvcsTimer = new Timer(this._checkingIntervalSeconds);
            if(_playLogic.playCmd == CmdType.vodPlay)
            {
               this._cvcsTimer.addEventListener(TimerEvent.TIMER,this.VodTimer_Tick);
            }
            else if(_playLogic.playCmd == CmdType.shiftPlay)
            {
               this._prevDate = _playLogic.VideoResult.clipViewDate;
               this._cvcsTimer.addEventListener(TimerEvent.TIMER,this.ShiftTimer_Tick);
            }
            
            this._cvcsTimer.start();
         }
         this._bitrateTimer = new Timer(this._checkingBitrateInterval);
         this._bitrateTimer.addEventListener(TimerEvent.TIMER,this.BitrateTimer_Tick);
         this._bitrateTimer.start();
         this._prevTime = new Date();
         this._framerateTimer = new Timer(this._checkingFramerateInterval);
         this._framerateTimer.addEventListener(TimerEvent.TIMER,this.FramerateTimer_Tick);
         this._framerateTimer.start();
      }
      
      private function BitrateTimer_Tick(param1:TimerEvent) : void
      {
         var _loc2_:Date = new Date();
         var _loc3_:int = _playLogic.getCurrentBitrate();
         var _loc4_:Number = (_loc2_.getTime() - this._prevTime.getTime()) / 1000;
         _playLogic.VideoResult.addBitrateKbps(_loc3_,_loc4_);
         this._prevTime = _loc2_;
      }
      
      private function FramerateTimer_Tick(param1:TimerEvent) : void
      {
         _playLogic.checkFramerate();
      }
      
      private function VodTimer_Tick(param1:TimerEvent) : void
      {
         var _loc2_:Number = _playLogic.getVideoPosition();
         var _loc3_:ClipView = _playLogic.VideoResult.GetClipViewByPosition(_loc2_);
         if(_loc3_ != null)
         {
            this.recordCVCS(_loc2_,_loc3_);
            this._prevClipView = _loc3_;
            this._prevPosition = _loc2_;
         }
         else
         {
            TextTracer.writeLine("[错误][PlayingVideoStateHandler.VodTimer_Tick]ClipView超出范围：currentPosition = " + _playLogic.getVideoPosition());
         }
      }
      
      private function ShiftTimer_Tick(param1:TimerEvent) : void
      {
         var _loc2_:Date = _playLogic.getVideoDate();
         var _loc3_:Number = _playLogic.getVideoPosition();
         var _loc4_:ClipView = _playLogic.VideoResult.GetClipViewByPosition(_loc3_);
         if(_loc4_ != null)
         {
            if(this._prevDate == null)
            {
               _playLogic.VideoResult.clipViewDate = _loc2_;
            }
            else if(_loc2_.getTime() != this._prevDate.getTime())
            {
               _playLogic.SendGeneralStatistics(false);
               _playLogic.VideoResult.createClipViews();
               _playLogic.VideoResult.clipViewDate = _loc2_;
            }
            else
            {
               this.recordCVCS(_loc3_,_loc4_);
            }
            
            this._prevDate = _loc2_;
            this._prevClipView = _loc4_;
            this._prevPosition = _loc3_;
         }
         else
         {
            TextTracer.writeLine("[错误][PlayingVideoStateHandler.ShiftTimer_Tick]ClipView超出范围：currentPosition = " + _playLogic.getVideoPosition());
         }
      }
      
      private function recordCVCS(param1:Number, param2:ClipView) : void
      {
         var _loc3_:* = NaN;
         var _loc4_:* = NaN;
         var _loc5_:* = NaN;
         var _loc6_:ClipView = null;
         var _loc7_:uint = 0;
         if(param1 > this._prevPosition && param1 - this._prevPosition < this._diffThreshold)
         {
            _loc3_ = _playLogic.VideoResult.clipLength;
            if(_loc3_ < 0.01)
            {
               return;
            }
            if(param2.index == this._prevClipView.index)
            {
               param2.view((param1 - this._prevPosition) / _loc3_);
            }
            else
            {
               _loc4_ = (this._prevClipView.index + 1) * _loc3_ - this._prevPosition;
               this._prevClipView.view(_loc4_ / _loc3_);
               _loc5_ = param1 - param2.index * _loc3_;
               param2.view(_loc5_ / _loc3_);
               _loc6_ = null;
               _loc7_ = this._prevClipView.index + 1;
               while(_loc7_ < param2.index)
               {
                  _loc6_ = _playLogic.VideoResult.GetClipViewByIndex(_loc7_);
                  if(_loc6_ != null)
                  {
                     _loc6_.view(1);
                  }
                  _loc7_++;
               }
            }
         }
      }
      
      override public function endHandle(param1:String) : void
      {
         super.endHandle(param1);
         if(!_playLogic.IsVideoReady)
         {
            return;
         }
         var _loc2_:GeneralStatisticsVideoResult = _playLogic.VideoResult;
         _loc2_.stopPlayingTimer();
         if(this._cvcsTimer != null)
         {
            this._cvcsTimer.stop();
            this._cvcsTimer = null;
         }
         if(this._bitrateTimer != null)
         {
            this._bitrateTimer.stop();
            this._bitrateTimer = null;
         }
         var _loc3_:Date = new Date();
         var _loc4_:int = _playLogic.getCurrentBitrate();
         var _loc5_:Number = (_loc3_.getTime() - this._prevTime.getTime()) / 1000;
         _playLogic.VideoResult.addBitrateKbps(_loc4_,_loc5_);
         this._prevTime = _loc3_;
         if(this._framerateTimer != null)
         {
            this._framerateTimer.stop();
            this._framerateTimer = null;
         }
      }
   }
}
