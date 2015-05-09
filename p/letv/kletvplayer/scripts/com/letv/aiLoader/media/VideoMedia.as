package com.letv.aiLoader.media
{
   import flash.net.URLStream;
   import flash.net.NetConnection;
   import flash.net.NetStream;
   import flash.media.Video;
   import com.letv.aiLoader.tools.BufferCheck;
   import flash.utils.ByteArray;
   import flash.geom.Rectangle;
   import flash.media.SoundTransform;
   import flash.utils.getTimer;
   import flash.errors.IOError;
   import com.letv.aiLoader.errors.AIError;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.Event;
   import flash.net.URLRequest;
   import flash.events.NetStatusEvent;
   import com.letv.aiLoader.tools.NetClient;
   import com.letv.aiLoader.events.AILoaderEvent;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import com.letv.aiLoader.events.BufferCheckEvent;
   import com.letv.aiLoader.type.PlayerVersion;
   
   public class VideoMedia extends BaseMedia
   {
      
      private var _useDataMode:Boolean;
      
      private var _hadReume:Boolean;
      
      private var _playing:Boolean;
      
      private var _loader:URLStream;
      
      private var _conn:NetConnection;
      
      private var _ns:NetStream;
      
      private var _video:Video;
      
      private var _check:BufferCheck;
      
      private var _totalBytes:ByteArray;
      
      private var _loopIner:int;
      
      public function VideoMedia(param1:int = 0, param2:Object = null)
      {
         super(param1,param2);
         if((data.hasOwnProperty("dm")) && String(data.dm) == "1" && (PlayerVersion.supportP2P))
         {
            this._useDataMode = true;
         }
         else
         {
            this._useDataMode = false;
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.gc();
         this._video = null;
      }
      
      public function get useDataMode() : Boolean
      {
         return this._useDataMode;
      }
      
      public function get netstream() : NetStream
      {
         return this._ns;
      }
      
      override public function get content() : Object
      {
         return this._video;
      }
      
      override public function set visible(param1:Boolean) : void
      {
         var value:Boolean = param1;
         try
         {
            this._video.visible = value;
         }
         catch(e:Error)
         {
         }
      }
      
      override public function get time() : Number
      {
         try
         {
            return this._ns.time;
         }
         catch(e:Error)
         {
         }
         return 0;
      }
      
      override public function get metadata() : Object
      {
         return _metadata;
      }
      
      override public function get rect() : Rectangle
      {
         try
         {
            return new Rectangle(0,0,this.metadata.width,this.metadata.height);
         }
         catch(e:Error)
         {
         }
         return new Rectangle(0,0,400,300);
      }
      
      override public function pause() : Boolean
      {
         this._playing = false;
         if(this._ns)
         {
            if(this.useDataMode)
            {
               if(hadUsed)
               {
                  this._ns.pause();
               }
            }
            else
            {
               this._ns.pause();
            }
            return true;
         }
         return false;
      }
      
      override public function resume() : Boolean
      {
         this._playing = true;
         try
         {
            if(this.useDataMode)
            {
               if(!this._hadReume)
               {
                  this._hadReume = true;
                  this.setGetLoop(true);
               }
            }
            this._ns.resume();
            return true;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function replay() : void
      {
         if(this.useDataMode)
         {
            return;
         }
         try
         {
            this._ns.seek(0);
         }
         catch(e:Error)
         {
         }
      }
      
      override public function mute(param1:Number = 1) : void
      {
         var value:Number = param1;
         try
         {
            this._ns.soundTransform = new SoundTransform(value);
         }
         catch(e:Error)
         {
         }
      }
      
      public function set volume(param1:Number) : void
      {
         var value:Number = param1;
         try
         {
            this._ns.soundTransform = new SoundTransform(value);
         }
         catch(e:Error)
         {
         }
      }
      
      public function close() : void
      {
         try
         {
            this._ns.close();
         }
         catch(e:Error)
         {
         }
         try
         {
            this._video.clear();
         }
         catch(e:Error)
         {
         }
      }
      
      public function play(param1:String) : void
      {
         start(param1);
      }
      
      public function onData(param1:Object) : void
      {
         var info:Object = param1;
         if(info.type == "metadata")
         {
            setDelay(false);
            if(!hadUsed)
            {
               if(!info.hasOwnProperty("duration"))
               {
                  info.duration = 15;
               }
               _metadata = info;
               this._video.width = _metadata.width;
               this._video.height = _metadata.height;
               _hadUsed = true;
               this.visible = true;
               if((this.useDataMode) && !this._playing)
               {
                  try
                  {
                     this._ns.pause();
                  }
                  catch(e:Error)
                  {
                  }
               }
               this.sendState("metadata");
            }
         }
      }
      
      override public function get speed() : int
      {
         if(this._ns == null)
         {
            return 0;
         }
         if(_stopTime > 0)
         {
            if(this._ns.bytesLoaded > 0)
            {
               return int(this._ns.bytesLoaded / (_stopTime - _startTime));
            }
            return int(_size / (_stopTime - _startTime));
         }
         if(this._ns.bytesLoaded > 0)
         {
            return int(this._ns.bytesLoaded / (getTimer() - _startTime));
         }
         return int(_size / (getTimer() - _startTime));
      }
      
      override protected function request(param1:Boolean = false) : void
      {
         var retryFlag:Boolean = param1;
         super.request(retryFlag);
         var newurl:String = url;
         if((url) && _retryTimes > 0)
         {
            newurl = newurl + (newurl.indexOf("?") == -1?"?retry=" + _retryTimes:"&retry=" + _retryTimes);
         }
         _outTime = _firstOutTime + _gap * _retryTimes;
         _retryTimes++;
         if(url == null || url == "")
         {
            this.sendError("otherError",AIError.OTHER_ERROR);
            return;
         }
         this.gc();
         this.initVideo();
         this.visible = false;
         _startTime = getTimer();
         if(this.useDataMode)
         {
            this._loader = new URLStream();
            this._loader.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
            this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
            this._loader.addEventListener(ProgressEvent.PROGRESS,this.onLoadProgress);
            this._loader.addEventListener(Event.COMPLETE,this.onLoadComplete);
            try
            {
               this.sendState("NetStream.Play.Start");
               this.volume = 0;
               this.setGetLoop(true);
               this._totalBytes = new ByteArray();
               this._loader.load(new URLRequest(newurl));
            }
            catch(e:SecurityError)
            {
               onSecurityError();
            }
            catch(e:IOError)
            {
               onIOError();
            }
            catch(e:Error)
            {
               onOtherError();
            }
         }
         else
         {
            try
            {
               this._ns.play(newurl);
            }
            catch(e:Error)
            {
            }
            this.pause();
         }
         setDelay(true);
      }
      
      protected function initVideo() : void
      {
         if(this._video == null)
         {
            this._video = new Video();
            this._video.smoothing = true;
         }
         this._conn = new NetConnection();
         this._conn.addEventListener(NetStatusEvent.NET_STATUS,this.onNetStatus);
         this._conn.connect(null);
         this._ns = new NetStream(this._conn);
         this._ns.client = new NetClient(this);
         this._ns.bufferTime = 3;
         this._video.attachNetStream(this._ns);
         this._ns.addEventListener(NetStatusEvent.NET_STATUS,this.onNetStatus);
         if(this.useDataMode)
         {
            this._ns.play(null);
         }
      }
      
      override protected function onDelay() : void
      {
         this.gc();
         this.sendError("timeout",AIError.TIMEOUT_ERROR);
      }
      
      protected function onOtherError() : void
      {
         this.gc();
         this.sendError("otherError",AIError.OTHER_ERROR);
      }
      
      protected function onIOError(param1:IOErrorEvent = null) : void
      {
         this.gc();
         this.sendError("ioError",AIError.IO_ERROR);
      }
      
      protected function onSecurityError(param1:SecurityErrorEvent = null) : void
      {
         this.gc();
         this.sendError("securityError",AIError.SECURITY_ERROR);
      }
      
      protected function onLoadProgress(param1:ProgressEvent) : void
      {
         var _loc2_:ByteArray = null;
         if(this._loader.bytesAvailable > 0)
         {
            _loc2_ = new ByteArray();
            this._loader.readBytes(_loc2_,0,this._loader.bytesAvailable);
            _loc2_.readBytes(this._totalBytes,this._totalBytes.length,_loc2_.bytesAvailable);
         }
         if(_size <= 0 && param1.bytesTotal > 0)
         {
            _size = param1.bytesTotal;
         }
      }
      
      protected function onLoadComplete(param1:Event) : void
      {
         this.loaderGc();
         _stopTime = getTimer();
         var _loc2_:AILoaderEvent = new AILoaderEvent(AILoaderEvent.LOAD_COMPLETE,resourceType,index,_retryTimes);
         _loc2_.dataProvider = this;
         this.dispatchEvent(_loc2_);
      }
      
      protected function onNetStatus(param1:NetStatusEvent) : void
      {
         switch(param1.info.code)
         {
            case "NetStream.Play.Start":
               this.sendState(param1.info.code);
               this.setCheck(true);
               break;
            case "NetStream.Play.Stop":
            case "NetStream.Buffer.Full":
               this.sendState(param1.info.code);
               break;
            case "NetStream.Buffer.Empty":
               if(this.useDataMode)
               {
                  if(this.metadata.duration - this._ns.time <= this._ns.bufferTime)
                  {
                     this.sendState("NetStream.Play.Stop");
                  }
                  else
                  {
                     this.sendState(param1.info.code);
                  }
               }
               else
               {
                  this.sendState(param1.info.code);
               }
               break;
            case "NetStream.Play.StreamNotFound":
            case "NetStream.Play.FileStructureInvalid":
               this.sendError(param1.info.code,AIError.IO_ERROR);
               break;
         }
      }
      
      protected function setGetLoop(param1:Boolean) : void
      {
         var flag:Boolean = param1;
         clearInterval(this._loopIner);
         if(flag)
         {
            this._totalBytes.position = 0;
            try
            {
               this._ns.seek(0);
            }
            catch(e:Error)
            {
            }
            try
            {
               this._ns["appendBytesAction"]("resetBegin");
            }
            catch(e:Error)
            {
            }
            this._loopIner = setInterval(this.onLoop,50);
            this.onLoop();
         }
      }
      
      protected function onLoop() : void
      {
         var bytes:ByteArray = null;
         if((this._totalBytes) && this._totalBytes.bytesAvailable > 0)
         {
            bytes = new ByteArray();
            this._totalBytes.readBytes(bytes,0,this._totalBytes.bytesAvailable);
            try
            {
               this._ns["appendBytes"](bytes);
            }
            catch(e:Error)
            {
            }
         }
      }
      
      protected function sendState(param1:String, param2:int = 0) : void
      {
         var _loc3_:AILoaderEvent = new AILoaderEvent(AILoaderEvent.LOAD_STATE_CHANGE,resourceType,index,_retryTimes);
         _loc3_.dataProvider = this;
         _loc3_.errorCode = param2;
         _loc3_.infoCode = param1;
         dispatchEvent(_loc3_);
      }
      
      protected function sendError(param1:String, param2:int = 0) : void
      {
         var _loc3_:AILoaderEvent = null;
         _stopTime = getTimer();
         if(_retryTimes >= _retryMax)
         {
            this.destroy();
            this._hadError = true;
            _loc3_ = new AILoaderEvent(AILoaderEvent.LOAD_ERROR,resourceType,index,_retryTimes);
            _loc3_.dataProvider = this;
            _loc3_.errorCode = param2;
            _loc3_.infoCode = param1;
            dispatchEvent(_loc3_);
         }
         else
         {
            this.sendState(param1,param2);
            setDelayRetry(true,param2);
         }
      }
      
      protected function loaderGc() : void
      {
         this.setCheck(false);
         setDelay(false);
         try
         {
            this._loader.close();
         }
         catch(e:Error)
         {
         }
         try
         {
            this._loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
            this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
            this._loader.removeEventListener(ProgressEvent.PROGRESS,this.onLoadProgress);
            this._loader.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         }
         catch(e:Error)
         {
         }
         this._loader = null;
      }
      
      protected function gc() : void
      {
         this.loaderGc();
         this.setGetLoop(false);
         setDelayRetry(false);
         try
         {
            this._totalBytes.clear();
         }
         catch(e:Error)
         {
         }
         try
         {
            this._conn.close();
         }
         catch(e:Error)
         {
         }
         try
         {
            this._conn.removeEventListener(NetStatusEvent.NET_STATUS,this.onNetStatus);
         }
         catch(e:Error)
         {
         }
         try
         {
            this._ns.close();
         }
         catch(e:Error)
         {
         }
         try
         {
            this._ns.removeEventListener(NetStatusEvent.NET_STATUS,this.onNetStatus);
         }
         catch(e:Error)
         {
         }
         this._ns = null;
         this._conn = null;
         this._totalBytes = null;
      }
      
      protected function setCheck(param1:Boolean) : void
      {
         if(param1)
         {
            _size = this._ns.bytesTotal;
            if(this._check == null)
            {
               this._check = new BufferCheck(this._ns);
            }
            this._check.addEventListener(BufferCheckEvent.VIDEO_LOAD_COMPLETE,this.onLoadComplete);
            this._check.start();
         }
         else if(this._check)
         {
            this._check.close();
            this._check.removeEventListener(BufferCheckEvent.VIDEO_LOAD_COMPLETE,this.onLoadComplete);
            this._check = null;
         }
         
      }
   }
}
