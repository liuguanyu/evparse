package com.alex.media.net
{
   import flash.events.TimerEvent;
   import com.alex.media.net.filehandler.HTTPM3U8FileHandler;
   import flash.events.Event;
   import com.alex.media.events.HTTPNetStreamingEvent;
   import flash.utils.Timer;
   import flash.net.NetConnection;
   import com.alex.media.net.hls.HLStream;
   import flash.events.NetStatusEvent;
   import flash.events.IOErrorEvent;
   import com.alex.media.net.items.HTTPIndexItem;
   import com.alex.media.net.filehandler.HTTPBinaryLoader;
   import com.alex.media.net.filehandler.HTTPBinaryFragment;
   import flash.net.NetStream;
   import flash.media.SoundTransform;
   import flash.utils.ByteArray;
   
   public class HTTPM3U8NetStreaming extends BaseNetStreaming
   {
      
      protected var _connection:NetConnection;
      
      protected var _stream:HLStream;
      
      protected var _seekTime:Number = 0;
      
      private var _handler:HTTPM3U8FileHandler;
      
      private var _groups:Vector.<HTTPIndexItem>;
      
      private var _loader:HTTPBinaryLoader;
      
      private var _fragment:HTTPBinaryFragment;
      
      private var _fragments:Array;
      
      private var _fragmentPool:Array;
      
      private var _currentStopTime:Number = 0;
      
      private var _currentIndex:int = 0;
      
      private var _fragmentLoopTimer:Timer;
      
      private var _refreshTimer:Timer;
      
      private var _pointTimer:Timer;
      
      private var _nextList:Array;
      
      private var _nextDefinition:String;
      
      private var _definitionPointArr:Array;
      
      private var _isSwaping:Boolean;
      
      private var _metadata:Object;
      
      private var _isLoading:Boolean;
      
      private var _isSeek:Boolean;
      
      public function HTTPM3U8NetStreaming()
      {
         this._fragmentPool = [];
         this._fragmentLoopTimer = new Timer(1000);
         this._refreshTimer = new Timer(1000);
         this._pointTimer = new Timer(1000);
         this._definitionPointArr = [];
         super();
         log(this + " Init");
         this.streamSetup();
      }
      
      override public function close() : void
      {
         super.close();
         this.clear();
         this.fragmentGC();
         this.frgmentPoolGC();
         this.streamGC();
         this._seekTime = 0;
         this._fragment = null;
         this.loaderGC();
      }
      
      private function clear() : void
      {
         this.fileHanlderGC();
         this._groups = null;
      }
      
      override public function play(... rest) : void
      {
         this.setLoopFunction(this._refreshTimer,50,this.refreshLoop,false);
         if(!(rest == null) && !(rest[0] == null))
         {
            if(rest[2])
            {
               this._nextList = rest[0];
               this._nextDefinition = rest[3];
               this.smoothMode(rest);
            }
            else
            {
               this.unsmoothMode(rest);
            }
         }
      }
      
      private function unsmoothMode(param1:Array) : void
      {
         this.close();
         if(param1[1] != null)
         {
            this._seekTime = param1[1];
         }
         else
         {
            this._seekTime = 0;
         }
         this.startFileHandler(param1[0],false);
      }
      
      private function smoothMode(param1:Array) : void
      {
         this.setLoop(false);
         this._isSwaping = true;
         this.smoothModeLoad();
      }
      
      private function smoothModeLoad() : void
      {
         this.clear();
         this.setLoopFunction(this._fragmentLoopTimer,100,this.fragmentLoadingLoop,true);
      }
      
      private function fragmentLoadingLoop(param1:TimerEvent) : void
      {
         if(this._fragmentPool[0] == null || !(this._fragmentPool[0] == this._fragment) || (this._fragment.isComplete))
         {
            this.setLoopFunction(this._fragmentLoopTimer,100,this.fragmentLoadingLoop,false);
            this.startFileHandler(this._nextList,true);
         }
         else
         {
            setPlayTimerLoop(true);
         }
      }
      
      private function startFileHandler(param1:Array, param2:Boolean) : void
      {
         this._handler = new HTTPM3U8FileHandler();
         if(param2)
         {
            this._handler.addEventListener(Event.COMPLETE,this.smoothFileHandlerComplete);
         }
         else
         {
            this._handler.addEventListener(Event.COMPLETE,this.unsmoothFileHandlerComplete);
         }
         this._handler.addEventListener(HTTPNetStreamingEvent.M3U8_ERROR,this.onFileHandlerError);
         this._handler.addEventListener(HTTPNetStreamingEvent.LOG,this.onLogHandler);
         log(this + " seekTime: " + this._seekTime + " play: " + param1);
         this._handler.start(param1);
         this._isLoading = true;
      }
      
      private function onLogHandler(param1:HTTPNetStreamingEvent) : void
      {
         log(param1.dataProvider.toString());
      }
      
      private function onFileHandlerError(param1:HTTPNetStreamingEvent = null) : void
      {
         var _loc2_:int = param1 == null?4:param1.errorCode;
         this.sendError(FILE_READ_ERROR,this.time,_loc2_);
      }
      
      private function smoothFileHandlerComplete(param1:Event) : void
      {
         this.fragmentGC();
         this.loaderGC();
         this._fragment = null;
         this.resetFragmentData();
         if(this._definitionPointArr.length > 0)
         {
            if(this._definitionPointArr[this._definitionPointArr.length - 1].time == this._currentStopTime)
            {
               this._definitionPointArr.pop();
            }
         }
         this._definitionPointArr.push({
            "time":this._currentStopTime,
            "definition":this._nextDefinition
         });
         log(this + " cuts: " + this._groups.length + " duration: " + duration);
         this._metadata = param1.target.metadata;
         this.getFragment();
      }
      
      private function getFragment() : void
      {
         if(this._groups == null)
         {
            return;
         }
         if(this._fragments == null)
         {
            return;
         }
         var _loc1_:int = this.getIndex(this._currentStopTime);
         if(_loc1_ == 0 || this._groups[_loc1_ - 1].stopTime == this._currentStopTime)
         {
            dispatchEvent(new HTTPNetStreamingEvent(HTTPNetStreamingEvent.ALLOW_SMOOTH,"",0,true));
            this.setLoopFunction(this._refreshTimer,50,this.refreshLoop,false);
            if(this._isSeek)
            {
               this._isSeek = false;
               this.seek(this._seekTime);
            }
            this.setLoopFunction(this._refreshTimer,50,this.refreshLoop,true);
            return;
         }
         dispatchEvent(new HTTPNetStreamingEvent(HTTPNetStreamingEvent.ALLOW_SMOOTH,"",0,false));
      }
      
      private function refreshLoop(param1:TimerEvent) : void
      {
         if(this._stream.refresh())
         {
            this.setLoopFunction(this._refreshTimer,50,this.refreshLoop,false);
            setPlayTimerLoop(false);
            this.frgmentPoolGC();
            this.smoothPlay(this._currentStopTime);
         }
      }
      
      private function smoothPlay(param1:int) : void
      {
         var index:int = 0;
         var time:int = param1;
         try
         {
            index = this.getIndex(time);
            if(index < this._groups.length)
            {
               this.loadFile(index);
               this.setLoop(true);
               this.setLoopFunction(this._pointTimer,500,this.pointLoop,true);
            }
            else
            {
               log(this + " playFrom Index: " + index + " 超出范围: " + this._groups.length);
            }
         }
         catch(e:Error)
         {
            onFileHandlerError();
         }
      }
      
      private function unsmoothFileHandlerComplete(param1:Event) : void
      {
         this.resetFragmentData();
         log(this + " cuts: " + this._groups.length + " duration: " + duration);
         sendState(FILE_READ_COMPLETE,param1.target.metadata);
         this.seek(this._seekTime);
      }
      
      override public function seek(param1:Number) : void
      {
         if(this._isLoading)
         {
            this._seekTime = param1;
            this._isSeek = true;
            return;
         }
         if(this._groups == null)
         {
            return;
         }
         if(this._fragments == null)
         {
            return;
         }
         this.setLoop(false);
         this.setLoopFunction(this._refreshTimer,50,this.refreshLoop,false);
         this._fragmentPool = [];
         var _loc2_:int = this.getIndex(param1);
         if(this._loader != null)
         {
            this._loader.interrupt(_loc2_);
         }
         this.streamSetup();
         this._stream.close();
         this._stream.resetBegin();
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
               this.setLoop(true);
               if(this._isSwaping)
               {
                  this.seekPointComplete();
               }
            }
            else
            {
               log(this + " playFrom Index: " + index + " 超出范围: " + this._groups.length);
            }
         }
         catch(e:Error)
         {
            onFileHandlerError();
         }
      }
      
      private function pointLoop(param1:TimerEvent) : void
      {
         var _loc2_:Object = null;
         if(this._definitionPointArr.length == 0)
         {
            this.setLoopFunction(this._pointTimer,500,this.pointLoop,false);
            this._isSwaping = false;
         }
         else if(this.time >= this._definitionPointArr[0].time)
         {
            _loc2_ = {
               "last":this._definitionPointArr.length == 1,
               "definition":this._definitionPointArr[0].definition,
               "info":this._metadata
            };
            sendState(FILE_READ_COMPLETE,this._metadata);
            dispatchEvent(new HTTPNetStreamingEvent(HTTPNetStreamingEvent.SWAP_COMPLETE,null,0,_loc2_));
            this._definitionPointArr.shift();
         }
         
      }
      
      private function seekPointComplete() : void
      {
         this.setLoopFunction(this._pointTimer,500,this.pointLoop,false);
         var _loc1_:Object = {
            "last":true,
            "definition":this._definitionPointArr[this._definitionPointArr.length - 1].definition,
            "info":this._metadata
         };
         sendState(FILE_READ_COMPLETE,this._metadata);
         dispatchEvent(new HTTPNetStreamingEvent(HTTPNetStreamingEvent.SWAP_COMPLETE,null,0,_loc1_));
         while(this._definitionPointArr.length > 0)
         {
            this._definitionPointArr.pop();
         }
         this._isSwaping = false;
      }
      
      private function setLoopFunction(param1:Timer, param2:int, param3:Function, param4:Boolean) : void
      {
         if(param4)
         {
            if(param1 == null)
            {
               var param1:Timer = new Timer(param2);
            }
            if(!param1.running)
            {
               param1.delay = param2;
               param1.addEventListener(TimerEvent.TIMER,param3);
               param1.reset();
               param1.start();
            }
         }
         else if(param1 != null)
         {
            param1.removeEventListener(TimerEvent.TIMER,param3);
            param1.stop();
         }
         
      }
      
      private function streamSetup() : void
      {
         if(this._stream == null)
         {
            this._connection = new NetConnection();
            this._connection.connect(null);
            this._stream = new HLStream(this._connection);
            this._stream.bufferTime = 1;
         }
         this._stream.addEventListener(NetStatusEvent.NET_STATUS,this.onNetStatus);
      }
      
      private function fileHanlderGC() : void
      {
         if(this._handler != null)
         {
            this._handler.destroy();
            this._handler.removeEventListener(IOErrorEvent.IO_ERROR,this.onFileHandlerError);
            this._handler.removeEventListener(Event.COMPLETE,this.unsmoothFileHandlerComplete);
            this._handler.removeEventListener(Event.COMPLETE,this.smoothFileHandlerComplete);
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
            while(this._fragments.length > 0)
            {
               if(this._fragments[this._fragments.length - 1] != null)
               {
                  this._fragments.pop().destroy();
               }
               else
               {
                  this._fragments.pop();
               }
            }
            this._fragments = null;
         }
      }
      
      private function frgmentPoolGC() : void
      {
         if(this._fragmentPool != null)
         {
            while(this._fragmentPool.length > 0)
            {
               this._fragmentPool.pop();
            }
         }
      }
      
      private function resetFragmentData() : void
      {
         this._fragments = [];
         this._groups = this._handler.result as Vector.<HTTPIndexItem>;
         _duration = this._handler.duration;
         this._isLoading = false;
      }
      
      private function onNetStatus(param1:NetStatusEvent) : void
      {
         log(this + " onNetStatus " + param1.info.code);
         switch(param1.info.code)
         {
            case "NetStream.Buffer.Full":
               log(this + " onNetStatus " + param1.info.code);
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
         if((this._handler.canRetry) && !_videoStart)
         {
            this._seekTime = Number(param2);
            super.close();
            this.streamGC();
            this.fragmentGC();
            this._handler.retryNext();
            this._groups = null;
         }
         else
         {
            this.close();
            sendState(param1,param2,param3);
         }
      }
      
      private function callback(param1:Object) : void
      {
         switch(param1.type)
         {
            case "speed":
               sendState(VIDEO_SPEED,param1.value);
               break;
            case "error":
               if(this._fragment.startTime == this.time)
               {
                  log(this + " Index: " + this._fragment.index + " HttpCode: " + this._fragment.httpCode + " ErrorCode: " + this._fragment.errorCode + " LoadState: " + this._fragment.length + " Percent: " + this._fragment.percent + " URL: " + this._fragment.url,"error");
                  this.sendError(VIDEO_ERROR,this.time,param1.errorCode);
               }
               break;
         }
      }
      
      protected function loadFile(param1:int) : void
      {
         if(this._fragmentPool.length > 0 && this._fragmentPool[this._fragmentPool.length - 1].index == param1)
         {
            return;
         }
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
      
      protected function getRegister(param1:int) : HTTPBinaryFragment
      {
         if(this._fragments != null)
         {
            if(this._fragments[param1] == null)
            {
               this._fragments[param1] = new HTTPBinaryFragment(this._groups[param1]);
            }
            if(this._fragmentPool.length > 0)
            {
               this.pushFragment(this._fragments[param1]);
            }
            else
            {
               this._fragmentPool.push(this._fragments[param1]);
            }
            return this._fragments[param1];
         }
         return null;
      }
      
      private function pushFragment(param1:HTTPBinaryFragment) : void
      {
         var _loc2_:* = 0;
         while(_loc2_ < this._fragmentPool.length)
         {
            if(this._fragmentPool[_loc2_].item == null)
            {
               return;
            }
            if(this._fragmentPool[_loc2_].index == param1.index)
            {
               this._fragmentPool[_loc2_] = param1;
               return;
            }
            if(this._fragmentPool[_loc2_].index > param1.index)
            {
               this._fragmentPool.splice(_loc2_,0,param1);
               return;
            }
            _loc2_++;
         }
         this._fragmentPool.push(param1);
      }
      
      protected function getIndex(param1:Number) : int
      {
         var _loc3_:* = 0;
         if(this._groups == null)
         {
            return -1;
         }
         if(this._groups.length <= 0)
         {
            return -1;
         }
         var _loc2_:int = this._groups.length;
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
         this._currentIndex = _loc3_;
         return _loc3_;
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
         return 50;
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
      
      public function get groups() : Vector.<HTTPIndexItem>
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
      
      override protected function get bufferLength() : Number
      {
         if(this.stream != null)
         {
            return this.stream.bufferLength;
         }
         return 0;
      }
      
      private function setLoop(param1:Boolean) : void
      {
         setPlayMemoryLoop(param1);
         setPlayTimerLoop(param1);
         setPlayTimeout(param1);
      }
      
      override protected function onPlayLoop() : void
      {
         var _loc1_:ByteArray = null;
         if(this._fragmentPool[0] == null)
         {
            return;
         }
         if(this._fragmentPool[0].item == null && this._fragmentPool[0].bytesAvailable == 0)
         {
            this._fragmentPool.shift();
            return;
         }
         if(this._fragmentPool[0].startTime - this.time <= 10)
         {
            _loc1_ = this._fragmentPool[0].bytes;
            if(_loc1_ != null)
            {
               this._stream.append(_loc1_);
               this._currentStopTime = this._fragmentPool[0].stopTime;
            }
            if((this._fragmentPool[0].bytesAvailable == 0) && (this._fragmentPool[0].isComplete) && this._fragmentPool.length > 1)
            {
               this._fragmentPool.shift();
            }
         }
      }
      
      override protected function onMemoryLoop() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         if(this._fragmentPool[this._fragmentPool.length - 1] == null)
         {
            return;
         }
         if(memory > MAX_MEMORY)
         {
            _loc1_ = this._fragments.length;
            _loc2_ = this._fragmentPool[this._fragmentPool.length - 1].index;
            _loc3_ = 0;
            while(_loc3_ < _loc1_)
            {
               if(_loc3_ >= _loc2_)
               {
                  break;
               }
               if(!(this._fragments[_loc3_] == null) && this._fragments[_loc3_].bytesAvailable == 0 && (this._fragments[_loc3_].isComplete))
               {
                  this._fragments[_loc3_].destroy();
                  this._fragments[_loc3_] = null;
                  break;
               }
               _loc3_++;
            }
         }
         if(this._fragmentPool[this._fragmentPool.length - 1].isComplete)
         {
            if(this._fragmentPool[this._fragmentPool.length - 1].startTime - this.time <= SAFE_BUFFER_TIME)
            {
               this.loadFile(this._fragmentPool[this._fragmentPool.length - 1].index + 1);
            }
         }
      }
      
      override protected function onTimeout() : void
      {
         this.sendError(VIDEO_ERROR,this.time,1);
      }
   }
}
