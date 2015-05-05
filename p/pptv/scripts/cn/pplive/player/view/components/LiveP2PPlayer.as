package cn.pplive.player.view.components
{
   import cn.pplive.player.utils.PrintDebug;
   import cn.pplive.player.utils.FlvParser;
   import cn.pplive.player.utils.NetClient;
   import flash.net.*;
   import flash.events.*;
   import cn.pplive.player.common.*;
   import flash.utils.*;
   import cn.pplive.player.dac.DACReport;
   import cn.pplive.player.view.events.StreamEvent;
   
   public class LiveP2PPlayer extends BasePlayer
   {
      
      private var _timeHack:Number = 0;
      
      private var _speed:Number;
      
      private var _curr:int = 0;
      
      private var _onair:Number = 0;
      
      private var _isOnair:Boolean = false;
      
      private var _inter_onair:uint;
      
      private var _timeCount:int = 0;
      
      private var _bytesLoaded:uint;
      
      private var _bytesTotal:uint;
      
      private var $kernel;
      
      private var $isKernelStart:Boolean = true;
      
      private var $liveStream = null;
      
      private var $kernelCtx:String = "";
      
      private var $host:String = "";
      
      public function LiveP2PPlayer()
      {
         super();
      }
      
      override public function setConnect() : void
      {
         super.setConnect();
         PrintDebug.Trace("watch 开始连接 LIVE2 直播服务  ===>>>");
         $flvParser = new FlvParser();
         $nc = new NetConnection();
         $nc.connect(null);
         $ns = new NetStream($nc);
         $ns.bufferTime = 4;
         $ns.checkPolicyFile = true;
         $ns.addEventListener(NetStatusEvent.NET_STATUS,this.onNetStatusHandler);
         $ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.onNSErrorHandler);
         $ns.addEventListener(IOErrorEvent.IO_ERROR,this.onNSErrorHandler);
         $ns.client = new NetClient(this);
         $ns.play(null);
         $ns.appendBytesAction(NetStreamAppendBytesAction.RESET_BEGIN);
         $ns.appendBytes($flvParser.writeHeader());
         $video.attachNetStream($ns);
         this.addNetStream();
         setVolume(VodParser.sv);
      }
      
      private function addNetStream() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Vector.<String> = null;
         var _loc3_:* = 0;
         var _loc4_:* = undefined;
         if(this.$isKernelStart)
         {
            this.$kernel["start"]();
            _loc1_ = VodPlay.addr.slice(1);
            _loc2_ = new Vector.<String>();
            _loc3_ = 0;
            while(_loc3_ < _loc1_.length)
            {
               _loc2_.push(_loc1_[_loc3_]);
               _loc3_++;
            }
            _loc4_ = this.$kernel["createPlayInfo"](VodPlay.addr[VodPlay.cdnIndex],_loc2_,VodPlay.rid,$filename,"vvid=" + DACReport.vvid + "&type=" + VodCommon.playType + "&o=" + VodParser.os + "&k=" + VodPlay.key,VodPlay.bwt,VodPlay.posi,-1,VodPlay.interval,VodParser.etime);
            PrintDebug.Trace("kernel 初始化 playInfo 信息......");
            this.$liveStream = this.$kernel["createLiveStream"]();
            this.$liveStream.addEventListener(this.$kernel["getEventTypeLIVE_STREAM_DATA"](),this.onLiveStreamHandler,false,0,true);
            this.$liveStream.addEventListener(this.$kernel["getEventTypeLIVE_STREAM_RESETED"](),this.onLiveStreamHandler,false,0,true);
            this.$liveStream.addEventListener(this.$kernel["getEventTypeLIVE_P2P_DAC_LOG"](),this.onLiveStreamHandler,false,0,true);
            this.$liveStream.addEventListener(this.$kernel["getEventTypeLIVE_STREAM_STARTED"](),this.onLiveStreamHandler,false,0,true);
            this.$liveStream.addEventListener(this.$kernel["getEventTypeLIVE_STREAM_SEEKED"](),this.onLiveStreamHandler,false,0,true);
            this.$liveStream.addEventListener(this.$kernel["getEventTypeLIVE_STREAM_FAIL"](),this.onLiveStreamHandler,false,0,true);
            this.$liveStream["start"](_loc4_);
            PrintDebug.Trace("kernel 通过 start 开始启动......");
            this.$isKernelStart = false;
         }
      }
      
      private function onLiveStreamHandler(param1:*) : void
      {
         var _loc2_:Object = null;
         var _loc3_:* = false;
         var _loc4_:* = undefined;
         if(!(param1.type == this.$kernel["getEventTypeLIVE_STREAM_DATA"]()) && !(param1.type == this.$kernel["getEventTypeLIVE_P2P_DAC_LOG"]()))
         {
            PrintDebug.Trace("侦听到 FlashP2P内核 事件 ===>>> ",param1.type);
         }
         switch(param1.type)
         {
            case this.$kernel["getEventTypeLIVE_STREAM_DATA"]():
               $ns.appendBytes($flvParser.getTagTimestamp(param1.data));
               $timer.start();
               this._bytesLoaded = param1.data.length;
               break;
            case this.$kernel["getEventTypeLIVE_STREAM_RESETED"]():
               this.clear();
               this.setConnect();
               break;
            case this.$kernel["getEventTypeLIVE_P2P_DAC_LOG"]():
               _loc2_ = param1.info as Object;
               this.$kernelCtx = "";
               for(_loc4_ in _loc2_)
               {
                  this.$kernelCtx = this.$kernelCtx + ((this.$kernelCtx.length == 0?"":"&") + _loc4_ + "=" + _loc2_[_loc4_]);
               }
               sendEvent("_flashp2p_dac_");
               break;
            case this.$kernel["getEventTypeLIVE_STREAM_STARTED"]():
               this.$host = param1.info["host"];
               PrintDebug.Trace("收到该事件对象 ： ",param1.info);
               if(param1.info["k"] != undefined)
               {
                  VodCommon.mkey = param1.info["k"];
               }
               sendEvent("_stream_started_");
               break;
            case this.$kernel["getEventTypeLIVE_STREAM_SEEKED"]():
               this.$host = param1.info["host"];
               PrintDebug.Trace("收到该事件对象 ： ",param1.info);
               if(param1.info["k"] != undefined)
               {
                  VodCommon.mkey = param1.info["k"];
               }
               sendEvent("_stream_seeked_");
               break;
            case this.$kernel["getEventTypeLIVE_STREAM_FAIL"]():
               _loc3_ = param1.info["hasReceivedData"] as Boolean;
               PrintDebug.Trace("收到该事件对象 ： ",param1.info);
               sendEvent(_loc3_?StreamEvent.STREAM_FAILED:"_play_error_");
               break;
         }
      }
      
      public function get kernelCtx() : String
      {
         return this.$kernelCtx;
      }
      
      public function get host() : String
      {
         return this.$host;
      }
      
      override protected function onTimerHandler(param1:TimerEvent) : void
      {
         $headTime = Math.round($ns.time);
         sendEvent(StreamEvent.STREAM_UPDATE);
         this._timeCount++;
         if(this._timeCount == VodPlay.interval * VodCommon.aheadCount)
         {
            this._speed = (this._bytesLoaded - this._bytesTotal) / this._timeCount;
            this._timeCount = 0;
            this._bytesTotal = this._bytesLoaded;
            if(this._speed > 0)
            {
               PrintDebug.Trace("当前 flashp2p   >>>>>>   平均下载速度：" + this._speed + " KB/s");
               sendEvent(StreamEvent.STREAM_SPEED);
            }
         }
         if(this.$liveStream)
         {
            this.$liveStream["restPlayTime"] = $ns.bufferLength;
         }
         param1.updateAfterEvent();
      }
      
      override protected function onNSErrorHandler(param1:*) : void
      {
         VodCommon.playstate = "paused";
         sendEvent(StreamEvent.STREAM_FAILED);
         if((this.$liveStream) && (this.$isKernelStart))
         {
            this.$liveStream["close"]();
            this.$liveStream = null;
         }
         close();
      }
      
      override protected function onNetStatusHandler(param1:NetStatusEvent) : void
      {
         PrintDebug.Trace("NetStream事件   >>>>>>   " + param1.info.code);
         switch(param1.info.code)
         {
            case "NetStream.Play.StreamNotFound":
            case "NetStream.Play.Failed":
               break;
            case "NetStream.Buffer.Empty":
               sendEvent(StreamEvent.STREAM_EMPTY);
               break;
            case "NetStream.Buffer.Full":
               if($isInitStart)
               {
                  $isInitStart = false;
                  VodCommon.playstate = "playing";
                  sendEvent(StreamEvent.STREAM_START);
               }
               else if($isInitSeek)
               {
                  $isInitSeek = false;
                  VodCommon.playstate = "playing";
                  sendEvent(StreamEvent.STREAM_SEEK);
               }
               
               sendEvent(StreamEvent.STREAM_FULL);
               break;
         }
      }
      
      override public function onCuePoint(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         for(_loc2_ in param1)
         {
            if(_loc2_ == "parameters")
            {
               if(param1["parameters"] != undefined)
               {
                  for(_loc3_ in param1["parameters"])
                  {
                     if(_loc3_ == "start")
                     {
                        if(this._curr < 1)
                        {
                           this._timeHack = param1["parameters"][_loc3_];
                           this._curr++;
                           PrintDebug.Trace("直播 CuePoint 出现  >>>>>  start  <<<<<  " + this._timeHack);
                        }
                        break;
                     }
                     if(_loc3_ == "onair")
                     {
                        this.resetOnair();
                        PrintDebug.Trace("直播 CuePoint 出现  >>>>>  onair  <<<<<  标记");
                        break;
                     }
                  }
                  break;
               }
            }
         }
      }
      
      private function resetOnair() : void
      {
         this._onair = this._onair + VodPlay.interval;
         sendEvent("_onair_show_");
         if(!this._isOnair)
         {
            this._isOnair = true;
            $ns.pause();
            this._inter_onair = setInterval(function():void
            {
               _onair--;
               if(_onair == 0)
               {
                  $ns.resume();
                  _isOnair = false;
                  sendEvent("_onair_hide_");
                  PrintDebug.Trace("onair标记  >>>>>  时间结束  <<<<<");
                  clearInterval(_inter_onair);
               }
            },1000);
         }
      }
      
      override public function play() : void
      {
         if($ns)
         {
            $ns.resume();
            if(this.$liveStream)
            {
               this.$liveStream["resume"]();
            }
            VodCommon.playstate = "playing";
         }
         else
         {
            sendEvent(StreamEvent.STREAM_REPLAY);
         }
         PrintDebug.Trace("直播开始播放");
      }
      
      override public function pause() : void
      {
         if($ns)
         {
            $ns.pause();
            if(this.$liveStream)
            {
               this.$liveStream["pause"]();
            }
            VodCommon.playstate = "paused";
         }
         PrintDebug.Trace("直播已经暂停");
      }
      
      override public function stop() : void
      {
         $isInitStart = true;
         $isInitSeek = false;
         this.$isKernelStart = true;
         this.clear();
         VodCommon.playstate = "stopped";
         PrintDebug.Trace("直播已经停止");
      }
      
      override public function seek() : void
      {
         VodCommon.playstate = "playing";
         $isInitSeek = true;
         this.clear();
         this.setConnect();
         if(this.$liveStream)
         {
            sendEvent(StreamEvent.STREAM_EMPTY);
            $timer.stop();
            PrintDebug.Trace("直播重新 seek 定位  ",VodPlay.posi);
            this.$liveStream["seek"](VodPlay.posi);
         }
      }
      
      private function clear() : void
      {
         if(this._inter_onair)
         {
            clearInterval(this._inter_onair);
         }
         this._curr = 0;
         this._onair = 0;
         this._isOnair = false;
         if((this.$liveStream) && (this.$isKernelStart))
         {
            this.$liveStream["close"]();
            this.$liveStream = null;
         }
         close();
      }
      
      public function get timeHack() : Number
      {
         return this._timeHack;
      }
      
      public function get speed() : Number
      {
         return this._speed;
      }
      
      public function set kernel(param1:*) : void
      {
         this.$kernel = param1;
      }
      
      public function set advertisementTime(param1:Number) : void
      {
         if(this.$liveStream)
         {
            PrintDebug.Trace("设置内核需要的前帖广告总时间 ===>>>  ",param1);
            this.$liveStream["advertisementTime"] = param1;
         }
      }
      
      public function set isKernelStart(param1:Boolean) : void
      {
         this.$isKernelStart = param1;
      }
   }
}
