package cn.pplive.player.view.components
{
   import flash.display.Sprite;
   import cn.pplive.player.view.interfaces.IPlayer;
   import cn.pplive.player.utils.FlvParser;
   import flash.net.NetConnection;
   import flash.net.NetStream;
   import flash.utils.Timer;
   import flash.media.SoundTransform;
   import flash.events.Event;
   import cn.pplive.player.common.VodCommon;
   import flash.events.TimerEvent;
   import flash.events.NetStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.AsyncErrorEvent;
   import flash.events.SecurityErrorEvent;
   import cn.pplive.player.utils.NetClient;
   import cn.pplive.player.utils.PrintDebug;
   import cn.pplive.player.utils.hash.Global;
   
   public class BasePlayer extends Sprite implements IPlayer
   {
      
      protected var $flvParser:FlvParser;
      
      protected var $nc:NetConnection;
      
      protected var $ns:NetStream;
      
      protected var $timer:Timer;
      
      protected var $ow:Number = 0;
      
      protected var $oh:Number = 0;
      
      protected var $w:Number = NaN;
      
      protected var $h:Number = NaN;
      
      protected var $stf:SoundTransform;
      
      protected var $headTime:Number = 0;
      
      protected var $video:VideoProxy;
      
      protected var $timeHack:Number = 0;
      
      protected var $filename:String;
      
      protected var _videoUrl:String;
      
      protected var $isInitStart:Boolean = true;
      
      protected var $isInitSeek:Boolean = false;
      
      protected var $server:String;
      
      protected var $inter:uint;
      
      private var clientArr:Array;
      
      public function BasePlayer()
      {
         this.clientArr = [["metadata",false],["cuepoint",false]];
         super();
         this.$stf = new SoundTransform();
         this.mouseChildren = false;
         this.$video = new VideoProxy(this,VodCommon.isSVavailable);
         this.$video.addEventListener("_video_change_",this.onVideoChangeHandler);
         this.$video.addEventListener("_video_status_",this.onVideoChangeHandler);
      }
      
      public function get isInitStart() : Boolean
      {
         return this.$isInitStart;
      }
      
      public function set isInitStart(param1:Boolean) : void
      {
         this.$isInitStart = param1;
      }
      
      public function get isInitSeek() : Boolean
      {
         return this.$isInitSeek;
      }
      
      public function set isInitSeek(param1:Boolean) : void
      {
         this.$isInitSeek = param1;
      }
      
      public function get server() : String
      {
         return this.$server;
      }
      
      protected function onVideoChangeHandler(param1:Event) : void
      {
         switch(param1.type)
         {
            case "_video_change_":
               VodCommon.isSV = this.$video.available;
               this.sendEvent("_video_change_");
               break;
            case "_video_status_":
               VodCommon.hardwareDecoding = this.$video.hardwareDecoding;
               VodCommon.hardwareEncoding = this.$video.hardwareEncoding;
               this.sendEvent("_video_status_");
               break;
         }
      }
      
      public function setup(param1:Boolean) : void
      {
         if(this.$video)
         {
            this.$video.setup(param1);
         }
      }
      
      public function setConnect() : void
      {
         this.$timer = new Timer(1000);
         this.$timer.addEventListener(TimerEvent.TIMER,this.onTimerHandler,false,0,true);
         this.$timer.start();
      }
      
      protected function onTimerHandler(param1:TimerEvent) : void
      {
         throw new Error("TimerEvent.TIMER  事件侦听......");
      }
      
      protected function connect(param1:String, ... rest) : void
      {
         this.closeNC();
         this.$nc = new NetConnection();
         this.$nc.addEventListener(NetStatusEvent.NET_STATUS,this.onNetStatusHandler);
         this.$nc.addEventListener(IOErrorEvent.IO_ERROR,this.onNSErrorHandler);
         this.$nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.onNSErrorHandler);
         this.$nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onNSErrorHandler);
         this.$nc.client = new NetClient(this);
         rest.unshift(param1);
         this.$nc.connect.apply(null,rest);
      }
      
      protected function connectNetStream() : void
      {
         this.closeNS();
         this.$ns = new NetStream(this.$nc);
         this.$ns.addEventListener(NetStatusEvent.NET_STATUS,this.onNetStatusHandler);
         this.$ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.onNSErrorHandler);
         this.$ns.addEventListener(IOErrorEvent.IO_ERROR,this.onNSErrorHandler);
         this.$ns.client = new NetClient(this);
      }
      
      protected function onNSErrorHandler(param1:*) : void
      {
      }
      
      protected function onNetStatusHandler(param1:NetStatusEvent) : void
      {
         throw new Error("NetStatusEvent.NET_STATUS  事件侦听......");
      }
      
      protected function sendEvent(param1:String) : void
      {
         this.dispatchEvent(new Event(param1));
      }
      
      public function onData(param1:Object) : void
      {
         var _loc2_:* = undefined;
         for each(_loc2_ in this.clientArr)
         {
            if(_loc2_[0] == param1["type"] && !_loc2_[1])
            {
               _loc2_[1] = true;
               PrintDebug.Trace("NetClient 回调函数信息  ===>>> ",param1);
               break;
            }
         }
         if((param1["type"] == "metadata") && (param1["width"]) && (param1["height"]))
         {
            VodCommon.isMetadata = true;
            this.originalResize(param1.width,param1.height);
         }
         else if(param1["type"] == "cuepoint")
         {
            this.onCuePoint(param1);
         }
         
      }
      
      public function onCuePoint(param1:Object) : void
      {
      }
      
      public function originalResize(param1:Number, param2:Number) : void
      {
         if(this.$video)
         {
            this.$video.ow = param1;
            this.$video.oh = param2;
            Global.getInstance()["ow"] = this.$video.ow;
            Global.getInstance()["oh"] = this.$video.oh;
            this.resize(stage.displayState == "fullScreen"?stage.stageWidth:VodCommon.playerWidth,stage.displayState == "fullScreen"?stage.stageHeight:VodCommon.playerHeight,Global.getInstance()["ratio"]);
         }
      }
      
      public function resize(param1:Number = NaN, param2:Number = NaN, param3:Number = NaN) : void
      {
         this.$w = isNaN(param1)?stage.stageWidth:param1;
         this.$h = isNaN(param2)?stage.stageHeight:param2;
         if(this.$video)
         {
            this.$video.resize(this.$w,this.$h,param3);
         }
      }
      
      public function setVolume(param1:Number) : void
      {
         if(this.$ns)
         {
            PrintDebug.Trace("当前音量设置  ===>>> " + param1);
            this.$stf.volume = param1 / 100;
            this.$ns.soundTransform = this.$stf;
         }
      }
      
      public function play() : void
      {
         throw new Error("playing ...");
      }
      
      public function pause() : void
      {
         throw new Error("paused ...");
      }
      
      public function stop() : void
      {
         throw new Error("stopped ...");
      }
      
      public function seek() : void
      {
         throw new Error("seeked ...");
      }
      
      protected function closeNC() : void
      {
         if(this.$nc)
         {
            if(this.$nc.connected)
            {
               this.$nc.close();
            }
            this.$nc = null;
         }
      }
      
      protected function closeNS() : void
      {
         if(this.$ns)
         {
            this.$ns.attachCamera(null);
            this.$ns.attachAudio(null);
            this.$ns.close();
            this.$ns = null;
         }
      }
      
      protected function closeTime() : void
      {
         if(this.$timer)
         {
            this.$timer.removeEventListener(TimerEvent.TIMER,this.onTimerHandler);
            this.$timer.stop();
            this.$timer = null;
         }
      }
      
      public function close() : void
      {
         this.closeNC();
         this.closeNS();
         this.closeTime();
         this.$video.clearStream();
      }
      
      public function get headTime() : Number
      {
         return this.$headTime;
      }
      
      public function get video() : *
      {
         return this.$video.v;
      }
      
      public function set currRid(param1:String) : void
      {
         this.$filename = param1;
      }
   }
}
