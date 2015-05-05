package com
{
   import com.gridsum.VideoTracker.VodPlay;
   import flash.media.*;
   import flash.display.*;
   import com.utl.*;
   import flash.ui.*;
   import flash.events.*;
   import flash.text.*;
   import flash.net.*;
   import flash.utils.*;
   import com.gridsum.VideoTracker.GSVideoState;
   import flash.filters.ColorMatrixFilter;
   import p2pstream.loader.SWCLoader;
   import com.gridsum.VideoTracker.VideoTracker;
   import com.gridsum.VideoTracker.VideoInfo;
   import com.gs.NetStreamVodInfoProvider;
   import p2pstream.mango.SSConfig;
   import p2pstream.mango.SSNetStream;
   import p2pstream.events.StreamingEvent;
   import com.gridsum.VideoTracker.VodMetaInfo;
   
   public class playerCoreGs extends Sprite
   {
      
      public var parmObj:parmParse;
      
      public var stream:NetStream = null;
      
      var connection:NetConnection = null;
      
      var soundTrans:SoundTransform;
      
      var theVideo:Video;
      
      public var isPlayComplete:Boolean = false;
      
      public var isStreamConect:Boolean = false;
      
      public var videoMeta:FLVMetaData;
      
      public var isReloadMediaInfo:Boolean = true;
      
      public var isCanHttpSeek:Boolean = false;
      
      public var BuffEndTime:Number = 0;
      
      public var bufStartPos:Number = 0;
      
      public var bufEndPos:Number = 0;
      
      public var adpanel:MovieClip;
      
      public var videoPanel:MovieClip;
      
      public var loadMV:MovieClip;
      
      var CDNTimerTicker:Number = 0;
      
      var CDNTickerTime:Number = 60000;
      
      var DisplayTimerTicker:Number = 0;
      
      var DisplayTimeValue:Number = 1000;
      
      public var canSkipHead:Boolean = false;
      
      var _vodPlay:VodPlay = null;
      
      protected var _state:String = "disconnected";
      
      protected var _isGoingToPlay:Boolean = true;
      
      protected var _eventDispatcher:EventDispatcher = null;
      
      protected var _seekTarget:Number = 0;
      
      protected var _startCheckTimer:Timer = null;
      
      protected var _startTime:Number = 0;
      
      private var _loadStates:Boolean = false;
      
      private var mRateChangeOpt:Boolean = false;
      
      var HeartBeatTimerTicker:Number = 0;
      
      var HeartBeatTimeValue:Number = 60000;
      
      var mShortMovieTip:Boolean = false;
      
      private var mImgotv:imgotv;
      
      var loadStart:Number = 0;
      
      var loadEnd:Number = 0;
      
      var bufferStart:Number = 0;
      
      var bufferFull:Number = 0;
      
      private var _swcLoader:SWCLoader = null;
      
      private var mVodMetaInfo:VodMetaInfo = null;
      
      public function playerCoreGs(param1:parmParse, param2:MovieClip, param3:imgotv)
      {
         this.theVideo = new Video();
         this.videoMeta = new FLVMetaData();
         this.adpanel = new MovieClip();
         this.videoPanel = new MovieClip();
         this.loadMV = new MovieClip();
         super();
         this.videoPanel = param2;
         this.theVideo = this.videoPanel.VideoDisplayCtr;
         this.parmObj = param1;
         this.videoMeta.offsetType = this.parmObj.offsetType;
         this.mImgotv = param3;
         if(stage)
         {
            this.initF(null);
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,this.initF);
         }
      }
      
      function initF(param1:Event) : *
      {
         this.loadP2pSwc();
         helpMethods.addMutiEventListener(stage,this.dealmsg,playerEvents.AD_START,playerEvents.AD_OVER,playerEvents.CONTORL_PAUSE,playerEvents.CONTORL_START,playerEvents.CONTORL_RESTART,playerEvents.CONTORL_SEEKSTART,playerEvents.CONTORL_SIZE,playerEvents.CONTORL_SKIP_HEADEND,playerEvents.CONTORL_SETVOLUME,playerEvents.BITSET_CHANGE,playerEvents.CONTORL_LIGHTSET);
      }
      
      private function BroadcastTipMessage(param1:String, param2:String = "", param3:Number = 3000, param4:Boolean = true, param5:String = "", param6:Boolean = true) : *
      {
         var _loc7_:Object = new Object();
         _loc7_.text = param1;
         _loc7_.hide = param4;
         _loc7_.htmlUrl = param5;
         _loc7_.show = param6;
         _loc7_.skip = param2;
         _loc7_.timeout = param3;
         dispatchEvent(new playerEvents(playerEvents.MAIN_OPT_TIP,_loc7_));
      }
      
      function dealmsg(param1:playerEvents) : *
      {
         var _loc2_:* = 0;
         var _loc3_:String = null;
         var _loc4_:Array = null;
         switch(param1.type)
         {
            case playerEvents.AD_START:
               if(!this.isPlayComplete)
               {
                  this.pauseStream();
               }
               break;
            case playerEvents.AD_OVER:
               _loc2_ = param1.data as int;
               trace("adStates:" + _loc2_);
               consolelog.log("adStates:" + _loc2_);
               if(!this.isPlayComplete)
               {
                  if(_loc2_ == 1)
                  {
                     this.canSkipHead = true;
                     clearInterval(this.HeartBeatTimerTicker);
                     this.HeartBeatTimerTicker = setInterval(this.OnHeartBeatEvent,this.HeartBeatTimeValue);
                  }
                  else if(_loc2_ == 2)
                  {
                     this.resumeStream();
                  }
                  
               }
               break;
            case playerEvents.CONTORL_PAUSE:
               this.pauseStream();
               break;
            case playerEvents.CONTORL_START:
               if(this.isPlayComplete)
               {
                  dispatchEvent(new playerEvents(playerEvents.VIDEO_REPLAY));
                  this.isPlayComplete = false;
                  this.restartStream();
                  clearInterval(this.HeartBeatTimerTicker);
                  this.HeartBeatTimerTicker = setInterval(this.OnHeartBeatEvent,this.HeartBeatTimeValue);
               }
               else
               {
                  dispatchEvent(new playerEvents(playerEvents.STATISTICS_BIGDATA_RESUME));
                  this.resumeStream();
               }
               break;
            case playerEvents.CONTORL_SEEKSTART:
               this.seekTo(param1.data as Number);
               break;
            case playerEvents.CONTORL_SIZE:
               break;
            case playerEvents.CONTORL_SKIP_HEADEND:
               break;
            case playerEvents.CONTORL_SETVOLUME:
               this.setVolume(param1.data as Number);
               break;
            case playerEvents.BITSET_CHANGE:
               this.stopStream();
               this.isPlayComplete = false;
               this.mRateChangeOpt = true;
               break;
            case playerEvents.CONTORL_LIGHTSET:
               _loc3_ = param1.data as String;
               _loc4_ = _loc3_.split("-");
               this.setVideoColor(_loc4_[0],_loc4_[1]);
               break;
         }
      }
      
      function sendMsg(param1:String, param2:Object) : *
      {
         dispatchEvent(new playerEvents(param1,param2,true,false));
      }
      
      public function connectHttpserverP2P(param1:String) : void
      {
         this.videoMeta.mediaURL = param1;
         this.isReloadMediaInfo = true;
         this.p2p();
      }
      
      public function connectHttpLive() : void
      {
      }
      
      public function pauseStream() : *
      {
         if(this.stream != null)
         {
            this.stream.pause();
            if(this._state == GSVideoState.PLAYING || this._state == GSVideoState.BUFFERING)
            {
               this.onStateChange(GSVideoState.PAUSED);
            }
            this._isGoingToPlay = false;
         }
      }
      
      public function PStream() : *
      {
         if(this.stream != null)
         {
            this.stream.pause();
         }
      }
      
      public function resumeStream() : *
      {
         if(this.stream != null)
         {
            this.stream.resume();
            if(this._state == GSVideoState.PAUSED)
            {
               this.onStateChange(GSVideoState.PLAYING);
            }
            this._isGoingToPlay = true;
         }
      }
      
      public function RStream() : *
      {
         if(this.stream != null)
         {
            this.stream.resume();
         }
      }
      
      public function stopStream() : *
      {
         this.isPlayComplete = true;
         this.CDNStopHeart();
         this.isStreamConect = false;
         this.stopdisplayTime();
         this.theVideo.clear();
         this.stream.close();
         helpMethods.callPageJs("getStopEvent");
         this.onStateChange(GSVideoState.DISCONNECTED);
         this._isGoingToPlay = false;
      }
      
      public function restartStream() : *
      {
         this.videoMeta.streamSeekTime = 0;
         this.videoMeta.streamSeekPos = 0;
         this.stream.close();
         this.onStateChange(GSVideoState.PLAYING);
         this.connectHttpserverP2P(this.parmObj.HttpServerUrl);
         clearInterval(this.DisplayTimerTicker);
         var _loc1_:timeInfo = new timeInfo();
         _loc1_.streamtime = this.stream.time;
         _loc1_.totaltime = this.videoMeta.duration;
         _loc1_.loadbyte = this.videoMeta.streamSeekPos + this.stream.bytesLoaded;
         _loc1_.totalbyte = this.videoMeta.streamSeekPos + this.stream.bytesTotal;
         dispatchEvent(new playerEvents(playerEvents.STREAM_TIME,_loc1_,true,false));
         this.canSkipHead = true;
      }
      
      public function setVolume(param1:Number) : *
      {
         if(param1 > 5)
         {
            var param1:Number = 5;
         }
         if(param1 < 0)
         {
            param1 = 0;
         }
         param1 = helpMethods.roundParseInt(param1 * 10000);
         this.soundTrans.volume = param1 / 10000;
         this.stream.soundTransform = this.soundTrans;
      }
      
      public function netConnStatusHandler(param1:NetStatusEvent) : void
      {
         var _loc2_:Object = null;
         switch(param1.info.code)
         {
            case "NetConnection.Connect.Success":
               break;
            case "NetConnection.Connect.Failed":
               this.sendMsg(playerEvents.MSG_SHOW,new msgTipData("连接失败,请刷新页面重试!",true,false));
               this._vodPlay.onError("3");
               this._vodPlay.endLoading(false,null);
               _loc2_ = new Object();
               _loc2_.ecode = "3";
               _loc2_.err = "连接视频流失败";
               dispatchEvent(new playerEvents(playerEvents.STATISTICS_BIGDATA_ERROR,_loc2_));
               break;
            case "NetConnection.Connect.Rejected":
               this.sendMsg(playerEvents.MSG_SHOW,new msgTipData("连接拒绝",true,false));
               break;
            case "NetConnection.Connect.Closed":
               break;
         }
      }
      
      public function netStreamStatusHandler(param1:NetStatusEvent) : void
      {
         var obj:Object = null;
         var event:NetStatusEvent = param1;
         trace("event.info.code:" + event.info.code);
         consolelog.log("event.info.code:" + event.info.code);
         switch(event.info.code)
         {
            case "NetStream.Play.Start":
               stage.dispatchEvent(new playerEvents(playerEvents.BUFF_START,this.stream.time));
               this.sendMsg(playerEvents.MSG_SHOW,new msgTipData("正在缓冲....",true,false));
               dispatchEvent(new playerEvents(playerEvents.LOADING_START));
               this.bufferStart = getTimer();
               this.onStateChange(GSVideoState.BUFFERING);
               this.CDNStart();
               break;
            case "NetStream.Seek.Notify":
               if(this._state != GSVideoState.LOADING)
               {
                  this.onStateChange(this._isGoingToPlay?GSVideoState.BUFFERING:GSVideoState.PAUSED);
               }
               break;
            case "NetStream.Pause.Notify":
               break;
            case "NetStream.Unpause.Notify":
               break;
            case "NetStream.Play.StreamNotFound":
               this.sendMsg(playerEvents.MSG_SHOW,new msgTipData("打开流失败,请观看其他节目或稍后再试",true,false));
               this.errlog("2",this.parmObj.rotueurl + "-----" + this.videoMeta.PlayMediaUrl);
               dispatchEvent(new playerEvents(playerEvents.PLAYCORE_COMPLETE));
               this.isPlayComplete = true;
               this.isStreamConect = false;
               this.stopdisplayTime();
               this.onStateChange(GSVideoState.CONNECTION_ERROR);
               this._isGoingToPlay = false;
               this._vodPlay.onError("4");
               obj = new Object();
               obj.ecode = "4";
               obj.err = "视频流找不到";
               dispatchEvent(new playerEvents(playerEvents.STATISTICS_BIGDATA_ERROR,obj));
               break;
            case "NetStream.Buffer.Full":
               this.sendMsg(playerEvents.MSG_SHOW,new msgTipData("缓冲完成....",false,true));
               stage.dispatchEvent(new playerEvents(playerEvents.BUFF_END));
               dispatchEvent(new playerEvents(playerEvents.LOADING_END));
               this.bufferFull = getTimer();
               this.loadEnd = getTimer();
               obj = new Object();
               obj.et = "";
               obj.td = this.bufferFull - this.bufferStart;
               dispatchEvent(new playerEvents(playerEvents.STATISTICS_BIGDATA_BUFFER,obj));
               if(this._state == GSVideoState.BUFFERING || this._state == GSVideoState.PAUSED)
               {
                  this.onStateChange(this._isGoingToPlay?GSVideoState.PLAYING:GSVideoState.PAUSED);
               }
               break;
            case "NetStream.Buffer.Empty":
               if(!this.isPlayComplete)
               {
                  dispatchEvent(new playerEvents(playerEvents.STATISTICS_BIGDATA_BLOCK));
                  stage.dispatchEvent(new playerEvents(playerEvents.BUFF_START,this.stream.time));
                  stage.dispatchEvent(new playerEvents(playerEvents.LOADING_START));
               }
               if(this._state == GSVideoState.PLAYING && this.stream.bytesLoaded < this.stream.bytesTotal)
               {
                  this.onStateChange(GSVideoState.BUFFERING);
               }
               break;
            case "NetStream.Play.Stop":
               clearInterval(this.HeartBeatTimerTicker);
               dispatchEvent(new playerEvents(playerEvents.STATISTICS_BIGDATA_OVER));
               try
               {
                  if(this.mImgotv.playAd.AdPlugin != null)
                  {
                     dispatchEvent(new playerEvents(playerEvents.AD_BACK_COMPLETE));
                  }
                  else
                  {
                     dispatchEvent(new playerEvents(playerEvents.PLAYCORE_COMPLETE));
                  }
               }
               catch(e:*)
               {
                  dispatchEvent(new playerEvents(playerEvents.PLAYCORE_COMPLETE));
               }
               this.stopStream();
               this.parmObj.shareObj.setLastClipTime(this.parmObj.clipid,0);
               this.onStateChange(GSVideoState.STOPPED);
               break;
         }
      }
      
      public function errlog(param1:String, param2:String) : *
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
      
      public function onXMPData(param1:Object) : void
      {
      }
      
      public function seekTo(param1:Number) : *
      {
         var _loc2_:* = NaN;
         var _loc3_:* = NaN;
         trace("isStreamConect:" + this.isStreamConect);
         trace("isCanHttpSeek:" + this.isCanHttpSeek);
         trace("time:" + param1);
         if((this.isStreamConect) && (this.isCanHttpSeek))
         {
            if(param1 < 0)
            {
               var param1:Number = 0;
            }
            if(param1 > this.videoMeta.duration - 1)
            {
               param1 = this.videoMeta.duration - 1;
            }
            _loc2_ = this.videoMeta.getTheSeekPos(int(param1));
            _loc3_ = int(param1);
            this.resumeStream();
            this.videoMeta.streamSeekTime = _loc3_;
            this.videoMeta.streamSeekPos = _loc2_;
            this.stream.play(this.videoMeta.PlayMediaUrl);
            helpMethods.callPageJs("getSeekEvent",this.videoMeta.streamSeekTime.toString());
            this.onStateChange(GSVideoState.SEEKING);
         }
         dispatchEvent(new playerEvents(playerEvents.PLAYCORE_SEEKEND));
      }
      
      public function TryLookCall() : Boolean
      {
         if(this.parmObj.mMovieInfo.data.user.purview != "200")
         {
            if(this.parmObj.mMovieInfo.data.info.trialtime != null)
            {
               if(Math.floor(this.stream.time) == parseInt(this.parmObj.mMovieInfo.data.info.trialtime))
               {
                  this.parmObj.OpenPayDialog();
                  return true;
               }
               if(Math.floor(this.stream.time) > parseInt(this.parmObj.mMovieInfo.data.info.trialtime))
               {
                  trace("TryLookCall");
                  this.parmObj.shareObj.setLastClipTime(this.parmObj.clipid,0);
                  this.parmObj.OpenPayDialog();
                  return true;
               }
            }
         }
         return false;
      }
      
      public function displayTime() : void
      {
         var _loc3_:* = false;
         var _loc4_:* = NaN;
         var _loc1_:* = false;
         var _loc2_:timeInfo = new timeInfo();
         if(this.stream.time >= 0 && (this.canSkipHead))
         {
            this.canSkipHead = false;
            _loc3_ = false;
            if(this.parmObj.mMovieHead > 0 && (this.parmObj.shareObj.getSkipHeadEnd()))
            {
               if(this.parmObj.shareObj.getLastClipTime(this.parmObj.clipid) > this.parmObj.mMovieHead)
               {
                  if(this.mRateChangeOpt)
                  {
                     this.mRateChangeOpt = false;
                  }
                  else
                  {
                     this.BroadcastTipMessage("接上次观看时间" + helpMethods.formattime(this.parmObj.shareObj.getLastClipTime(this.parmObj.clipid)) + "继续播出");
                  }
                  _loc3_ = true;
                  this.seekTo(this.parmObj.shareObj.getLastClipTime(this.parmObj.clipid));
               }
               else
               {
                  if(this.mRateChangeOpt)
                  {
                     this.mRateChangeOpt = false;
                  }
                  else
                  {
                     this.seekTo(this.parmObj.mMovieHead);
                  }
                  _loc3_ = true;
                  this.BroadcastTipMessage("","已经为您跳过片头，",5000,true);
               }
            }
            else if(this.parmObj.shareObj.getLastClipTime(this.parmObj.clipid) > 20)
            {
               if(this.mRateChangeOpt)
               {
                  this.mRateChangeOpt = false;
               }
               else
               {
                  this.BroadcastTipMessage("接上次观看时间" + helpMethods.formattime(this.parmObj.shareObj.getLastClipTime(this.parmObj.clipid)) + "继续播出");
               }
               _loc3_ = true;
               this.seekTo(this.parmObj.shareObj.getLastClipTime(this.parmObj.clipid));
               if(this.parmObj.mMovieHead > 0 && !this.parmObj.shareObj.getSkipHeadEnd())
               {
                  this.BroadcastTipMessage("","是否跳过片头片尾，",5000,true);
               }
            }
            
            if(!_loc3_)
            {
               dispatchEvent(new playerEvents(playerEvents.FULL_SCREEN_MASK));
               this.resumeStream();
               if(this.parmObj.mMovieHead > 0 && !this.parmObj.shareObj.getSkipHeadEnd())
               {
                  this.BroadcastTipMessage("","是否跳过片头片尾，",5000,true);
               }
            }
         }
         else
         {
            _loc2_.streamtime = this.stream.time;
            if(_loc2_.streamtime > this.videoMeta.duration)
            {
               _loc2_.streamtime = 0;
            }
            _loc2_.totaltime = this.videoMeta.duration;
            _loc2_.loadbyte = this.videoMeta.streamSeekPos + this.stream.bytesLoaded;
            _loc2_.totalbyte = this.videoMeta.streamSeekPos + this.stream.bytesTotal;
            dispatchEvent(new playerEvents(playerEvents.STREAM_TIME,_loc2_,true,false));
            _loc1_ = true;
         }
         if(this.parmObj.mMovieEnd > 0 && (this.parmObj.shareObj.getSkipHeadEnd()))
         {
            if(Math.ceil(_loc2_.streamtime) == Math.ceil(this.parmObj.mMovieEnd))
            {
               this.parmObj.shareObj.setLastClipTime(this.parmObj.clipid,0);
               dispatchEvent(new playerEvents(playerEvents.PLAYCORE_COMPLETE,null,true,false));
               this.isPlayComplete = true;
               this.isStreamConect = false;
               this.stopStream();
               return;
            }
            if(Math.ceil(_loc2_.streamtime) == Math.ceil(this.parmObj.mMovieEnd) - 5)
            {
               this.BroadcastTipMessage("","即将为您跳过片尾，",5000,true);
            }
         }
         if(this.parmObj.mMovieEnd > 0 && !this.parmObj.shareObj.getSkipHeadEnd())
         {
            if(Math.ceil(_loc2_.streamtime) == this.parmObj.mMovieEnd - 5)
            {
               this.BroadcastTipMessage("","是否跳过片头片尾，",5000,true);
            }
         }
         if(this.stream.time > 0)
         {
            if(this.stream.time > 20 && this.stream.time < this.videoMeta.duration - 5)
            {
               this.parmObj.shareObj.setLastClipTime(this.parmObj.clipid,Math.floor(this.stream.time));
            }
            else if(this.stream.time > this.videoMeta.duration)
            {
               this.parmObj.shareObj.setLastClipTime(this.parmObj.clipid,0);
            }
            
            if(this.stream.time > this.videoMeta.duration - 10)
            {
               if(!(this.parmObj.s_title == "") && !(this.parmObj.s_url == ""))
               {
                  this.BroadcastTipMessage(this.parmObj.s_title,"",3000,false,this.parmObj.s_url);
                  this.mShortMovieTip = true;
               }
            }
            else if(this.mShortMovieTip)
            {
               this.mShortMovieTip = false;
               this.BroadcastTipMessage("","",3000,true,"",false);
            }
            
         }
         if(this.stream.time >= 3)
         {
            dispatchEvent(new playerEvents(playerEvents.STATISTICS_COMSCORE_START));
         }
         if(this.stream.time >= 1 && (_loc1_))
         {
            _loc4_ = this.loadEnd - this.loadStart;
            dispatchEvent(new playerEvents(playerEvents.STATISTICS_BIGDATA_PLAY,_loc4_.toString()));
         }
         if(this.TryLookCall())
         {
            clearInterval(this.DisplayTimerTicker);
            return;
         }
      }
      
      public function stopdisplayTime() : void
      {
         this.isReloadMediaInfo = true;
         clearInterval(this.DisplayTimerTicker);
      }
      
      public function onLastSecond(param1:Object) : void
      {
         this.isPlayComplete = true;
      }
      
      public function onCuePoint(param1:Object) : void
      {
      }
      
      public function onPlayStatus(param1:Object) : void
      {
      }
      
      public function onFI(param1:Object) : void
      {
      }
      
      private function securityErrorHandler(param1:SecurityErrorEvent) : void
      {
         trace(param1);
      }
      
      private function asyncErrorHandler(param1:AsyncErrorEvent) : void
      {
         trace(param1);
      }
      
      private function ioErrorHandler(param1:IOErrorEvent) : void
      {
      }
      
      public function setVideoColor(param1:Number, param2:Number) : void
      {
         var _loc3_:ColorMatrix = null;
         var _loc4_:ColorMatrixFilter = null;
         if(param1 == 50 && param2 == 50)
         {
            this.theVideo.filters = [];
         }
         else
         {
            _loc3_ = new ColorMatrix();
            _loc3_.adjustBrightness(param1);
            _loc3_.adjustContrast(param2);
            _loc4_ = new ColorMatrixFilter(_loc3_);
            this.theVideo.filters = [];
            this.theVideo.filters = [_loc4_];
            this.theVideo.visible = true;
         }
      }
      
      private function CDNStart() : *
      {
         var _loc1_:String = null;
         var _loc2_:URLLoader = null;
         if(this.CDNTimerTicker == 0)
         {
            if(!this.parmObj.selfCDN)
            {
               _loc1_ = this.parmObj.getStartUrl();
               if(_loc1_ != "")
               {
                  _loc2_ = new URLLoader();
                  try
                  {
                     _loc2_.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
                     _loc2_.load(new URLRequest(_loc1_));
                  }
                  catch(e:Error)
                  {
                  }
               }
            }
            this.CDNStartHeart();
         }
      }
      
      function CDNStartHeart() : *
      {
         this.CDNTimerTicker = setInterval(this.CDNHeartBeat,this.CDNTickerTime);
      }
      
      function CDNStopHeart() : *
      {
         clearInterval(this.CDNTimerTicker);
         this.CDNTimerTicker = 0;
         this.CDNOffline();
      }
      
      function CDNHeartBeat() : *
      {
         var _loc2_:URLLoader = null;
         helpMethods.callPageJs("getHeartbeatEvent",this.stream.time.toString());
         var _loc1_:String = this.parmObj.getHeartBeatUrl();
         if(_loc1_ != "")
         {
            _loc2_ = new URLLoader();
            try
            {
               _loc2_.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
               _loc2_.load(new URLRequest(_loc1_));
            }
            catch(e:Error)
            {
            }
         }
      }
      
      public function CDNOffline() : *
      {
         var _loc2_:URLLoader = null;
         var _loc1_:String = this.parmObj.getOfflineUrl();
         if(_loc1_ != "")
         {
            _loc2_ = new URLLoader();
            try
            {
               _loc2_.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
               _loc2_.load(new URLRequest(_loc1_));
            }
            catch(e:Error)
            {
            }
         }
      }
      
      public function closepage() : *
      {
         var _loc1_:Encrypt = new Encrypt();
         var _loc2_:String = "http://localhost:33623/testflash/count.aspx?id=" + _loc1_.creatRandomCode(8);
         consolelog.log(_loc2_);
         var _loc3_:URLLoader = new URLLoader();
         try
         {
            _loc3_.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
            _loc3_.load(new URLRequest(_loc2_));
         }
         catch(e:Error)
         {
         }
         consolelog.log("closepage");
      }
      
      public function loadP2pSwc() : *
      {
         try
         {
            this._swcLoader = new SWCLoader();
            this._swcLoader.addEventListener(SWCLoader.COMPLETE,this.onComplete2);
            this._swcLoader.addEventListener(SWCLoader.ERROR,this.onError2);
            this._swcLoader.load("http://www.mg.lightonus.com/2f247330e7de34ef281f9caff5d7060f/ss_vod.swf");
         }
         catch(ex:*)
         {
            stage.dispatchEvent(new playerEvents(playerEvents.P2P_ERROR));
         }
      }
      
      private function onError2(param1:Event) : void
      {
         this._swcLoader.removeEventListener(SWCLoader.COMPLETE,this.onComplete2);
         this._swcLoader.removeEventListener(SWCLoader.ERROR,this.onError2);
         stage.dispatchEvent(new playerEvents(playerEvents.P2P_ERROR));
      }
      
      private function onComplete2(param1:Event) : void
      {
         this._swcLoader.removeEventListener(SWCLoader.COMPLETE,this.onComplete2);
         this._swcLoader.removeEventListener(SWCLoader.ERROR,this.onError2);
         stage.dispatchEvent(new playerEvents(playerEvents.P2P_READY));
      }
      
      private function p2p() : void
      {
         var _loc9_:VideoTracker = null;
         var _loc10_:VideoInfo = null;
         var _loc11_:NetStreamVodInfoProvider = null;
         var _loc1_:String = this.getWWW(this.parmObj.HttpServerUrl);
         var _loc2_:Array = new Array(this.videoMeta.mediaURL);
         var _loc3_:String = this.parmObj.video_id;
         var _loc4_:String = this.parmObj.mRateURI;
         var _loc5_:Number = 128000000;
         var _loc6_:Number = 240;
         var _loc7_:SSConfig = new SSConfig(false,_loc3_,_loc4_,_loc2_,null,null,_loc5_,_loc6_);
         var _loc8_:* = false;
         if(this.stream == null)
         {
            _loc8_ = false;
            this.connection = new NetConnection();
            this.connection.addEventListener(NetStatusEvent.NET_STATUS,this.netConnStatusHandler);
            this.connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
            this.connection.connect(null);
            this.stream = new SSNetStream(this.connection);
            this.stream.addEventListener(NetStatusEvent.NET_STATUS,this.netStreamStatusHandler);
            this.stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.asyncErrorHandler);
            this.stream.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
            this.stream.dispatchEvent(new StreamingEvent(StreamingEvent.SET_CONFIG,false,false,_loc7_));
            this.stream.checkPolicyFile = true;
            this.stream.client = this;
            this.stream.bufferTime = 2;
            this.theVideo.smoothing = true;
            this.soundTrans = this.stream.soundTransform;
            this.theVideo.attachNetStream(this.stream);
            _loc9_ = VideoTracker.getInstance("GVD-200050","GSD-200050");
            _loc10_ = new VideoInfo(this.parmObj.video_id);
            VideoTracker.setSamplingRate(parmParse.VTSAMPLINGRATE);
            _loc10_.extendProperty1 = parmParse.VERSION;
            _loc10_.videoOriginalName = this.parmObj.mediaAlias;
            _loc10_.videoName = this.parmObj.mediaTitle;
            _loc10_.videoUrl = this.videoMeta.mediaURL;
            _loc10_.videoWebChannel = this.parmObj.mediaRootName + "////" + this.parmObj.mediaCollectionName;
            _loc10_.videoTag = "";
            _loc10_.extendProperty2 = _loc1_;
            if(_loc1_.indexOf(".tv") == -1)
            {
               _loc1_ = "imgotv";
            }
            _loc10_.cdn = _loc1_;
            consolelog.log("s:" + _loc1_);
            _loc10_.extendProperty3 = "p2p";
            _loc11_ = new NetStreamVodInfoProvider(this);
            this._vodPlay = _loc9_.newVodPlay(_loc10_,_loc11_);
            this._vodPlay.beginLoading();
         }
         else
         {
            _loc8_ = true;
            this.stream.dispatchEvent(new StreamingEvent(StreamingEvent.SET_CONFIG,false,false,_loc7_));
         }
         this.stream.play(this.videoMeta.mediaURL);
         this.isStreamConect = true;
         this.onStateChange(GSVideoState.LOADING);
         this._isGoingToPlay = true;
         this._loadStates = true;
         if(_loc8_)
         {
            this.pauseStream();
         }
         this.loadStart = getTimer();
      }
      
      public function onMetaData(param1:Object) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:* = undefined;
         if(this.isReloadMediaInfo)
         {
            this.mVodMetaInfo = new VodMetaInfo();
            this.mVodMetaInfo.videoDuration = param1.duration;
            this.mVodMetaInfo.framesPerSecond = param1.framerate;
            this.mVodMetaInfo.isBitrateChangeable = false;
            this.mVodMetaInfo.bitrateKbps = param1.videodatarate;
            this._vodPlay.endLoading(true,this.mVodMetaInfo);
            if(parmParse.INSTATION)
            {
               helpMethods.callPageJs("getPlayEvent");
            }
            else
            {
               this.OutVVStatistics();
            }
            trace("info.width:" + param1.width);
            trace("info.height:" + param1.height);
            this.videoMeta.duration = param1.duration;
            this.videoMeta.videowidth = param1.width;
            this.videoMeta.videoheight = param1.height;
            this.videoMeta.framerate = param1.framerate;
            this.videoMeta.canSeekToEnd = param1.canSeekToEnd;
            this.videoMeta.cuePoints = param1.cuePoints;
            this.videoMeta.audiocodecid = param1.audiocodecid;
            this.videoMeta.audiodatarate = param1.audiodatarate;
            this.videoMeta.audiodelay = param1.audiodelay;
            this.videoMeta.videocodecid = param1.videocodecid;
            this.videoMeta.videodatarate = param1.videodatarate;
            this.videoMeta.videoRatio = param1.width / param1.height;
            try
            {
               for(_loc2_ in param1)
               {
                  if(!(param1[_loc2_] == null) || !(param1[_loc2_] == undefined))
                  {
                     if(_loc2_ == "keyframes")
                     {
                        trace("times:" + param1[_loc2_]["times"].toString());
                        this.videoMeta.mediaInfoObject["timeslist"] = param1[_loc2_]["times"].toString();
                        this.videoMeta.mediaInfoObject["filepositionslist"] = param1[_loc2_]["filepositions"].toString();
                     }
                     else if(_loc2_ == "seekpoints")
                     {
                        for(_loc5_ in param1[_loc2_])
                        {
                           _loc3_ = _loc3_ + (param1[_loc2_][_loc5_]["time"].toString() + ",");
                           _loc4_ = _loc4_ + (param1[_loc2_][_loc5_]["offset"].toString() + ",");
                        }
                        _loc3_ = _loc3_ + "0";
                        _loc4_ = _loc4_ + "0";
                        this.videoMeta.mediaInfoObject["timeslist"] = _loc3_;
                        this.videoMeta.mediaInfoObject["filepositionslist"] = _loc4_;
                     }
                     else
                     {
                        this.videoMeta.mediaInfoObject[_loc2_] = param1[_loc2_];
                     }
                     
                  }
               }
            }
            catch(ex:*)
            {
            }
            if(!(this.videoMeta.mediaInfoObject["timeslist"] == null) && !(this.videoMeta.mediaInfoObject["filepositionslist"] == null))
            {
               this.isCanHttpSeek = true;
            }
            else
            {
               this.isCanHttpSeek = false;
            }
            dispatchEvent(new playerEvents(playerEvents.META_READY,this.videoMeta));
            clearInterval(this.DisplayTimerTicker);
            this.DisplayTimerTicker = setInterval(this.displayTime,this.DisplayTimeValue);
            this.isReloadMediaInfo = false;
            this.displayTime();
         }
         trace("onMetaData............................................................................................................................" + this.videoMeta.videodatarate);
      }
      
      public function getWWW(param1:String) : String
      {
         var _loc3_:RegExp = null;
         var _loc4_:RegExp = null;
         var _loc2_:* = "HNTV";
         try
         {
            _loc3_ = new RegExp("http://([^/]+)/","im");
            _loc4_ = new RegExp("(^|&|\\?)uuid=([^&]*)(&|$)","im");
            _loc2_ = param1.match(_loc3_)[1];
         }
         catch(ex:*)
         {
         }
         return _loc2_;
      }
      
      public function connectHttpserverNoP2p(param1:String) : void
      {
         var _loc3_:VideoTracker = null;
         var _loc4_:VideoInfo = null;
         var _loc5_:NetStreamVodInfoProvider = null;
         trace("connectHttpserverNoP2p");
         if(parmParse.INSTATION)
         {
            helpMethods.callPageJs("getPlayEvent");
         }
         else
         {
            this.OutVVStatistics();
         }
         this.videoMeta.mediaURL = param1;
         this.isReloadMediaInfo = true;
         var _loc2_:String = this.getWWW(this.parmObj.HttpServerUrl);
         if(this.stream == null)
         {
            _loc3_ = VideoTracker.getInstance("GVD-200050","GSD-200050");
            _loc4_ = new VideoInfo(this.parmObj.video_id);
            VideoTracker.setSamplingRate(parmParse.VTSAMPLINGRATE);
            _loc4_.extendProperty1 = parmParse.VERSION;
            _loc4_.videoOriginalName = this.parmObj.mediaAlias;
            _loc4_.videoName = this.parmObj.mediaTitle;
            _loc4_.videoUrl = this.videoMeta.mediaURL;
            _loc4_.videoWebChannel = this.parmObj.mediaRootName + "////" + this.parmObj.mediaCollectionName;
            _loc4_.videoTag = "";
            _loc4_.extendProperty2 = _loc2_;
            if(_loc2_.indexOf(".tv") == -1)
            {
               _loc2_ = "imgotv";
            }
            _loc4_.cdn = _loc2_;
            _loc4_.extendProperty3 = "http";
            _loc5_ = new NetStreamVodInfoProvider(this);
            this._vodPlay = _loc3_.newVodPlay(_loc4_,_loc5_);
            this.connection = new NetConnection();
            this.connection.addEventListener(NetStatusEvent.NET_STATUS,this.netConnStatusHandler);
            this.connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
            this.connection.connect(null);
            this.stream = new NetStream(this.connection);
            this.stream.addEventListener(NetStatusEvent.NET_STATUS,this.netStreamStatusHandler);
            this.stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.asyncErrorHandler);
            this.stream.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
            this.stream.checkPolicyFile = true;
            this.stream.client = this;
            this.stream.bufferTime = 2;
            this.theVideo.smoothing = true;
            this.soundTrans = this.stream.soundTransform;
            this.theVideo.attachNetStream(this.stream);
            this._vodPlay.beginLoading();
         }
         this.stream.play(this.videoMeta.PlayMediaUrl);
         this.isStreamConect = true;
      }
      
      private function OnHeartBeatEvent() : *
      {
         trace("OnHeartBeatEvent");
         dispatchEvent(new playerEvents(playerEvents.STATISTICS_BIGDATA_HEARTBEAT));
      }
      
      private function OutVVStatistics() : *
      {
         var _loc1_:URLLoader = new URLLoader();
         _loc1_.load(new URLRequest("http://click.hunantv.com/click.php?vid=" + this.parmObj.video_id + "&cid=" + this.parmObj.collection_id + "&client=share"));
      }
      
      private function onStateChange(param1:String) : void
      {
         if(this._state != param1)
         {
            this._state = param1;
            this._vodPlay.onStateChanged(param1);
         }
      }
   }
}
