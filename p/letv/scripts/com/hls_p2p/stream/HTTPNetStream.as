package com.hls_p2p.stream
{
   import flash.net.NetStream;
   import flash.utils.Timer;
   import com.hls_p2p.data.vo.class_2;
   import com.hls_p2p.data.class_1;
   import com.hls_p2p.data.Piece;
   import flash.net.NetConnection;
   import com.hls_p2p.dataManager.DataManager;
   import com.hls_p2p.statistics.ErrorReport;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import com.hls_p2p.loaders.ReportDownloadError;
   import com.hls_p2p.data.vo.LiveVodConfig;
   import com.hls_p2p.statistics.Statistic;
   import flash.events.NetStatusEvent;
   import flash.events.TimerEvent;
   import com.p2p.utils.Utils;
   import com.p2p.utils.console;
   import at.matthew.httpstreaming.*;
   import com.hls_p2p.data.LIVE_TIME;
   import com.hls_p2p.events.EventWithData;
   import com.hls_p2p.events.protocol.NETSTREAM_PROTOCOL;
   import com.p2p.utils.GetLocalID;
   import com.p2p.utils.ParseUrl;
   import net.httpstreaming.flv.FLVHeader;
   import net.httpstreaming.flv.FLVTagScriptDataObject;
   import flash.system.System;
   import com.hls_p2p.loaders.cdnLoader.CDNRateStrategy;
   import com.p2p.utils.sha1Encrypt;
   
   public class HTTPNetStream extends NetStream
   {
      
      public static const END_SEQUENCE:String = "endSequence";
      
      public static const RESET_BEGIN:String = "resetBegin";
      
      public static const RESET_SEEK:String = "resetSeek";
      
      public var isDebug:Boolean = false;
      
      protected var _mainTimer:Timer = null;
      
      protected var _initData:class_2;
      
      protected var _seekOK:Boolean = true;
      
      protected var _seekDataOK:Boolean = false;
      
      protected var _seekType:int = 0;
      
      protected var _currentBlock:class_1 = null;
      
      protected var _currentPiece:Piece = null;
      
      protected var lastBlock:class_1 = null;
      
      protected var lastPiece:Number = -1;
      
      protected var _need_CDN_Bytes:int = 0;
      
      protected var _seekTimeRecord:Number = 0;
      
      protected var _connection:NetConnection;
      
      protected var _dataManager:DataManager = null;
      
      protected var _errorReport:ErrorReport = null;
      
      protected var _isBufferEmpty:Boolean = true;
      
      protected var isPause:Boolean = false;
      
      protected var _currentBytes:ByteArray;
      
      protected var _fileHandler:HTTPStreamingMP2TSFileHandler = null;
      
      private var statisTimeCount:int = 0;
      
      private var onLoopDelay:int = 7;
      
      private var _isLastData:Boolean = false;
      
      private var _isShowSeekIcon:Boolean = false;
      
      private var input:IDataInput;
      
      private var offLiveTime:Number = -1;
      
      private var _isForcedSeek:Boolean = false;
      
      private var g_Lastbuflen:Number = -1;
      
      private var iErrorCount:int = 0;
      
      private var _bufferEmptyStartTime:Number = -1;
      
      private var _startWatchTime:Number = -1;
      
      private var _reportDownloadError:ReportDownloadError;
      
      private var _isNotifyPlayStop:Boolean = false;
      
      private var _isFirstRun:Boolean = true;
      
      private var isChangeKBPSSuccessAfterSeek:Boolean = false;
      
      private var _startPlayTime:Number = 0;
      
      private var _isEmptyIn15:Boolean = false;
      
      private var _adRemainingTime:int = 0;
      
      private var bytes:ByteArray;
      
      private var notifyDurationGroupID:String = "";
      
      private var notifyWidth:Number = 0;
      
      private var notifyHeight:Number = 0;
      
      private var tmpBlock:class_1;
      
      private var changingKBPSArray:Array;
      
      private var _eventObj:Object;
      
      public function HTTPNetStream(param1:Object = null)
      {
         this._currentBytes = new ByteArray();
         this.bytes = new ByteArray();
         this.changingKBPSArray = new Array();
         this._eventObj = new Object();
         console.log(this,"Creat NetStream  getTimer : " + this.getTime());
         if(null == param1)
         {
            var param1:Object = new Object();
            param1.playType = LiveVodConfig.VOD;
         }
         LiveVodConfig.TYPE = param1.playType.toUpperCase();
         if(LiveVodConfig.uuid == "")
         {
            LiveVodConfig.uuid = new Utils().get40SizeUUID();
         }
         if(param1.vars)
         {
            LiveVodConfig.vars = param1.vars;
            if(param1.vars["ws"])
            {
               if(param1.vars["ws"] == "1")
               {
                  LiveVodConfig.var_274 = true;
               }
               else
               {
                  LiveVodConfig.var_274 = false;
               }
            }
            if(param1.vars["om"])
            {
               LiveVodConfig.var_275 = param1.vars["om"];
            }
         }
         console.log(this,"P2PNetStream" + LiveVodConfig.method_263() + LiveVodConfig.method_265());
         this._connection = new NetConnection();
         this._connection.connect(null);
         super(this._connection);
         super.client = new ClientObject_HLS();
         super.client.metaDataCallBackFun = this.onMetaData;
      }
      
      private function init(param1:Boolean = false) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:* = NaN;
         var _loc5_:* = NaN;
         var _loc6_:* = NaN;
         this.lastBlock = null;
         this.isPause = false;
         this.lastPiece = -1;
         this._isShowSeekIcon = false;
         this._adRemainingTime = 0;
         this._isBufferEmpty = true;
         this._seekTimeRecord = 0;
         this._startWatchTime = -1;
         this._isForcedSeek = false;
         this._isNotifyPlayStop = false;
         LiveVodConfig.IS_CHANGE_KBPS = false;
         this.changingKBPSArray = new Array();
         LiveVodConfig.BirthTime = this.getTime();
         this.isChangeKBPSSuccessAfterSeek = false;
         Statistic.method_261().addEventListener();
         Statistic.method_261().method_123(this);
         if(!this.hasEventListener(NetStatusEvent.NET_STATUS))
         {
            this.addEventListener(NetStatusEvent.NET_STATUS,this._this_NET_STATUS,false,1);
         }
         if(!this._dataManager)
         {
            this._dataManager = new DataManager();
         }
         if(!this._mainTimer)
         {
            this._mainTimer = new Timer(this.onLoopDelay);
            this._mainTimer.addEventListener(TimerEvent.TIMER,this.onLoop);
         }
         if(this._errorReport)
         {
            this._errorReport.clear();
            this._errorReport = null;
         }
         if(true == param1)
         {
            _loc2_ = LiveVodConfig.nextVid;
            _loc3_ = LiveVodConfig.uuid;
            if(_loc3_ == "")
            {
               _loc3_ = new Utils().get40SizeUUID();
            }
            LiveVodConfig.CLEAR();
            LiveVodConfig.uuid = _loc3_;
            LiveVodConfig.TYPE = LiveVodConfig.VOD;
            LiveVodConfig.currentVid = _loc2_;
            LiveVodConfig.LAST_TS_ID = this._dataManager.method_14(LiveVodConfig.currentVid);
            trace(this,"init playNext " + String(LiveVodConfig.currentVid).substr(0,5));
            console.log(this,"init playNext " + String(LiveVodConfig.currentVid).substr(0,5));
            _loc4_ = this._initData.var_65.totalDuration;
            _loc5_ = this._initData.var_65.mediaDuration;
            _loc6_ = this._initData.var_65.totalSize;
            this._initData = new class_2();
            this._initData.var_53 = true;
            this._initData.totalDuration = _loc4_;
            this._initData.mediaDuration = _loc5_;
            this._initData.totalSize = _loc6_;
            this._isFirstRun = true;
            this._seekType = 0;
            this.bufferTime = 1;
            trace(this,"init currentVid = " + LiveVodConfig.currentVid + "; LAST_TS_ID" + LiveVodConfig.LAST_TS_ID);
            trace(this,"init totalDuration = " + this._initData.totalDuration + "; mediaDuration = " + this._initData.mediaDuration + "; totalSize = " + this._initData.totalSize);
            console.log(this,"init currentVid = " + LiveVodConfig.currentVid + "; LAST_TS_ID" + LiveVodConfig.LAST_TS_ID);
            console.log(this,"init totalDuration = " + this._initData.totalDuration + "; mediaDuration = " + this._initData.mediaDuration + "; totalSize = " + this._initData.totalSize);
         }
         else
         {
            this._initData = new class_2();
         }
         this._errorReport = new ErrorReport(this._initData,this._dataManager);
         this.Reset(0);
         if(this._reportDownloadError)
         {
            this._reportDownloadError.clear();
            this._reportDownloadError = null;
         }
         this._reportDownloadError = new ReportDownloadError(this._initData);
      }
      
      public function getUsingTsURL() : String
      {
         return LiveVodConfig.USING_TS_URL;
      }
      
      public function set need_CDN_Bytes(param1:int) : void
      {
         this._need_CDN_Bytes = param1;
      }
      
      public function getStatisticData() : Object
      {
         return null;
      }
      
      public function getDownloadSpeed() : Number
      {
         return Statistic.method_261().method_107;
      }
      
      public function change_KBPS(param1:Array) : Boolean
      {
         var _loc2_:* = false;
         if(!(LiveVodConfig.TYPE == LiveVodConfig.LIVE) && param1.length > 0 && (param1[0]["kbps"]))
         {
            if(param1[0]["kbps"] != this._initData.kbps)
            {
               if(!((this._initData.method_68) && (this._initData.method_70)))
               {
                  _loc2_ = true;
               }
               else if(this._initData.method_70[0]["kbps"] != param1[0]["kbps"])
               {
                  _loc2_ = true;
               }
               else
               {
                  trace(this,"change_KBPS error");
               }
               
            }
            else if(true == LiveVodConfig.IS_CHANGE_KBPS)
            {
               this.clearNextVideoInfo();
               this._dataManager.method_13();
               this._initData.method_72();
               LiveVodConfig.currentChangeVid = "";
               LiveVodConfig.IS_CHANGE_KBPS = false;
               this.dispatchChangeKBPSSuccess();
               return true;
            }
            
         }
         if(_loc2_)
         {
            console.log(this,this._initData.kbps + " --> " + param1[0]["kbps"]);
            this.clearNextVideoInfo();
            this._dataManager.method_13();
            this._initData.method_72();
            LiveVodConfig.IS_CHANGE_KBPS = true;
            LiveVodConfig.currentChangeVid = "";
            this._initData.method_71(param1);
            this._dataManager.method_12(this._initData);
            this.setBufferTime();
            return true;
         }
         return false;
      }
      
      public function set_CDN_URL(param1:Array) : void
      {
         if((param1.length > 0) && (this._initData) && (this._initData.hasOwnProperty("flvURL")))
         {
            this._initData["flvURL"] = param1.concat();
            this._initData.method_66(0);
            console.log(this,"set_CDN_URL:" + param1);
            if(LiveVodConfig.TYPE == LiveVodConfig.LIVE)
            {
               this._initData.var_52 = true;
               this._initData.var_53 = false;
            }
            this._initData.g_nM3U8Idx = 0;
         }
      }
      
      public function setNextCdnUrl(param1:Array) : void
      {
         if(param1.length > 0 && (this._initData))
         {
            this._initData.method_73 = param1.concat();
            console.log(this,"set_NEXT_CDN_URL:" + param1);
            this._initData.var_51 = 0;
         }
      }
      
      public function set_CDN_INFO(param1:Array) : void
      {
         if((param1.length > 0) && (this._initData) && (this._initData.hasOwnProperty("cdnInfo")))
         {
            if(LiveVodConfig.TYPE == LiveVodConfig.LIVE)
            {
               this._initData["cdnInfo"] = param1;
               console.log(this,"set_CDN_INFO:" + param1);
               this._initData.var_52 = true;
               this._initData.var_53 = false;
               this._initData.g_nM3U8Idx = 0;
            }
            else if((this._dataManager) && (param1[0]["kbps"]) && true == this._dataManager.method_11(param1))
            {
               this._initData["cdnInfo"] = param1;
               console.log(this,"set_CDN_INFO:" + param1);
               this._initData.g_nM3U8Idx = 0;
            }
            
         }
      }
      
      public function setNextVideoInfo(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:* = 0;
         console.log(this," setNextVideoInfoLog info1 = " + param1);
         Statistic.method_261().method_95("setNextVideo");
         if((LiveVodConfig.TYPE == LiveVodConfig.VOD) && (param1["gslbURL"]) && true == this.isNextVideo(param1["gslbURL"]))
         {
            this.clearNextVideoInfo();
            this._initData.var_65 = new Object();
            console.log(this," setNextVideoInfoLog info2 = " + param1);
            Statistic.method_261().method_95("nextVideoInfo ok");
            for(_loc2_ in param1)
            {
               console.log(this," setNextVideoInfoLog ");
               console.log(this,_loc2_ + " : " + param1[_loc2_]);
               trace(this,this.setNextVideoInfo);
               trace(this,_loc2_ + " : " + param1[_loc2_]);
               if(_loc2_ == "cdnInfo")
               {
                  _loc3_ = param1[_loc2_];
                  if(_loc3_)
                  {
                     this._initData.var_65.flvURL = new Array();
                     this._initData.var_65.playLevelArr = new Array();
                     _loc4_ = 0;
                     while(_loc4_ < _loc3_.length)
                     {
                        this._initData.var_65.flvURL.push(_loc3_[_loc4_]["location"]);
                        this._initData.var_65.playLevelArr.push(_loc3_[_loc4_]["playlevel"]);
                        if(_loc3_[_loc4_]["kbps"])
                        {
                           this._initData.var_65.kbps = String(_loc3_[_loc4_]["kbps"]);
                        }
                        _loc4_++;
                     }
                  }
               }
               else
               {
                  this._initData.var_65[_loc2_] = param1[_loc2_];
                  if(_loc2_ == "adRemainingTime")
                  {
                     this._initData.method_61(param1[_loc2_] * 1000);
                  }
               }
            }
            this._initData.var_65.g_nM3U8Idx = 0;
            this._initData.var_54 = false;
            if(false == LiveVodConfig.IS_CHANGE_KBPS)
            {
               this._dataManager.method_12(this._initData);
            }
         }
      }
      
      public function stopLoadNextVideo() : void
      {
         this.clearNextVideoInfo();
      }
      
      private function clearNextVideoInfo() : void
      {
         if(this._initData.var_65)
         {
            console.log(this," setNextVideoInfo ");
            this._dataManager.method_13();
            this._dataManager.method_15(LiveVodConfig.nextVid);
         }
         LiveVodConfig.nextVid = "";
         this._initData.var_65 = null;
         this._initData.var_54 == false;
         Statistic.method_261().method_95("clearNextVideoInfo");
      }
      
      private function isNextVideo(param1:String) : Boolean
      {
         if((this._initData.gslbURL) && !(this.getKeyFromG3(this._initData.gslbURL) == this.getKeyFromG3(param1)))
         {
            if(this._initData.var_65)
            {
               if(this._initData.var_65.gslbURL)
               {
                  if(this.getKeyFromG3(this._initData.var_65.gslbURL) != this.getKeyFromG3(param1))
                  {
                     console.log(this,"isNextVideo: " + param1);
                     return true;
                  }
               }
            }
            else
            {
               console.log(this,"isNextVideo: " + param1);
               return true;
            }
         }
         return false;
      }
      
      private function getKeyFromG3(param1:String) : String
      {
         var _loc2_:int = param1.indexOf("v2/");
         var _loc3_:int = param1.indexOf("?");
         console.log(this," getKeyFromG3 " + param1);
         return param1.substring(_loc2_ + 3,_loc3_);
      }
      
      override public function get bytesLoaded() : uint
      {
         var _loc1_:class_1 = null;
         var _loc2_:* = NaN;
         if((this._initData) && (this._initData.totalSize > 0) && !(LiveVodConfig.TYPE == LiveVodConfig.LIVE))
         {
            _loc1_ = this._dataManager.method_24(LiveVodConfig.currentVid,LiveVodConfig.method_94);
            _loc2_ = 0;
            if((_loc1_) && (_loc1_.name_1))
            {
               _loc2_ = _loc1_.id + _loc1_.duration;
            }
            else if(_loc1_)
            {
               _loc2_ = _loc1_.id;
            }
            
            if(this.time / this._initData.totalDuration >= 1 || _loc2_ / this._initData.totalDuration >= 1)
            {
               return this._initData.totalSize;
            }
            if(_loc2_ <= this.time)
            {
               return this.time / this._initData.totalDuration * this._initData.totalSize;
            }
            return _loc2_ / this._initData.totalDuration * this._initData.totalSize;
         }
         return 0;
      }
      
      override public function get bytesTotal() : uint
      {
         if((this._initData) && this._initData.totalSize > 0)
         {
            return this._initData.totalSize;
         }
         return 0;
      }
      
      override public function resume() : void
      {
         this.isPause = false;
         if(!this._isBufferEmpty)
         {
            LIVE_TIME.isPause = false;
            this._bufferEmptyStartTime = -1;
         }
         else
         {
            this._bufferEmptyStartTime = this.getTime();
         }
         if(this._startWatchTime == -1)
         {
            this._startWatchTime = this.getTime();
         }
         this._initData.method_58(0);
         this.offLiveTime = LIVE_TIME.method_257() - LiveVodConfig.ADD_DATA_TIME;
         console.log(this,"resume _isBufferEmpty=" + this._isBufferEmpty + ", _bufferEmptyStartTime=" + this._bufferEmptyStartTime);
         super.resume();
      }
      
      override public function pause() : void
      {
         this.isPause = true;
         console.log(this,"pause _isBufferEmpty=" + this._isBufferEmpty + ", _bufferEmptyStartTime=" + this._bufferEmptyStartTime);
         super.pause();
         LIVE_TIME.isPause = true;
      }
      
      private function realSeek(param1:Number, param2:int = 0, param3:Boolean = false) : void
      {
         if(!param3)
         {
            LiveVodConfig.canChangeM3U8 = false;
            LiveVodConfig.changeBlockId = -1;
            if(param1 < 0)
            {
               var param1:Number = 0;
            }
            if((true == LiveVodConfig.IS_CHANGE_KBPS) && (this._initData.method_70) && !(param2 == 3))
            {
               this.isChangeKBPSSuccessAfterSeek = true;
               this._dataManager.method_13();
               LiveVodConfig.IS_CHANGE_KBPS = false;
               LiveVodConfig.currentVid = "";
               LiveVodConfig.currentChangeVid = "";
               this._initData.changeKBPSSuccess();
               this._initData.var_53 = false;
               this._dataManager.method_12(this._initData);
            }
            if(LiveVodConfig.TYPE == LiveVodConfig.LIVE && param1 >= LIVE_TIME.method_258())
            {
               param1 = LIVE_TIME.method_258();
            }
            if(!(LiveVodConfig.TYPE == LiveVodConfig.LIVE) && param1 >= LiveVodConfig.LAST_TS_ID)
            {
               param1 = LiveVodConfig.LAST_TS_ID;
            }
            this._seekTimeRecord = param1;
            LIVE_TIME.isPause = true;
            if(0 == param2 || 2 == param2)
            {
               if(LiveVodConfig.TYPE == LiveVodConfig.LIVE)
               {
                  LiveVodConfig.method_267 = param1;
               }
               if(this._initData)
               {
                  this._initData.var_55 = param1;
               }
               LiveVodConfig.var_281 = param1;
            }
            if(LiveVodConfig.TYPE == LiveVodConfig.LIVE)
            {
               LIVE_TIME.method_259(param1);
               this.offLiveTime = LIVE_TIME.method_257() - param1;
               console.log(this,"seek offLiveTime" + this.offLiveTime + " LiveTime:" + LIVE_TIME.method_257() + " = " + (LIVE_TIME.method_257() - param1));
            }
            LiveVodConfig.ADD_DATA_TIME = param1;
            LiveVodConfig.var_270 = param1;
            LiveVodConfig.method_94 = LiveVodConfig.ADD_DATA_TIME;
            LiveVodConfig.IS_SEEKING = true;
            console.log(this,"seek:" + LiveVodConfig.ADD_DATA_TIME + " M3U8_MAXTIME:" + LiveVodConfig.method_267 + " type:" + param2 + " offLiveTime:" + this.offLiveTime);
            this._isShowSeekIcon = true;
            this.Reset(param2);
            EventWithData.method_261().method_77(NETSTREAM_PROTOCOL.SEEK,param1);
            this._seekType = param2;
         }
         super.seek(0);
         this.flvHeadHandler();
         this["appendBytesAction"](RESET_SEEK);
      }
      
      override public function seek(param1:Number) : void
      {
         if(this._initData)
         {
            this._initData.var_58 = new Array();
         }
         LiveVodConfig.USING_ERROR_TS_URL = "";
         this.realSeek(param1,0);
      }
      
      private function Reset(param1:int) : void
      {
         this._seekOK = false;
         this._seekDataOK = false;
         if(this._currentBytes)
         {
            this._currentBytes.clear();
         }
         if(3 != param1)
         {
            this._currentBlock = null;
         }
         this._currentPiece = null;
         this.lastBlock = null;
         this._isLastData = false;
         this._isBufferEmpty = true;
         this._isNotifyPlayStop = false;
         this.lastPiece = -1;
         this._isEmptyIn15 = false;
         this.bufferTime = 1;
         if(this._fileHandler)
         {
            this._fileHandler.endProcessFile(null);
         }
         this._fileHandler = null;
         this._fileHandler = new HTTPStreamingMP2TSFileHandler();
      }
      
      private function setBufferTime(param1:Boolean = false) : void
      {
         if(true == LiveVodConfig.IS_CHANGE_KBPS)
         {
            this.bufferTime = 2;
            LiveVodConfig.BufferTimeLimit = 3;
            return;
         }
         if(LiveVodConfig.TYPE == LiveVodConfig.LIVE)
         {
            if(this.getTime() - this._startPlayTime >= 10 * 1000)
            {
               this.bufferTime = 8;
            }
            else if(true == param1)
            {
               if(false == this._isEmptyIn15)
               {
                  this.bufferTime = 2;
                  this._isEmptyIn15 = true;
               }
               else
               {
                  this.bufferTime = 8;
               }
            }
            
            LiveVodConfig.BufferTimeLimit = 10;
         }
         else
         {
            if(!this._initData)
            {
               return;
            }
            if(this._initData.totalDuration - this.time < this.bufferTime && !(this.bufferTime == 0.1))
            {
               this.bufferTime = 0.1;
            }
            else if(this._initData.totalDuration >= 5)
            {
               if(this.time * 1000 - this._startPlayTime >= 5 * 1000)
               {
                  if(String(this._initData.kbps).indexOf("p") != -1)
                  {
                     this.bufferTime = 4;
                  }
                  else
                  {
                     this.bufferTime = 5;
                  }
               }
               else if(true == param1)
               {
                  if(false == this._isEmptyIn15)
                  {
                     this.bufferTime = 2;
                     this._isEmptyIn15 = true;
                  }
                  else if(this._initData.totalDuration - this.time >= 5)
                  {
                     if(String(this._initData.kbps).indexOf("p") != -1)
                     {
                        this.bufferTime = 4;
                     }
                     else
                     {
                        trace(" 5<= " + (this._initData.totalDuration - this.time));
                        this.bufferTime = 5;
                     }
                  }
                  else
                  {
                     this.bufferTime = Math.floor(this._initData.totalDuration - this.time);
                  }
                  
               }
               
            }
            else if(this._initData.totalDuration > 3)
            {
               this.bufferTime = 2;
            }
            else
            {
               this.bufferTime = 0.1;
            }
            
            
            if(this.bufferTime < 1)
            {
               LiveVodConfig.BufferTimeLimit = 1;
            }
            else
            {
               LiveVodConfig.BufferTimeLimit = this.bufferTime;
            }
         }
      }
      
      private function isContinuity(param1:String) : Boolean
      {
         if((this._initData) && LiveVodConfig.TYPE == LiveVodConfig.VOD)
         {
            if((this._initData.var_65) && (this._initData.var_65.gslbURL) && this.getKeyFromG3(this._initData.var_65.gslbURL) == this.getKeyFromG3(param1))
            {
               return true;
            }
         }
         return false;
      }
      
      override public function play(... rest) : void
      {
         var _loc3_:String = null;
         var _loc4_:GetLocalID = null;
         var _loc5_:String = null;
         console.log(this,"初始化参数",rest);
         if(LiveVodConfig.TYPE == LiveVodConfig.LIVE && !(null == this._initData))
         {
            return;
         }
         var _loc2_:* = false;
         if(LiveVodConfig.TYPE == LiveVodConfig.VOD)
         {
            if(rest[0].gslbURL)
            {
               if(null != this._initData)
               {
                  if(this.isContinuity(rest[0].gslbURL))
                  {
                     this.init(true);
                     trace(this,"play 下一集 " + rest[0].gslbURL);
                     console.log(this,"play 下一集 " + rest[0].gslbURL);
                  }
                  else
                  {
                     _loc5_ = LiveVodConfig.uuid;
                     if(_loc5_ == "")
                     {
                        _loc5_ = new Utils().get40SizeUUID();
                     }
                     this.close();
                     this._connection = new NetConnection();
                     this._connection.connect(null);
                     this.init();
                     LiveVodConfig.uuid = _loc5_;
                     trace(this,"play 下一集 不相同" + rest[0].gslbURL);
                     console.log(this,"play 下一集 不相同" + rest[0].gslbURL);
                  }
                  _loc2_ = true;
               }
               else
               {
                  this.init();
                  console.log(this,"play  " + rest[0].gslbURL);
               }
            }
            else
            {
               console.log(this,"play 抛错 ");
               return;
            }
         }
         else
         {
            this.init();
         }
         super.play(null);
         for(_loc3_ in rest[0])
         {
            this._initData[_loc3_] = rest[0][_loc3_];
            console.log(this,_loc3_ + " : " + rest[0][_loc3_]);
            trace(this,"play, " + _loc3_ + " : " + rest[0][_loc3_]);
            if(LiveVodConfig.TYPE == LiveVodConfig.VOD && _loc3_ == "cdnInfo")
            {
               if(-1 != (rest[0][_loc3_][0]["location"] as String).toLowerCase().indexOf("_s.m3u8"))
               {
                  LiveVodConfig.IS_DRM = true;
               }
            }
            if(LiveVodConfig.TYPE == LiveVodConfig.LIVE && _loc3_ == "cdnInfo")
            {
               LiveVodConfig.STREAMID = ParseUrl.getParam(rest[0][_loc3_]["location"],"stream_id");
            }
            if(_loc3_ == "livesftime")
            {
               LiveVodConfig.var_273 = Number(rest[0][_loc3_]);
            }
            if(_loc3_ == "reportVar")
            {
               LiveVodConfig.REPORT_VAR = this._initData[_loc3_];
            }
         }
         _loc4_ = new GetLocalID();
         LiveVodConfig.CDE_ID = _loc4_.getCDEID();
         if(rest[0]["geo"])
         {
            LiveVodConfig.GEO = rest[0]["geo"];
         }
         if(rest[0]["adRemainingTime"])
         {
            this._initData.method_58(int(rest[0]["adRemainingTime"]) * 1000);
            this._adRemainingTime = int(rest[0]["adRemainingTime"]) * 1000;
            console.log(this,"初始化参数adRemainingTime=>" + int(rest[0]["adRemainingTime"]) * 1000);
         }
         if(rest[0]["gslbURL"])
         {
            LiveVodConfig.TERMID = "1";
            LiveVodConfig.PLATID = ParseUrl.getParam(rest[0]["gslbURL"],"platid");
            LiveVodConfig.SPLATID = ParseUrl.getParam(rest[0]["gslbURL"],"splatid");
            LiveVodConfig.VTYPE = ParseUrl.getParam(rest[0]["gslbURL"],"vtype");
            LiveVodConfig.P1 = ParseUrl.getParam(rest[0]["gslbURL"],"p1");
            LiveVodConfig.P2 = ParseUrl.getParam(rest[0]["gslbURL"],"p2");
            LiveVodConfig.P3 = ParseUrl.getParam(rest[0]["gslbURL"],"p3");
            LiveVodConfig.CH = ParseUrl.getParam(rest[0]["gslbURL"],"ch");
         }
         else if(rest[0]["gslb"])
         {
            LiveVodConfig.TERMID = "1";
            LiveVodConfig.PLATID = ParseUrl.getParam(rest[0]["gslb"],"platid");
            LiveVodConfig.SPLATID = ParseUrl.getParam(rest[0]["gslb"],"splatid");
            LiveVodConfig.VTYPE = ParseUrl.getParam(rest[0]["gslb"],"vtype");
            LiveVodConfig.P1 = ParseUrl.getParam(rest[0]["gslb"],"p1");
            LiveVodConfig.P2 = ParseUrl.getParam(rest[0]["gslb"],"p2");
            LiveVodConfig.P3 = ParseUrl.getParam(rest[0]["gslb"],"p3");
            LiveVodConfig.CH = ParseUrl.getParam(rest[0]["gslb"],"ch");
         }
         
         if(rest[0]["endtime"])
         {
            LiveVodConfig.END_TIME = rest[0]["endtime"];
         }
         LiveVodConfig.ADD_DATA_TIME = this._initData.startTime;
         LiveVodConfig.var_270 = this._initData.startTime;
         this._startPlayTime = this._initData.startTime * 1000;
         if(LiveVodConfig.TYPE == LiveVodConfig.LIVE)
         {
            LIVE_TIME.method_259(this._initData.startTime);
            LIVE_TIME.isPause = true;
            LiveVodConfig.method_267 = this._initData.startTime;
            LIVE_TIME.method_256(this._initData.serverCurtime);
         }
         EventWithData.method_261().method_77(NETSTREAM_PROTOCOL.PLAY,{
            "initData":this._initData,
            "reportDownloadError":this._reportDownloadError
         });
         this.flvHeadHandler();
         if((this._mainTimer) && !this._mainTimer.running)
         {
            this._mainTimer.start();
         }
         Statistic.method_261().method_82();
         this._bufferEmptyStartTime = this.getTime();
         if(_loc2_ == true)
         {
            this.pause();
            this.resume();
            this.seek(this._initData.startTime);
         }
      }
      
      public function resumeP2P() : Boolean
      {
         LiveVodConfig.ifCanP2PDownload = true;
         LiveVodConfig.ifCanP2PUpload = true;
         return true;
      }
      
      public function pauseP2P() : Boolean
      {
         LiveVodConfig.ifCanP2PDownload = false;
         LiveVodConfig.ifCanP2PUpload = false;
         return true;
      }
      
      private function flvHeadHandler() : void
      {
         console.log(this,"flvHeadHandler");
         this["appendBytesAction"]("resetBegin");
         var _loc1_:FLVHeader = new FLVHeader();
         var _loc2_:ByteArray = new ByteArray();
         _loc1_.write(_loc2_);
         this["appendBytes"](_loc2_);
      }
      
      private function processAndAppend(param1:ByteArray) : void
      {
         if(!this._seekOK)
         {
            return;
         }
         this.attemptAppendBytes(param1);
      }
      
      private function attemptAppendBytes(param1:ByteArray) : void
      {
         this["appendBytes"](param1);
      }
      
      private function notifyMetaData(param1:Object = null, param2:int = 0) : void
      {
         var _loc6_:String = null;
         var _loc7_:ByteArray = null;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         if(null == param1)
         {
            return;
         }
         if((param1 && this.notifyDurationGroupID == param1.groupID) && (this.notifyWidth == param1.width) && this.notifyHeight == param1.height)
         {
            return;
         }
         if(param1)
         {
            this.notifyDurationGroupID = param1.groupID;
            this.notifyWidth = param1.width;
            this.notifyHeight = param1.height;
         }
         var _loc3_:FLVTagScriptDataObject = new FLVTagScriptDataObject();
         var _loc4_:Object = new Object();
         if(LiveVodConfig.TYPE != LiveVodConfig.LIVE)
         {
            LiveVodConfig.TOTAL_DURATION = _loc4_.duration = this._initData.totalDuration;
            _loc4_.mediaDuration = this._initData.mediaDuration;
            Statistic.method_261().method_83(this._initData.totalDuration);
            LiveVodConfig.DATARATE = Math.round(this._initData.totalSize * 8 / this._initData.totalDuration / 1024);
         }
         _loc4_.height = param1.height;
         _loc4_.width = param1.width;
         if(param1.playerKbps)
         {
            _loc4_.kbps = param1.playerKbps;
         }
         var _loc5_:* = "";
         for(_loc6_ in _loc4_)
         {
            _loc5_ = _loc5_ + (" msg:" + _loc6_ + "=" + _loc4_[_loc6_]);
         }
         console.log(this,"notifyTotalDuration:" + _loc5_);
         _loc3_.objects = ["onMetaData",_loc4_];
         _loc7_ = new ByteArray();
         _loc3_.write(_loc7_);
         if(0 == param2 || 1 == param2)
         {
            this.attemptAppendBytes(_loc7_);
         }
         if(0 == param2 || 2 == param2)
         {
            if(this.client)
            {
               _loc8_ = _loc3_.objects[0];
               _loc9_ = _loc3_.objects[1];
               if(this.client.hasOwnProperty(_loc8_))
               {
                  this.client[_loc8_](_loc9_);
                  console.log(this,"metaDataEvent : " + _loc4_.width + " * " + _loc4_.height + ", kbps: " + (_loc4_.kbps?_loc4_.kbps:""));
               }
            }
         }
         this.dispatchEventFun({
            "code":"Stream.Play.Start",
            "startTime":this._initData.startTime
         });
      }
      
      private function onLoop(param1:TimerEvent) : void
      {
         var _loc2_:ByteArray = null;
         this.statisTimeCount++;
         if(this.statisTimeCount >= 100)
         {
            this.statisTimeCount = 0;
            LiveVodConfig.PLAY_TIME = this.time;
            Statistic.method_261().method_91(this.currentFPS);
            if(!(LiveVodConfig.TYPE == LiveVodConfig.LIVE) && true == this._initData.var_54 && this.time - this._initData.endTime >= LiveVodConfig.var_277)
            {
            }
            console.log(this,"FPS:" + Math.round(this.currentFPS)," memory:",System.totalMemory," totalMemory:",System.totalMemoryNumber," privateMemory:",System.privateMemory);
            this.doAllCDNFailed();
         }
         Statistic.method_261().getDownloadSpeed();
         this.judgeChangeKBPS();
         this.setBufferTime();
         if(this._currentBytes == null || this._currentBytes.bytesAvailable == 0)
         {
            this._currentBytes.clear();
            this.fetchData();
         }
         if(!(this.input == null) && this.input.bytesAvailable > 0)
         {
            if(this._fileHandler == null)
            {
               this._fileHandler = new HTTPStreamingMP2TSFileHandler();
            }
            _loc2_ = this._fileHandler.processFileSegment(this.input);
            if(_loc2_ != null)
            {
               this.processAndAppend(_loc2_);
            }
         }
         if(LiveVodConfig.TYPE != LiveVodConfig.LIVE)
         {
            if((this._currentBlock && this._currentBlock.id == LiveVodConfig.LAST_TS_ID && this._currentPiece && this._currentPiece.id == this._currentBlock.var_6.length - 1 && this.bufferLength < 0.1) && (this.input.bytesAvailable < 188) && Math.abs(LiveVodConfig.TOTAL_DURATION - this.time) < 0.5)
            {
               this.notifyPlayStop();
            }
         }
         if((this._isBufferEmpty) && LiveVodConfig.TYPE == LiveVodConfig.LIVE)
         {
            if((LiveVodConfig.canChangeM3U8) && LiveVodConfig.changeBlockId - LiveVodConfig.ADD_DATA_TIME < 20)
            {
               console.log(this,"NetStream.change.player time:" + LiveVodConfig.changeBlockId);
               dispatchEvent(new NetStatusEvent(NETSTREAM_PROTOCOL.const_3,false,false,{
                  "code":"NetStream.change.player",
                  "level":"status",
                  "changeTime":LiveVodConfig.changeBlockId
               }));
               return;
            }
            if(!(this.offLiveTime == -1) && !this.isPause)
            {
               if(true == this._seekDataOK)
               {
                  if(LIVE_TIME.method_257() - LiveVodConfig.ADD_DATA_TIME - this.offLiveTime > 90)
                  {
                     console.log(this,"buffer is empty, delay time 90:" + (LIVE_TIME.method_258() - LiveVodConfig.ADD_DATA_TIME));
                     this.realSeek(LiveVodConfig.ADD_DATA_TIME + 90,2);
                  }
               }
               else if(LIVE_TIME.method_257() - LiveVodConfig.ADD_DATA_TIME - this.offLiveTime > 90)
               {
                  console.log(this,"seek buffer is empty, delay time 90:" + LIVE_TIME.method_257() + " " + LiveVodConfig.ADD_DATA_TIME + " " + this.offLiveTime);
                  this.realSeek(LiveVodConfig.ADD_DATA_TIME + 90,2);
               }
               
            }
         }
      }
      
      private function fetchData() : void
      {
         var _loc1_:* = NaN;
         var _loc2_:class_1 = null;
         var _loc3_:* = false;
         var _loc4_:class_1 = null;
         var _loc5_:class_1 = null;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         if(this._initData)
         {
            Statistic.method_261().bufferTime(this.bufferTime,this.bufferLength,this._adRemainingTime,this._initData.method_59());
         }
         if(!(LiveVodConfig.TYPE == LiveVodConfig.LIVE) && (this._isLastData))
         {
            this.setBufferTime();
            return;
         }
         if(LiveVodConfig.TYPE == LiveVodConfig.LIVE)
         {
            if(LIVE_TIME.method_257() - LiveVodConfig.ADD_DATA_TIME < 30)
            {
               return;
            }
         }
         if(this.bufferLength > LiveVodConfig.BufferTimeLimit && this.bufferLength <= 60)
         {
            return;
         }
         if((this._currentBlock) && this.bufferLength > 60)
         {
            console.log(this,"data error1-time error");
            _loc2_ = null;
            if(this._currentBlock.var_1 != -1)
            {
               _loc2_ = this._dataManager.method_24(LiveVodConfig.currentVid,this._currentBlock.var_1,true);
            }
            else
            {
               _loc2_ = this._dataManager.method_25(LiveVodConfig.currentVid,this._currentBlock.id);
            }
            if(null != _loc2_)
            {
               LiveVodConfig.ADD_DATA_TIME = LiveVodConfig.BlockID = _loc2_.id;
               LiveVodConfig.PLAYING_BLOCK_GID = _loc2_.groupID;
               this._currentBlock = _loc2_;
               this.notifyMetaData(_loc2_);
               this.realSeek(_loc2_.id,3);
               this.g_Lastbuflen = this.bufferLength;
               console.log(this,"g_Lastbuflen == 0 && this.bufferLength == 0 block.id: " + _loc2_.id);
               return;
            }
         }
         else if(this._currentBlock == null && this.bufferLength > 60)
         {
            console.log(this,"data error2-time error");
            return;
         }
         
         if(this._currentBytes == null || this._currentBytes.bytesAvailable == 0)
         {
            if(this._currentBlock == null)
            {
               if(!this._dataManager)
               {
                  trace(this,"_dataManager = " + this._dataManager);
                  console.log(this,"_dataManager = " + this._dataManager);
                  return;
               }
               if(LiveVodConfig.TYPE == LiveVodConfig.LIVE && !this._initData.var_57)
               {
                  this.tmpBlock = this._dataManager.method_24(LiveVodConfig.currentVid,0);
                  if(this.tmpBlock)
                  {
                     LiveVodConfig.ADD_DATA_TIME = this.tmpBlock.id;
                  }
                  else
                  {
                     return;
                  }
               }
               else
               {
                  this.tmpBlock = this._dataManager.method_24(LiveVodConfig.currentVid,LiveVodConfig.ADD_DATA_TIME);
               }
               if((this.tmpBlock) && (this._seekType == 0) && !(-1 == this.tmpBlock.var_1))
               {
                  console.log(this,"fetchData a stime=" + LiveVodConfig.ADD_DATA_TIME + "; tmpBlock.id=" + this.tmpBlock.id + "; vid=" + LiveVodConfig.currentVid + "; gid" + this.tmpBlock.groupID);
                  if((this.tmpBlock.id + this.tmpBlock.var_1) / 2 < LiveVodConfig.ADD_DATA_TIME)
                  {
                     this.tmpBlock = this._dataManager.method_24(LiveVodConfig.currentVid,this.tmpBlock.var_1);
                     console.log("fetchData 1/2 tmpBlock.id=" + "; next=" + this.tmpBlock.var_1);
                  }
               }
               if(this.tmpBlock)
               {
                  Statistic.method_261().method_89(this.tmpBlock.groupID);
                  console.log(this,"fetchData b stime=" + LiveVodConfig.ADD_DATA_TIME + "; tmpBlock.id=" + this.tmpBlock.id + "; vid=" + LiveVodConfig.currentVid + "; gid" + this.tmpBlock.groupID);
               }
               while((this.tmpBlock) && this.tmpBlock.duration == 0)
               {
                  if(this.tmpBlock.var_1 != -1)
                  {
                     this.tmpBlock = this._dataManager.method_24(LiveVodConfig.currentVid,this.tmpBlock.var_1,true);
                     if(-1 == this.tmpBlock.var_1)
                     {
                        break;
                     }
                  }
               }
               if(!this.tmpBlock)
               {
                  console.log(this,"seek  !tmpBlock " + LiveVodConfig.ADD_DATA_TIME);
                  return;
               }
               this._currentBlock = this.tmpBlock;
               LiveVodConfig.ADD_DATA_TIME = LiveVodConfig.BlockID = this._currentBlock.id;
               LiveVodConfig.PLAYING_BLOCK_GID = this._currentBlock.groupID;
               trace(this,"seek  !tmpBlock " + LiveVodConfig.ADD_DATA_TIME);
               trace(this,"LiveVodConfig.ADD_DATA_TIME = LiveVodConfig.BlockID = _currentBlock.id " + this._currentBlock.id + ", gid=" + this._currentBlock.groupID);
               console.log(this,"afterSeek LiveVodConfig.BlockID = " + LiveVodConfig.BlockID);
               console.log(this,"fetchData ADD_DATA_TIME= " + LiveVodConfig.ADD_DATA_TIME + "; PLAYING_BLOCK_GID= " + LiveVodConfig.PLAYING_BLOCK_GID);
               if(true == this.isChangeKBPSSuccessAfterSeek)
               {
                  this.changeKBPSSuccess(this._currentBlock.groupID,this._currentBlock.playerKbps,true);
                  this.notifyMetaData(this._currentBlock,2);
                  this.dispatchChangeKBPSSuccess(this._currentBlock.playerKbps);
                  this.changingKBPSArray = new Array();
                  this.isChangeKBPSSuccessAfterSeek = false;
                  console.log(this,"ChangeKBPSSuccess!!! time = " + this.time);
                  console.log(this,"seek ChangeKBPSSuccess!!!" + this._currentBlock.playerKbps);
               }
               else
               {
                  this.notifyMetaData(this._currentBlock);
               }
               if(LiveVodConfig.TYPE != LiveVodConfig.LIVE)
               {
                  if(true == this._isFirstRun)
                  {
                     this._isFirstRun = false;
                  }
                  else
                  {
                     this._startPlayTime = this.time * 1000;
                  }
               }
               else
               {
                  this._startPlayTime = this.getTime();
               }
               this.realSeek(this.tmpBlock.id,3);
               this.lastBlock = this._currentBlock;
               this._currentPiece = this.tmpBlock.method_5(0);
               if(this._currentPiece)
               {
                  LiveVodConfig.var_279 = this._currentPiece.id;
               }
            }
            console.log(this,"_currentBlock != null ");
            if((this._currentBlock) && !this._currentPiece)
            {
               this._currentPiece = this._currentBlock.method_5(0);
               if(this._currentPiece)
               {
                  LiveVodConfig.var_279 = this._currentPiece.id;
               }
            }
            if((this._currentBlock && this._currentPiece) && (this._currentPiece.name_1) && this._currentPiece.method_50().length > 0)
            {
               Statistic.method_261().method_78 = this._currentBlock.groupID;
               if(this._currentBytes == null)
               {
                  this._currentBytes = new ByteArray();
               }
               if(this.lastPiece != this._currentPiece.id)
               {
                  this.lastPiece = this._currentPiece.id;
                  this._currentBytes.clear();
                  this._currentBytes.writeBytes(this._currentPiece.method_50());
                  this._currentBytes.position = 0;
                  console.log(this,"play->bID:" + this._currentBlock.id + " pID:" + this._currentPiece.id + "_" + this._currentPiece.pieceKey + " url:" + this._currentBlock.name);
                  if((LiveVodConfig.IS_DRM) && (this._dataManager.method_33(this._currentBlock.groupID).drm))
                  {
                     this._currentBytes = this._dataManager.method_33(this._currentBlock.groupID).drm.decryptSream(this._currentBytes,this._currentBlock.id);
                     this.input = this._currentBytes;
                  }
                  else
                  {
                     this.input = this._currentBytes;
                  }
                  if(!this._seekDataOK)
                  {
                     this._seekDataOK = true;
                     this.offLiveTime = LIVE_TIME.method_257() - LiveVodConfig.ADD_DATA_TIME;
                  }
                  if(null == this._fileHandler)
                  {
                     this._fileHandler = new HTTPStreamingMP2TSFileHandler();
                  }
                  this._fileHandler.beginProcessFile();
                  this._isShowSeekIcon = false;
                  _loc3_ = LIVE_TIME.isPause;
                  if(this.g_Lastbuflen == -1 && this.bufferLength > 0)
                  {
                     this.g_Lastbuflen = this.bufferLength;
                  }
                  else if(this.g_Lastbuflen == this.bufferLength && (_loc3_ == false || this._isBufferEmpty == true))
                  {
                     this.iErrorCount++;
                     if(this.iErrorCount >= 8)
                     {
                        this.iErrorCount = 0;
                        _loc4_ = null;
                        if(this._currentBlock.var_1 != -1)
                        {
                           _loc4_ = this._dataManager.method_24(LiveVodConfig.currentVid,this._currentBlock.var_1,true);
                        }
                        else
                        {
                           _loc4_ = this._dataManager.method_25(LiveVodConfig.currentVid,this._currentBlock.id);
                        }
                        if(_loc4_)
                        {
                           if(!(true == LiveVodConfig.IS_CHANGE_KBPS && this._initData.method_70))
                           {
                              this.notifyMetaData(_loc4_);
                              this.realSeek(_loc4_.id,3);
                              console.log(this,"g_Lastbuflen:" + this.g_Lastbuflen + "== bufferLength:" + bufferLength + " seek->" + _loc4_.id);
                           }
                           else
                           {
                              this.realSeek(_loc4_.id,0);
                              console.log(this,"g_Lastbuflen:" + this.g_Lastbuflen + "== bufferLength:" + bufferLength + "changeKBPS seek->" + _loc4_.id);
                           }
                        }
                        else
                        {
                           console.log(this,"g_Lastbuflen:" + this.g_Lastbuflen + "== bufferLength:" + bufferLength + " seek->" + "null");
                        }
                        this.g_Lastbuflen = this.bufferLength;
                        return;
                     }
                  }
                  else
                  {
                     this.iErrorCount = 0;
                  }
                  
               }
               else
               {
                  if(!this.isPause && (this._seekDataOK) && this.g_Lastbuflen == this.bufferLength)
                  {
                     this.iErrorCount++;
                     if(this.iErrorCount >= 8)
                     {
                        this.iErrorCount = 0;
                        _loc5_ = null;
                        if(this._currentBlock.var_1 != -1)
                        {
                           _loc5_ = this._dataManager.method_24(LiveVodConfig.currentVid,this._currentBlock.var_1,true);
                        }
                        else
                        {
                           _loc5_ = this._dataManager.method_25(LiveVodConfig.currentVid,this._currentBlock.id);
                        }
                        console.log(this,"iErrorCount >= 8 " + this._currentBlock.id + ", " + this._currentPiece.id);
                        if(_loc5_)
                        {
                           if(!(true == LiveVodConfig.IS_CHANGE_KBPS && this._initData.method_70))
                           {
                              this.notifyMetaData(_loc5_);
                              this.realSeek(_loc5_.id,2);
                              this.g_Lastbuflen = this.bufferLength;
                              console.log(this,"g_Lastbuflen != this.bufferLength s block.id: " + _loc5_.id);
                              return;
                           }
                           this.realSeek(_loc5_.id,0);
                           this.g_Lastbuflen = this.bufferLength;
                           console.log(this,"g_Lastbuflen != this.bufferLength s block.id changeKBPS: " + _loc5_.id);
                           return;
                        }
                     }
                  }
                  else
                  {
                     this.iErrorCount = 0;
                  }
                  if((this._currentBlock) && (this._currentPiece))
                  {
                     console.log(this,"PieceRepated_Blockid:" + this._currentBlock.id + " Pieceid:" + this._currentPiece.id + "_" + this._currentPiece.pieceKey);
                  }
               }
               this.g_Lastbuflen = this.bufferLength;
               if((this._currentBlock) && (this._currentPiece))
               {
                  Statistic.method_261().method_92(String(this._currentBlock.id) + "_" + this._currentPiece.id);
               }
               if(LiveVodConfig.TYPE != LiveVodConfig.LIVE)
               {
                  if(this._currentBlock.id == LiveVodConfig.LAST_TS_ID && this._currentPiece.id == this._currentBlock.var_6.length - 1)
                  {
                     this._isLastData = true;
                  }
               }
               if((this._currentBlock) && (this._currentPiece) && this._currentPiece.id == this._currentBlock.var_6.length - 1)
               {
                  if(!(LiveVodConfig.TYPE == LiveVodConfig.LIVE) && this._currentBlock.id + this._currentBlock.duration >= LiveVodConfig.TOTAL_DURATION)
                  {
                     LiveVodConfig.ADD_DATA_TIME = LiveVodConfig.LAST_TS_ID;
                  }
                  if(this._currentBlock.var_1 != -1)
                  {
                     if(false == LiveVodConfig.IS_CHANGE_KBPS)
                     {
                        this.tmpBlock = this._dataManager.method_24(LiveVodConfig.currentVid,this._currentBlock.var_1,true);
                     }
                     else
                     {
                        _loc6_ = this.prepareChangeKBPS(this._currentBlock,true);
                        if(_loc6_)
                        {
                           if(_loc6_ is class_1)
                           {
                              this.tmpBlock = _loc6_ as class_1;
                           }
                           else if(_loc6_ == -1)
                           {
                              this.tmpBlock = null;
                              return;
                           }
                           
                        }
                        else
                        {
                           this.dispatchDiscKBPSSuccess(_loc6_["playerKbps"]);
                           return;
                        }
                     }
                  }
                  else if(false == LiveVodConfig.IS_CHANGE_KBPS)
                  {
                     this.tmpBlock = this._dataManager.method_25(LiveVodConfig.currentVid,this._currentBlock.id);
                  }
                  else
                  {
                     _loc7_ = this.prepareChangeKBPS(this._currentBlock,false);
                     if(_loc7_)
                     {
                        if(_loc7_ is class_1)
                        {
                           this.tmpBlock = _loc6_ as class_1;
                        }
                        else if(_loc7_ == -1)
                        {
                           this.tmpBlock = null;
                           return;
                        }
                        
                     }
                     else
                     {
                        this.dispatchDiscKBPSSuccess(_loc6_["playerKbps"]);
                        return;
                     }
                  }
                  
                  while((this.tmpBlock) && this.tmpBlock.duration == 0)
                  {
                     if(this.tmpBlock.var_1 != 0)
                     {
                        this.tmpBlock = this._dataManager.method_24(LiveVodConfig.currentVid,this.tmpBlock.var_1,true);
                        continue;
                     }
                     this.tmpBlock = this._dataManager.method_25(LiveVodConfig.currentVid,this._currentBlock.id);
                     break;
                  }
                  if((this.tmpBlock) && !(this.tmpBlock.id == this._currentBlock.id))
                  {
                     if(this.tmpBlock.discontinuity == 0 && this.tmpBlock.groupID == this._currentBlock.groupID && this.tmpBlock.width == this._currentBlock.width && this.tmpBlock.height == this._currentBlock.height)
                     {
                        this._initData.videoHeight = this.tmpBlock.width;
                        this._initData.videoWidth = this.tmpBlock.height;
                        console.log(this,"lastpiece_tmpBlock.id:" + this.tmpBlock.id);
                        this._currentBlock = this.tmpBlock;
                        LiveVodConfig.ADD_DATA_TIME = LiveVodConfig.BlockID = this._currentBlock.id;
                        LiveVodConfig.PLAYING_BLOCK_GID = this._currentBlock.groupID;
                        this.lastBlock = this._currentBlock;
                        this._currentPiece = this._currentBlock.method_5(0);
                        if(this._currentPiece)
                        {
                           LiveVodConfig.var_279 = this._currentPiece.id;
                        }
                     }
                     else if(this.tmpBlock.discontinuity == 1 || !(this.tmpBlock.groupID == this._currentBlock.groupID) || !(this.tmpBlock.width == this._currentBlock.width) || !(this.tmpBlock.height == this._currentBlock.height))
                     {
                        if(LiveVodConfig.IS_CHANGE_KBPS == true && !(this.tmpBlock.groupID == this._currentBlock.groupID))
                        {
                           console.log(this,"lastpiece_tmpBlock.id:" + this.tmpBlock.id);
                           if(this._currentBytes.bytesAvailable != 0)
                           {
                              console.log(this,"------------------------");
                              return;
                           }
                           this._currentBytes.clear();
                           console.log(this,"OLD_KEYFRAME id = " + this._currentBlock.id + ", kbps = " + this._currentBlock.playerKbps);
                           console.log(this,"OLD_KEYFRAME id+dur = " + (this._currentBlock.id + this._currentBlock.duration));
                           this._currentBlock = this.tmpBlock;
                           LiveVodConfig.ADD_DATA_TIME = LiveVodConfig.BlockID = this._currentBlock.id;
                           LiveVodConfig.PLAYING_BLOCK_GID = this._currentBlock.groupID;
                           this.lastBlock = this._currentBlock;
                           this._currentPiece = this._currentBlock.method_5(0);
                           if(this._currentPiece)
                           {
                              LiveVodConfig.var_279 = this._currentPiece.id;
                           }
                           console.log(this,"CHANGE_KEYFRAME id = " + this.tmpBlock.id + ", kbps = " + this.tmpBlock.playerKbps);
                           this.addChangeKBPSPoint(this.tmpBlock);
                           if(this._fileHandler)
                           {
                              this._fileHandler.endProcessFile(null);
                           }
                           this._fileHandler = null;
                           this._fileHandler = new HTTPStreamingMP2TSFileHandler();
                           this.flvHeadHandler();
                           console.log(this,"OOOOOOO appendBytesAction changeKBPS " + this._currentBlock.id + " " + this._currentBlock.playerKbps);
                        }
                        else if(this.bufferLength <= 0.5)
                        {
                           this._currentBlock = this.tmpBlock;
                           LiveVodConfig.ADD_DATA_TIME = LiveVodConfig.BlockID = this._currentBlock.id;
                           LiveVodConfig.PLAYING_BLOCK_GID = this._currentBlock.groupID;
                           this.notifyMetaData(this.tmpBlock);
                           this.realSeek(this.tmpBlock.id,3);
                           console.log(this,"change group seek " + this.tmpBlock.discontinuity);
                           return;
                        }
                        
                     }
                     
                  }
                  else
                  {
                     console.log(this,"tmpBlock is null LiveVodConfig.ADD_DATA_TIME: " + LiveVodConfig.ADD_DATA_TIME);
                  }
                  return;
               }
               if((this._currentBlock) && (this._currentPiece))
               {
                  this._currentPiece = this._currentBlock.method_5(this._currentPiece.id + 1);
                  if(this._currentPiece)
                  {
                     while((this._currentPiece.name_1) && this._currentPiece.size == 0)
                     {
                        if(this._currentPiece.id + 1 == this._currentBlock.var_6.length)
                        {
                           if(-1 != this._currentBlock.var_1)
                           {
                              this.tmpBlock = this._dataManager.method_24(LiveVodConfig.currentVid,this._currentBlock.var_1,true);
                              if(this.tmpBlock)
                              {
                                 this._currentBlock = this.tmpBlock;
                                 LiveVodConfig.ADD_DATA_TIME = LiveVodConfig.BlockID = this._currentBlock.id;
                                 LiveVodConfig.PLAYING_BLOCK_GID = this._currentBlock.groupID;
                                 this._currentPiece = this._currentBlock.method_5(0);
                                 LiveVodConfig.var_279 = this._currentPiece.id;
                              }
                           }
                           break;
                        }
                        this._currentPiece = this._currentBlock.method_5(this._currentPiece.id + 1);
                        LiveVodConfig.var_279 = this._currentPiece.id;
                     }
                  }
               }
               if(!this._seekDataOK)
               {
                  this._seekTimeRecord = this._currentBlock.id;
               }
            }
            else
            {
               if((LiveVodConfig.TYPE == LiveVodConfig.VOD && this._currentBlock) && (this._currentPiece) && this._currentPiece.name_1 == false)
               {
                  trace(this,"addTaskCache " + this._currentBlock.id + ", " + this._currentPiece.id);
                  console.log(this,"addTaskCache " + this._currentBlock.id + ", " + this._currentPiece.id);
               }
               else
               {
                  trace(this,"addTaskCache " + this._currentBlock + ", " + this._currentPiece);
               }
               if((this._currentPiece) && this._currentPiece.var_26 >= 3)
               {
                  if(-1 != this._currentBlock.var_1)
                  {
                     console.log(this,"piece errorCount >= 3 " + this._currentBlock.id + "[" + this._currentPiece.id + "]");
                     this.realSeek(this._currentBlock.var_1,1);
                  }
                  else
                  {
                     console.log(this,"piece errorCount >= 3 no next " + this._currentBlock.id + "[" + this._currentPiece.id + "]");
                     this.realSeek(this._currentBlock.id + this._currentBlock.duration + 2.5,1);
                  }
               }
               if(this._isShowSeekIcon)
               {
                  this.notifyShowIcon();
               }
            }
         }
      }
      
      private function judgeChangeKBPS(param1:Boolean = false) : void
      {
         var _loc2_:Object = null;
         var _loc3_:* = false;
         if(true == LiveVodConfig.IS_CHANGE_KBPS)
         {
            if((this.changingKBPSArray) && this.changingKBPSArray.length > 0)
            {
               if(false == param1)
               {
                  if(this.time >= this.changingKBPSArray[0]["id"])
                  {
                     _loc3_ = false;
                     if((this._initData.method_70) && this._initData.method_70[0]["kbps"] == this.changingKBPSArray[0]["playerKbps"])
                     {
                        _loc3_ = true;
                     }
                     console.log(this,"w==" + this.changingKBPSArray[0].width + " h==" + this.changingKBPSArray[0].height);
                     this.changeKBPSSuccess(this.changingKBPSArray[0]["groupID"],this.changingKBPSArray[0]["playerKbps"],_loc3_);
                     this.notifyMetaData(this.changingKBPSArray[0],2);
                     this.dispatchChangeKBPSSuccess(this.changingKBPSArray[0]["playerKbps"]);
                     console.log(this,"ChangeKBPSSuccess!!! kbps = " + this.changingKBPSArray[0]["playerKbps"] + ",time = " + this.time);
                     if(true == _loc3_)
                     {
                        this.changingKBPSArray = new Array();
                     }
                     else
                     {
                        this.changingKBPSArray.shift();
                     }
                     return;
                  }
               }
            }
            _loc2_ = null;
            if(this._currentBlock.var_1 != -1)
            {
               _loc2_ = this.prepareChangeKBPS(this._currentBlock,true);
            }
            else
            {
               _loc2_ = this.prepareChangeKBPS(this._currentBlock,false);
            }
            if(!_loc2_ && !(-1 == _loc2_))
            {
               this.notifyShowIcon(true);
               this.realSeek(this.time,0);
               return;
            }
         }
      }
      
      private function addChangeKBPSPoint(param1:class_1) : void
      {
         var _loc4_:String = null;
         var _loc2_:* = 0;
         while(_loc2_ < this.changingKBPSArray.length)
         {
            if(this.changingKBPSArray[_loc2_]["id"] == param1.id && this.changingKBPSArray[_loc2_]["playerKbps"] == param1.playerKbps && this.changingKBPSArray[_loc2_]["groupID"] == param1.groupID)
            {
               trace(this,"same changingKBPS " + param1.id);
               return;
            }
            _loc2_++;
         }
         var _loc3_:Object = new Object();
         _loc3_.id = param1.id;
         _loc3_.groupID = param1.groupID;
         _loc3_.width = param1.width;
         _loc3_.height = param1.height;
         _loc3_.playerKbps = param1.playerKbps;
         this.changingKBPSArray.push(_loc3_);
         trace(this,"addChangeKBPSPoint " + param1.id,param1.groupID);
         for(_loc4_ in _loc3_)
         {
            console.log(this,"addChangeKBPSPoint." + _loc4_ + " = " + _loc3_[_loc4_]);
         }
         _loc2_ = 0;
         while(_loc2_ < this.changingKBPSArray.length)
         {
            console.log(this,"changeKBPSPointList[" + _loc2_ + "].id = " + this.changingKBPSArray[_loc2_]["id"] + ", kbps = " + this.changingKBPSArray[_loc2_]["playerKbps"]);
            _loc2_++;
         }
      }
      
      private function changeKBPSSuccess(param1:String, param2:String, param3:Boolean = true) : void
      {
         LiveVodConfig.currentVid = param1;
         this._initData.kbps = param2;
         LiveVodConfig.LAST_TS_ID = this._dataManager.method_14(LiveVodConfig.currentVid);
         console.log("changeKBPSSuccess = " + LiveVodConfig.LAST_TS_ID);
         if(true == param3)
         {
            this._initData.changeKBPSSuccess();
            LiveVodConfig.currentChangeVid = "";
            LiveVodConfig.IS_CHANGE_KBPS = false;
            if((LiveVodConfig.nextVid == "") && (this._initData.var_65) && this._initData.var_54 == false)
            {
               this._dataManager.method_12(this._initData);
            }
         }
         if(LiveVodConfig.TYPE != LiveVodConfig.LIVE)
         {
            this._startPlayTime = this.time * 1000;
            this.bufferTime = 1;
         }
         else
         {
            this._startPlayTime = this.getTime();
         }
      }
      
      private function prepareChangeKBPS(param1:class_1, param2:Boolean) : Object
      {
         var _loc3_:class_1 = null;
         var _loc4_:class_1 = null;
         if("" == LiveVodConfig.currentChangeVid || null == this._dataManager.method_33(LiveVodConfig.currentChangeVid))
         {
            return -1;
         }
         if(true == param2)
         {
            _loc3_ = this._dataManager.method_24(LiveVodConfig.currentVid,param1.var_1,param2);
            _loc4_ = this._dataManager.method_24(LiveVodConfig.currentChangeVid,param1.var_1,param2);
         }
         else
         {
            _loc3_ = this._dataManager.method_25(LiveVodConfig.currentVid,this._currentBlock.id);
            _loc4_ = this._dataManager.method_25(LiveVodConfig.currentChangeVid,this._currentBlock.id);
         }
         if((_loc3_) && (_loc4_) && _loc3_.id == _loc4_.id)
         {
            return _loc4_;
         }
         if(_loc3_)
         {
            console.log(this,"can\'t change kbps this_NextKBPS= " + _loc3_.id + ", kbps" + _loc3_.playerKbps);
         }
         if(_loc4_)
         {
            console.log(this,"can\'t change kbps change_NextKBPS= " + _loc4_.id + ", kbps" + _loc4_.playerKbps);
         }
         return null;
      }
      
      private function dispatchOnMetaData() : void
      {
      }
      
      private function dispatchDiscKBPSSuccess(param1:String = "") : void
      {
         dispatchEvent(new NetStatusEvent(NETSTREAM_PROTOCOL.const_4,false,false,{
            "code":"P2P.ChangeKBPS.Success",
            "level":"status",
            "kbps":param1
         }));
         console.log(this,"dispatchChangeDiscKBPSSuccess!!! kbps = " + param1 + "time = " + this.time);
         this.notifyShowIcon(true);
         this.realSeek(this.time,0);
      }
      
      private function dispatchChangeKBPSSuccess(param1:String = "") : void
      {
         if(param1 == "")
         {
            var param1:String = this._initData.kbps;
         }
         dispatchEvent(new NetStatusEvent(NETSTREAM_PROTOCOL.const_4,false,false,{
            "code":"P2P.ChangeKBPS.Success",
            "level":"status",
            "kbps":param1
         }));
         console.log(this,"dispatchChangeKBPSSuccess!!! kbps = " + param1 + "time = " + this.time);
      }
      
      public function dispatchPreLoadComplete() : void
      {
         dispatchEvent(new NetStatusEvent(NETSTREAM_PROTOCOL.const_3,false,false,{
            "code":"Stream.preLoad.Complete",
            "level":"status"
         }));
         console.log(this,"Stream.preLoad.Complete!!!  " + this._initData.var_65.gslbURL);
      }
      
      private function notifyShowIcon(param1:Boolean = false) : void
      {
         this._isShowSeekIcon = false;
         console.log(this,"Stream.Seek.ShowIcon");
         if(!this._isBufferEmpty)
         {
            if(!param1)
            {
               return;
            }
         }
         dispatchEvent(new NetStatusEvent(NETSTREAM_PROTOCOL.const_3,false,false,{
            "code":"Stream.Seek.ShowIcon",
            "level":"status"
         }));
      }
      
      private function notifyPlayStop() : void
      {
         console.log(this,"_isNotifyPlayStop : " + this._isNotifyPlayStop);
         if(!this._isNotifyPlayStop)
         {
            this._isNotifyPlayStop = true;
            if((this._mainTimer) && (this._mainTimer.running))
            {
               this._mainTimer.stop();
            }
            console.log(this,"Stream.Play.Stop");
            var _loc1_:Object = new Object();
            _loc1_.code = "Stream.Play.Stop";
            _loc1_.level = "status";
            dispatchEvent(new NetStatusEvent(NETSTREAM_PROTOCOL.const_3,false,false,_loc1_));
            return;
         }
      }
      
      private function resetEndHandler() : void
      {
         this["appendBytesAction"](END_SEQUENCE);
      }
      
      private function doAllCDNFailed() : void
      {
         var _loc2_:String = null;
         var _loc1_:Object = new Object();
         if(LiveVodConfig.var_269)
         {
            _loc1_.code = "Stream.Play.Failed";
            _loc1_.p2pErrorCode = "0000";
            _loc1_.allCDNFailed = 1;
            _loc1_.error = "DRM";
            console.log(this,"doAllCDNFailed type:DRM");
            dispatchEvent(new NetStatusEvent(NETSTREAM_PROTOCOL.const_3,false,false,_loc1_));
         }
         if("noError" != LiveVodConfig.EXT_LETV_M3U8_ERRCODE)
         {
            _loc1_.code = "Letv.M3U8.Error";
            _loc1_.EXT_LETV_M3U8_ERRCODE = LiveVodConfig.EXT_LETV_M3U8_ERRCODE;
            dispatchEvent(new NetStatusEvent(NETSTREAM_PROTOCOL.const_3,false,false,_loc1_));
         }
         if((this._initData && this._reportDownloadError && false == this.isPause) && (this._bufferEmptyStartTime > 0) && this.getTime() - this._bufferEmptyStartTime > 15 * 1000)
         {
            console.log(this,"isPause = " + this.isPause + ", _bufferEmptyStartTime = " + this._bufferEmptyStartTime + ", " + (this.getTime() - this._bufferEmptyStartTime));
            _loc1_.code = "Stream.Play.Failed";
            _loc1_.p2pErrorCode = "0000";
            _loc1_.allCDNFailed = 1;
            _loc2_ = this._reportDownloadError.method_55();
            if(_loc2_ != "")
            {
               this.sendError(_loc2_);
               trace(this,"whichDownloadError = " + _loc2_);
               console.log(this,"whichDownloadError = " + _loc2_);
               _loc1_.error = _loc2_;
               dispatchEvent(new NetStatusEvent(NETSTREAM_PROTOCOL.const_3,false,false,_loc1_));
            }
            else if(this.getTime() - this._bufferEmptyStartTime > 15 * 1000)
            {
               trace(this,"whichDownloadError = !!! ; " + this.getTime() + " - " + this._bufferEmptyStartTime + " = " + (this.getTime() - this._bufferEmptyStartTime) + " > 15*1000");
               console.log(this,"whichDownloadError = !!! ; " + this.getTime() + " - " + this._bufferEmptyStartTime + " = " + (this.getTime() - this._bufferEmptyStartTime) + " > 15*1000");
            }
            
         }
      }
      
      public function sendError(param1:String) : void
      {
         var _loc2_:Object = null;
         if(this._errorReport)
         {
            _loc2_ = new Object();
            _loc2_.err = param1;
            _loc2_.startPlayTime = Math.round(this._startPlayTime / 1000);
            _loc2_.afterEmptyTime = this._bufferEmptyStartTime - this.getTime() < 0?0:(this._bufferEmptyStartTime - this.getTime()) / 1000;
            _loc2_.playHead = this.time;
            _loc2_.bufferTime = this.bufferTime;
            _loc2_.bufferLength = this.bufferLength;
            this._errorReport.sendError(_loc2_);
         }
      }
      
      protected function _this_NET_STATUS(param1:NetStatusEvent) : void
      {
         var _loc2_:String = param1.info.code;
         console.log(this,"code:" + _loc2_);
         switch(_loc2_)
         {
            case "NetStream.Buffer.Empty":
               this._bufferEmptyStartTime = this.getTime();
               this._isBufferEmpty = true;
               this._isShowSeekIcon = true;
               this.notifyShowIcon();
               this.setBufferTime(true);
               LIVE_TIME.isPause = true;
               console.log(this,"NetStream.Buffer.Empty _bufferEmptyStartTime=",this._bufferEmptyStartTime);
               this.dispatchEventFun({"code":"Stream.Buffer.Empty"});
               if(LiveVodConfig.TYPE != LiveVodConfig.LIVE)
               {
                  this.endHandler();
               }
               break;
            case "NetStream.Buffer.Full":
               this._bufferEmptyStartTime = -1;
               console.log(this,"NetStream.Buffer.Full _bufferEmptyStartTime=",this._bufferEmptyStartTime);
               if(!this.isPause)
               {
                  LIVE_TIME.isPause = false;
               }
               this._isBufferEmpty = false;
               this._isShowSeekIcon = false;
               this.dispatchEventFun({"code":"Stream.Buffer.Full"});
               break;
            case "NetStream.Pause.Notify":
               this.dispatchEventFun({"code":"Stream.Pause.Notify"});
               break;
            case "NetStream.Unpause.Notify":
               this.dispatchEventFun({"code":"Stream.Unpause.Notify"});
               break;
            case "NetStream.Seek.Notify":
            case "NetStream.Seek.Failed":
            case "NetStream.Seek.InvalidTime":
               this._seekOK = true;
               if(!this._mainTimer.running)
               {
                  this._mainTimer.start();
               }
               break;
         }
      }
      
      private function dispatchEventFun(param1:Object) : void
      {
         dispatchEvent(new NetStatusEvent(NETSTREAM_PROTOCOL.const_3,false,false,param1));
      }
      
      private function endHandler() : void
      {
         if((this._seekOK && this._currentBlock && this._currentBlock.id == LiveVodConfig.LAST_TS_ID && this._currentPiece) && (this._currentPiece.id == this._currentBlock.var_6.length - 1) && this.input.bytesAvailable < 188)
         {
            this.notifyPlayStop();
         }
      }
      
      public function set callBack(param1:Object) : void
      {
         Statistic.method_261().var_74[param1.key] = param1;
      }
      
      public function set outMsg(param1:Function) : void
      {
         Statistic.method_261().outMsg = param1;
      }
      
      override public function get time() : Number
      {
         if(LiveVodConfig.TYPE != LiveVodConfig.LIVE)
         {
            if(this._seekTimeRecord + super.time >= LiveVodConfig.TOTAL_DURATION)
            {
               return LiveVodConfig.TOTAL_DURATION;
            }
            return this._seekTimeRecord + super.time;
         }
         if(LiveVodConfig.TYPE == LiveVodConfig.LIVE)
         {
            return this._seekTimeRecord + super.time;
         }
         return super.time;
      }
      
      override public function close() : void
      {
         console.log(this,"close");
         trace(this,"close");
         super.close();
         this.clear();
      }
      
      protected function clear() : void
      {
         trace(this,"clear NetStream  getTimer : " + this.getTime());
         console.log(this,"clear NetStream  getTimer : " + this.getTime());
         CDNRateStrategy.method_261().clear();
         if(this._mainTimer)
         {
            console.log(this,"clear");
            this._mainTimer.stop();
            this._mainTimer.removeEventListener(TimerEvent.TIMER,this.onLoop);
            this._mainTimer = null;
            if(this.hasEventListener(NetStatusEvent.NET_STATUS))
            {
               this.removeEventListener(NetStatusEvent.NET_STATUS,this._this_NET_STATUS);
            }
            if(this._connection)
            {
               if(this._connection.connected)
               {
                  this._connection.close();
               }
               this._connection = null;
            }
            this.lastBlock = null;
            this.isPause = false;
            this.lastPiece = -1;
            this._isShowSeekIcon = false;
            this._adRemainingTime = 0;
            this._isBufferEmpty = true;
            this._seekTimeRecord = 0;
            this._isForcedSeek = false;
            this._isNotifyPlayStop = false;
            this.isChangeKBPSSuccessAfterSeek = false;
            Statistic.method_261().removeEventListener();
            Statistic.method_261().clear();
            if(LiveVodConfig.TYPE == LiveVodConfig.LIVE)
            {
               LIVE_TIME.CLEAR();
            }
            this._dataManager.clear();
            if(this._initData.drm)
            {
               this._initData.drm.close();
               this._initData.drm = null;
            }
            if(this._errorReport)
            {
               this._errorReport.clear();
               this._errorReport = null;
            }
            this._initData = null;
            this._dataManager = null;
            this._reportDownloadError = null;
            this.changingKBPSArray = new Array();
            LiveVodConfig.CLEAR();
            this._isFirstRun = true;
         }
      }
      
      public function onMetaData(param1:Object = null) : void
      {
      }
      
      override public function get client() : Object
      {
         return super.client.client;
      }
      
      override public function set client(param1:Object) : void
      {
         super.client.client = param1;
      }
      
      public function getManager() : Object
      {
         return this._dataManager;
      }
      
      private function getTime() : Number
      {
         return Math.floor(new Date().time);
      }
      
      public function get version() : String
      {
         return LiveVodConfig.method_263();
      }
      
      protected function getSHA1Code(param1:String) : String
      {
         var _loc2_:sha1Encrypt = new sha1Encrypt(true);
         var _loc3_:String = sha1Encrypt.encrypt(param1);
         return _loc3_;
      }
   }
}
