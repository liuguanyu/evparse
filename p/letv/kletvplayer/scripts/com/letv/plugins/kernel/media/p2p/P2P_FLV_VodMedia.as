package com.letv.plugins.kernel.media.p2p
{
   import com.letv.plugins.kernel.media.BaseMedia;
   import com.letv.plugins.kernel.interfaces.IMedia;
   import com.letv.plugins.kernel.model.Model;
   import com.letv.plugins.kernel.media.PlayMode;
   import com.letv.pluginsAPI.kernel.PlayerStateEvent;
   import com.letv.pluginsAPI.kernel.PlayerError;
   import com.alex.utils.NetClient;
   import com.letv.plugins.kernel.components.VideoUI;
   import flash.net.NetStream;
   import com.letv.plugins.kernel.Kernel;
   import com.letv.pluginsAPI.kernel.PlayerErrorEvent;
   import com.letv.plugins.kernel.media.MediaEvent;
   import com.letv.speed.Speed;
   import com.letv.speed.SpeedEvent;
   import com.letv.plugins.kernel.utils.Sha1EncryptUtil;
   import flash.media.SoundTransform;
   import com.letv.plugins.kernel.controller.gslb.GslbEvent;
   
   public class P2P_FLV_VodMedia extends BaseMedia
   {
      
      private static var _instance:IMedia;
      
      protected var s:Speed;
      
      protected var stream:Object;
      
      public function P2P_FLV_VodMedia()
      {
         super();
      }
      
      public static function getInstance() : IMedia
      {
         if(_instance == null)
         {
            _instance = new P2P_FLV_VodMedia();
         }
         return _instance;
      }
      
      override public function init(param1:Model, param2:Boolean = false) : void
      {
         var _loc3_:Number = super.initBase(param1,PlayMode.P2P_VOD);
         this.seekTo(_loc3_);
         this.setVolume(param1.setting.autoPlay?param1.setting.volume:0);
         if(param2)
         {
            sendState(PlayerStateEvent.SWAP_COMPLETE,{
               "last":true,
               "definition":param1.getDefinition()
            });
         }
      }
      
      protected function addStream() : void
      {
         if(model.p2p.p2pFLV == null || !(model.p2p.p2pFLV.create is Function))
         {
            throw new Error("P2PFLV Instance Invalid",PlayerError.P2P_PLAY_OTHER_ERROR);
         }
         else
         {
            if(this.stream == null)
            {
               this.stream = model.p2p.p2pFLV.create();
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
         Kernel.sendLog(this + " onStreamStatus " + param1.info.code);
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
               Kernel.sendLog(this + " OutMsg " + param2 + " " + param1);
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
         setLoop(false);
         model.dispatchEvent(new PlayerStateEvent(PlayerStateEvent.CUT_PLAY_COMPLETE,model.play.limitData.stopName));
         super.watchStop(false);
         this.closeVideo();
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
         if((model.play.autoReplay) || (model.config.autoReplay))
         {
            super.watchStopAutoReplay();
            autoReplay();
         }
         else
         {
            super.watchStop();
         }
      }
      
      protected function swapPlayMode() : void
      {
         model.setting.playerErrorTime = this.getVideoTime();
         this.closeVideo(false);
         Kernel.sendLog(this + " SwapPlayMode " + model.setting.playerErrorTime);
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
            this.s.addEventListener(SpeedEvent.GSLB_FAILED,this.onSpeedOver);
            this.s.addEventListener(SpeedEvent.COMPLETE,this.onSpeedOver);
            this.s.start("2",true);
         }
         else if(this.s != null)
         {
            this.s.destroy();
            this.s.removeEventListener(SpeedEvent.GSLB_FAILED,this.onSpeedOver);
            this.s.removeEventListener(SpeedEvent.COMPLETE,this.onSpeedOver);
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
            if(!startPlay)
            {
               super.onMeta(param1);
            }
         }
      }
      
      override public function seekTo(param1:Number, param2:Boolean = false) : void
      {
         var limitTime:Number = NaN;
         var stopTime:Number = NaN;
         var sha1:Sha1EncryptUtil = null;
         var gslbDF:String = null;
         var groupID:Object = null;
         var checkurl:Object = null;
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
               gslbDF = model.gslb.gslblist[model.setting.definition].df;
               groupID = Sha1EncryptUtil.encrypt(gslbDF);
               checkurl = "http://webchecksum.letv.com/" + gslbDF.replace(".flv",".xml");
               obj = {
                  "cdnInfo":model.cdnlistInfo,
                  "flvURL":model.cdnlist,
                  "gslbURL":model.gslb.currentGslbUrl,
                  "groupName":groupID,
                  "checkURL":checkurl,
                  "startTime":position,
                  "geo":model.gslb.geo,
                  "testSpeed":(model.gslb.cantest?model.config.p2ptestInterval:-1),
                  "adRemainingTime":model.ad.adRemainingTime
               };
               if(model.setting.autoPlay)
               {
                  setDelay(true);
               }
               this.stream["play"](obj);
            }
            this.setVolume(model.setting.volume);
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
         if(duration > 0 && !(this.stream == null))
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
   }
}
