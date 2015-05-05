package com.gridsum.VideoTracker.Core
{
   import com.gridsum.VideoTracker.Config.VideoTrackerConfig;
   import com.gridsum.VideoTracker.VideoInfo;
   import com.gridsum.VideoTracker.VodMetaInfo;
   import flash.external.ExternalInterface;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import com.gridsum.Debug.TextTracer;
   import flash.utils.Dictionary;
   import com.gridsum.VideoTracker.Util.StringCompresser;
   
   class DataSender extends Object
   {
      
      private static var _cvcsFormatter:Array = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"];
      
      private var _previousData:String = null;
      
      function DataSender(param1:String)
      {
         super();
         this._previousData = param1;
      }
      
      public function SendGeneralStatistics(param1:GeneralStatisticsVideoResult, param2:Boolean) : String
      {
         var _loc7_:* = 0;
         var _loc8_:* = NaN;
         var _loc9_:* = 0;
         var _loc3_:* = "?";
         _loc3_ = _loc3_ + (DataSenderKeys.VersionKey + "=" + this.encodeUrl(VideoTrackerConfig.version));
         _loc3_ = _loc3_ + "&";
         var _loc4_:* = 0;
         if(!(param1.vdProfileID == null) && !(param1.vdProfileID == ""))
         {
            _loc3_ = _loc3_ + (DataSenderKeys.VDProfileIDKey + "=" + this.encodeUrl(param1.vdProfileID));
            _loc3_ = _loc3_ + "&";
            _loc4_++;
         }
         if(!(param1.sdProfileID == null) && !(param1.sdProfileID == "") && (param2))
         {
            _loc3_ = _loc3_ + (DataSenderKeys.SDProfileIDKey + "=" + this.encodeUrl(param1.sdProfileID));
            _loc3_ = _loc3_ + "&";
            _loc4_++;
         }
         var _loc5_:String = param1.cmd;
         _loc3_ = _loc3_ + (DataSenderKeys.CommandKey + "=" + this.encodeUrl(_loc5_));
         _loc3_ = _loc3_ + "&";
         _loc3_ = _loc3_ + (DataSenderKeys.SamplingRateKey + "=" + VideoTrackerConfig.samplingRate.toFixed(3));
         _loc3_ = _loc3_ + "&";
         _loc3_ = _loc3_ + (DataSenderKeys.SerialNumberKey + "=" + this.encodeUrl(param1.serialNumber.toString()));
         _loc3_ = _loc3_ + "&";
         _loc3_ = _loc3_ + (DataSenderKeys.CookieIDKey + "=" + this.encodeUrl(param1.cookieID));
         _loc3_ = _loc3_ + "&";
         _loc3_ = _loc3_ + (DataSenderKeys.PlayIDKey + "=" + this.encodeUrl(param1.playID));
         _loc3_ = _loc3_ + "&";
         if(param1.cmd == CmdType.vodPlay)
         {
            _loc3_ = _loc3_ + (DataSenderKeys.CVCSKey + "=" + this.encodeUrl(this.GetCVCSSendingFormat(param1)));
            _loc3_ = _loc3_ + "&";
            _loc3_ = _loc3_ + (DataSenderKeys.ViewedRateKey + "=" + this.encodeUrl(this.GetViewedRate(param1).toString()));
            _loc3_ = _loc3_ + "&";
         }
         else if(param1.cmd == CmdType.shiftPlay)
         {
         }
         
         _loc3_ = _loc3_ + (DataSenderKeys.AdsCountKey + "=" + param1.ownedAdvs.length);
         _loc3_ = _loc3_ + "&";
         _loc3_ = _loc3_ + (DataSenderKeys.IsAdvBouncedKey + "=" + param1.getIsAdvBounced());
         _loc3_ = _loc3_ + "&";
         _loc3_ = _loc3_ + (DataSenderKeys.BouncedAdvIDKey + "=" + param1.getBouncedAdvID());
         _loc3_ = _loc3_ + "&";
         _loc3_ = _loc3_ + (DataSenderKeys.LoadingTimeKey + "=" + param1.getLoadingTime());
         _loc3_ = _loc3_ + "&";
         _loc3_ = _loc3_ + (DataSenderKeys.IsPlayFailedKey + "=" + param1.getLoadingStatus());
         _loc3_ = _loc3_ + "&";
         if(!(param1.vdProfileID == null) && !(param1.vdProfileID == ""))
         {
            _loc3_ = _loc3_ + (DataSenderKeys.StickTimesKey + "=" + this.encodeUrl(param1.getStickTimes().toString()));
            _loc3_ = _loc3_ + "&";
            _loc3_ = _loc3_ + (DataSenderKeys.StickTimespanKey + "=" + this.encodeUrl(param1.getTotalStickDuration().toString()));
            _loc3_ = _loc3_ + "&";
            _loc3_ = _loc3_ + (DataSenderKeys.FluencyKey + "=" + this.encodeUrl(param1.getFluency().toString()));
            _loc3_ = _loc3_ + "&";
         }
         if(!(param1.sdProfileID == null) && !(param1.sdProfileID == ""))
         {
            _loc7_ = param1.getRecentStickTimes(VideoTrackerConfig.recentLength);
            _loc3_ = _loc3_ + (DataSenderKeys.RecentStickTimesKey + "=" + _loc7_);
            _loc3_ = _loc3_ + "&";
            _loc3_ = _loc3_ + (DataSenderKeys.RecentStickTimespanKey + "=" + param1.getRecentStickDuration(_loc7_));
            _loc3_ = _loc3_ + "&";
            _loc3_ = _loc3_ + (DataSenderKeys.RecentFluencyKey + "=" + this.encodeUrl(param1.getRecentFluency(VideoTrackerConfig.recentLength).toString()));
            _loc3_ = _loc3_ + "&";
         }
         _loc3_ = _loc3_ + (DataSenderKeys.IsBounceKey + "=" + (param1.isBounce?"1":"0"));
         _loc3_ = _loc3_ + "&";
         _loc3_ = _loc3_ + (DataSenderKeys.TimeZoneKey + "=" + this.encodeUrl(param1.clientTimeZone.toString()));
         _loc3_ = _loc3_ + "&";
         _loc3_ = _loc3_ + (DataSenderKeys.GeographyKey + "=" + this.encodeUrl(param1.geography));
         _loc3_ = _loc3_ + "&";
         var _loc6_:VideoInfo = param1.vidInfo;
         _loc3_ = _loc3_ + (DataSenderKeys.VideoIDKey + "=" + this.encodeUrl(_loc6_.videoID));
         _loc3_ = _loc3_ + "&";
         _loc3_ = _loc3_ + (DataSenderKeys.VideoOriginalNameKey + "=" + this.encodeUrl(_loc6_.videoOriginalName));
         _loc3_ = _loc3_ + "&";
         _loc3_ = _loc3_ + (DataSenderKeys.VideoNameKey + "=" + this.encodeUrl(_loc6_.videoName));
         _loc3_ = _loc3_ + "&";
         _loc3_ = _loc3_ + (DataSenderKeys.VideoTVChannelKey + "=" + this.encodeUrl(_loc6_.videoTVChannel));
         _loc3_ = _loc3_ + "&";
         _loc3_ = _loc3_ + (DataSenderKeys.VideoWebChannelKey + "=" + this.encodeUrl(_loc6_.videoWebChannel));
         _loc3_ = _loc3_ + "&";
         _loc3_ = _loc3_ + (DataSenderKeys.FocusKey + "=" + this.encodeUrl(_loc6_.videoFocus));
         _loc3_ = _loc3_ + "&";
         _loc3_ = _loc3_ + (DataSenderKeys.VideoTagKey + "=" + this.encodeUrl(_loc6_.videoTag));
         _loc3_ = _loc3_ + "&";
         _loc3_ = _loc3_ + (DataSenderKeys.VideoExtendPropertyKey + "=" + this.encodeUrl(param1.getExtendPropertyListString()));
         _loc3_ = _loc3_ + "&";
         _loc3_ = _loc3_ + (DataSenderKeys.PlayedCountKey + "=" + this.encodeUrl(param1.playedCount.toString()));
         _loc3_ = _loc3_ + "&";
         _loc3_ = _loc3_ + (DataSenderKeys.CDNKey + "=" + this.encodeUrl(_loc6_.cdn));
         _loc3_ = _loc3_ + "&";
         _loc3_ = _loc3_ + (DataSenderKeys.PlayTimespanKey + "=" + param1.getPlayingTime());
         _loc3_ = _loc3_ + "&";
         _loc3_ = _loc3_ + (DataSenderKeys.PlayActiveTimeKey + "=" + param1.getPlayActiveTime());
         _loc3_ = _loc3_ + "&";
         if(param1.metaData != null)
         {
            if(param1.cmd == CmdType.vodPlay)
            {
               _loc8_ = (param1.metaData as VodMetaInfo).videoDuration;
               _loc9_ = Math.round(_loc8_);
               _loc3_ = _loc3_ + (DataSenderKeys.VideoDurationKey + "=" + this.encodeUrl(_loc9_.toString()));
               _loc3_ = _loc3_ + "&";
            }
            if(!(param1.vdProfileID == null) && !(param1.vdProfileID == ""))
            {
               if(param1.metaData.isBitrateChangeable)
               {
                  _loc3_ = _loc3_ + (DataSenderKeys.BitrateKey + "=" + this.GetBitrateSendingFormat(param1.getAllBitrates()));
               }
               else
               {
                  _loc3_ = _loc3_ + (DataSenderKeys.BitrateKey + "=" + param1.metaData.bitrateKbps + "!" + param1.getPlayingTime() + "~");
               }
               _loc3_ = _loc3_ + "&";
            }
            if(!(param1.sdProfileID == null) && !(param1.sdProfileID == null))
            {
               if(param1.metaData.isBitrateChangeable)
               {
                  _loc3_ = _loc3_ + (DataSenderKeys.CurrentBitrateKey + "=" + param1.currentBitrateKbps.toString());
               }
               else
               {
                  _loc3_ = _loc3_ + (DataSenderKeys.CurrentBitrateKey + "=" + param1.metaData.bitrateKbps.toString());
               }
               _loc3_ = _loc3_ + "&";
            }
            _loc3_ = _loc3_ + (DataSenderKeys.FrameRateKey + "=" + param1.metaData.framesPerSecond);
            _loc3_ = _loc3_ + "&";
            _loc3_ = _loc3_ + (DataSenderKeys.AverageFrameRateKey + "=" + param1.getAverageFramerate().toFixed(2));
            _loc3_ = _loc3_ + "&";
         }
         _loc3_ = _loc3_ + (DataSenderKeys.PlatFormKey + "=" + this.encodeUrl(param1.platform));
         _loc3_ = _loc3_ + "&";
         _loc3_ = _loc3_ + (DataSenderKeys.ActionKey + "=" + this.encodeUrl(param1.getUserActions()));
         _loc3_ = _loc3_ + "&";
         _loc3_ = _loc3_ + (DataSenderKeys.ErrorMessageKey + "=" + this.encodeUrl(this.GetEventListSendingFormat(param1.getErrors())));
         _loc3_ = _loc3_ + "&";
         _loc3_ = _loc3_ + (DataSenderKeys.OSKey + "=" + this.encodeUrl(param1.os));
         _loc3_ = _loc3_ + "&";
         _loc3_ = _loc3_ + (DataSenderKeys.BrowserKey + "=" + this.encodeUrl(param1.browser));
         _loc3_ = _loc3_ + "&";
         _loc3_ = _loc3_ + (DataSenderKeys.PageTitleKey + "=" + this.encodeUrl(param1.hostingPageTitle));
         _loc3_ = _loc3_ + "&";
         _loc3_ = _loc3_ + (DataSenderKeys.VideoUrlKey + "=" + this.encodeUrl(_loc6_.videoUrl));
         _loc3_ = _loc3_ + "&";
         _loc3_ = _loc3_ + (DataSenderKeys.PageUrlKey + "=" + this.encodeUrl(param1.hostingPageUrl));
         if(param1.hostingPageUrl != param1.hostingPageOriginalUrl)
         {
            _loc3_ = _loc3_ + "&";
            _loc3_ = _loc3_ + (DataSenderKeys.PageOriginalUrlKey + "=" + this.encodeUrl(param1.hostingPageOriginalUrl));
         }
         if(_loc4_ > 0 && !this.isLocal())
         {
            if(!this.isEqual(this._previousData,_loc3_) || !(param1.sdProfileID == null) && !(param1.sdProfileID == ""))
            {
               this.Send(_loc3_);
               param1.serialNumber = param1.serialNumber + 1;
            }
         }
         return _loc3_;
      }
      
      public function SendAdInfo(param1:GeneralStatisticsVideoResult, param2:Boolean) : String
      {
         var _loc3_:* = "?";
         _loc3_ = _loc3_ + (DataSenderKeys.VersionKey + "=" + this.encodeUrl(VideoTrackerConfig.version));
         _loc3_ = _loc3_ + "&";
         var _loc4_:* = 0;
         if(!(param1.vdProfileID == null) && !(param1.vdProfileID == ""))
         {
            _loc3_ = _loc3_ + (DataSenderKeys.VDProfileIDKey + "=" + this.encodeUrl(param1.vdProfileID));
            _loc3_ = _loc3_ + "&";
            _loc4_++;
         }
         if(!(param1.sdProfileID == null) && !(param1.sdProfileID == ""))
         {
            _loc3_ = _loc3_ + (DataSenderKeys.SDProfileIDKey + "=" + this.encodeUrl(param1.sdProfileID));
            _loc3_ = _loc3_ + "&";
            _loc4_++;
         }
         _loc3_ = _loc3_ + (DataSenderKeys.CommandKey + "=" + param1.cmd);
         _loc3_ = _loc3_ + "&";
         _loc3_ = _loc3_ + (DataSenderKeys.SamplingRateKey + "=1&");
         _loc3_ = _loc3_ + (DataSenderKeys.SerialNumberKey + "=" + this.encodeUrl(param1.serialNumber.toString()));
         _loc3_ = _loc3_ + "&";
         _loc3_ = _loc3_ + (DataSenderKeys.CookieIDKey + "=" + this.encodeUrl(param1.cookieID));
         _loc3_ = _loc3_ + "&";
         _loc3_ = _loc3_ + (DataSenderKeys.PlayIDKey + "=" + this.encodeUrl(param1.playID));
         _loc3_ = _loc3_ + "&";
         _loc3_ = _loc3_ + (DataSenderKeys.ParentPlayKey + "=" + this.encodeUrl(param1.parentPlayID));
         _loc3_ = _loc3_ + "&";
         _loc3_ = _loc3_ + (DataSenderKeys.LoadingTimeKey + "=" + param1.getLoadingTime());
         _loc3_ = _loc3_ + "&";
         _loc3_ = _loc3_ + (DataSenderKeys.IsPlayFailedKey + "=" + param1.getLoadingStatus());
         _loc3_ = _loc3_ + "&";
         _loc3_ = _loc3_ + (DataSenderKeys.IsBounceKey + "=" + (param2?"0":"1"));
         _loc3_ = _loc3_ + "&";
         _loc3_ = _loc3_ + (DataSenderKeys.VideoIDKey + "=" + this.encodeUrl(param1.vidInfo.videoID));
         _loc3_ = _loc3_ + "&";
         _loc3_ = _loc3_ + (DataSenderKeys.VideoOriginalNameKey + "=" + this.encodeUrl(param1.vidInfo.videoOriginalName));
         _loc3_ = _loc3_ + "&";
         _loc3_ = _loc3_ + (DataSenderKeys.VideoTagKey + "=" + this.encodeUrl(param1.vidInfo.videoTag));
         _loc3_ = _loc3_ + "&";
         _loc3_ = _loc3_ + (DataSenderKeys.CDNKey + "=" + this.encodeUrl(param1.vidInfo.cdn));
         _loc3_ = _loc3_ + "&";
         _loc3_ = _loc3_ + (DataSenderKeys.VideoUrlKey + "=" + this.encodeUrl(param1.vidInfo.videoUrl));
         _loc3_ = _loc3_ + "&";
         if(param1.metaData != null)
         {
            _loc3_ = _loc3_ + (DataSenderKeys.VideoDurationKey + "=" + (param1.metaData as VodMetaInfo).videoDuration);
         }
         if(_loc4_ > 0 && !this.isLocal())
         {
            if(!this.isEqual(this._previousData,_loc3_))
            {
               this.Send(_loc3_);
               param1.serialNumber = param1.serialNumber + 1;
            }
         }
         return _loc3_;
      }
      
      private function isLocal() : Boolean
      {
         var protocol:String = null;
         var host:String = null;
         try
         {
            protocol = ExternalInterface.call("eval","location.protocol");
            if(protocol == "file:")
            {
               trace("本地文件系统");
               return true;
            }
            host = ExternalInterface.call("eval","location.host");
            if(host == null)
            {
               host = "-";
            }
            if(host.indexOf("127.0.0.1") > -1 || host.indexOf("localhost") > -1)
            {
               trace("localhost或者127.0.0.1");
               return true;
            }
         }
         catch(err:Error)
         {
         }
         return false;
      }
      
      private function isEqual(param1:String, param2:String) : Boolean
      {
         if(param1 == null || param2 == null)
         {
            return false;
         }
         var _loc3_:int = param1.indexOf(DataSenderKeys.SerialNumberKey + "=");
         var _loc4_:int = param2.indexOf(DataSenderKeys.SerialNumberKey + "=");
         var _loc5_:String = param1.substr(0,_loc3_);
         var _loc6_:String = param2.substr(0,_loc4_);
         _loc3_ = param1.indexOf("&",_loc3_);
         _loc4_ = param2.indexOf("&",_loc4_);
         var _loc7_:String = param1.substr(_loc3_);
         var _loc8_:String = param2.substr(_loc4_);
         if(_loc5_ == _loc6_ && _loc7_ == _loc8_)
         {
            return true;
         }
         return false;
      }
      
      private function encodeUrl(param1:String) : String
      {
         if(param1 == null || param1 == "")
         {
            var param1:* = "-";
         }
         var _loc2_:String = encodeURIComponent(param1);
         return _loc2_;
      }
      
      private function Send(param1:String) : void
      {
         var destinationAddress:String = null;
         var loader:URLLoader = null;
         var req:URLRequest = null;
         var urlData:String = param1;
         var i:int = 0;
         while(i < VideoTrackerConfig.destinationAddresses.length)
         {
            destinationAddress = VideoTrackerConfig.destinationAddresses[i];
            try
            {
               loader = new URLLoader();
               req = new URLRequest(destinationAddress + urlData);
               loader.addEventListener(IOErrorEvent.IO_ERROR,this.OnLoaderIOError);
               loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.OnSecurityError);
               loader.load(req);
            }
            catch(e:Error)
            {
               TextTracer.writeLine("Exception occurred: " + e.message);
            }
            i++;
         }
      }
      
      private function OnLoaderIOError(param1:IOErrorEvent) : void
      {
         TextTracer.writeLine("IOError occur while sending message: " + param1.text);
      }
      
      private function OnSecurityError(param1:SecurityErrorEvent) : void
      {
         TextTracer.writeLine("SecurityError occur while sending message: " + param1.text);
      }
      
      private function GetEventListSendingFormat(param1:Dictionary) : String
      {
         var _loc3_:Object = null;
         var _loc2_:* = "";
         for(_loc3_ in param1)
         {
            _loc2_ = _loc2_ + (_loc3_ + "!" + param1[_loc3_] + "~");
         }
         return _loc2_;
      }
      
      private function GetBitrateSendingFormat(param1:Dictionary) : String
      {
         var _loc4_:Object = null;
         var _loc2_:* = "";
         var _loc3_:String = null;
         for(_loc4_ in param1)
         {
            _loc3_ = (param1[_loc4_] as Number).toFixed(1);
            _loc2_ = _loc2_ + (_loc4_ + "!" + _loc3_ + "~");
         }
         return _loc2_;
      }
      
      private function GetCVCSDateSendingFormat(param1:Date) : String
      {
         if(param1 == null)
         {
            var param1:Date = new Date();
         }
         return param1.getFullYear() + "-" + param1.getMonth() + "-" + param1.getDate();
      }
      
      private function GetCVCSSendingFormat(param1:GeneralStatisticsVideoResult) : String
      {
         var _loc3_:String = null;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         var _loc7_:* = 0;
         var _loc2_:Array = param1.getClipViews();
         if(_loc2_ == null || _loc2_.Length == 0)
         {
            return "0";
         }
         _loc3_ = "";
         _loc4_ = _loc2_.length;
         _loc5_ = _cvcsFormatter.length;
         _loc6_ = 0;
         while(_loc6_ < _loc4_)
         {
            _loc7_ = (_loc2_[_loc6_] as ClipView).getViewCount();
            if(_loc7_ < 0)
            {
               _loc7_ = 0;
            }
            else if(_loc7_ >= _loc5_)
            {
               _loc7_ = _loc5_ - 1;
            }
            
            _loc3_ = _loc3_ + _cvcsFormatter[_loc7_];
            _loc6_++;
         }
         return StringCompresser.compress(_loc3_);
      }
      
      private function GetViewedRate(param1:GeneralStatisticsVideoResult) : Number
      {
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         var _loc2_:Array = param1.getClipViews();
         if(_loc2_ == null || _loc2_.Length == 0)
         {
            return 0;
         }
         _loc3_ = 0;
         _loc4_ = _loc2_.length;
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = (_loc2_[_loc5_] as ClipView).getViewCount();
            if(_loc6_ > 0)
            {
               _loc3_++;
            }
            _loc5_++;
         }
         return _loc3_ / _loc4_;
      }
   }
}
