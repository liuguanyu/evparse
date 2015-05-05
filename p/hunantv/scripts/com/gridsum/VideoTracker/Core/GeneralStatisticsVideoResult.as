package com.gridsum.VideoTracker.Core
{
   import com.gridsum.VideoTracker.MetaInfo;
   import flash.utils.Dictionary;
   import com.gridsum.VideoTracker.VideoInfo;
   import com.gridsum.Tools.StopWatch;
   import com.gridsum.VideoTracker.VodMetaInfo;
   import com.gridsum.VideoTracker.Config.VideoTrackerConfig;
   
   class GeneralStatisticsVideoResult extends Object
   {
      
      private const _100classificationSeconds:Number = 300;
      
      private const _200classificationSeconds:Number = 600;
      
      private const _shiftClipLength:Number = 300;
      
      private var _clipLength:Number = -1;
      
      private var _metaData:MetaInfo = null;
      
      private var _clipViews:Array = null;
      
      public var clipViewDate:Date = null;
      
      private var _playTime:Number = 0;
      
      private var _isPlayingTimerStarted:Boolean = false;
      
      private var _stickTimeSpans:Array = null;
      
      private var _stickTimeSpansDate:Array = null;
      
      private var _cookieID:String = null;
      
      private var _playID:String = null;
      
      private var _parentPlayID:String = null;
      
      private var _vdProfileID:String = null;
      
      private var _sdProfileID:String = null;
      
      private var _bitrates:Dictionary = null;
      
      private var _userEventLogic:UserEventLogic = null;
      
      private var _errors:Dictionary = null;
      
      public var isBounce:Boolean = false;
      
      public var vidInfo:VideoInfo = null;
      
      public var serialNumber:int = 1;
      
      private var _loadingStatus:int = 1;
      
      public var hostingPageUrl:String = null;
      
      public var hostingPageOriginalUrl:String = null;
      
      public var hostingPageTitle:String = null;
      
      public var clientTimeZone:Number = 0;
      
      public var platform:String = null;
      
      public var currentBitrateKbps:Number = 0;
      
      public var framerateTotal:Number = 0;
      
      public var framerateCheckTimes:int = 0;
      
      public var geography:String = "-";
      
      public var os:String = null;
      
      public var browser:String = null;
      
      public var playedCount:int = 1;
      
      private var _cmd:String = "vopl";
      
      public var ownedAdvs:Array = null;
      
      private var _stopWatch:StopWatch = null;
      
      private var _lifeWatch:StopWatch = null;
      
      public var loadingBeginTime:Date = null;
      
      public var loadingEndTime:Date = null;
      
      private const _timeoutTagForSD:int = 1 << 2;
      
      private const _timeoutTagForVD:int = 1 << 3;
      
      function GeneralStatisticsVideoResult(param1:String)
      {
         super();
         this._loadingStatus = 1;
         this.serialNumber = 1;
         this._stickTimeSpans = new Array();
         this._stickTimeSpansDate = new Array();
         this._isPlayingTimerStarted = false;
         this._playTime = 0;
         this._bitrates = new Dictionary();
         this._userEventLogic = new UserEventLogic();
         this._errors = new Dictionary();
         this.ownedAdvs = new Array();
         this._cmd = param1;
         if(this.cmd == CmdType.shiftPlay)
         {
            this._clipLength = this._shiftClipLength;
         }
         this._stopWatch = new StopWatch();
         this._lifeWatch = new StopWatch();
         this._lifeWatch.startWatch();
      }
      
      public function GetClipViewByPosition(param1:Number) : ClipView
      {
         var _loc2_:* = 0;
         var _loc3_:* = NaN;
         var _loc4_:* = 0;
         if(this._cmd == CmdType.livePlay)
         {
            return null;
         }
         if(this._cmd == CmdType.vodPlay)
         {
            _loc2_ = Math.floor(param1 / this._clipLength);
            if(_loc2_ < 0 || _loc2_ > this._clipViews.length)
            {
               return null;
            }
            if(_loc2_ == this._clipViews.length)
            {
               _loc3_ = (this._metaData as VodMetaInfo).videoDuration;
               if(_loc3_ == 0)
               {
                  return null;
               }
               if(Math.abs(param1 - _loc3_) < 10)
               {
                  _loc2_--;
                  return this._clipViews[_loc2_];
               }
               return null;
            }
            return this._clipViews[_loc2_];
         }
         if(this._cmd == CmdType.shiftPlay)
         {
            _loc4_ = Math.floor(param1 / this._clipLength);
            if(_loc4_ < 0 || _loc4_ >= this._clipViews.length)
            {
               return null;
            }
            return this._clipViews[_loc4_];
         }
         return null;
      }
      
      public function GetClipViewByIndex(param1:int) : ClipView
      {
         if(!(this._clipViews == null) && param1 >= 0 && param1 < this._clipViews.length)
         {
            return this._clipViews[param1];
         }
         return null;
      }
      
      public function get cmd() : String
      {
         return this._cmd;
      }
      
      public function get playID() : String
      {
         return this._playID;
      }
      
      public function set playID(param1:String) : void
      {
         this._playID = param1;
      }
      
      public function get parentPlayID() : String
      {
         return this._parentPlayID;
      }
      
      public function set parentPlayID(param1:String) : void
      {
         this._parentPlayID = param1;
      }
      
      public function get cookieID() : String
      {
         return this._cookieID;
      }
      
      public function set cookieID(param1:String) : void
      {
         this._cookieID = param1;
      }
      
      public function get vdProfileID() : String
      {
         return this._vdProfileID;
      }
      
      public function set vdProfileID(param1:String) : void
      {
         this._vdProfileID = param1;
      }
      
      public function get sdProfileID() : String
      {
         return this._sdProfileID;
      }
      
      public function set sdProfileID(param1:String) : void
      {
         this._sdProfileID = param1;
      }
      
      public function get clipLength() : Number
      {
         return this._clipLength;
      }
      
      public function get metaData() : MetaInfo
      {
         return this._metaData;
      }
      
      public function set metaData(param1:MetaInfo) : void
      {
         this._metaData = param1;
      }
      
      public function addBitrateKbps(param1:Number, param2:Number) : void
      {
         if(this._bitrates.hasOwnProperty(param1))
         {
            this._bitrates[param1] = this._bitrates[param1] + param2;
         }
         else
         {
            this._bitrates[param1] = param2;
         }
      }
      
      public function getAllBitrates() : Dictionary
      {
         return this._bitrates;
      }
      
      public function trackEvent(param1:String, param2:String, param3:String, param4:int) : void
      {
         this._userEventLogic.trackEvent(param1,param2,param3,param4);
      }
      
      public function beginEvent(param1:String, param2:String, param3:String, param4:int) : int
      {
         return this._userEventLogic.beginEvent(param1,param2,param3,param4);
      }
      
      public function endEvent(param1:int) : void
      {
         this._userEventLogic.endEvent(param1);
      }
      
      public function getUserActions() : String
      {
         return this._userEventLogic.toString();
      }
      
      public function addError(param1:String) : void
      {
         if(this._errors.hasOwnProperty(param1))
         {
            this._errors[param1]++;
         }
         else
         {
            this._errors[param1] = 1;
         }
      }
      
      public function getErrors() : Dictionary
      {
         return this._errors;
      }
      
      public function AddStickTimeSpan(param1:Number) : void
      {
         this._stickTimeSpans.push(param1);
         this._stickTimeSpansDate.push(new Date());
      }
      
      public function AddToLastStickTime(param1:Number) : void
      {
         if(!(this._stickTimeSpans == null) && this._stickTimeSpans.length > 0)
         {
            this._stickTimeSpans[this._stickTimeSpans.length - 1] = this._stickTimeSpans[this._stickTimeSpans.length - 1] + param1;
         }
         if(!(this._stickTimeSpansDate == null) && this._stickTimeSpansDate.length > 0)
         {
            this._stickTimeSpansDate[this._stickTimeSpansDate.length - 1] = new Date();
         }
      }
      
      public function getStickTimeSpans() : Array
      {
         return this._stickTimeSpans;
      }
      
      public function getStickTimes() : int
      {
         return FluencyInfoProvider.getStickTimes(this._stickTimeSpans);
      }
      
      public function getRecentStickTimes(param1:Number) : int
      {
         return FluencyInfoProvider.getRecentStickTimes(this._stickTimeSpansDate,param1);
      }
      
      public function getRecentStickDuration(param1:int) : int
      {
         return Math.ceil(FluencyInfoProvider.getRecentTotalStickDuration(this._stickTimeSpans,param1));
      }
      
      public function getTotalStickDuration() : int
      {
         return Math.ceil(FluencyInfoProvider.getTotalStickDuration(this._stickTimeSpans));
      }
      
      public function getFluency() : int
      {
         return FluencyInfoProvider.getFluency(this._stickTimeSpans,this.getPlayingTime());
      }
      
      public function getRecentFluency(param1:Number) : int
      {
         var _loc2_:int = this.getRecentStickTimes(param1);
         var _loc3_:int = this.getPlayingTime();
         var _loc4_:Number = param1 * 60 < _loc3_?param1 * 60:_loc3_;
         return FluencyInfoProvider.getRecentFluency(this._stickTimeSpans,_loc2_,_loc4_);
      }
      
      public function getClipViews() : Array
      {
         return this._clipViews;
      }
      
      public function createClipViews() : void
      {
         var _loc3_:* = NaN;
         var _loc4_:* = 0;
         var _loc1_:* = 0;
         var _loc2_:Array = null;
         if(this._cmd == CmdType.livePlay)
         {
            return;
         }
         if(this._cmd == CmdType.vodPlay)
         {
            _loc3_ = (this._metaData as VodMetaInfo).videoDuration;
            if(this._clipViews != null)
            {
               return;
            }
            if(_loc3_ < 0.1)
            {
               _loc3_ = 0.1;
            }
            _loc1_ = 50;
            if(_loc3_ < this._100classificationSeconds)
            {
               _loc1_ = 50;
            }
            else if(_loc3_ < this._200classificationSeconds)
            {
               _loc1_ = 100;
            }
            else
            {
               _loc1_ = 200;
            }
            
            this._clipLength = _loc3_ / _loc1_;
            _loc2_ = new Array(_loc1_);
            _loc4_ = 0;
            while(_loc4_ < _loc1_)
            {
               _loc2_[_loc4_] = new ClipView(_loc4_);
               _loc4_++;
            }
            this._clipViews = _loc2_;
         }
         else if(this._cmd == CmdType.shiftPlay)
         {
            _loc1_ = Math.ceil(24 * 60 * 60 / this._clipLength);
            _loc2_ = new Array(_loc1_);
            _loc4_ = 0;
            while(_loc4_ < _loc1_)
            {
               _loc2_[_loc4_] = new ClipView(_loc4_);
               _loc4_++;
            }
            this._clipViews = _loc2_;
         }
         
      }
      
      public function startPlayingTimer() : void
      {
         if(this._isPlayingTimerStarted)
         {
            return;
         }
         this._isPlayingTimerStarted = true;
         this._stopWatch.startWatch();
      }
      
      public function stopPlayingTimer() : void
      {
         if(!this._isPlayingTimerStarted)
         {
            return;
         }
         this._stopWatch.pauseWatch();
         this._playTime = this._stopWatch.timeCount;
         this._isPlayingTimerStarted = false;
      }
      
      public function getPlayingTime() : int
      {
         if(!this._isPlayingTimerStarted)
         {
            return Math.round(this._playTime / 1000);
         }
         return Math.round(this._stopWatch.timeCount / 1000);
      }
      
      public function getPlayActiveTime() : int
      {
         return Math.round(this._lifeWatch.timeCount / 1000);
      }
      
      public function getLoadingTime() : int
      {
         var _loc2_:Date = null;
         var _loc1_:Number = 0;
         if(this.loadingBeginTime == null)
         {
            return 0;
         }
         if(this.loadingEndTime == null)
         {
            _loc2_ = new Date();
            _loc1_ = _loc2_.getTime() - this.loadingBeginTime.getTime();
         }
         else
         {
            _loc1_ = this.loadingEndTime.getTime() - this.loadingBeginTime.getTime();
         }
         if(_loc1_ >= 0)
         {
            return _loc1_;
         }
         return 0;
      }
      
      public function endLoading(param1:Boolean) : void
      {
         this._loadingStatus = param1?0:2;
      }
      
      public function getLoadingStatus() : int
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         if(this._loadingStatus == 0 || this._loadingStatus == 2)
         {
            return this._loadingStatus;
         }
         _loc1_ = this._loadingStatus;
         _loc2_ = this.getLoadingTime();
         if(_loc2_ > VideoTrackerConfig.loadingTimeoutForVD)
         {
            _loc1_ = _loc1_ | this._timeoutTagForVD;
         }
         if(_loc2_ > VideoTrackerConfig.loadingTimeoutForSD)
         {
            _loc1_ = _loc1_ | this._timeoutTagForSD;
         }
         return _loc1_;
      }
      
      public function getIsAdvBounced() : int
      {
         var _loc2_:* = 0;
         var _loc1_:int = this.ownedAdvs.length;
         while(_loc2_ < _loc1_)
         {
            if(!(this.ownedAdvs[_loc2_] as AdvStatusInfo).isFinished)
            {
               return 1;
            }
            _loc2_++;
         }
         return 0;
      }
      
      public function getBouncedAdvID() : String
      {
         var _loc2_:* = 0;
         var _loc1_:int = this.ownedAdvs.length;
         while(_loc2_ < _loc1_)
         {
            if(!(this.ownedAdvs[_loc2_] as AdvStatusInfo).isFinished)
            {
               return (this.ownedAdvs[_loc2_] as AdvStatusInfo).videoInfo.videoID;
            }
            _loc2_++;
         }
         return "-";
      }
      
      public function getAverageFramerate() : Number
      {
         if(this.framerateCheckTimes <= 0)
         {
            return 0;
         }
         return this.framerateTotal / this.framerateCheckTimes;
      }
      
      public function getExtendPropertyListString() : String
      {
         var _loc1_:String = null;
         if(this.vidInfo == null)
         {
            return "-~-~-~-~-~-~-~-~-~-~";
         }
         _loc1_ = this.standardString(this.vidInfo.extendProperty1) + "~" + this.standardString(this.vidInfo.extendProperty2) + "~" + this.standardString(this.vidInfo.extendProperty3) + "~" + this.standardString(this.vidInfo.extendProperty4) + "~" + this.standardString(this.vidInfo.extendProperty5) + "~" + this.standardString(this.vidInfo.extendProperty6) + "~" + this.standardString(this.vidInfo.extendProperty7) + "~" + this.standardString(this.vidInfo.extendProperty8) + "~" + this.standardString(this.vidInfo.extendProperty9) + "~" + this.standardString(this.vidInfo.extendProperty10) + "~";
         return _loc1_;
      }
      
      private function standardString(param1:String) : String
      {
         if(param1 == null || param1 == "")
         {
            return "-";
         }
         return param1;
      }
   }
}
