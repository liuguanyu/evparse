package com.letv.plugins.kernel.media
{
   import com.letv.plugins.kernel.interfaces.IMedia;
   import flash.system.System;
   import com.letv.plugins.kernel.model.Model;
   import com.letv.pluginsAPI.kernel.PlayerStateEvent;
   import com.letv.plugins.kernel.Kernel;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import com.letv.pluginsAPI.kernel.Config;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import com.letv.pluginsAPI.kernel.PlayerErrorEvent;
   import flash.utils.getTimer;
   import com.letv.pluginsAPI.stat.Stat;
   import com.letv.pluginsAPI.api.JsAPI;
   import com.letv.plugins.kernel.components.VideoUI;
   import flash.net.NetStream;
   import com.letv.plugins.kernel.utils.DataUtil;
   import com.letv.plugins.kernel.controller.gslb.GslbEvent;
   import com.letv.plugins.kernel.controller.gslb.Gslb;
   import com.letv.plugins.kernel.statistics.LetvStatistics;
   
   public class BaseMedia extends Object implements IMedia
   {
      
      public static const LOOP_PLAY:uint = 500;
      
      public static const LOOP_MEMORY:uint = 12000;
      
      public static const MAX_MEMORY:uint = 629145600;
      
      private var timer:int;
      
      private var gslb:Gslb;
      
      protected var statistics:LetvStatistics;
      
      protected var model:Model;
      
      protected var realDuration:Number = 0;
      
      protected var metadata:Object;
      
      protected var startPlay:Boolean;
      
      protected var playing:Boolean;
      
      protected var stopPlay:Boolean;
      
      protected var canPlay:Boolean;
      
      protected var retry:int;
      
      protected var retryMax:int;
      
      protected var retryOnce:Boolean;
      
      protected var utimeRecord:int;
      
      protected var canShowEndTip:Boolean;
      
      protected var tvShowEndTip:Boolean;
      
      protected var loginShowEndTip:Boolean;
      
      protected var cutShowEndTip:Boolean = true;
      
      protected var _cloadInter:int;
      
      protected var _inter:int;
      
      protected var _memoryInter:int;
      
      protected var _timeout:int;
      
      public function BaseMedia()
      {
         this.statistics = LetvStatistics.getInstance();
         super();
      }
      
      public static function get memory() : Number
      {
         try
         {
            return System["privateMemory"];
         }
         catch(e:Error)
         {
         }
         return -1;
      }
      
      public function init(param1:Model, param2:Boolean = false) : void
      {
      }
      
      protected function initBase(param1:Model, param2:String) : Number
      {
         this.model = param1;
         this.retry = 0;
         this.canPlay = false;
         this.startPlay = false;
         this.stopPlay = false;
         this.retryOnce = false;
         this.metadata = null;
         this.model.playMode = param2;
         this.model.setting.playerErrorCode = null;
         this.retryMax = param1.gslb.urlist.length;
         param1.setting.isBp = false;
         param1.setting.playStartType = "normal";
         this.sendState(PlayerStateEvent.EXCUTE_P2P,{"type":"gc"});
         this.sendState(PlayerStateEvent.PLAYER_MEDIA_MODE,{"mode":param2});
         Kernel.sendLog(this + " " + param2 + " CanTest: " + param1.gslb.cantest);
         var _loc3_:Number = 0;
         if(param1.play.limitData.limitPlay)
         {
            if(this.canJumpHead)
            {
               if(param1.setting.playStartType != "over")
               {
                  param1.setting.playStartType = "jump";
               }
               return param1.vrs.headTime;
            }
            return _loc3_;
         }
         if(param1.setting.playerErrorTime > 0)
         {
            Kernel.sendLog(this + " Play Video ByErrorRecordTime " + param1.setting.playerErrorTime);
            param1.setting.playStartType = "error";
            _loc3_ = param1.setting.playerErrorTime;
            param1.setting.playerErrorTime = -1;
            return _loc3_;
         }
         if(param1.config.flashvars.start > 0)
         {
            if(param1.config.flashvars.start >= param1.setting.duration)
            {
               _loc3_ = param1.setting.duration - 10;
            }
            else
            {
               _loc3_ = param1.config.flashvars.start;
            }
            Kernel.sendLog(this + " Play Video ByPowerTime " + param1.config.flashvars.start);
            param1.setting.playStartType = "power";
            param1.config.flashvars.start = 0;
            return _loc3_;
         }
         if(param1.setting.setDefinitionRecordTime > 0)
         {
            Kernel.sendLog(this + " Play Video ByDefinitionRecordTime " + param1.setting.setDefinitionRecordTime);
            param1.setting.playStartType = "definition";
            _loc3_ = param1.setting.setDefinitionRecordTime;
            param1.setting.setDefinitionRecordTime = 0;
            return _loc3_;
         }
         var _loc4_:Boolean = this.canJumpHead;
         if(param1.flashCookie.recordTime >= 0)
         {
            if((_loc4_) && param1.vrs.headTime <= param1.flashCookie.recordTime)
            {
               Kernel.sendLog(this + " Play Video ByRecordTime " + param1.flashCookie.recordTime);
               param1.setting.isBp = true;
               param1.setting.playStartType = "record";
               return param1.flashCookie.recordTime;
            }
         }
         else if(param1.flashCookie.recordTime < 0)
         {
            Kernel.sendLog(this + " Watch This Film Over Yet");
            param1.setting.playStartType = "over";
         }
         
         if(_loc4_)
         {
            Kernel.sendLog(this + " Play Video ByJumpHeadTime " + param1.vrs.headTime);
            if(param1.setting.playStartType != "over")
            {
               param1.setting.playStartType = "jump";
            }
            return param1.vrs.headTime;
         }
         return _loc3_;
      }
      
      protected function setLoop(param1:Boolean) : void
      {
         clearInterval(this._inter);
         clearInterval(this._memoryInter);
         if(param1)
         {
            this._inter = setInterval(this.onLoop,LOOP_PLAY);
            this._memoryInter = setInterval(this.onMemoryLoop,LOOP_MEMORY);
         }
      }
      
      protected function onLoop() : void
      {
         var _loc1_:* = 0;
         if(!this.stopPlay)
         {
            _loc1_ = Math.round(this.getVideoTime());
            if((this.tvShowEndTip) && (this.model.play.limitData.firstlook))
            {
               this.tvShowEndTip = false;
               this.sendState(PlayerStateEvent.FIRSTLOOK_STOPPING,{"info":"firstlookStopping"});
            }
            if((this.loginShowEndTip) && (this.model.play.limitData.login) && _loc1_ + 30 >= this.model.play.limitData.loginTime)
            {
               this.loginShowEndTip = false;
               this.sendState(PlayerStateEvent.LOGINLOOK_STOPPING,{"info":"loginlookStopping"});
            }
            if((this.cutShowEndTip) && (this.model.play.limitData.cutPC))
            {
               this.cutShowEndTip = false;
               this.sendState(PlayerStateEvent.FIRSTLOOK_STOPPING,{
                  "info":"cutStopping",
                  "cuttime":this.model.play.limitData.cutoffPCTime
               });
            }
            if(this.canJumpTail)
            {
               if(_loc1_ == this.model.vrs.tailTime)
               {
                  this.jumpVideo(1);
                  return;
               }
               if((this.canShowEndTip) && _loc1_ < this.model.vrs.tailTime && _loc1_ >= this.model.vrs.tailTime - Config.JUMP_TAIL_INFO)
               {
                  this.sendEnding("jump");
               }
            }
            if((this.model.play.autoReplay) || (this.model.config.autoReplay))
            {
               return;
            }
            if((this.canShowEndTip) && (this.canShowRecommendVideo) && _loc1_ >= this.duration - Config.JUMP_TAIL_INFO)
            {
               this.sendEnding("recommend");
            }
         }
      }
      
      protected function onMemoryLoop() : void
      {
      }
      
      protected function get bufferTimeout() : uint
      {
         return this.model.config.bufferTimeout;
      }
      
      protected function setDelay(param1:Boolean) : void
      {
         clearTimeout(this._timeout);
         if(param1)
         {
            this._timeout = setTimeout(this.onDelay,this.bufferTimeout);
         }
      }
      
      protected function onDelay() : void
      {
      }
      
      protected function sendError(param1:String, param2:Number = 0, param3:int = -1, param4:Number = -1, param5:Boolean = true) : void
      {
         var _loc6_:PlayerErrorEvent = null;
         this.model.setting.playerErrorCode = param1;
         if(param2 > 0)
         {
            this.model.setting.playerErrorTime = param2;
         }
         Kernel.sendLog(this + " sendError Time: " + param2 + " ErrorCode:" + param1 + " AutoPlay: " + this.model.setting.autoPlay);
         if(this.model.setting.autoPlay)
         {
            if((param5) && this.metadata == null)
            {
               this.sendCLoadStat(param1,param4 >= 0?param4:this.utime,param3 >= 0?param3:this.retry);
            }
            _loc6_ = new PlayerErrorEvent(PlayerErrorEvent.PLAYER_ERROR);
            _loc6_.errorCode = param1;
            this.model.dispatchEvent(_loc6_);
         }
      }
      
      protected function sendState(param1:String, param2:Object = null) : void
      {
         var _loc3_:PlayerStateEvent = new PlayerStateEvent(param1);
         _loc3_.dataProvider = param2;
         this.model.playerState = [param1,param2];
      }
      
      protected function onMeta(param1:Object) : void
      {
         this.model.gslb.hadControl = true;
         this.metadata = param1;
         if((this.metadata.hasOwnProperty("duration")) && Number(this.metadata.duration) > 0)
         {
            this.realDuration = this.metadata.duration;
         }
         else
         {
            this.realDuration = 0;
         }
         this.model.setMetaData(this.metadata);
         Kernel.sendLog(this + " onMeta Duration:" + this.duration + " Size:" + this.filesize);
      }
      
      protected function onEmpty(param1:* = null) : void
      {
         this.statistics.params.emptytime = getTimer();
         this.statistics.sendStat(Stat.OP_PAUSE_PT,Stat.LOG_PLAY_EMPTY);
         this.sendState(PlayerStateEvent.PLAYER_EMPTY);
      }
      
      protected function onFull(param1:* = null) : void
      {
         this.statistics.sendStat(Stat.OP_RESUME_PT);
         this.statistics.sendStat(Stat.LOG_PLAY,Stat.LOG_PLAY_EMPTY);
         this.sendState(PlayerStateEvent.PLAYER_FULL);
         this.retry = 0;
         this.retryOnce = false;
         this.model.gslb.hadControl = true;
      }
      
      protected function watchStart() : void
      {
         this.playing = true;
         this.startPlay = true;
         this.model.gslb.hadControl = true;
         this.model.setting.autoPlay = true;
         Kernel.sendLog(this + " watchStart Dt: " + this.duration + " Meta: " + this.metadata);
         this.statistics.params.emptytime = 0;
         this.statistics.sendStat(Stat.OP_RESUME_PT);
         this.statistics.sendStat(Stat.OP_RESUME_HEAD);
         this.sendState(PlayerStateEvent.PLAYER_START,{
            "errorCode":this.model.setting.playerErrorCode,
            "retry":this.retry,
            "utime":1,
            "metadata":this.metadata
         });
         this.setLoop(true);
         this.setDelay(false);
         this.setLoopGslbTimer(true);
      }
      
      protected function watchStop(param1:Boolean = true) : void
      {
         this.playing = false;
         this.stopPlay = true;
         this.setLoop(false);
         this.setDelay(false);
         this.setLoopGslbTimer(false);
         this.statistics.params.emptytime = 0;
         this.statistics.sendStat(Stat.OP_PAUSE_PT);
         this.statistics.sendStat(Stat.OP_PAUSE_HEAD);
         this.statistics.sendStat(Stat.LOG_IRS,Stat.IRS_END);
         this.statistics.sendStat(Stat.LOG_PLAY,Stat.LOG_PLAY_HEAD);
         this.statistics.sendStat(Stat.LOG_PLAY,Stat.LOG_PLAY_END);
         Kernel.sendLog(this + " watchStop clear " + param1);
         if(!param1)
         {
            return;
         }
         this.sendState(PlayerStateEvent.PLAYER_STOP);
      }
      
      protected function watchStopAutoReplay() : void
      {
         this.stopPlay = true;
         this.setLoop(false);
         this.setDelay(false);
         this.setLoopGslbTimer(false);
         this.statistics.params.emptytime = 0;
         this.statistics.sendStat(Stat.OP_PAUSE_PT);
         this.statistics.sendStat(Stat.OP_PAUSE_HEAD);
         this.statistics.sendStat(Stat.LOG_IRS,Stat.IRS_END);
         this.statistics.sendStat(Stat.LOG_PLAY,Stat.LOG_PLAY_HEAD);
         this.statistics.sendStat(Stat.LOG_PLAY,Stat.LOG_PLAY_END);
         Kernel.sendLog(this + " watchStopAutoReplay");
      }
      
      protected function autoReplay() : void
      {
         Kernel.sendLog(this + " autoReplay");
         this.replayVideo();
      }
      
      public function get getDownloadSpeed() : int
      {
         return 0;
      }
      
      public function replayVideo() : void
      {
         this.playing = true;
         this.stopPlay = false;
         this.model.setting.playStartType = null;
         this.statistics.params.emptytime = 0;
         this.sendState(PlayerStateEvent.PLAYER_REPLAY);
      }
      
      public function toggleVideo() : void
      {
         if(!this.startPlay)
         {
            return;
         }
         if(this.playing)
         {
            this.pauseVideo();
         }
         else
         {
            this.resumeVideo();
         }
      }
      
      public function pauseVideo() : void
      {
         this.playing = false;
         this.setDelay(false);
         if(this.model.setting.autoPlay)
         {
            this.statistics.params.emptytime = 0;
            this.statistics.sendStat(Stat.OP_PAUSE_PT);
            this.statistics.sendStat(Stat.LOG_IRS,Stat.IRS_PAUSE);
            this.model.sendInterface(JsAPI.PLAYER_VIDEO_PAUSE,{"id":this.model.setting.vid});
         }
      }
      
      public function resumeVideo() : void
      {
         this.playing = true;
         if(this.model.setting.autoPlay)
         {
            this.statistics.params.emptytime = 0;
            this.statistics.sendStat(Stat.OP_RESUME_PT);
            this.statistics.sendStat(Stat.LOG_IRS,Stat.IRS_PLAY);
            this.model.sendInterface(JsAPI.PLAYER_VIDEO_RESUME,{"id":this.model.setting.vid});
         }
         if(!this.model.setting.autoPlay)
         {
            this.model.setting.autoPlay = true;
            if(this.model.setting.playerErrorCode != null)
            {
               this.closeVideo();
               this.sendError(this.model.setting.playerErrorCode,this.model.setting.playerErrorTime,-1,-1,false);
               return;
            }
            Kernel.sendLog(this + " resumeVideo autoplay: " + this.model.setting.autoPlay);
            if(this.canPlay)
            {
               this.watchStart();
            }
            else
            {
               this.setDelay(true);
            }
         }
      }
      
      public function closeVideo(param1:Boolean = true) : void
      {
         this.startPlay = false;
         this.stopPlay = false;
         this.setLoop(false);
         this.setDelay(false);
         this.setCLoad(false);
         this.setLoopGslbTimer(false);
         if(param1)
         {
            VideoUI.clear();
         }
      }
      
      public function jumpVideo(param1:int = 0) : void
      {
         if(this.duration > 0)
         {
            if(param1 == 0)
            {
               if((this.model.setting.jump) && this.model.vrs.headTime > 0 && this.getVideoTime() < this.model.vrs.headTime)
               {
                  Kernel.sendLog(this + " jumpVideo Head " + this.model.vrs.headTime);
                  this.seekTo(this.model.vrs.headTime);
               }
            }
            else if(param1 == 1)
            {
               Kernel.sendLog(this + " jumpVideo Tail " + this.model.vrs.tailTime);
               this.watchStop();
            }
            
         }
      }
      
      public function seekTo(param1:Number, param2:Boolean = false) : void
      {
         var position:Number = param1;
         var forRetry:Boolean = param2;
         this.statistics.params.emptytime = 0;
         this.statistics.sendStat(Stat.OP_PAUSE_PT);
         if(this.stopPlay)
         {
            this.setLoopGslbTimer(true);
         }
         try
         {
            this.model.gslb.gone = this.model.gslb.urlist[this.retry][this.model.setting.definition].gone;
         }
         catch(e:Error)
         {
         }
         this.playing = true;
         this.stopPlay = false;
         if(!forRetry)
         {
            this.retryOnce = false;
            this.canShowEndTip = true;
            this.tvShowEndTip = true;
            this.loginShowEndTip = true;
            this.cutShowEndTip = true;
         }
         this.utimeRecord = getTimer();
      }
      
      public function setVolume(param1:Number) : void
      {
      }
      
      protected function get utime() : Number
      {
         return getTimer() - this.utimeRecord;
      }
      
      protected function set speed(param1:Object) : void
      {
         if((param1.speed) && (!isNaN(param1.speed)) && param1.speed > 0)
         {
            this.model.cookieControl.recordSpeed(param1.speed);
         }
      }
      
      protected function setCLoad(param1:Boolean, param2:NetStream = null) : void
      {
         clearInterval(this._cloadInter);
         if((param1) && !(param2 == null))
         {
            Kernel.sendLog(this + " setCLoad");
            this._cloadInter = setInterval(this.onCLoad,50,param2);
            this.onCLoad(param2);
         }
      }
      
      protected function onCLoad(param1:Object) : void
      {
         if(param1 is NetStream && param1.bytesLoaded >= 1024 || param1 >= 1024)
         {
            Kernel.sendLog(this + " onCLoad");
            this.setCLoad(false);
            this.sendCLoadStat("0",this.utime,this.retry);
         }
      }
      
      protected function sendCLoadStat(param1:Object, param2:Number = 0, param3:int = 0) : void
      {
         this.statistics.sendStat(Stat.LOG_PLAY,Stat.LOG_PLAY_CLOAD,{
            "error":param1,
            "utime":param2,
            "retry":param3
         });
      }
      
      protected function sendP2PPlayStat(param1:Object, param2:Number = 0, param3:int = 0, param4:Object = null) : void
      {
         if(param4 == null)
         {
            var param4:Object = {};
         }
         param4["geo"] = this.model.gslb.geo;
         param4["desc"] = this.model.gslb.desc;
         param4["userip"] = this.model.gslb.remote;
         param4["serverinfo"] = DataUtil.cdnString(this.model.cdnlist);
         this.statistics.sendStat(Stat.LOG_PLAY,Stat.LOG_PLAY_PLAY,{
            "error":param1,
            "utime":param2,
            "retry":param3,
            "py":param4
         });
      }
      
      protected function sendPlayStat(param1:Object, param2:Number, param3:int, param4:Object = null) : void
      {
         if(param4 == null)
         {
            var param4:Object = {};
         }
         param4["geo"] = this.model.gslb.geo;
         param4["desc"] = this.model.gslb.desc;
         param4["userip"] = this.model.gslb.remote;
         param4["serverinfo"] = DataUtil.cdnString(this.model.cdnlist);
         this.statistics.sendStat(Stat.LOG_PLAY,Stat.LOG_PLAY_PLAY,{
            "error":param1,
            "utime":param2,
            "retry":param3,
            "py":param4
         });
      }
      
      protected function sendEnding(param1:Object) : void
      {
         this.canShowEndTip = false;
         this.model.cookieControl.setRecordLoop(false,true);
         this.model.cookieControl.setRecordVcsLoop(false,true);
         this.sendState(PlayerStateEvent.PLAYER_STOPPING,param1);
      }
      
      public function getPlayState() : Object
      {
         return {
            "playing":this.playing,
            "finish":this.stopPlay,
            "start":this.startPlay,
            "canPlay":this.canPlay
         };
      }
      
      public function getVideoTime() : Number
      {
         return 0;
      }
      
      public function getFPS() : int
      {
         return 24;
      }
      
      public function getLoadPercent() : Number
      {
         return 0;
      }
      
      public function getBufferPercent() : Number
      {
         return 0;
      }
      
      public function getSessionDuration() : Number
      {
         return int(getTimer() * 0.001);
      }
      
      public function get bufferDataSize() : Number
      {
         return 0;
      }
      
      public function get bufferTime() : Number
      {
         return this.model.setting.aiBufferTime;
      }
      
      public function get currentUrl() : String
      {
         try
         {
            return this.model.gslb.urlist[this.retry][this.model.setting.definition].location;
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      public function get currentNode() : String
      {
         try
         {
            return this.model.gslb.urlist[this.retry][this.model.setting.definition].gone;
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      public function get duration() : Number
      {
         try
         {
            return this.model.setting.duration;
         }
         catch(e:Error)
         {
         }
         return 0;
      }
      
      public function get filesize() : int
      {
         try
         {
            return this.model.metadata.filesize;
         }
         catch(e:Error)
         {
         }
         return 0;
      }
      
      public function get preTime() : Number
      {
         return 420;
      }
      
      public function get leaveEndTime() : Number
      {
         return 60;
      }
      
      protected function get canJumpHead() : Boolean
      {
         if(!this.model.config.jump)
         {
            return false;
         }
         if(!this.model.setting.jump)
         {
            return false;
         }
         if(this.model.vrs.headTime <= 0)
         {
            return false;
         }
         if(this.model.vrs.headTime >= this.model.setting.duration)
         {
            return false;
         }
         return true;
      }
      
      protected function get canJumpTail() : Boolean
      {
         if(!this.model.config.jump)
         {
            return false;
         }
         if(!this.model.setting.jump)
         {
            return false;
         }
         if(this.model.vrs.tailTime <= 0)
         {
            return false;
         }
         return true;
      }
      
      protected function get canShowRecommendVideo() : Boolean
      {
         if(!this.model.config.continuration)
         {
            return true;
         }
         if(!this.model.setting.continuePlay)
         {
            return true;
         }
         if(this.model.setting.nextvid == null)
         {
            return true;
         }
         return false;
      }
      
      public function get p2pInfo() : Object
      {
         return null;
      }
      
      public function get sectionInfo() : String
      {
         return "1 / 1";
      }
      
      protected function setLoopGslbTimer(param1:Boolean) : void
      {
         if(!this.gslbTimerFlag)
         {
            return;
         }
         clearTimeout(this.timer);
         if((param1) && this.model.gslb.gslbp2pRate > 0 && (this.startPlay) && !this.stopPlay)
         {
            this.timer = setTimeout(this.onLoopGslbTimer,this.model.gslb.gslbp2pRate * 1000);
         }
         else
         {
            this.loadLoopGslbGC();
         }
      }
      
      private function loadLoopGslbGC() : void
      {
         if(this.gslb != null)
         {
            this.gslb.removeEventListener(GslbEvent.LOAD_FAILED,this.onLoadLoopGslbFailed);
            this.gslb.removeEventListener(GslbEvent.LOAD_SUCCESS,this.onLoadLoopGslbSuccess);
            this.gslb.destroy();
            this.gslb = null;
         }
      }
      
      private function onLoopGslbTimer() : void
      {
         this.loadLoopGslbGC();
         this.gslb = new Gslb(this.model);
         this.gslb.addEventListener(GslbEvent.LOAD_FAILED,this.onLoadLoopGslbFailed);
         this.gslb.addEventListener(GslbEvent.LOAD_SUCCESS,this.onLoadLoopGslbSuccess);
         this.gslb.load(this.model.setting.definition,this.model.gslb.gslblist,true);
      }
      
      private function onLoadLoopGslbFailed(param1:GslbEvent) : void
      {
         this.loadLoopGslbGC();
         this.setLoopGslbTimer(true);
      }
      
      protected function onLoadLoopGslbSuccess(param1:GslbEvent) : Boolean
      {
         var result:Array = null;
         var event:GslbEvent = param1;
         this.loadLoopGslbGC();
         this.setLoopGslbTimer(true);
         try
         {
            result = event.dataProvider as Array;
            this.model.gslb.urlist = result.list;
         }
         catch(e:Error)
         {
         }
         return (this.startPlay) && !this.stopPlay;
      }
      
      protected function get gslbTimerFlag() : Boolean
      {
         return false;
      }
      
      public function get streamValid() : Boolean
      {
         return false;
      }
      
      public function startPreload() : void
      {
      }
      
      public function clearPreloadData() : void
      {
      }
   }
}
