package com.alex.media.net
{
   import com.alex.media.net.filehandler.HTTPMetaFileHandler;
   import com.alex.media.events.HTTPNetStreamingEvent;
   import flash.events.IOErrorEvent;
   import flash.events.Event;
   import flash.net.NetStream;
   import com.alex.media.net.items.HTTPDataIndexItem;
   import com.alex.media.net.filehandler.HTTPBinaryFragment;
   import flash.media.SoundTransform;
   import flash.utils.ByteArray;
   import flash.net.NetConnection;
   import com.alex.utils.NetClient;
   import flash.events.NetStatusEvent;
   import com.alex.media.net.filehandler.HTTPBinaryLoader;
   
   public class HTTPDataNetStreaming extends BaseNetStreaming
   {
      
      protected var _connection:NetConnection;
      
      protected var _stream:NetStream;
      
      protected var _seekTime:Number = 0;
      
      private var _handler:HTTPMetaFileHandler;
      
      private var _groups:Vector.<HTTPDataIndexItem>;
      
      private var _loader:HTTPBinaryLoader;
      
      private var _fragment:HTTPBinaryFragment;
      
      private var _fragments:Array;
      
      public function HTTPDataNetStreaming()
      {
         super();
         log(this + " Init");
         this.streamSetup();
      }
      
      override public function close() : void
      {
         super.close();
         this.loaderGC();
         this.streamGC();
         this.fragmentGC();
         this.groupGC();
         this.fileHanlderGC();
         this._seekTime = 0;
         this._fragment = null;
      }
      
      override public function play(... rest) : void
      {
         if(!(rest == null) && !(rest[0] == null))
         {
            this.close();
            super.play(rest);
            if(rest[1] != null)
            {
               this._seekTime = rest[1];
            }
            else
            {
               this._seekTime = 0;
            }
            this._handler = new HTTPMetaFileHandler();
            this._handler.addEventListener(HTTPNetStreamingEvent.LOG,this.onFileHandlerLog);
            this._handler.addEventListener(IOErrorEvent.IO_ERROR,this.onMetaFileHandlerError);
            this._handler.addEventListener(Event.COMPLETE,this.onMetaFileHandlerComplete);
            log(this + " seekTime: " + this._seekTime + " play: " + rest[0]);
            this._handler.start(rest[0]);
         }
      }
      
      override public function seek(param1:Number) : void
      {
         if(this._groups == null)
         {
            return;
         }
         if(this._fragments == null)
         {
            return;
         }
         setPlayTimerLoop(false);
         setPlayMemoryLoop(false);
         setPlayTimeout(false);
         var _loc2_:int = this.getIndex(param1);
         if(this._loader != null)
         {
            this._loader.interrupt(_loc2_);
         }
         this.streamSetup();
         this.stream.close();
         this.resetBegin();
         var _loc3_:int = this._fragments.length;
         var _loc4_:* = 0;
         while(_loc4_ < _loc3_)
         {
            if(this._fragments[_loc4_] != null)
            {
               this._fragments[_loc4_].position = 0;
            }
            _loc4_++;
         }
         log(this + " Seek " + " seekindex: " + _loc2_);
         this.playFrom(_loc2_);
      }
      
      override public function resume() : void
      {
         _autoplay = true;
         if(this._groups == null)
         {
            return;
         }
         if(this._fragments == null)
         {
            return;
         }
         if(this.stream != null)
         {
            this.stream.resume();
         }
         super.resume();
      }
      
      override public function pause() : void
      {
         if(this._groups == null)
         {
            return;
         }
         if(this._fragments == null)
         {
            return;
         }
         setPlayTimeout(false);
         if(this.stream != null)
         {
            this.stream.pause();
         }
      }
      
      override public function replay() : void
      {
         if(this._groups == null)
         {
            return;
         }
         if(this._fragments == null)
         {
            return;
         }
         if(!_videoStart)
         {
            return;
         }
         this.seek(0);
      }
      
      override public function get playLoopRate() : uint
      {
         return 200;
      }
      
      override public function get stream() : NetStream
      {
         return this._stream;
      }
      
      override public function get videoinfo() : String
      {
         if(this._groups == null)
         {
            return "1/1";
         }
         if(this._fragment == null)
         {
            return "1/1";
         }
         return this._fragment.index + "/" + this._groups.length;
      }
      
      public function get groups() : Vector.<HTTPDataIndexItem>
      {
         return this._groups;
      }
      
      public function get bytesLoaded() : Number
      {
         var _loc3_:* = 0;
         if(this._fragments == null)
         {
            return 0;
         }
         var _loc1_:int = this._fragments.length;
         var _loc2_:Number = 0;
         while(_loc3_ < _loc1_)
         {
            if(this._fragments[_loc3_] != null)
            {
               _loc2_ = _loc2_ + this._fragments[_loc3_].length;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function get bufferPercent() : Number
      {
         if(this.stream == null)
         {
            return 0;
         }
         return this.stream.bufferLength / this.stream.bufferTime;
      }
      
      override public function get playPercent() : Number
      {
         if(this._fragments == null)
         {
            return 0;
         }
         if(this.stream == null)
         {
            return 0;
         }
         return this.time / duration;
      }
      
      override public function get loadPercent() : Number
      {
         if(this._fragments == null)
         {
            return 0;
         }
         if(this._fragment == null)
         {
            return 0;
         }
         var _loc1_:int = this._fragment.index;
         var _loc2_:HTTPBinaryFragment = this._fragment;
         while(_loc1_ < this._fragments.length)
         {
            if(this._fragments[_loc1_] != null)
            {
               _loc2_ = this._fragments[_loc1_];
               if(this._fragments[_loc1_].length <= 0)
               {
                  break;
               }
               _loc1_++;
               continue;
            }
            break;
         }
         if(_loc2_ != null)
         {
            return (_loc2_.percent * _loc2_.duration + _loc2_.startTime) / duration;
         }
         return 0;
      }
      
      override public function set cdnlist(param1:Array) : void
      {
         if(this._handler != null)
         {
            this._handler.setQueue(param1);
         }
      }
      
      override public function get time() : Number
      {
         if(this.stream == null)
         {
            return 0;
         }
         if(this.stream.time <= 0)
         {
            return this._seekTime;
         }
         return this._seekTime + this.stream.time;
      }
      
      override public function set volume(param1:Number) : void
      {
         super.volume = param1;
         if(this.stream != null)
         {
            this.stream.soundTransform = new SoundTransform(param1);
         }
      }
      
      override public function set mute(param1:Boolean) : void
      {
         super.mute = param1;
         if(this.stream != null)
         {
            this.stream.soundTransform = new SoundTransform(volume);
         }
      }
      
      public function onData(param1:Object) : void
      {
      }
      
      override protected function get bufferLength() : Number
      {
         if(this.stream != null)
         {
            return this.stream.bufferLength;
         }
         return 0;
      }
      
      override protected function onPlayLoop() : void
      {
         if(this._fragment == null)
         {
            return;
         }
         var _loc1_:ByteArray = this._fragment.bytes;
         if(_loc1_ != null)
         {
            this.append(_loc1_);
         }
      }
      
      override protected function onMemoryLoop() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         if(this._fragment == null)
         {
            return;
         }
         if(memory > MAX_MEMORY)
         {
            _loc1_ = this._fragments.length;
            _loc2_ = this._fragment.index;
            _loc3_ = 0;
            while(_loc3_ < _loc1_)
            {
               if(_loc3_ >= _loc2_)
               {
                  break;
               }
               if(this._fragments[_loc3_] != null)
               {
                  this._fragments[_loc3_].destroy();
                  this._fragments[_loc3_] = null;
                  break;
               }
               _loc3_++;
            }
         }
         if((this._fragment.isComplete) && this._fragment.bytesAvailable == 0)
         {
            if(this._fragment.stopTime - this.time <= SAFE_BUFFER_TIME)
            {
               this.loadFile(this._fragment.index + 1);
            }
         }
      }
      
      override protected function onTimeout() : void
      {
         this.sendError(VIDEO_ERROR,this.time,this._fragment.errorCode);
      }
      
      private function onFileHandlerLog(param1:HTTPNetStreamingEvent) : void
      {
         log(String(param1.dataProvider),param1.status);
      }
      
      private function onMetaFileHandlerError(param1:* = null) : void
      {
         if(param1 is IOErrorEvent)
         {
            log(this + " onMetaFileHandlerError ErrorHttpCode: " + this._handler.httpCode,"error");
            this.sendError(FILE_READ_ERROR,this.time,this._handler.errorCode);
         }
         else
         {
            log(this + " onMetaFileHandlerError ErrorProgram: " + param1,"error");
            this.sendError(FILE_READ_ERROR,this.time,this._handler.errorCode);
         }
      }
      
      private function onMetaFileHandlerComplete(param1:Event) : void
      {
         this.fragmentGC();
         this._fragments = [];
         this._groups = this._handler.result as Vector.<HTTPDataIndexItem>;
         _duration = this._handler.duration;
         log(this + " cuts: " + this._groups.length + " duration: " + duration + " " + param1.target.width + "/" + param1.target.height);
         sendState(FILE_READ_COMPLETE,{
            "duration":duration,
            "width":param1.target.width,
            "height":param1.target.height
         });
         this.seek(this._seekTime);
      }
      
      private function playFrom(param1:int) : void
      {
         var index:int = param1;
         try
         {
            if(index < this._groups.length)
            {
               this._seekTime = this._groups[index].startTime;
               this.loadFile(index);
               if(this._fragment.length == 0)
               {
                  sendState(VIDEO_BUFFER_LOADING);
               }
               setPlayTimeout(true);
               setPlayTimerLoop(true);
               setPlayMemoryLoop(true);
            }
            else
            {
               log(this + " playFrom Index: " + index + " 超出范围: " + this._groups.length,"error");
            }
         }
         catch(e:Error)
         {
            onMetaFileHandlerError(e.message);
         }
      }
      
      private function callback(param1:Object) : void
      {
         switch(param1.type)
         {
            case "error":
               log(this + " Index: " + this._fragment.index + " HttpCode: " + this._fragment.httpCode + " ErrorCode: " + this._fragment.errorCode + " LoadState: " + this._fragment.length + " Percent: " + this._fragment.percent + " URL: " + this._fragment.url,"error");
               if(this._stream.bufferLength < this._stream.bufferTime)
               {
                  this.sendError(VIDEO_ERROR,this.time,param1.errorCode);
               }
               break;
            case "speed":
               sendState(VIDEO_SPEED,param1.value);
               break;
         }
      }
      
      private function streamSetup() : void
      {
         if(this._stream == null)
         {
            this._connection = new NetConnection();
            this._connection.connect(null);
            this._stream = new NetStream(this._connection);
            this._stream.client = new NetClient(this);
            this._stream.play(null);
         }
         this._stream.bufferTime = 1;
         this._stream.addEventListener(NetStatusEvent.NET_STATUS,this.onNetStatus);
      }
      
      private function fileHanlderGC() : void
      {
         if(this._handler != null)
         {
            this._handler.destroy();
            this._handler.removeEventListener(HTTPNetStreamingEvent.LOG,this.onFileHandlerLog);
            this._handler.removeEventListener(IOErrorEvent.IO_ERROR,this.onMetaFileHandlerError);
            this._handler.removeEventListener(Event.COMPLETE,this.onMetaFileHandlerComplete);
            this._handler = null;
         }
      }
      
      private function streamGC() : void
      {
         if(this._stream != null)
         {
            this._stream.close();
         }
      }
      
      private function loaderGC() : void
      {
         if(this._loader != null)
         {
            this._loader.close();
            this._loader = null;
         }
      }
      
      private function fragmentGC() : void
      {
         if(this._fragments != null)
         {
            if(this._fragments != null)
            {
               while(this._fragments.length > 0)
               {
                  if(this._fragments[0] != null)
                  {
                     this._fragments.shift().destroy();
                  }
                  else
                  {
                     this._fragments.shift();
                  }
               }
               this._fragments = null;
            }
         }
      }
      
      private function groupGC() : void
      {
         if(this._groups != null)
         {
            while(this._groups.length > 0)
            {
               this._groups.shift();
            }
            this._groups = null;
         }
      }
      
      private function onNetStatus(param1:NetStatusEvent) : void
      {
         log(this + " onNetStatus " + param1.info.code);
         switch(param1.info.code)
         {
            case "NetStream.Buffer.Full":
               this._stream.bufferTime = BUFFER_TIME;
               _canPlay = true;
               setPlayTimeout(false);
               if(!_videoStart)
               {
                  if(autoplay)
                  {
                     this.watchStart();
                  }
                  else
                  {
                     this.pause();
                  }
               }
               sendState(VIDEO_BUFFER_FULL);
               break;
            case "NetStream.Buffer.Empty":
               if((_videoStart) && this._fragment.index == this._groups.length - 1)
               {
                  if((this._fragment.isComplete) && duration - this.time <= this.stream.bufferTime)
                  {
                     this.watchStop();
                     return;
                  }
               }
               if(!(this._fragment == null) && this._fragment.errorCode >= 0)
               {
                  log(this + " Index: " + this._fragment.index + " HttpCode: " + this._fragment.httpCode + " ErrorCode: " + this._fragment.errorCode + " LoadState: " + this._fragment.length + " Percent: " + this._fragment.percent + " URL: " + this._fragment.url,"error");
                  this.sendError(VIDEO_ERROR,this.time,this._fragment.errorCode);
               }
               else
               {
                  setPlayTimeout(true);
                  sendState(VIDEO_BUFFER_EMPTY);
               }
               break;
         }
      }
      
      override protected function watchStart() : void
      {
         super.watchStart();
         sendState(VIDEO_START);
      }
      
      override protected function watchStop() : void
      {
         super.watchStop();
         sendState(VIDEO_STOP);
      }
      
      override protected function sendError(param1:String, param2:Object = null, param3:int = 0) : void
      {
         if(this._handler.canRetry)
         {
            this._seekTime = Number(param2);
            super.close();
            this.streamGC();
            this.fragmentGC();
            this.groupGC();
            this._handler.retryNext();
         }
         else
         {
            this.close();
            sendState(param1,param2,param3);
         }
      }
      
      protected function loadFile(param1:int) : void
      {
         if(param1 < this._groups.length)
         {
            if(this._loader == null)
            {
               this._loader = new HTTPBinaryLoader(this.callback);
            }
            this._fragment = this.getRegister(param1);
            this._loader.open(this._fragment);
         }
      }
      
      protected function resetBegin() : void
      {
         if(this.stream == null)
         {
            return;
         }
         if(this._handler == null)
         {
            return;
         }
         if(this._handler.header == null)
         {
            return;
         }
         this.stream.play(null);
         this.stream["appendBytesAction"]("resetBegin");
         this.append(this._handler.header);
         this.stream["appendBytesAction"]("resetSeek");
      }
      
      protected function append(param1:ByteArray) : void
      {
         if(!(this.stream == null) && !(param1 == null))
         {
            this.stream["appendBytes"](param1);
         }
      }
      
      protected function getIndex(param1:Number) : int
      {
         if(this._groups == null)
         {
            return -1;
         }
         if(this._groups.length <= 0)
         {
            return -1;
         }
         var _loc2_:int = this._groups.length;
         var _loc3_:* = 0;
         var _loc4_:Number = Math.abs(this._groups[0].startTime - param1);
         var _loc5_:Number = 0;
         var _loc6_:* = 1;
         while(_loc6_ < _loc2_)
         {
            _loc5_ = Math.abs(this._groups[_loc6_].startTime - param1);
            if(_loc5_ > _loc4_)
            {
               break;
            }
            _loc3_ = _loc6_;
            _loc4_ = _loc5_;
            _loc6_++;
         }
         while(this._groups[_loc3_].duration <= BUFFER_TIME && _loc3_ > 0)
         {
            _loc3_--;
         }
         return _loc3_;
      }
      
      protected function getRegister(param1:int) : HTTPBinaryFragment
      {
         if(this._fragments != null)
         {
            if(this._fragments[param1] == null)
            {
               this._fragments[param1] = new HTTPBinaryFragment(this._groups[param1]);
            }
            return this._fragments[param1];
         }
         return null;
      }
   }
}
