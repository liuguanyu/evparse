package com
{
   import flash.text.TextFormat;
   import com.utl.*;
   import com.datasvc.*;
   import flash.events.*;
   import flash.display.*;
   import flash.net.*;
   import flash.utils.*;
   import com.adobe.serialization.json.JSON;
   import flash.system.LoaderContext;
   
   public class parmParse extends MovieClip
   {
      
      public static var INSTATION:Boolean = true;
      
      public static var DEBUG:Boolean = false;
      
      public static var VERSION:String = "hunantv.com 10.3.20150415.1";
      
      public static var SMALL_WINDOW:Boolean = false;
      
      public static var FONT_FACE:String = "Microsoft YaHei";
      
      public static var TFormat:TextFormat = new TextFormat();
      
      public static var VTSAMPLINGRATE:Number = 0.1;
      
      private static var mServerAddress:String = "http://v.api.hunantv.com/player/video?video_id=";
      
      var params:Object;
      
      var encryptObj:Encrypt;
      
      public var shareObj:setupSharedObject;
      
      public var selfCDN:Boolean = false;
      
      public var offsetType:String = "0";
      
      public var directFile:String = "";
      
      public var typeid:String = "";
      
      public var clipid:String = "";
      
      public var fileid:String = "";
      
      public var fstid:String = "";
      
      public var mediaTitle:String = "";
      
      public var mediaAlias:String = "";
      
      public var mediaRootName:String = "";
      
      public var mediaCollectionName:String = "";
      
      public var ispay:String = "0";
      
      public var video_id:String = "";
      
      public var root_id:String = "";
      
      public var clip_type:String = "";
      
      public var collection_id:String = "";
      
      public var purview:String = "";
      
      public var s_url:String = "";
      
      public var s_title:String = "";
      
      public var showlist:String = "";
      
      public var from:String = "";
      
      public var useiplimit:String = "";
      
      public var rotueurl:String = "";
      
      public var HttpServerUrl:String = "";
      
      public var isPlayAd:String = "1";
      
      public var mMovieInfo:Object = null;
      
      private var mRateChange:Boolean = false;
      
      public var mRateURI:String = "hd";
      
      public var mAutoName:String = "高清";
      
      public var PlayInfo:Object;
      
      private var mTimeOut:uint = 0;
      
      private var mTimeOutDone:Boolean = false;
      
      public var mVideoDuration:Number = 0;
      
      public var mBaiduVIPUser:Boolean = false;
      
      private var mErrorJsonString:String = "{\"status\":200,\"msg\":\"\",\"data\":{\"user\":{\"id\":\"\"},\"info\":{\"video_id\":\"\",\"root_id\":\"\",\"root_name\":\"\",\"collection_id\":\"\",\"clip_type\":\"\",\"play_next\":\"0\",\"title\":\"\",\"sub_title\":\"\",\"series\":\"\",\"url\":\"\",\"thumb\":\"\",\"desc\":\"\"},\"stream\":[{\"url\":\"\",\"name\":\"\"}],\"share\":{\"weibo\":\"\",\"weixin\":\"\",\"qq\":\"\"}}}";
      
      public var mMovieHead:int = -1;
      
      public var mMovieEnd:int = -1;
      
      var ByteTotal:Number;
      
      var BeginTime:int;
      
      var EndTime:int;
      
      public var httpServerIp:String = "";
      
      public var uuid:String = "";
      
      public function parmParse()
      {
         this.encryptObj = new Encrypt();
         this.shareObj = new setupSharedObject();
         this.PlayInfo = new Object();
         super();
      }
      
      public function Init() : void
      {
         this.params = root.loaderInfo.parameters;
         var _loc1_:* = new Date();
         var _loc2_:Number = _loc1_.getTime();
         var _loc3_:Number = this.shareObj.GetTimerMS();
         var _loc4_:Number = _loc2_ - _loc3_;
         if(_loc4_ > 43200000)
         {
            this.shareObj.SetTimerMS(_loc1_.getTime());
            this.shareObj.setQualityConfig("高清");
            this.shareObj.setValue("SHAREOBJ_ZOOM_KEY","1");
            this.shareObj.setSkipHeadEnd(true);
         }
         this.shareObj.GetCookie();
         this.ReadWebPageParms();
         if(DEBUG)
         {
            this.Test();
         }
         if(this.from == "ala")
         {
            this.GetBaiduInfo();
         }
         this.GetMovieInfo(this.GetSeverAddress());
      }
      
      public function ReadWebPageParms() : void
      {
         this.selfCDN = this.getParmValue("cdn") == "0"?true:false;
         this.directFile = this.getParmValue("file");
         this.typeid = this.getParmValue("tid");
         this.clipid = this.getParmValue("cid");
         this.fileid = this.getParmValue("fid");
         this.fstid = this.getParmValue("fst");
         this.mediaTitle = this.getParmValue("mt");
         if(this.mediaTitle == "")
         {
            this.mediaTitle = "芒果tv";
            this.mediaAlias = "芒果tv副标题";
         }
         this.ispay = this.getParmValue("pay");
         if(this.ispay == "" || this.ispay == "n")
         {
            this.ispay = "0";
         }
         this.video_id = this.getParmValue("video_id");
         this.root_id = this.getParmValue("root_id");
         this.clip_type = this.getParmValue("clip_type");
         this.collection_id = this.getParmValue("collection_id");
         if(this.video_id != "")
         {
            this.clipid = this.video_id;
         }
         this.purview = this.getParmValue("purview");
         if(this.purview == "1")
         {
            dispatchEvent(new playerEvents(playerEvents.PAID_MOVIE_BG));
         }
         this.s_url = this.getParmValue("s_url");
         this.s_title = this.getParmValue("s_title");
         if(this.s_url == "" || this.s_url == "undefined")
         {
            this.s_url = "";
         }
         if(this.s_title == "" || this.s_title == "undefined")
         {
            this.s_title = "";
         }
         this.showlist = this.getParmValue("showlist");
         this.from = this.getParmValue("fm");
         this.useiplimit = this.getParmValue("useiplimit");
         trace("s_url:" + this.s_url);
         trace("s_title:" + this.s_title);
         consolelog.log("s_url:" + this.s_url);
         consolelog.log("s_title:" + this.s_title);
         consolelog.log("网页传参:" + this.directFile);
      }
      
      private function Test() : *
      {
         this.clipid = "518825";
      }
      
      private function getParmValue(param1:String) : String
      {
         if(!(this.params[param1] == null) && !(this.params[param1] == undefined) && !(this.params[param1] == ""))
         {
            return this.params[param1];
         }
         return "";
      }
      
      private function GetSeverAddress() : String
      {
         if(this.clipid != "")
         {
            return mServerAddress + this.clipid;
         }
         return "";
      }
      
      public function MovieInfo() : *
      {
         this.BroadcastPlayInfo();
         this.BroadcastMovieInfo();
      }
      
      private function GetMovieInfo(param1:String) : *
      {
         trace("url:" + param1);
         var _loc2_:URLLoader = new URLLoader();
         this.MovieInfoConfigureListeners(_loc2_);
         _loc2_.load(new URLRequest(param1 + "&random=" + this.encryptObj.creatRandomCode(8)));
         this.mTimeOutDone = false;
         this.mTimeOut = setTimeout(this.OnGetMovieInfoTimeOutHandler,10000);
      }
      
      private function OnGetMovieInfoTimeOutHandler() : *
      {
         trace("OnGetMovieInfoTimeOutHandler");
         consolelog.log("OnGetMovieInfoTimeOutHandler");
         this.mTimeOutDone = true;
         this.mMovieInfo = null;
         this.GetVideoSourcesURL(this.directFile);
      }
      
      private function MovieInfoConfigureListeners(param1:IEventDispatcher) : void
      {
         param1.addEventListener(Event.COMPLETE,this.MovieInfoCompleteHandler);
         param1.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.MovieInfoSecurityErrorHandler);
         param1.addEventListener(IOErrorEvent.IO_ERROR,this.MovieInfoIOErrorHandler);
         param1.addEventListener(Event.OPEN,this.MovieInfoOpenHandler);
         param1.addEventListener(ProgressEvent.PROGRESS,this.MovieInfoProgressHandler);
         param1.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.MovieInfoHttpStatusHandler);
      }
      
      private function MovieInfoCompleteHandler(param1:Event) : void
      {
         var arr:Array = null;
         var url:String = null;
         var event:Event = param1;
         trace("MovieInfo Event.COMPLETE:" + event);
         if(this.mTimeOutDone)
         {
            return;
         }
         clearTimeout(this.mTimeOut);
         try
         {
            this.mMovieInfo = com.adobe.serialization.json.JSON.decode(URLLoader(event.target).data);
            if(this.mMovieInfo.status == 200)
            {
               if(INSTATION)
               {
                  this.mediaTitle = this.mMovieInfo.data.info.title;
                  this.mediaAlias = this.mMovieInfo.data.info.desc;
                  this.mediaRootName = this.mMovieInfo.data.info.root_name;
                  this.clipid = this.mMovieInfo.data.info.video_id;
                  this.video_id = this.mMovieInfo.data.info.video_id;
                  this.root_id = this.mMovieInfo.data.info.root_id;
                  this.clip_type = this.mMovieInfo.data.info.clip_type;
                  this.collection_id = this.mMovieInfo.data.info.collection_id;
                  this.mediaCollectionName = this.mMovieInfo.data.info.collection_name;
                  this.mVideoDuration = this.mMovieInfo.data.info.duration;
                  arr = new Array();
                  if(this.mMovieInfo.data.points.start.length > 0)
                  {
                     arr = this.mMovieInfo.data.points.start[0].split("|");
                     this.mMovieHead = int(arr[0]);
                  }
                  if(this.mMovieInfo.data.points.end.length > 0)
                  {
                     arr = this.mMovieInfo.data.points.end[0].split("|");
                     this.mMovieEnd = int(arr[0]);
                  }
                  this.mAutoName = "高清";
                  if(this.mMovieInfo.data.info.isiplimit == "1")
                  {
                     this.IPLimit(true);
                  }
                  else
                  {
                     this.VideoSources();
                  }
                  if(!(this.mMovieInfo.data.user.purview == "200") && this.shareObj.getLastClipTime(this.clipid) == 300)
                  {
                     this.shareObj.setLastClipTime(this.clipid,0);
                  }
               }
               else if(this.mMovieInfo.data.user.purview == "200")
               {
                  this.mediaTitle = this.mMovieInfo.data.info.title;
                  this.mediaAlias = this.mMovieInfo.data.info.desc;
                  this.mediaRootName = this.mMovieInfo.data.info.root_name;
                  this.clipid = this.mMovieInfo.data.info.video_id;
                  this.video_id = this.mMovieInfo.data.info.video_id;
                  this.root_id = this.mMovieInfo.data.info.root_id;
                  this.clip_type = this.mMovieInfo.data.info.clip_type;
                  this.collection_id = this.mMovieInfo.data.info.collection_id;
                  this.mediaCollectionName = this.mMovieInfo.data.info.collection_name;
                  this.mVideoDuration = this.mMovieInfo.data.info.duration;
                  arr = new Array();
                  if(this.mMovieInfo.data.points.start.length > 0)
                  {
                     arr = this.mMovieInfo.data.points.start[0].split("|");
                     this.mMovieHead = int(arr[0]);
                  }
                  if(this.mMovieInfo.data.points.end.length > 0)
                  {
                     arr = this.mMovieInfo.data.points.end[0].split("|");
                     this.mMovieEnd = int(arr[0]);
                  }
                  this.mAutoName = "高清";
                  if(this.mMovieInfo.data.info.isiplimit == "1")
                  {
                     this.IPLimit(true);
                  }
                  else
                  {
                     this.VideoSources();
                  }
               }
               else
               {
                  url = this.mMovieInfo.data.info.url;
                  dispatchEvent(new playerEvents(playerEvents.STATION_OUTSIDE_VIP,url));
               }
               
            }
            else
            {
               this.mMovieInfo = null;
               this.GetVideoSourcesURL(this.directFile);
            }
         }
         catch(e:*)
         {
            mMovieInfo = null;
            GetVideoSourcesURL(directFile);
         }
      }
      
      public function OpenPayDialog() : *
      {
         stage.displayState = StageDisplayState.NORMAL;
         var _loc1_:String = com.adobe.serialization.json.JSON.encode(this.mMovieInfo.data.user);
         var _loc2_:String = com.adobe.serialization.json.JSON.encode(this.mMovieInfo.data.info);
         helpMethods.callPageJs("showPlayPayDialog",_loc1_,_loc2_);
      }
      
      private function MovieInfoSecurityErrorHandler(param1:SecurityErrorEvent) : void
      {
         trace("MovieInfo Event.SecurityErrorEvent:" + param1);
         consolelog.log("MovieInfo:" + param1.toString());
         this.ErrorLog("MovieInfo",param1.toString());
      }
      
      private function MovieInfoIOErrorHandler(param1:IOErrorEvent) : void
      {
         trace("MovieInfo Event.IOErrorEvent:" + param1);
         consolelog.log("MovieInfo:" + param1.toString());
         this.ErrorLog("MovieInfo",param1.toString());
      }
      
      private function MovieInfoOpenHandler(param1:Event) : void
      {
         trace("MovieInfo Event.OPEN:" + param1);
      }
      
      private function MovieInfoProgressHandler(param1:ProgressEvent) : void
      {
         trace("MovieInfo ProgressEvent.PROGRESS:" + param1);
      }
      
      private function MovieInfoHttpStatusHandler(param1:HTTPStatusEvent) : void
      {
         trace("MovieInfo HTTPStatusEvent:" + param1);
         if(param1.status != 200)
         {
            consolelog.log("MovieInfo HTTP STATUS CODE:" + param1.toString());
            this.ErrorLog("MovieInfo HTTP STATUS CODE",param1.toString());
            clearTimeout(this.mTimeOut);
            this.GetVideoSourcesURL(this.directFile);
         }
      }
      
      private function IPLimit(param1:Boolean = true) : *
      {
         var _loc2_:Object = null;
         if(param1)
         {
            _loc2_ = new Object();
            _loc2_.mongoMsg = "很抱歉,本视频仅允许在中国大陆地区观看";
            dispatchEvent(new playerEvents(playerEvents.IP_LEGAL,_loc2_));
         }
         else
         {
            dispatchEvent(new playerEvents(playerEvents.IP_LEAGL_ERROR));
         }
      }
      
      private function GetNetSpeed(param1:String) : *
      {
         var _loc2_:Loader = new Loader();
         var _loc3_:URLRequest = new URLRequest(param1);
         var _loc4_:LoaderContext = new LoaderContext(true);
         _loc2_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.GetNetSpeedCompleteHandler);
         _loc2_.contentLoaderInfo.addEventListener(Event.OPEN,this.GetNetSpeedOpenHandler);
         _loc2_.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.GetNetSpeedProgressHandler);
         _loc2_.load(_loc3_,_loc4_);
      }
      
      private function GetNetSpeedCompleteHandler(param1:Event) : void
      {
         this.EndTime = getTimer();
         trace("EndTime:" + this.EndTime);
         var _loc2_:Number = (this.EndTime - this.BeginTime) / 1000;
         var _loc3_:Number = this.ByteTotal * 8 / 1024;
         trace("second:" + _loc2_);
         trace("kb:" + _loc3_);
         var _loc4_:Number = _loc3_ / _loc2_;
         trace("Kbps:" + _loc4_);
         if(_loc4_ > 2200)
         {
            this.mAutoName = "超清";
         }
         else if(_loc4_ > 1400)
         {
            this.mAutoName = "高清";
         }
         else
         {
            this.mAutoName = "标清";
         }
         
         this.VideoSources();
      }
      
      private function GetNetSpeedOpenHandler(param1:Event) : void
      {
         trace("GetNetSpeedOpenHandler Event.OPEN:" + param1);
         this.BeginTime = getTimer();
         trace("BeginTime:" + this.BeginTime);
      }
      
      private function GetNetSpeedProgressHandler(param1:ProgressEvent) : void
      {
         trace("GetNetSpeedProgressHandler ProgressEvent.PROGRESS:" + param1);
         this.ByteTotal = param1.bytesTotal;
      }
      
      public function VideoSources(param1:Boolean = false) : *
      {
         this.mRateChange = param1;
         this.GetVideoSourcesURL(this.GetVideoSourcesURLLinkByRate());
      }
      
      private function GetVideoSourcesURLLinkByRate() : String
      {
         var _loc1_:* = "";
         var _loc2_:String = this.shareObj.getQualityConfig();
         var _loc3_:* = 0;
         while(_loc3_ < this.mMovieInfo.data.stream.length)
         {
            if(_loc2_ == "自动")
            {
               if(this.mMovieInfo.data.stream[_loc3_].name == this.mAutoName)
               {
                  _loc1_ = this.mMovieInfo.data.stream[_loc3_].url;
                  break;
               }
            }
            else if(this.mMovieInfo.data.stream[_loc3_].name == _loc2_)
            {
               _loc1_ = this.mMovieInfo.data.stream[_loc3_].url;
               break;
            }
            
            _loc3_++;
         }
         if(_loc1_ == "")
         {
            _loc1_ = this.mMovieInfo.data.stream[0].url;
            this.mAutoName = this.mMovieInfo.data.stream[0].name;
            this.shareObj.setQualityConfig(this.mMovieInfo.data.stream[0].name);
         }
         this.SetRateURI(_loc1_);
         return _loc1_;
      }
      
      private function SetRateURI(param1:String) : *
      {
         var _loc2_:* = 0;
         while(_loc2_ < this.mMovieInfo.data.stream.length)
         {
            if(this.mMovieInfo.data.stream[_loc2_].url == param1)
            {
               switch(this.mMovieInfo.data.stream[_loc2_].name)
               {
                  case "标清":
                     this.mRateURI = "sd";
                     break;
                  case "高清":
                     this.mRateURI = "hd";
                     break;
                  case "超清":
                     this.mRateURI = "ud";
                     break;
               }
               break;
            }
            _loc2_++;
         }
      }
      
      private function GetVideoSourcesURL(param1:String) : *
      {
         var _loc3_:Object = null;
         if(this.purview == "1" && this.mMovieInfo == null)
         {
            return;
         }
         if(this.mMovieInfo == null)
         {
            dispatchEvent(new playerEvents(playerEvents.TV_ERROR,"1"));
            this.shareObj.setQualityConfig(this.mAutoName);
            _loc3_ = new Object();
            _loc3_.ecode = "1";
            _loc3_.err = "CMS接口报错";
            dispatchEvent(new playerEvents(playerEvents.STATISTICS_BIGDATA_ERROR,_loc3_));
         }
         if(this.mMovieInfo == null && this.useiplimit == "1")
         {
            this.IPLimit(false);
            return;
         }
         this.rotueurl = param1;
         var param1:String = param1 + ("&random=" + this.encryptObj.creatRandomCode(8));
         trace("url:" + param1);
         var _loc2_:URLLoader = new URLLoader();
         this.VideoSourceConfigureListeners(_loc2_);
         _loc2_.load(new URLRequest(param1));
      }
      
      private function VideoSourceURLCompleteHandler(param1:Event) : *
      {
         var _loc3_:RegExp = null;
         var _loc4_:RegExp = null;
         trace("PCVCR Event.COMPLETE:" + param1);
         var _loc2_:Object = com.adobe.serialization.json.JSON.decode(URLLoader(param1.target).data);
         if(_loc2_.status == "ok")
         {
            this.HttpServerUrl = _loc2_.info;
            trace("HttpServerUrl:" + this.HttpServerUrl);
            consolelog.log("HttpServerUrl:" + this.HttpServerUrl);
            if(this.HttpServerUrl.indexOf(".fhv") != -1)
            {
               this.offsetType = "0";
            }
            else if(!(this.HttpServerUrl.indexOf(".f4v") == -1) || !(this.HttpServerUrl.indexOf(".mp4") == -1))
            {
               this.offsetType = "1";
            }
            
            consolelog.log("offsetType:" + this.offsetType);
            if(_loc2_.isothercdn != "1")
            {
               _loc3_ = new RegExp("http://([^/]+)/","im");
               _loc4_ = new RegExp("(^|&|\\?)uuid=([^&]*)(&|$)","im");
               this.httpServerIp = this.HttpServerUrl.match(_loc3_)[0];
               this.uuid = this.HttpServerUrl.match(_loc4_)[2];
            }
            this.selfCDN = _loc2_.isothercdn == "0";
            if(this.mRateChange)
            {
               dispatchEvent(new playerEvents(playerEvents.BITSET_CHANGE_OK));
            }
            else
            {
               dispatchEvent(new playerEvents(playerEvents.PARMS_READY));
            }
         }
      }
      
      private function VideoSourceConfigureListeners(param1:IEventDispatcher) : void
      {
         param1.addEventListener(Event.COMPLETE,this.VideoSourceURLCompleteHandler);
         param1.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.VideoSourceVideoSourceSecurityErrorHandler);
         param1.addEventListener(IOErrorEvent.IO_ERROR,this.VideoSourceIOErrorHandler);
         param1.addEventListener(Event.OPEN,this.VideoSourceOpenHandler);
         param1.addEventListener(ProgressEvent.PROGRESS,this.VideoSourceProgressHandler);
         param1.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.VideoSourceHttpStatusHandler);
      }
      
      private function VideoSourceVideoSourceSecurityErrorHandler(param1:SecurityErrorEvent) : void
      {
         trace("PCVCR Event.SecurityErrorEvent:" + param1);
         consolelog.log("PCVCR:" + param1.toString());
         this.ErrorLog("PCVCR",param1.toString());
      }
      
      private function VideoSourceIOErrorHandler(param1:IOErrorEvent) : void
      {
         trace("PCVCR Event.IOErrorEvent:" + param1);
         consolelog.log("PCVCR:" + param1.toString());
         this.ErrorLog("PCVCR",param1.toString());
      }
      
      private function VideoSourceOpenHandler(param1:Event) : void
      {
         trace("PCVCR Event.OPEN:" + param1);
      }
      
      private function VideoSourceProgressHandler(param1:ProgressEvent) : void
      {
         trace("PCVCR ProgressEvent.PROGRESS:" + param1);
      }
      
      private function VideoSourceHttpStatusHandler(param1:HTTPStatusEvent) : void
      {
         var _loc2_:Object = null;
         trace("PCVCR HTTPStatusEvent:" + param1);
         if(param1.status != 200)
         {
            consolelog.log("PCVCR HTTP STATUS CODE:" + param1.toString());
            this.ErrorLog("PCVCR HTTP STATUS CODE",param1.toString());
            dispatchEvent(new playerEvents(playerEvents.TV_ERROR,"2"));
            _loc2_ = new Object();
            _loc2_.ecode = "2";
            _loc2_.err = "PRVCR接口报错";
            dispatchEvent(new playerEvents(playerEvents.STATISTICS_BIGDATA_ERROR,_loc2_));
         }
      }
      
      public function ErrorLog(param1:String, param2:String) : *
      {
         var _loc3_:String = "http://port.imgo.tv/log/log.ashx?t=" + param1 + "&n=" + encodeURIComponent(param2);
         var _loc4_:URLLoader = new URLLoader();
         try
         {
            if(_loc3_ != "")
            {
               _loc4_.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
               _loc4_.load(new URLRequest(_loc3_));
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function ioErrorHandler(param1:IOErrorEvent) : void
      {
      }
      
      private function BroadcastMovieInfo() : *
      {
         if(this.mMovieInfo != null)
         {
            stage.dispatchEvent(new playerEvents(playerEvents.MOVIE_INFO,this.mMovieInfo));
         }
      }
      
      public function BroadcastPlayInfo() : *
      {
         this.PlayInfo.rotueurl = this.rotueurl;
         this.PlayInfo.HttpServerUrl = this.HttpServerUrl;
         this.PlayInfo.autoName = this.mAutoName;
         this.PlayInfo.showlist = !(this.showlist == "no");
         this.PlayInfo.autoPlay = false;
         if(!(this.s_title == "") && !(this.s_url == ""))
         {
            this.PlayInfo.autoPlay = true;
         }
         stage.dispatchEvent(new playerEvents(playerEvents.PLAY_INFO,this.PlayInfo));
      }
      
      public function getStartUrl() : String
      {
         var _loc1_:* = "";
         _loc1_ = "http://stat.titan.imgo.tv/play/start.do?url=" + encodeURIComponent(this.HttpServerUrl);
         return _loc1_;
      }
      
      public function getHeartBeatUrl() : String
      {
         var _loc1_:* = "";
         if(this.selfCDN)
         {
            if(this.httpServerIp != "")
            {
               _loc1_ = this.httpServerIp + "heartbeat.do?uuid=" + this.uuid;
            }
         }
         else
         {
            _loc1_ = "http://stat.titan.imgo.tv/play/heartbeat.do?url=" + encodeURIComponent(this.HttpServerUrl);
         }
         return _loc1_;
      }
      
      public function getOfflineUrl() : String
      {
         var _loc1_:* = "";
         if(this.selfCDN)
         {
            if(this.httpServerIp != "")
            {
               _loc1_ = this.httpServerIp + "offline.do?uuid=" + this.uuid;
            }
         }
         else
         {
            _loc1_ = "http://stat.titan.imgo.tv/play/offline.do?url=" + encodeURIComponent(this.HttpServerUrl);
         }
         return _loc1_;
      }
      
      private function GetBaiduInfo() : *
      {
         var _loc1_:URLLoader = new URLLoader();
         this.BaiduInfoConfigureListeners(_loc1_);
         _loc1_.load(new URLRequest("http://api.open.baidu.com/pae/ecosys/api/check?type=video&fm=hunantv&random=" + this.encryptObj.creatRandomCode(8)));
      }
      
      private function BaiduInfoConfigureListeners(param1:IEventDispatcher) : void
      {
         param1.addEventListener(Event.COMPLETE,this.BaiduInfoCompleteHandler);
         param1.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.BaiduInfoSecurityErrorHandler);
         param1.addEventListener(IOErrorEvent.IO_ERROR,this.BaiduInfoIOErrorHandler);
         param1.addEventListener(Event.OPEN,this.BaiduInfoOpenHandler);
         param1.addEventListener(ProgressEvent.PROGRESS,this.BaiduInfoProgressHandler);
         param1.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.BaiduInfoHttpStatusHandler);
      }
      
      private function BaiduInfoCompleteHandler(param1:Event) : void
      {
         var obj:Object = null;
         var event:Event = param1;
         trace("BaiduInfo Event.COMPLETE:" + event);
         consolelog.log("BaiduInfo Event.COMPLETE:" + event);
         try
         {
            obj = com.adobe.serialization.json.JSON.decode(URLLoader(event.target).data);
            if(obj.status == 0)
            {
               this.mBaiduVIPUser = obj.data.ret == "1"?true:false;
            }
            consolelog.log("mBaiduVIPUser:" + this.mBaiduVIPUser);
         }
         catch(e:*)
         {
            trace("BaiduInfo Event.COMPLETE parse error");
            consolelog.log("BaiduInfo Event.COMPLETE parse error");
         }
      }
      
      private function BaiduInfoSecurityErrorHandler(param1:SecurityErrorEvent) : void
      {
         trace("BaiduInfo Event.SecurityErrorEvent:" + param1);
         consolelog.log("BaiduInfo:" + param1.toString());
      }
      
      private function BaiduInfoIOErrorHandler(param1:IOErrorEvent) : void
      {
         trace("BaiduInfo Event.IOErrorEvent:" + param1);
         consolelog.log("BaiduInfo:" + param1.toString());
      }
      
      private function BaiduInfoOpenHandler(param1:Event) : void
      {
         trace("BaiduInfo Event.OPEN:" + param1);
      }
      
      private function BaiduInfoProgressHandler(param1:ProgressEvent) : void
      {
         trace("BaiduInfo ProgressEvent.PROGRESS:" + param1);
      }
      
      private function BaiduInfoHttpStatusHandler(param1:HTTPStatusEvent) : void
      {
         trace("BaiduInfo HTTPStatusEvent:" + param1);
         if(param1.status != 200)
         {
            consolelog.log("BaiduInfo HTTP STATUS CODE:" + param1.toString());
            this.ErrorLog("BaiduInfo HTTP STATUS CODE",param1.toString());
         }
      }
   }
}
