package com.gridsum.VideoTracker
{
   import flash.utils.Dictionary;
   import com.gridsum.VideoTracker.Store.*;
   import com.gridsum.VideoTracker.Config.VideoTrackerConfig;
   import com.gridsum.VideoTracker.Core.BrowserOSInfoProvider;
   import com.gridsum.VideoTracker.Core.HostingPageInfoProvider;
   import com.gridsum.VideoTracker.Util.UniqueIDGenerator;
   import com.gridsum.VideoTracker.Core.GeographyProvider;
   
   public class VideoTracker extends Object
   {
      
      private static var _profiles:Dictionary = new Dictionary();
      
      private static var _platform:String = "page";
      
      private var _vdProfileID:String = null;
      
      private var _sdProfileID:String = null;
      
      private var _profileKey:String = "";
      
      private var _cookieID:String = null;
      
      private var _plays:Dictionary = null;
      
      public function VideoTracker()
      {
         super();
         this._plays = new Dictionary();
      }
      
      public static function getInstance(param1:String, param2:String) : VideoTracker
      {
         var _loc4_:VideoTracker = null;
         var _loc3_:String = param1 + "/" + param2;
         if(!_profiles.hasOwnProperty(_loc3_))
         {
            _loc4_ = new VideoTracker();
            _loc4_._vdProfileID = param1;
            _loc4_._sdProfileID = param2;
            _loc4_._profileKey = _loc3_;
            _loc4_.prepareGeographyInfo();
            _profiles[_loc3_] = _loc4_;
         }
         return _profiles[_loc3_];
      }
      
      public static function setSamplingRate(param1:Number) : void
      {
         VideoTrackerConfig.samplingRate = param1;
      }
      
      public static function setPlatform(param1:String) : void
      {
         _platform = param1;
      }
      
      public static function get platform() : String
      {
         return _platform;
      }
      
      public static function setBrowser(param1:String) : void
      {
         BrowserOSInfoProvider.setBrowserName(param1);
      }
      
      public static function get BrowserName() : String
      {
         return BrowserOSInfoProvider.getBrowserName();
      }
      
      public static function setOS(param1:String) : void
      {
         BrowserOSInfoProvider.setOSName(param1);
      }
      
      public static function get OSName() : String
      {
         return BrowserOSInfoProvider.getOSName();
      }
      
      public static function setPageUrl(param1:String) : void
      {
         HostingPageInfoProvider.setStaticPageURL(param1);
      }
      
      public static function setPageTitle(param1:String) : void
      {
         HostingPageInfoProvider.setStaticPageTitle(param1);
      }
      
      public static function setTimeoutThresholdForSD(param1:int) : void
      {
         VideoTrackerConfig.loadingTimeoutForSD = param1 * 1000;
      }
      
      public static function setTimeoutThresholdForVD(param1:int) : void
      {
         VideoTrackerConfig.loadingTimeoutForVD = param1 * 1000;
      }
      
      public function newLivePlay(param1:VideoInfo, param2:ILiveInfoProvider) : LivePlay
      {
         if(param1 == null)
         {
            throw new ArgumentError("NewLivePlay\'s parameter:VideoInfo should not be null.");
         }
         else
         {
            var _loc3_:String = UniqueIDGenerator.Generate();
            var _loc4_:LivePlay = new LivePlay(_loc3_,this._vdProfileID,this._sdProfileID,param1,param2);
            this.addPlay(_loc3_,_loc4_);
            return _loc4_;
         }
      }
      
      public function newVodPlay(param1:VideoInfo, param2:IVodInfoProvider) : VodPlay
      {
         if(param1 == null)
         {
            throw new ArgumentError("NewVodPlay\'s parameter:VideoInfo should not be null.");
         }
         else
         {
            var _loc3_:String = UniqueIDGenerator.Generate();
            var _loc4_:VodPlay = new VodPlay(_loc3_,this._vdProfileID,this._sdProfileID,param1,param2);
            this.addPlay(_loc3_,_loc4_);
            return _loc4_;
         }
      }
      
      public function newShiftPlay(param1:VideoInfo, param2:IShiftInfoProvider) : ShiftPlay
      {
         if(param1 == null)
         {
            throw new ArgumentError("NewShiftPlay\'s parameter:VideoInfo should not be null.");
         }
         else
         {
            var _loc3_:String = UniqueIDGenerator.Generate();
            var _loc4_:ShiftPlay = new ShiftPlay(_loc3_,this._vdProfileID,this._sdProfileID,param1,param2);
            this.addPlay(_loc3_,_loc4_);
            return _loc4_;
         }
      }
      
      public function addPlay(param1:String, param2:Play) : void
      {
         this._plays[param1] = param2;
      }
      
      public function notifyPlayEnd(param1:String, param2:String, param3:Boolean) : void
      {
         if(param2 != null)
         {
            (this._plays[param2] as Play).notifyChildPlayEnd(param1,param3);
         }
         delete this._plays[param1];
         true;
      }
      
      public function get cookieID() : String
      {
         if(this._cookieID == null || this._cookieID == "")
         {
            this._cookieID = PersistInfoProvider.getInstance().loadVisitorID();
         }
         return this._cookieID;
      }
      
      private function prepareGeographyInfo() : void
      {
         GeographyProvider.prepare();
      }
      
      public function get vdProfileID() : String
      {
         return this._vdProfileID;
      }
      
      public function get sdProfileID() : String
      {
         return this._sdProfileID;
      }
      
      public function get profileKey() : String
      {
         return this._profileKey;
      }
   }
}
