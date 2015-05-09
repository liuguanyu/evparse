package com.letv.plugins.kernel.media.p2p
{
   import com.letv.plugins.kernel.media.BaseMedia;
   import com.letv.plugins.kernel.interfaces.IMedia;
   import com.letv.plugins.kernel.model.Model;
   import com.letv.plugins.kernel.media.PlayMode;
   import com.letv.pluginsAPI.kernel.PlayerError;
   import com.alex.utils.NetClient;
   import com.letv.plugins.kernel.components.VideoUI;
   import flash.net.NetStream;
   import com.letv.plugins.kernel.Kernel;
   import com.letv.pluginsAPI.kernel.PlayerStateEvent;
   import com.letv.pluginsAPI.kernel.PlayerErrorEvent;
   import com.letv.plugins.kernel.media.MediaEvent;
   import com.letv.speed.Speed;
   import com.letv.speed.SpeedEvent;
   import com.letv.plugins.kernel.utils.Sha1EncryptUtil;
   import flash.media.SoundTransform;
   import com.letv.plugins.kernel.controller.gslb.GslbEvent;
   import com.letv.pluginsAPI.api.JsAPI;
   
   public class P2P_M3U8_VodMedia extends BaseMedia
   {
      
      private static var _instance:IMedia;
      
      protected var s:Speed;
      
      private var stream:Object;
      
      private var _metadata:Object;
      
      public function P2P_M3U8_VodMedia()
      {
         super();
      }
      
      public static function getInstance() : IMedia
      {
         if(_instance == null)
         {
            _instance = new P2P_M3U8_VodMedia();
         }
         return _instance;
      }
      
      override public function init(param1:Model, param2:Boolean = false) : void
      {
         if((param2) && !(this.stream == null))
         {
            this.stream["change_KBPS"](param1.cdnlistInfo);
            return;
         }
         if(param1.preloadData.playPreload)
         {
            this.playPreload();
            return;
         }
         var _loc3_:Number = super.initBase(param1,PlayMode.P2P_M3U8_VOD);
         this.seekTo(_loc3_);
         this.setVolume(param1.setting.autoPlay?param1.setting.volume:0);
      }
      
      protected function addStream() : void
      {
         if(model.p2p.p2pM3U8 == null || !(model.p2p.p2pM3U8.create is Function))
         {
            throw new Error("P2PM3U8 Instance Invalid",PlayerError.P2P_PLAY_OTHER_ERROR);
         }
         else
         {
            if(this.stream == null)
            {
               this.stream = model.p2p.p2pM3U8.create();
               this.stream["outMsg"] = this.onOutMsg;
               this.stream["need_CDN_Bytes"] = 1024;
               this.stream["client"] = new NetClient(this);
               VideoUI.attachNetStream(this.stream as NetStream);
               this.stream.addEventListener("streamStatus",this.onStreamStatus);
               this.stream.addEventListener("p2pStatus",this.onP2PStatus);
               this.stream.addEventListener("p2pAllOver",this.onP2PError);
            }
            return;
         }
      }
      
      protected function removeStream() : void
      {
         if(this.stream != null)
         {
            this.stream["close"]();
            VideoUI.attachNetStream(null);
            this.stream.removeEventListener("streamStatus",this.onStreamStatus);
            this.stream.removeEventListener("p2pStatus",this.onP2PStatus);
            this.stream.removeEventListener("p2pAllOver",this.onP2PError);
            try
            {
               this.stream["client"] = null;
            }
            catch(e:Error)
            {
            }
            try
            {
               this.stream["outMsg"] = null;
            }
            catch(e:Error)
            {
            }
            this.stream = null;
         }
      }
      
      protected function onStreamStatus(param1:Object = null) : void
      {
         Kernel.sendLog(this + " StreamStatus " + param1["info"]["code"]);
         switch(param1.info.code)
         {
            case "Stream.Seek.ShowIcon":
               sendState(PlayerStateEvent.PLAYER_LOADING);
               break;
            case "Stream.Buffer.Empty":
               this.onBufferEmpty();
               break;
            case "Stream.Buffer.Full":
               this.onBufferFull();
               break;
            case "Stream.Play.Stop":
               this.watchStop();
               break;
            case "Stream.Play.Failed":
               Kernel.sendLog(this + " StreamStatus " + param1["info"]["code"] + " allCDNFailed: " + param1.info.allCDNFailed);
               if(param1.info.allCDNFailed == 1)
               {
                  if(param1.info.error == "ts")
                  {
                     this.onP2PError(PlayerError.P2P_PLAY_ERROR);
                  }
                  else
                  {
                     this.onP2PError(null,PlayerError.P2P_M3U8_ERROR);
                  }
               }
               break;
            case "Stream.preLoad.Complete":
               Kernel.sendLog(this + "-----------------P2PreloadComplete");
               model.preloadData.p2pPreloadComplete = true;
               break;
         }
      }
      
      protected function onP2PStatus(param1:Object = null) : void
      {
         switch(param1.info.code)
         {
            case "P2P.LoadG3URL.Failed":
            case "P2P.LoadG3URL.Success":
               Kernel.sendLog(this + " P2PStatus " + param1["info"]["code"]);
               break;
            case "need_CDN_Bytes_Success":
               Kernel.sendLog(this + " P2PStatus " + param1["info"]["code"]);
               sendCLoadStat("0",param1["info"]["utime"],param1["info"]["retry"]);
               break;
            case "P2P.ChangeKBPS.Success":
               sendState(PlayerStateEvent.SWAP_COMPLETE,{
                  "definition":param1.info.kbps,
                  "info":this._metadata,
                  "kbps":model.gslb.gslblist[model.setting.definition].br
               });
               break;
            case "P2P.ChangeKBPS.Failed":
               sendState(PlayerStateEvent.SWAP_DEFINITION_FAIL);
               break;
         }
      }
      
      protected function onP2PError(param1:Object = null, param2:String = "489") : void
      {
         Kernel.sendLog(this + " onP2PError" + " errorcode=" + param2);
         sendP2PPlayStat(param2);
         if(metadata == null)
         {
            sendCLoadStat(param2);
         }
         var _loc3_:PlayerErrorEvent = new PlayerErrorEvent(PlayerErrorEvent.P2P_ERROR);
         _loc3_.errorCode = param2;
         model.dispatchEvent(_loc3_);
         this.swapPlayMode();
      }
      
      public function onOutMsg(param1:Object, param2:String = "") : void
      {
         var _loc3_:* = NaN;
         switch(param2)
         {
            case "testSpeedBufferTime":
               Kernel.sendLog(this + " OutMsg" + param2 + " " + param1);
               if((model.gslb.cantest) && this.s == null)
               {
                  _loc3_ = Number(param1);
                  if(_loc3_ >= model.config.p2ptestBuffer)
                  {
                     this.stream["pauseP2P"]();
                     this.setSpeed(true);
                  }
               }
               break;
            case "testSpeedBufferNotFull":
               Kernel.sendLog(this + " OutMsg" + param2 + " " + param1);
               this.setSpeed(false);
               this.stream["resumeP2P"]();
               break;
            case "speed":
               speed = {"speed":param1};
               return;
            case "version":
               model.versions.p2pVersion = param1 + "";
               Kernel.sendLog(this + " OutMsg" + param2 + " " + param1);
               break;
         }
         sendState(PlayerStateEvent.EXCUTE_P2P,{
            "type":param2,
            "value":param1
         });
      }
      
      override protected function onLoop() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = NaN;
         var _loc3_:* = NaN;
         super.onLoop();
         if(!model.preloadData.preloadFail && !model.preloadData.preload && !model.preloadData.preloadComplete && (this.checkPreload()))
         {
            this.onPreloading();
         }
         if(!model.play.limitData.limitPlay)
         {
            return;
         }
         if(!stopPlay)
         {
            _loc1_ = Math.round(this.getVideoTime());
            _loc2_ = model.play.limitData.stopTime;
            _loc3_ = _loc2_ > duration?duration:_loc2_;
            if(_loc1_ >= _loc3_)
            {
               this.playStop();
            }
         }
      }
      
      override protected function onDelay() : void
      {
         Kernel.sendLog(this + " Timeout Error");
         sendP2PPlayStat(PlayerError.P2P_TIMEOUT_ERROR);
         var _loc1_:PlayerErrorEvent = new PlayerErrorEvent(PlayerErrorEvent.P2P_ERROR);
         _loc1_.errorCode = PlayerError.P2P_TIMEOUT_ERROR;
         model.dispatchEvent(_loc1_);
         this.swapPlayMode();
      }
      
      override protected function get gslbTimerFlag() : Boolean
      {
         return true;
      }
      
      protected function onBufferFull() : void
      {
         setDelay(false);
         canPlay = true;
         if(!startPlay)
         {
            sendState(PlayerStateEvent.PLAYER_START_READY);
         }
         if(model.setting.autoPlay)
         {
            super.onFull();
            setLoop(true);
            if(!startPlay)
            {
               this.watchStart();
            }
         }
         else
         {
            this.pauseVideo();
         }
      }
      
      protected function onBufferEmpty() : void
      {
         Kernel.sendLog(this + " onBufferEmpty");
         setDelay(true);
         super.onEmpty();
      }
      
      override protected function watchStart() : void
      {
         super.watchStart();
         this.setVolume(model.setting.volume);
         this.getNextInfo();
      }
      
      override protected function watchStop(param1:Boolean = true) : void
      {
         var clear:Boolean = param1;
         try
         {
            this.stream["pause"]();
         }
         catch(e:Error)
         {
         }
         if(model.preloadData.playPreload)
         {
            return;
         }
         if((model.play.autoReplay) || (model.config.autoReplay))
         {
            super.watchStopAutoReplay();
            autoReplay();
         }
         else
         {
            if(!model.preloadData.preloadComplete)
            {
               this.clearPreloadData();
            }
            super.watchStop();
         }
      }
      
      private function playStop() : void
      {
         try
         {
            this.stream["pause"]();
         }
         catch(e:Error)
         {
         }
         model.dispatchEvent(new PlayerStateEvent(PlayerStateEvent.CUT_PLAY_COMPLETE,model.play.limitData.stopName));
         super.watchStop(false);
         this.closeVideo();
      }
      
      protected function swapPlayMode() : void
      {
         try
         {
            this.stream["sendOutTimeError"]();
         }
         catch(e:Error)
         {
         }
         model.setting.playerErrorTime = this.getVideoTime();
         this.closeVideo(false);
         Kernel.sendLog(this + " SwapPlayMode CDN " + model.setting.playerErrorTime);
         model.dispatchEvent(new MediaEvent(MediaEvent.MODE_CHANGE,false));
      }
      
      protected function setSpeed(param1:Boolean) : void
      {
         if(param1)
         {
            if(this.s == null)
            {
               this.s = new Speed();
            }
            model.gslb.cantest = false;
            this.s.addEventListener(SpeedEvent.GSLB_FAILED,this.onSpeedOver,false,0,true);
            this.s.addEventListener(SpeedEvent.COMPLETE,this.onSpeedOver,false,0,true);
            this.s.start("2",true);
         }
         else
         {
            if(this.s)
            {
               this.s.destroy();
               this.s.removeEventListener(SpeedEvent.GSLB_FAILED,this.onSpeedOver);
               this.s.removeEventListener(SpeedEvent.COMPLETE,this.onSpeedOver);
            }
            this.s = null;
         }
      }
      
      protected function onSpeedOver(param1:*) : void
      {
         this.setSpeed(false);
         if(!stopPlay)
         {
            this.stream["resumeP2P"]();
         }
      }
      
      public function onData(param1:Object) : void
      {
         if(param1.type == "metadata")
         {
            this._metadata = param1;
            super.onMeta(param1);
         }
      }
      
      override public function seekTo(param1:Number, param2:Boolean = false) : void
      {
         var limitTime:Number = NaN;
         var stopTime:Number = NaN;
         var sha1:Sha1EncryptUtil = null;
         var gslburl:String = null;
         var groupID:Object = null;
         var obj:Object = null;
         var position:Number = param1;
         var forRetry:Boolean = param2;
         try
         {
            if((startPlay) && (model.play.limitData.limitPlay))
            {
               limitTime = model.play.limitData.stopTime;
               stopTime = limitTime > duration?duration:limitTime;
               if(position >= stopTime)
               {
                  this.playStop();
                  return;
               }
            }
            super.seekTo(position,forRetry);
            this.addStream();
            if(startPlay)
            {
               setDelay(true);
               this.stream["seek"](position);
               this.stream["resume"]();
            }
            else
            {
               sha1 = new Sha1EncryptUtil(true);
               gslburl = model.gslb.gslblist[model.setting.definition].df;
               groupID = Sha1EncryptUtil.encrypt(gslburl);
               obj = {
                  "cdnInfo":model.cdnlistInfo,
                  "gslbURL":model.gslb.currentGslbUrl,
                  "groupName":groupID,
                  "startTime":position,
                  "geo":model.gslb.geo,
                  "testSpeed":(model.gslb.cantest?model.config.p2ptestInterval:-1),
                  "adRemainingTime":model.ad.adRemainingTime,
                  "canCheck":model.config.cc,
                  "encrypt":M3U8Encryption.getInstance(),
                  "endtime":model.vrs.tailTime
               };
               if(model.setting.autoPlay)
               {
                  setDelay(true);
               }
               this.stream["play"](obj);
            }
            this.setVolume(model.setting.volume);
            if((model.preloadData.preload) && !this.checkPreload())
            {
               this.clearPreloadData();
            }
         }
         catch(e:Error)
         {
            Kernel.sendLog(this + " SeekTo Exception " + e.message,"error");
            onP2PError();
         }
      }
      
      override public function pauseVideo() : void
      {
         super.pauseVideo();
         try
         {
            this.stream["pause"]();
         }
         catch(e:Error)
         {
         }
      }
      
      override public function resumeVideo() : void
      {
         try
         {
            this.stream["resume"]();
         }
         catch(e:Error)
         {
         }
         super.resumeVideo();
      }
      
      override public function replayVideo() : void
      {
         super.replayVideo();
         if((model.setting.jump) && model.vrs.headTime > 0)
         {
            this.seekTo(model.vrs.headTime);
         }
         else
         {
            this.seekTo(0);
         }
      }
      
      override public function closeVideo(param1:Boolean = true) : void
      {
         super.closeVideo(param1);
         this.clearPreloadData();
         this.removeStream();
         this.setSpeed(false);
         sendState(PlayerStateEvent.EXCUTE_P2P,{"type":"gc"});
      }
      
      override public function jumpVideo(param1:int = 0) : void
      {
         var _loc2_:* = NaN;
         var _loc3_:* = NaN;
         super.jumpVideo(param1);
         if(!model.play.limitData.limitPlay)
         {
            return;
         }
         if(duration > 0)
         {
            _loc2_ = model.play.limitData.stopTime;
            _loc3_ = _loc2_ > duration?duration:_loc2_;
            if(param1 == 0 && model.vrs.headTime >= _loc3_)
            {
               this.playStop();
            }
            else if(param1 == 1 && model.vrs.tailTime >= _loc3_)
            {
               this.playStop();
            }
            
         }
      }
      
      override public function setVolume(param1:Number) : void
      {
         var value:Number = param1;
         try
         {
            this.stream["soundTransform"] = new SoundTransform(value);
         }
         catch(e:Error)
         {
         }
      }
      
      override public function getVideoTime() : Number
      {
         try
         {
            return this.stream["time"];
         }
         catch(e:Error)
         {
         }
         return 0;
      }
      
      override public function getFPS() : int
      {
         try
         {
            return this.stream["currentFPS"];
         }
         catch(e:Error)
         {
         }
         return 0;
      }
      
      override public function getLoadPercent() : Number
      {
         try
         {
            return this.stream["bytesLoaded"] / this.stream["bytesTotal"];
         }
         catch(e:Error)
         {
         }
         return 0;
      }
      
      override public function getBufferPercent() : Number
      {
         if(duration > 0 && (this.stream))
         {
            return this.stream["bufferLength"] / this.stream["bufferTime"];
         }
         return 0;
      }
      
      override public function get p2pInfo() : Object
      {
         try
         {
            return this.stream["getStatisticData"]();
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      override protected function onLoadLoopGslbSuccess(param1:GslbEvent) : Boolean
      {
         var event:GslbEvent = param1;
         try
         {
            if((super.onLoadLoopGslbSuccess(event)) && !(this.stream == null))
            {
               if(this.stream.hasOwnProperty("set_CDN_INFO"))
               {
                  this.stream["set_CDN_INFO"](model.cdnlistInfo);
               }
               else if(this.stream.hasOwnProperty("set_CDN_URL"))
               {
                  this.stream["set_CDN_URL"](model.cdnlist);
               }
               
            }
         }
         catch(e:Error)
         {
         }
         return true;
      }
      
      override public function get getDownloadSpeed() : int
      {
         try
         {
            return int(this.stream["getDownloadSpeed"]());
         }
         catch(e:Error)
         {
         }
         return 0;
      }
      
      override public function get streamValid() : Boolean
      {
         return !(this.stream == null);
      }
      
      override public function clearPreloadData() : void
      {
         if(model.preloadData.preload)
         {
            trace("停止预加载");
            try
            {
               this.stream["stopLoadNextVideo"]();
            }
            catch(e:Error)
            {
            }
            sendState(PlayerStateEvent.STOP_PRELOAD);
         }
         model.preloadData.gc();
      }
      
      private function checkPreload() : Boolean
      {
         if(this.getVideoTime() > 0)
         {
            if(this.getLoadPercent() >= 0.99)
            {
               model.preloadData.stopTime = duration;
               return true;
            }
            if((canJumpTail) && this.getVideoTime() < model.vrs.tailTime && this.getLoadPercent() * duration >= model.vrs.tailTime)
            {
               model.preloadData.stopTime = model.vrs.tailTime;
               return true;
            }
         }
         return false;
      }
      
      private function onPreloading(param1:Object = null) : void
      {
         model.preloadData.p2pPreloadComplete = false;
         model.preloadData.adPreloadComplete = false;
         sendState(PlayerStateEvent.START_PRELOAD);
         Kernel.sendLog("开始预加载");
      }
      
      override public function startPreload() : void
      {
         var time:Number = NaN;
         var sha1:Sha1EncryptUtil = null;
         var gslburl:String = null;
         var groupID:Object = null;
         var nextVideoInfo:Object = null;
         try
         {
            time = 0;
            if(canJumpHead)
            {
               time = model.preloadData.nextHeadTime;
            }
            sha1 = new Sha1EncryptUtil(true);
            gslburl = model.preloadData.preloadData.playData.list[model.preloadData.currentDefinition].df;
            groupID = Sha1EncryptUtil.encrypt(gslburl);
            nextVideoInfo = {
               "cdnInfo":model.preloadData.cdnlistInfo,
               "gslbURL":model.preloadData.currentGslbUrl,
               "groupName":groupID,
               "startTime":time,
               "geo":model.preloadData.gslbPreloadData.data.geo,
               "testSpeed":(model.preloadData.gslbPreloadData.data.cantest?model.config.p2ptestInterval:-1),
               "adRemainingTime":model.ad.adRemainingTime,
               "canCheck":model.config.cc,
               "encrypt":M3U8Encryption.getInstance(),
               "endtime":model.preloadData.nextTailTime
            };
            this.stream["setNextVideoInfo"](nextVideoInfo);
         }
         catch(e:Error)
         {
         }
      }
      
      private function playPreload() : void
      {
         if(model.preloadData.currentDefinition != model.setting.definition)
         {
            Kernel.sendLog("清晰度不符" + model.preloadData.currentDefinition + "-------" + model.setting.definition);
            this.clearPreloadData();
            this.watchStop();
            return;
         }
         super.initBase(model,PlayMode.P2P_M3U8_VOD);
         var _loc1_:String = model.gslb.gslblist[model.setting.definition].df;
         var _loc2_:Number = canJumpHead?model.vrs.headTime:0;
         var _loc3_:Sha1EncryptUtil = new Sha1EncryptUtil(true);
         var _loc4_:Object = Sha1EncryptUtil.encrypt(_loc1_);
         var _loc5_:Object = {
            "cdnInfo":model.cdnlistInfo,
            "gslbURL":model.gslb.currentGslbUrl,
            "groupName":_loc4_,
            "startTime":_loc2_,
            "geo":model.gslb.geo,
            "testSpeed":(model.gslb.cantest?model.config.p2ptestInterval:-1),
            "adRemainingTime":model.ad.adRemainingTime,
            "canCheck":model.config.cc,
            "encrypt":M3U8Encryption.getInstance(),
            "endtime":model.vrs.tailTime
         };
         Kernel.sendLog("开始播放预加载");
         this.stream["play"](_loc5_);
         if(model.setting.autoPlay)
         {
            setDelay(true);
         }
         model.preloadData.gc();
      }
      
      private function getNextInfo() : void
      {
         var callback:Object = null;
         try
         {
            callback = model.sendInterface(JsAPI.PLAYER_GET_NEXT_VID);
            switch(callback["status"])
            {
               case "recommend":
                  model.setting.nextvid = null;
                  break;
               case "pageContinue":
                  model.setting.nextvid = callback.nextvid;
                  break;
            }
         }
         catch(e:Error)
         {
         }
      }
   }
}
