package com.gridsum.VideoTracker.Core
{
   import com.gridsum.VideoTracker.VideoInfo;
   import flash.utils.Timer;
   import com.gridsum.VideoTracker.MetaInfo;
   import com.gridsum.VideoTracker.IInfoProvider;
   import com.gridsum.VideoTracker.IVodInfoProvider;
   import com.gridsum.VideoTracker.IShiftInfoProvider;
   import com.gridsum.VideoTracker.VodMetaInfo;
   import com.gridsum.VideoTracker.GSVideoState;
   import com.gridsum.Debug.TextTracer;
   import com.gridsum.VideoTracker.Config.VideoTrackerConfig;
   import flash.events.TimerEvent;
   import com.gridsum.VideoTracker.VideoTracker;
   import flash.external.ExternalInterface;
   import com.gridsum.VideoTracker.Store.*;
   
   public class PlayLogic extends Object
   {
      
      protected var _videoResult:GeneralStatisticsVideoResult = null;
      
      protected var _videoInfo:VideoInfo = null;
      
      protected var _playedCount:int = 0;
      
      protected var _currentState:String = null;
      
      protected var _currentHandler:VideoStateHandler = null;
      
      protected var _dataSendingTimer:Timer = null;
      
      protected var _playID:String = null;
      
      protected var _parentPlayID:String = null;
      
      protected var _vdProfileID:String = null;
      
      protected var _sdProfileID:String = null;
      
      protected var _profileKey:String = null;
      
      protected var _metaData:MetaInfo = null;
      
      protected var _infoProvider:IInfoProvider = null;
      
      protected var _preChangeState:String = null;
      
      protected var _previousSendGeneralStatisticsTime:Date = null;
      
      protected var _previousSDDataSendTime:Date = null;
      
      protected var _isVideoReady:Boolean = false;
      
      protected var _isSuccessfullyEnd:Boolean = false;
      
      protected var _previousData:String = null;
      
      protected var _playCmd:String = "vopl";
      
      private var _isVideoInfoSetted:Boolean = false;
      
      protected const _minDataSendInterval:int = 3000;
      
      protected const _minSDDataSendInterval:int = 30000;
      
      private const _initInterval:Number = 5000;
      
      private var _currentInterval:Number = 5000;
      
      private var _targetInterval:Number = 5000;
      
      public function PlayLogic(param1:String, param2:String, param3:String, param4:String, param5:VideoInfo, param6:IInfoProvider, param7:String)
      {
         super();
         this._playID = param1;
         this._parentPlayID = param2;
         this._vdProfileID = param3;
         this._sdProfileID = param4;
         this._profileKey = param3 + "/" + param4;
         this._isVideoReady = false;
         this._videoInfo = param5;
         this._infoProvider = param6;
         this._currentState = GSVideoState.DISCONNECTED;
         this._currentHandler = new InitialVideoStateHandler(this);
         this._currentHandler.beginHandle(GSVideoState.DISCONNECTED);
         this._previousSendGeneralStatisticsTime = new Date();
         this._previousSendGeneralStatisticsTime.setTime(this._previousSendGeneralStatisticsTime.getTime() - this._minDataSendInterval);
         this._previousSDDataSendTime = new Date();
         this._previousSDDataSendTime.setTime(this._previousSDDataSendTime.getTime() - this._minSDDataSendInterval);
         this._playCmd = param7;
         this.initGeneralStatistics();
      }
      
      public function setVideoInfo(param1:VideoInfo) : void
      {
         if(!this._isVideoInfoSetted)
         {
            if(param1 == null)
            {
               trace("[CPlayLogic.setVideoInfo] Parameter pVideoInfo should not be NULL");
            }
            else if(param1.videoID == null)
            {
               trace("[CPlayLogic.setVideoInfo] pVideoInfo->lpszVideoID should not be NULL.");
            }
            else if(this._videoResult.vidInfo.videoID == null)
            {
               trace("[CPlayLogic.SetVideoInfo] Original VideoID should not be NULL.");
            }
            else if(param1.videoID == this._videoResult.vidInfo.videoID)
            {
               this._videoResult.vidInfo = param1;
               this._isVideoInfoSetted = true;
            }
            else
            {
               trace("[CPlayLogic.setVideoInfo] VideoID conflicts.");
            }
            
            
            
         }
         else
         {
            trace("[CPlayLogic.setVideoInfo] VideoInfo cannot be set more than once.");
         }
      }
      
      public function get playedCount() : int
      {
         if(this._playedCount == 0)
         {
            this._playedCount = PersistInfoProvider.getInstance().loadPlayCount(this._videoInfo.videoID);
            this._playedCount++;
            PersistInfoProvider.getInstance().savePlayCount(this._videoInfo.videoID,this._playedCount);
         }
         return this._playedCount;
      }
      
      public function getVideoPosition() : Number
      {
         var _loc1_:Date = null;
         if(this._infoProvider != null)
         {
            if(this._playCmd == CmdType.vodPlay || this._playCmd == CmdType.videoAdPlay)
            {
               return (this._infoProvider as IVodInfoProvider).getPosition();
            }
            if(this._playCmd == CmdType.shiftPlay)
            {
               _loc1_ = (this._infoProvider as IShiftInfoProvider).getPosition();
               return _loc1_.getHours() * 3600 + _loc1_.getMinutes() * 60 + _loc1_.getSeconds() + _loc1_.getMilliseconds() * 0.001;
            }
         }
         return -1;
      }
      
      public function getCurrentBitrate() : int
      {
         if(this._metaData == null)
         {
            return 0;
         }
         if((this._metaData.isBitrateChangeable) && !(this._infoProvider == null))
         {
            return this._infoProvider.getBitrate();
         }
         return this._metaData.bitrateKbps;
      }
      
      public function getTotalTime() : Number
      {
         if(this._playCmd == CmdType.vodPlay || this._playCmd == CmdType.videoAdPlay)
         {
            if(this._metaData == null)
            {
               return 0;
            }
            return (this._metaData as VodMetaInfo).videoDuration;
         }
         return -1;
      }
      
      public function getVideoDate() : Date
      {
         var _loc1_:Date = null;
         if(this._playCmd == CmdType.shiftPlay)
         {
            _loc1_ = (this._infoProvider as IShiftInfoProvider).getPosition();
            return new Date(_loc1_.getFullYear(),_loc1_.getMonth(),_loc1_.getDate());
         }
         return null;
      }
      
      public function beginLoading() : void
      {
         this.OnCurrentStateChanged(GSVideoState.LOADING);
         this.initDataSendingTimer();
      }
      
      public function setLoadingBeginTime(param1:Date) : void
      {
         if(param1 != null)
         {
            this._videoResult.loadingBeginTime = param1;
            TextTracer.writeLine("设置Loading起始时间：" + param1.toLocaleTimeString());
         }
      }
      
      public function setLoadingEndTime(param1:Date) : void
      {
         if(param1 != null)
         {
            this._videoResult.loadingEndTime = param1;
            TextTracer.writeLine("设置Loading结束时间：" + param1.toLocaleTimeString());
         }
      }
      
      public function setMetaData(param1:MetaInfo) : void
      {
         this._metaData = param1;
         this._videoResult.metaData = this._metaData;
         if(this._playCmd == CmdType.vodPlay || this._playCmd == CmdType.shiftPlay)
         {
            this._videoResult.createClipViews();
         }
      }
      
      public function setPageUrl(param1:String) : void
      {
         this._videoResult.hostingPageUrl = param1;
      }
      
      public function setPageTitle(param1:String) : void
      {
         this._videoResult.hostingPageTitle = param1;
      }
      
      public function openSuccess() : void
      {
         if(!this._isVideoReady)
         {
            this._isVideoReady = true;
            this.initDataSendingTimer();
            if(!(this._preChangeState == null) && !(this._preChangeState == ""))
            {
               this.OnCurrentStateChanged(this._preChangeState);
            }
         }
      }
      
      public function openFailed() : void
      {
         this._videoResult.endLoading(false);
         this.end(false);
         this.OnCurrentStateChanged(GSVideoState.CONNECTION_ERROR);
      }
      
      public function trackEvent(param1:String, param2:String, param3:String, param4:int) : void
      {
         this._videoResult.trackEvent(param1,param2,param3,param4);
      }
      
      public function beginEvent(param1:String, param2:String, param3:String, param4:int) : int
      {
         return this._videoResult.beginEvent(param1,param2,param3,param4);
      }
      
      public function endEvent(param1:int) : void
      {
         this._videoResult.endEvent(param1);
      }
      
      public function onError(param1:String) : Boolean
      {
         if(param1.length > 32)
         {
            return false;
         }
         this._videoResult.addError(param1);
         return true;
      }
      
      private function initDataSendingTimer() : void
      {
         var _loc1_:* = NaN;
         if(this._dataSendingTimer != null)
         {
            this._dataSendingTimer.stop();
            this._dataSendingTimer = null;
         }
         if(this._videoResult.metaData == null)
         {
            this._dataSendingTimer = new Timer(VideoTrackerConfig.getLoadingDataSendingInterval() * 1000);
            this._dataSendingTimer.addEventListener(TimerEvent.TIMER,this.DataSendingTimer_Tick);
            trace("使用Loading的数据发送间隔");
         }
         else if(this._playCmd == CmdType.vodPlay)
         {
            _loc1_ = (this._videoResult.metaData as VodMetaInfo).videoDuration;
            this._currentInterval = this._initInterval;
            this._targetInterval = VideoTrackerConfig.getGeneralDataSendingInterval(_loc1_) * 1000;
            this._dataSendingTimer = new Timer(this._initInterval);
            this._dataSendingTimer.addEventListener(TimerEvent.TIMER,this.DataSendingTimer_AscendTick);
            trace("使用VodPlay的数据发送间隔，间隔为" + this._dataSendingTimer.delay);
         }
         else
         {
            this._currentInterval = this._initInterval;
            this._targetInterval = VideoTrackerConfig.getGeneralDataSendingInterval() * 1000;
            this._dataSendingTimer = new Timer(this._initInterval);
            this._dataSendingTimer.addEventListener(TimerEvent.TIMER,this.DataSendingTimer_AscendTick);
            trace("使用直播的数据发送间隔，间隔为" + this._dataSendingTimer.delay);
         }
         
         this._dataSendingTimer.start();
      }
      
      private function initGeneralStatistics() : void
      {
         this._videoResult = new GeneralStatisticsVideoResult(this._playCmd);
         var _loc1_:VideoTracker = VideoTracker.getInstance(this._vdProfileID,this._sdProfileID);
         this._videoResult.cookieID = _loc1_.cookieID;
         this._videoResult.vdProfileID = this._vdProfileID;
         this._videoResult.sdProfileID = this._sdProfileID;
         this._videoResult.playID = this._playID;
         this._videoResult.parentPlayID = this._parentPlayID;
         if(ExternalInterface.available)
         {
            this._videoResult.hostingPageTitle = HostingPageInfoProvider.getCurrentHostingPageTitle();
            this._videoResult.hostingPageOriginalUrl = HostingPageInfoProvider.getHostingPageURL();
            this._videoResult.hostingPageUrl = this._videoResult.hostingPageOriginalUrl;
            this._videoResult.os = BrowserOSInfoProvider.getOSName();
            this._videoResult.browser = BrowserOSInfoProvider.getBrowserName();
         }
         this._videoResult.platform = VideoTracker.platform;
         var _loc2_:TimeZoneProvider = new TimeZoneProvider();
         this._videoResult.clientTimeZone = _loc2_.getTimeZone();
         this._videoResult.vidInfo = this._videoInfo;
         this._videoResult.playedCount = this.playedCount;
      }
      
      private function DataSendingTimer_AscendTick(param1:TimerEvent) : void
      {
         this.DataSendingTimer_Tick(param1);
         this._dataSendingTimer.stop();
         this._currentInterval = this._currentInterval * 2;
         if(this._currentInterval < this._targetInterval)
         {
            this._dataSendingTimer.delay = this._currentInterval;
            this._dataSendingTimer.start();
         }
         else
         {
            this._dataSendingTimer.delay = this._targetInterval;
            this._dataSendingTimer.removeEventListener(TimerEvent.TIMER,this.DataSendingTimer_AscendTick);
            this._dataSendingTimer.addEventListener(TimerEvent.TIMER,this.DataSendingTimer_Tick);
            this._dataSendingTimer.start();
         }
      }
      
      private function DataSendingTimer_Tick(param1:TimerEvent) : void
      {
         this.SendGeneralStatistics(false);
      }
      
      public function SendGeneralStatistics(param1:Boolean) : void
      {
         var _loc2_:Date = null;
         var _loc3_:DataSender = null;
         var _loc4_:BounceInfoProvider = null;
         var _loc5_:* = false;
         var _loc6_:* = false;
         if(!(this._videoResult == null) && (VideoTrackerConfig.getIsSelected(this._videoResult.cookieID)))
         {
            _loc2_ = new Date();
            if(ExternalInterface.available)
            {
               if((param1) || _loc2_.getTime() - this._previousSendGeneralStatisticsTime.getTime() >= this._minDataSendInterval)
               {
                  this._previousSendGeneralStatisticsTime = _loc2_;
                  _loc3_ = null;
                  if(this._playCmd == CmdType.videoAdPlay)
                  {
                     _loc3_ = new DataSender(this._previousData);
                     this._previousData = _loc3_.SendAdInfo(this._videoResult,this._isSuccessfullyEnd);
                  }
                  else
                  {
                     _loc4_ = new BounceInfoProvider();
                     _loc5_ = true;
                     if(this._playCmd == CmdType.vodPlay)
                     {
                        _loc5_ = _loc4_.getVodVideoIsBounce(this._videoResult.getClipViews(),this._videoResult.getPlayingTime());
                     }
                     else if(this._playCmd == CmdType.livePlay)
                     {
                        _loc5_ = _loc4_.getLiveVideoIsBounce(this._videoResult.getPlayingTime());
                     }
                     else if(this._playCmd == CmdType.shiftPlay)
                     {
                        _loc5_ = _loc4_.getShiftVideoIsBounce(this._videoResult.getPlayingTime());
                     }
                     
                     
                     this._videoResult.isBounce = _loc5_;
                     if(this._infoProvider != null)
                     {
                        this._videoResult.currentBitrateKbps = this._infoProvider.getBitrate();
                     }
                     else if(this._videoResult.metaData != null)
                     {
                        this._videoResult.currentBitrateKbps = this._videoResult.metaData.bitrateKbps;
                     }
                     else
                     {
                        this._videoResult.currentBitrateKbps = 0;
                     }
                     
                     this._videoResult.geography = GeographyProvider.getGeographyInfo();
                     _loc6_ = false;
                     if(_loc2_.getTime() - this._previousSDDataSendTime.getTime() >= this._minSDDataSendInterval)
                     {
                        _loc6_ = true;
                        this._previousSDDataSendTime = _loc2_;
                     }
                     _loc3_ = new DataSender(this._previousData);
                     this._previousData = _loc3_.SendGeneralStatistics(this._videoResult,_loc6_);
                  }
               }
            }
         }
      }
      
      public function end(param1:Boolean) : void
      {
         this._isSuccessfullyEnd = param1;
         this.SendGeneralStatistics(true);
         if(this._dataSendingTimer != null)
         {
            this._dataSendingTimer.stop();
            this._dataSendingTimer = null;
         }
      }
      
      public function OnCurrentStateChanged(param1:String) : void
      {
         if(param1 == GSVideoState.BUFFERING)
         {
            if(this._currentState == GSVideoState.LOADING || this._currentState == GSVideoState.SEEKING)
            {
               var param1:String = this._currentState;
            }
         }
         if((this.IsVideoReady) || param1 == GSVideoState.LOADING || param1 == GSVideoState.CONNECTION_ERROR || param1 == GSVideoState.DISCONNECTED)
         {
            this.HandleVideoStateChanged(param1);
            this.SendGeneralStatistics(false);
         }
         else
         {
            this._preChangeState = param1;
         }
      }
      
      private function HandleVideoStateChanged(param1:String) : void
      {
         if(this._currentState == param1)
         {
            return;
         }
         TextTracer.writeLine("State change to: " + param1);
         this._currentState = param1;
         var _loc2_:VideoStateHandler = VideoStateHandler.getInstance(this,param1);
         this._currentHandler.endHandle(param1);
         this._currentHandler = _loc2_;
         this._currentHandler.beginHandle(param1);
      }
      
      public function get IsVideoReady() : Boolean
      {
         return this._isVideoReady;
      }
      
      public function get VideoResult() : GeneralStatisticsVideoResult
      {
         return this._videoResult;
      }
      
      public function get previousData() : String
      {
         return this._previousData;
      }
      
      public function get playCmd() : String
      {
         return this._playCmd;
      }
      
      public function addAdvertismentInfo(param1:AdvStatusInfo) : void
      {
         this._videoResult.ownedAdvs.push(param1);
         this.SendGeneralStatistics(false);
      }
      
      public function notifyAdvEnd(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:int = this._videoResult.ownedAdvs.length;
         var _loc4_:* = 0;
         while(_loc4_ < _loc3_)
         {
            if((this._videoResult.ownedAdvs[_loc4_] as AdvStatusInfo).advPlayID == param1)
            {
               (this._videoResult.ownedAdvs[_loc4_] as AdvStatusInfo).isFinished = param2;
               this.SendGeneralStatistics(false);
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      public function checkFramerate() : void
      {
         var _loc1_:* = NaN;
         if(this._infoProvider != null)
         {
            _loc1_ = this._infoProvider.getFramesPerSecond();
            if(_loc1_ > 0)
            {
               this._videoResult.framerateTotal = this._videoResult.framerateTotal + _loc1_;
               this._videoResult.framerateCheckTimes++;
            }
         }
      }
   }
}
