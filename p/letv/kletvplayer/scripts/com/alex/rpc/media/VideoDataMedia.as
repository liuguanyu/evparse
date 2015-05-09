package com.alex.rpc.media
{
   import flash.net.URLStream;
   import flash.net.NetConnection;
   import flash.net.NetStream;
   import flash.media.Video;
   import flash.utils.ByteArray;
   import flash.geom.Rectangle;
   import com.alex.rpc.errors.AutoError;
   import flash.media.SoundTransform;
   import com.alex.rpc.events.AutoLoaderEvent;
   import com.alex.rpc.type.StateType;
   import flash.errors.IOError;
   import flash.events.Event;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.URLRequest;
   import com.alex.utils.NetClient;
   import flash.events.NetStatusEvent;
   import flash.utils.getTimer;
   
   public class VideoDataMedia extends BaseMedia
   {
      
      private var _hadReume:Boolean;
      
      private var _playing:Boolean;
      
      private var _loader:URLStream;
      
      private var _conn:NetConnection;
      
      private var _ns:NetStream;
      
      private var _video:Video;
      
      private var _totalBytes:ByteArray;
      
      private var _loopIner:int;
      
      public function VideoDataMedia(param1:int = 0, param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.gc();
         this._video = null;
      }
      
      public function get netstream() : NetStream
      {
         return this._ns;
      }
      
      public function get bytes() : ByteArray
      {
         return this._totalBytes;
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
         if(this._ns != null)
         {
            if(hadUsed)
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
            if(!this._hadReume)
            {
               this._hadReume = true;
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
         throw new AutoError("Invalid Method");
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
               if(!this._playing)
               {
                  try
                  {
                     this._ns.pause();
                  }
                  catch(e:Error)
                  {
                  }
               }
               sendState(AutoLoaderEvent.LOAD_STATE_CHANGE,StateType.INFO_METADATA);
            }
         }
      }
      
      override protected function request(param1:Boolean = false, param2:String = null) : String
      {
         var retryFlag:Boolean = param1;
         var useURL:String = param2;
         var resulturl:String = super.request(retryFlag,useURL);
         if(resulturl == null)
         {
            this.onOtherError();
            return null;
         }
         this.initVideo();
         if(!this._ns.hasOwnProperty("appendBytes"))
         {
            this.onOtherError();
            return null;
         }
         try
         {
            this._loader = new URLStream();
            this._loader.addEventListener(Event.OPEN,this.onOpen);
            this._loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.onHttpStatus);
            this._loader.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
            this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
            this._loader.addEventListener(ProgressEvent.PROGRESS,this.onLoadProgress);
            this._loader.addEventListener(Event.COMPLETE,this.onLoadComplete);
            setDelay(true);
            this._loader.load(new URLRequest(resulturl));
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
         return null;
      }
      
      protected function initVideo() : void
      {
         this.gc();
         this._totalBytes = new ByteArray();
         if(this._video == null)
         {
            this._video = new Video();
            this._video.smoothing = true;
         }
         this._conn = new NetConnection();
         this._conn.connect(null);
         this._ns = new NetStream(this._conn);
         this._ns.client = new NetClient(this);
         this._ns.addEventListener(NetStatusEvent.NET_STATUS,this.onNetStatus);
         this._ns.play(null);
         this._video.attachNetStream(this._ns);
         this.volume = 0;
         this.visible = false;
      }
      
      override protected function onDelay() : void
      {
         this.gc();
         this.sendError(StateType.ERROR_TIMEOUT,AutoError.TIMEOUT_ERROR);
      }
      
      protected function onOtherError() : void
      {
         this.gc();
         this.sendError(StateType.ERROR_OTHER,AutoError.OTHER_ERROR);
      }
      
      protected function onOpen(param1:Event) : void
      {
         sendState(AutoLoaderEvent.LOAD_STATE_CHANGE,StateType.STREAM_START);
         sendState(AutoLoaderEvent.LOAD_STATE_CHANGE,StateType.INFO_OPEN);
      }
      
      protected function onHttpStatus(param1:HTTPStatusEvent) : void
      {
         sendState(AutoLoaderEvent.LOAD_STATE_CHANGE,StateType.INFO_HTTP_STATUS,param1.status);
      }
      
      protected function onIOError(param1:IOErrorEvent = null) : void
      {
         this.gc();
         this.sendError(StateType.ERROR_IO,AutoError.IO_ERROR);
      }
      
      protected function onSecurityError(param1:SecurityErrorEvent = null) : void
      {
         this.gc();
         this.sendError(StateType.ERROR_SECURITY,AutoError.SECURITY_ERROR);
      }
      
      protected function onLoadProgress(param1:ProgressEvent) : void
      {
         var _loc2_:ByteArray = null;
         if(this._loader.bytesAvailable > 0)
         {
            _loc2_ = new ByteArray();
            this._loader.readBytes(_loc2_,0,this._loader.bytesAvailable);
            _loc2_.readBytes(this._totalBytes,this._totalBytes.length,_loc2_.bytesAvailable);
            if(!(this._ns == null) && (this._ns.hasOwnProperty("appendBytes")))
            {
               this._ns["appendBytes"](_loc2_);
            }
         }
         if(_size <= 0 && param1.bytesTotal > 0)
         {
            _size = param1.bytesTotal;
         }
      }
      
      protected function onLoadComplete(param1:Event) : void
      {
         this.loaderGc();
         _utime = getTimer() - _utime;
         sendState(AutoLoaderEvent.LOAD_COMPLETE);
      }
      
      protected function onNetStatus(param1:NetStatusEvent) : void
      {
         switch(param1.info.code)
         {
            case "NetStream.Play.Start":
               sendState(AutoLoaderEvent.LOAD_STATE_CHANGE,param1.info.code);
               break;
            case "NetStream.Play.Stop":
            case "NetStream.Buffer.Full":
               sendState(AutoLoaderEvent.LOAD_STATE_CHANGE,param1.info.code);
               break;
            case "NetStream.Buffer.Empty":
               if(this.metadata.duration - this._ns.time <= this._ns.bufferTime)
               {
                  sendState(AutoLoaderEvent.LOAD_STATE_CHANGE,"NetStream.Play.Stop");
               }
               else
               {
                  sendState(AutoLoaderEvent.LOAD_STATE_CHANGE,param1.info.code);
               }
               break;
         }
      }
      
      protected function sendError(param1:String, param2:int = 0) : void
      {
         _utime = getTimer() - _utime;
         if(_retryTimes >= _retryMax)
         {
            this.destroy();
            _hadError = true;
            sendState(AutoLoaderEvent.LOAD_ERROR,param1,param2);
         }
         else
         {
            this.gc();
            sendState(AutoLoaderEvent.LOAD_STATE_CHANGE,param1,param2);
            setDelayRetry(true,param2);
         }
      }
      
      protected function loaderGc() : void
      {
         setDelay(false);
         if(this._loader != null)
         {
            try
            {
               this._loader.close();
            }
            catch(e:Error)
            {
            }
            this._loader.removeEventListener(Event.OPEN,this.onOpen);
            this._loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS,this.onHttpStatus);
            this._loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
            this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
            this._loader.removeEventListener(ProgressEvent.PROGRESS,this.onLoadProgress);
            this._loader.removeEventListener(Event.COMPLETE,this.onLoadComplete);
            this._loader = null;
         }
      }
      
      protected function gc() : void
      {
         this.loaderGc();
         setDelayRetry(false);
         if(this._totalBytes != null)
         {
            this._totalBytes.clear();
            this._totalBytes = null;
         }
         if(this._conn != null)
         {
            try
            {
               this._conn.close();
            }
            catch(e:Error)
            {
            }
            this._conn = null;
         }
         if(this._ns != null)
         {
            try
            {
               this._ns.close();
            }
            catch(e:Error)
            {
            }
            this._ns.removeEventListener(NetStatusEvent.NET_STATUS,this.onNetStatus);
            this._ns = null;
         }
      }
   }
}
