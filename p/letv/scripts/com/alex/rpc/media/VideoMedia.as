package com.alex.rpc.media
{
   import flash.net.NetConnection;
   import flash.net.NetStream;
   import flash.media.Video;
   import com.alex.rpc.tools.BufferCheck;
   import flash.geom.Rectangle;
   import flash.media.SoundTransform;
   import com.alex.rpc.events.AutoLoaderEvent;
   import com.alex.rpc.type.StateType;
   import flash.events.NetStatusEvent;
   import com.alex.utils.NetClient;
   import flash.events.AsyncErrorEvent;
   import com.alex.rpc.errors.AutoError;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.Event;
   import flash.utils.getTimer;
   import com.alex.rpc.events.BufferCheckEvent;
   
   public class VideoMedia extends BaseMedia
   {
      
      private var _hadReume:Boolean;
      
      private var _playing:Boolean;
      
      private var _conn:NetConnection;
      
      private var _ns:NetStream;
      
      private var _video:Video;
      
      private var _check:BufferCheck;
      
      private var _loopIner:int;
      
      public function VideoMedia(param1:int = 0, param2:Object = null)
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
            this._ns.pause();
            return true;
         }
         return false;
      }
      
      override public function resume() : Boolean
      {
         this._playing = true;
         try
         {
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
         this.visible = false;
         setDelay(true);
         try
         {
            this._ns.play(resulturl);
         }
         catch(e:Error)
         {
         }
         this.pause();
         return null;
      }
      
      protected function initVideo() : void
      {
         this.gc();
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
         this._ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.onAsyncError);
         this._ns.addEventListener(NetStatusEvent.NET_STATUS,this.onNetStatus);
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
      
      protected function onNetStatus(param1:NetStatusEvent) : void
      {
         switch(param1.info.code)
         {
            case "NetStream.Play.Start":
               sendState(AutoLoaderEvent.LOAD_STATE_CHANGE,param1.info.code);
               this.setCheck(true);
               break;
            case "NetStream.Play.Stop":
            case "NetStream.Buffer.Full":
            case "NetStream.Buffer.Empty":
               sendState(AutoLoaderEvent.LOAD_STATE_CHANGE,param1.info.code);
               break;
            case "NetStream.Play.StreamNotFound":
               this.sendError(param1.info.code,AutoError.IO_ERROR);
               break;
            case "NetStream.Play.FileStructureInvalid":
               this.sendError(param1.info.code,AutoError.ANALY_ERROR);
               break;
         }
      }
      
      protected function onAsyncError(param1:AsyncErrorEvent) : void
      {
         this.sendError(param1.type,AutoError.OTHER_ERROR);
      }
      
      protected function onLoadComplete(param1:Event) : void
      {
         this.setCheck(false);
         _utime = getTimer() - _utime;
         sendState(AutoLoaderEvent.LOAD_COMPLETE);
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
      
      protected function gc() : void
      {
         this.setCheck(false);
         setDelay(false);
         setDelayRetry(false);
         if(this._conn != null)
         {
            try
            {
               this._conn.close();
            }
            catch(e:Error)
            {
            }
            this._conn.removeEventListener(NetStatusEvent.NET_STATUS,this.onNetStatus);
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
            this._ns.removeEventListener(AsyncErrorEvent.ASYNC_ERROR,this.onAsyncError);
            this._ns.removeEventListener(NetStatusEvent.NET_STATUS,this.onNetStatus);
            this._ns = null;
         }
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
         else if(this._check != null)
         {
            this._check.close();
            this._check.removeEventListener(BufferCheckEvent.VIDEO_LOAD_COMPLETE,this.onLoadComplete);
            this._check = null;
         }
         
      }
   }
}
