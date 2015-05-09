package com.alex.media.net
{
   import com.alex.media.log.BaseLog;
   import com.alex.media.interfaces.IVideoDisplay;
   import flash.net.NetStream;
   import flash.utils.Timer;
   import flash.events.TimerEvent;
   import flash.system.System;
   import com.alex.media.events.HTTPNetStreamingEvent;
   
   public class BaseNetStreaming extends BaseLog implements IVideoDisplay
   {
      
      public static const MAX_MEMORY:uint = 419430400;
      
      public static const SAFE_BUFFER_TIME:uint = 60;
      
      public static const BUFFER_TIME:uint = 3;
      
      public static const FILE_READ_ERROR:String = "fileReadError";
      
      public static const FILE_READ_COMPLETE:String = "fileReadComplete";
      
      public static const FILE_READ_PERCENT:String = "fileReadPercent";
      
      public static const VIDEO_META_DATA:String = "videoMetaData";
      
      public static const VIDEO_START:String = "videoStart";
      
      public static const VIDEO_STOP:String = "videoStop";
      
      public static const VIDEO_ERROR:String = "videoError";
      
      public static const VIDEO_BUFFER_FULL:String = "videoBufferFull";
      
      public static const VIDEO_BUFFER_EMPTY:String = "videoBufferEmpty";
      
      public static const VIDEO_BUFFER_LOADING:String = "videoBufferLoading";
      
      public static const VIDEO_SPEED:String = "videoSpeed";
      
      private var latestBufferLength:Number = 0;
      
      protected var _autoplay:Boolean = true;
      
      protected var _canPlay:Boolean;
      
      protected var _videoStart:Boolean;
      
      protected var _videoStop:Boolean;
      
      protected var _volume:Number = 1;
      
      protected var _muted:Boolean;
      
      protected var _mutedBefore:Number = 1;
      
      protected var _duration:Number = 0;
      
      protected var _timer:Timer;
      
      protected var _memoryTimer:Timer;
      
      protected var _timeoutTimer:Timer;
      
      public function BaseNetStreaming()
      {
         super();
      }
      
      public function play(... rest) : void
      {
         this.close();
      }
      
      public function seek(param1:Number) : void
      {
      }
      
      public function close() : void
      {
         this._duration = 0;
         this._canPlay = false;
         this._videoStop = false;
         this._videoStart = false;
         this.setPlayTimerLoop(false);
         this.setPlayMemoryLoop(false);
         this.setPlayTimeout(false);
      }
      
      public function pause() : void
      {
      }
      
      public function resume() : void
      {
         if(!this._videoStart)
         {
            if(this._canPlay)
            {
               this.watchStart();
            }
         }
      }
      
      public function replay() : void
      {
         this._videoStop = false;
         this._videoStart = true;
      }
      
      public function get videoinfo() : String
      {
         return "";
      }
      
      public function set cdnlist(param1:Array) : void
      {
      }
      
      public function set autoplay(param1:Boolean) : void
      {
         this._autoplay = param1;
      }
      
      public function get autoplay() : Boolean
      {
         return this._autoplay;
      }
      
      public function set mute(param1:Boolean) : void
      {
         this._muted = param1;
         if(param1)
         {
            this._mutedBefore = this._volume;
            this._volume = 0;
         }
         else
         {
            this._volume = this._mutedBefore;
         }
      }
      
      public function get mute() : Boolean
      {
         return this._muted;
      }
      
      public function set volume(param1:Number) : void
      {
         if(this._volume <= 0)
         {
            this._volume = 0;
         }
         if(this._volume > 0)
         {
            this._muted = false;
         }
         else
         {
            this._muted = true;
            if(this._volume > 0)
            {
               this._mutedBefore = this._volume;
            }
         }
         this._volume = param1;
      }
      
      public function get volume() : Number
      {
         return this._volume;
      }
      
      public function get time() : Number
      {
         return 0;
      }
      
      public function get loadPercent() : Number
      {
         return 0;
      }
      
      public function get playPercent() : Number
      {
         return 0;
      }
      
      public function get duration() : Number
      {
         return this._duration;
      }
      
      public function get stream() : NetStream
      {
         return null;
      }
      
      public function get playLoopRate() : uint
      {
         return 30;
      }
      
      public function get memoryLoopRate() : uint
      {
         return 500;
      }
      
      public function get timeoutRate() : uint
      {
         return 30000;
      }
      
      protected function setPlayTimeout(param1:Boolean) : void
      {
         if(param1)
         {
            if(this._timeoutTimer == null)
            {
               this._timeoutTimer = new Timer(this.timeoutRate,1);
            }
            this._timeoutTimer.addEventListener(TimerEvent.TIMER,this.onTimeoutTimer);
            this._timeoutTimer.reset();
            this._timeoutTimer.start();
         }
         else
         {
            if(this._timeoutTimer != null)
            {
               this._timeoutTimer.removeEventListener(TimerEvent.TIMER,this.onTimeoutTimer);
               this._timeoutTimer.stop();
            }
            this.latestBufferLength = 0;
         }
      }
      
      protected function setPlayTimerLoop(param1:Boolean) : void
      {
         if(param1)
         {
            if(this._timer == null)
            {
               this._timer = new Timer(this.playLoopRate);
            }
            if(!this._timer.running)
            {
               this._timer.addEventListener(TimerEvent.TIMER,this.onPlayTimer);
               this._timer.reset();
               this._timer.start();
            }
         }
         else if(this._timer != null)
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.onPlayTimer);
            this._timer.stop();
         }
         
      }
      
      protected function setPlayMemoryLoop(param1:Boolean) : void
      {
         if(param1)
         {
            if(this._memoryTimer == null)
            {
               this._memoryTimer = new Timer(this.memoryLoopRate);
            }
            if(!this._memoryTimer.running)
            {
               this._memoryTimer.addEventListener(TimerEvent.TIMER,this.onMemoryTimer);
               this._memoryTimer.reset();
               this._memoryTimer.start();
            }
         }
         else if(this._memoryTimer != null)
         {
            this._memoryTimer.removeEventListener(TimerEvent.TIMER,this.onMemoryTimer);
            this._memoryTimer.stop();
         }
         
      }
      
      private function onPlayTimer(param1:TimerEvent) : void
      {
         this.onPlayLoop();
      }
      
      private function onMemoryTimer(param1:TimerEvent) : void
      {
         this.onMemoryLoop();
         if(!(this._timeoutTimer == null) && (this._timeoutTimer.running))
         {
            if(this.bufferLength != this.latestBufferLength)
            {
               this.setPlayTimeout(true);
            }
            this.latestBufferLength = this.bufferLength;
         }
      }
      
      private function onTimeoutTimer(param1:TimerEvent) : void
      {
         this.onTimeout();
      }
      
      protected function onPlayLoop() : void
      {
      }
      
      protected function onMemoryLoop() : void
      {
      }
      
      protected function onTimeout() : void
      {
      }
      
      protected function watchStart() : void
      {
         this._videoStop = false;
         this._videoStart = true;
         this.setPlayTimerLoop(true);
         this.setPlayMemoryLoop(true);
         this.setPlayTimeout(false);
      }
      
      protected function watchStop() : void
      {
         this._videoStop = true;
         this._videoStart = false;
         this.setPlayTimerLoop(false);
         this.setPlayMemoryLoop(false);
         this.setPlayTimeout(false);
      }
      
      protected function get bufferLength() : Number
      {
         return 0;
      }
      
      protected function get memory() : Number
      {
         try
         {
            return System["privateMemory"];
         }
         catch(e:Error)
         {
         }
         return -1;
      }
      
      protected function sendState(param1:String, param2:Object = null, param3:int = 0) : void
      {
         dispatchEvent(new HTTPNetStreamingEvent(HTTPNetStreamingEvent.STATUS,param1,param3,param2));
      }
      
      protected function sendError(param1:String, param2:Object = null, param3:int = 0) : void
      {
      }
   }
}
