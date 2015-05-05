package cn.pplive.player.view.components
{
   import cn.pplive.player.utils.PrintDebug;
   import cn.pplive.player.view.source.StreamListItem;
   import flash.events.*;
   import flash.net.*;
   import flash.utils.*;
   import cn.pplive.player.common.*;
   import cn.pplive.player.utils.Utils;
   import cn.pplive.player.view.source.CTXQuery;
   import cn.pplive.player.view.events.StreamEvent;
   
   public class VodP2PPlayer extends BasePlayer
   {
      
      private var _timeHack:Number = 0;
      
      private var _speed:Number;
      
      private var _accSpeed:Number;
      
      private var _bufferLength:Number;
      
      private var _bufferTime:Number = 0;
      
      private var _timeCount:int = 0;
      
      private var _bytesLoaded:uint;
      
      private var _bytesTotal:uint;
      
      private var $kernel;
      
      private var $pm = null;
      
      private var $logObject:Object;
      
      private var $kernelCtx:String = "";
      
      private var $failStr:String;
      
      public function VodP2PPlayer()
      {
         super();
      }
      
      override public function setConnect() : void
      {
         PrintDebug.Trace("watch 开始连接点播服务  ===>>>");
         this.addNetStream();
      }
      
      private function addNetStream() : void
      {
         var _loc2_:StreamListItem = null;
         var _loc3_:Vector.<String> = null;
         var _loc1_:Vector.<Object> = new Vector.<Object>();
         for each(_loc2_ in VodPlay.streamVec)
         {
            if(_loc2_)
            {
               _loc3_ = new Vector.<String>();
               _loc3_.push(_loc2_.dt.addr.slice(1));
               _loc1_.push({
                  "host":_loc2_.dt.addr[0],
                  "fileName":_loc2_.rid,
                  "key":Utils.constructKey((VodPlay.serverTime - 60 * 1000) / 1000),
                  "variables":CTXQuery.vctx,
                  "bwType":_loc2_.dt.bwt,
                  "segments":_loc2_.drag.sgm,
                  "backupHosts":_loc3_,
                  "isVip":VIPPrivilege.isVip,
                  "k":_loc2_.dt.key,
                  "ft":_loc2_.ft,
                  "type":"type=" + VodCommon.playType
               });
            }
         }
         PrintDebug.Trace("kernel 初始化 playInfo 信息 ====>>>>");
         if(VodPlay.draghost)
         {
            this.$pm = this.$kernel.createMultiResolutionVodPlayManager(_loc1_,VodPlay.streamIndex,VodPlay.draghost);
         }
         else
         {
            this.$pm = this.$kernel.createMultiResolutionVodPlayManager(_loc1_,VodPlay.streamIndex);
         }
         this.$pm.addEventListener(this.$kernel["getEventTypePLAY_START"](),this.onVodStreamHandler,false,0,true);
         this.$pm.addEventListener(this.$kernel["getEventTypePLAY_FAILED"](),this.onVodStreamHandler,false,0,true);
         this.$pm.addEventListener(this.$kernel["getEventTypePLAY_COMPLETE"](),this.onVodStreamHandler,false,0,true);
         this.$pm.addEventListener(this.$kernel["getEventTypeBUFFER_EMPTY"](),this.onVodStreamHandler,false,0,true);
         this.$pm.addEventListener(this.$kernel["getEventTypeBUFFER_FULL"](),this.onVodStreamHandler,false,0,true);
         this.$pm.addEventListener(this.$kernel["getEventTypeP2P_DAC_LOG"](),this.onVodStreamHandler,false,0,true);
         this.$pm.addEventListener(this.$kernel["getEventTypeDETECT_KERNEL_LOG"](),this.onVodStreamHandler,false,0,true);
         this.$pm.addEventListener(this.$kernel["getEventTypePLAY_PROGRESS"](),this.onVodStreamHandler,false,0,true);
         this.$pm.addEventListener(this.$kernel["getEventTypePLAY_RESULT"](),this.onVodStreamHandler,false,0,true);
         this.setup(VodCommon.isSVavailable);
         PrintDebug.Trace("kernel 通过 play 开始启动  ====>>>>");
         this.startPlay();
      }
      
      override public function setup(param1:Boolean) : void
      {
         super.setup(param1);
         try
         {
            this.$pm.attachVideo(video);
         }
         catch(evt:Error)
         {
         }
      }
      
      private function startPlay() : void
      {
         var _loc2_:* = 0;
         var _loc1_:Number = 0;
         if(VodCommon.cookie.contains("posiInfo"))
         {
            if(VodCommon.cookie.getData("posiInfo")["cid"] == VodParser.cid)
            {
               _loc1_ = VodCommon.cookie.getData("posiInfo")["posi"];
            }
         }
         if(VodCommon.isSkipPrelude)
         {
            try
            {
               _loc2_ = 0;
               while(_loc2_ < VodPlay.contentPoint.length)
               {
                  if(VodPlay.contentPoint[_loc2_]["type"] == "1" && VodPlay.contentPoint[_loc2_]["time"] > 0)
                  {
                     _loc1_ = _loc1_ > VodPlay.contentPoint[_loc2_]["time"]?_loc1_:VodPlay.contentPoint[_loc2_]["time"];
                  }
                  _loc2_++;
               }
            }
            catch(evt:Error)
            {
            }
         }
         this.$pm["play"](_loc1_);
      }
      
      public function get logObject() : Object
      {
         return this.$logObject;
      }
      
      private function onVodStreamHandler(param1:*) : void
      {
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         if(param1.type != this.$kernel["getEventTypePLAY_PROGRESS"]())
         {
            PrintDebug.Trace("侦听到 FlashP2P内核 事件 ===>>> ",param1.type);
         }
         switch(param1.type)
         {
            case this.$kernel["getEventTypePLAY_START"]():
               sendEvent(StreamEvent.STREAM_START);
               break;
            case this.$kernel["getEventTypePLAY_FAILED"]():
               try
               {
                  _loc2_ = param1.interval?param1.interval:0;
                  _loc3_ = param1.httpStatus?param1.httpStatus:0;
                  _loc4_ = param1.error?param1.error:0;
                  this.$failStr = "error=" + _loc4_ + "&interval=" + _loc2_ + "&httpStatus=" + _loc3_;
                  sendEvent("_play_error_");
               }
               catch(evt:Error)
               {
               }
               break;
            case this.$kernel["getEventTypePLAY_COMPLETE"]():
               sendEvent(StreamEvent.STREAM_STOP);
               break;
            case this.$kernel["getEventTypeBUFFER_EMPTY"]():
               VodCommon.isEmpty = param1.info;
               sendEvent(StreamEvent.STREAM_EMPTY);
               break;
            case this.$kernel["getEventTypeBUFFER_FULL"]():
               sendEvent(StreamEvent.STREAM_FULL);
               if($isInitStart)
               {
                  $isInitStart = false;
               }
               if($isInitSeek)
               {
                  $isInitSeek = false;
                  sendEvent(StreamEvent.STREAM_SEEK);
               }
               break;
            case this.$kernel["getEventTypeP2P_DAC_LOG"]():
               this.$logObject = param1.logObject;
               sendEvent(StreamEvent.STREAM_P2PLOG);
               break;
            case this.$kernel["getEventTypeDETECT_KERNEL_LOG"]():
               VodCommon.isPPAP = true;
               break;
            case this.$kernel["getEventTypePLAY_PROGRESS"]():
               $headTime = Math.round(this.$pm.time);
               if(param1.bufferLength)
               {
                  this._speed = param1.downloadSpeed;
                  this._accSpeed = param1.vipAccelerateSpeed;
                  this._bufferLength = param1.bufferLength;
                  this._bufferTime = this.$pm.bufferTime;
               }
               sendEvent(StreamEvent.STREAM_UPDATE);
               break;
            case this.$kernel["getEventTypePLAY_RESULT"]():
               try
               {
                  _loc5_ = param1.m;
                  _loc2_ = param1.interval?param1.interval:0;
                  _loc3_ = param1.httpStatus?param1.httpStatus:0;
                  _loc4_ = param1.error?param1.error:0;
                  this.$failStr = "m=" + _loc5_ + "&url=" + encodeURIComponent(param1.url);
                  if(_loc5_ == 5)
                  {
                     this.$failStr = this.$failStr + ("&error=" + _loc4_ + "&interval=" + _loc2_ + "&httpStatus=" + _loc3_);
                     if($isInitStart)
                     {
                        $isInitStart = false;
                        sendEvent(StreamEvent.STREAM_FAILED);
                     }
                     else
                     {
                        sendEvent("_play_error_");
                     }
                     sendEvent(StreamEvent.STREAM_STOP);
                  }
                  else
                  {
                     sendEvent(StreamEvent.STREAM_RESULT);
                  }
               }
               catch(evt:Error)
               {
               }
               break;
         }
      }
      
      public function get kernelCtx() : String
      {
         return this.$kernelCtx;
      }
      
      public function get failStr() : String
      {
         return this.$failStr;
      }
      
      override public function play() : void
      {
         if(this.$pm)
         {
            this.$pm["resume"]();
            VodCommon.playstate = "playing";
         }
         else
         {
            sendEvent(StreamEvent.STREAM_REPLAY);
         }
         PrintDebug.Trace("点播开始播放");
      }
      
      override public function pause() : void
      {
         try
         {
            VodCommon.playstate = "paused";
            PrintDebug.Trace("点播已经暂停");
            this.$pm["pause"]();
         }
         catch(evt:Error)
         {
         }
      }
      
      override public function stop() : void
      {
         $isInitStart = true;
         $isInitSeek = false;
         this.clear();
         VodCommon.playstate = "stopped";
         PrintDebug.Trace("点播已经结束");
      }
      
      override public function seek() : void
      {
         try
         {
            $isInitSeek = true;
            VodCommon.playstate = "playing";
            PrintDebug.Trace("点播重新 seek 定位  ",VodPlay.posi);
            this.$pm["resume"]();
            this.$pm["seek"](VodPlay.posi);
         }
         catch(evt:Error)
         {
         }
      }
      
      private function clear() : void
      {
         try
         {
            close();
            this.$pm["destroy"]();
            this.$pm.removeEventListener(this.$kernel["getEventTypePLAY_START"](),this.onVodStreamHandler,false,0,true);
            this.$pm.removeEventListener(this.$kernel["getEventTypePLAY_FAILED"](),this.onVodStreamHandler,false,0,true);
            this.$pm.removeEventListener(this.$kernel["getEventTypePLAY_COMPLETE"](),this.onVodStreamHandler,false,0,true);
            this.$pm.removeEventListener(this.$kernel["getEventTypeBUFFER_EMPTY"](),this.onVodStreamHandler,false,0,true);
            this.$pm.removeEventListener(this.$kernel["getEventTypeBUFFER_FULL"](),this.onVodStreamHandler,false,0,true);
            this.$pm.removeEventListener(this.$kernel["getEventTypeP2P_DAC_LOG"](),this.onVodStreamHandler,false,0,true);
            this.$pm.removeEventListener(this.$kernel["getEventTypeDETECT_KERNEL_LOG"](),this.onVodStreamHandler,false,0,true);
            this.$pm.removeEventListener(this.$kernel["getEventTypePLAY_PROGRESS"](),this.onVodStreamHandler,false,0,true);
            this.$pm.removeEventListener(this.$kernel["getEventTypePLAY_RESULT"](),this.onVodStreamHandler,false,0,true);
            this.$pm = null;
         }
         catch(evt:Error)
         {
         }
      }
      
      override public function setVolume(param1:Number) : void
      {
         try
         {
            var param1:Number = param1 / 100;
            PrintDebug.Trace("当前音量设置  ===>>> " + param1);
            this.$pm["volume"] = param1;
         }
         catch(evt:Error)
         {
         }
      }
      
      public function switchFT(param1:int) : void
      {
         try
         {
            VodCommon.playstate = "playing";
            this.$pm["resume"]();
            this.$pm["switchFT"](param1.toString());
         }
         catch(evt:Error)
         {
         }
      }
      
      public function get playIndex() : Number
      {
         try
         {
            return this.$pm["currentSegment"];
         }
         catch(evt:Error)
         {
         }
         return 0;
      }
      
      public function get speed() : Number
      {
         return this._speed;
      }
      
      public function get accSpeed() : Number
      {
         return this._accSpeed;
      }
      
      public function get buffer() : Number
      {
         return this._bufferLength;
      }
      
      public function get bufferTime() : Number
      {
         return this._bufferTime;
      }
      
      public function set kernel(param1:*) : void
      {
         this.$kernel = param1;
      }
      
      public function set advertisementTime(param1:Number) : void
      {
         try
         {
            PrintDebug.Trace("设置内核需要的前帖广告总时间 ===>>>  ",param1);
            this.$pm["availableDelayTime"] = param1;
         }
         catch(evt:Error)
         {
         }
      }
   }
}
