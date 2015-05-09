package com.letv.aiLoader.media
{
   import flash.events.EventDispatcher;
   import flash.geom.Rectangle;
   import flash.system.ApplicationDomain;
   import flash.utils.getTimer;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import com.letv.aiLoader.errors.AIError;
   
   public class BaseMedia extends EventDispatcher implements IMedia
   {
      
      protected var _index:int;
      
      protected var _data:Object;
      
      protected var _url:String;
      
      protected var _size:int;
      
      protected var _startTime:int = 0;
      
      protected var _stopTime:int = 0;
      
      protected var _retryTimes:int = 0;
      
      protected var _outTime:uint = 5000;
      
      protected var _firstOutTime:uint = 5000;
      
      protected var _gap:int = 1000;
      
      protected var _retryMax:int = 2;
      
      protected var _retryDelayTime:uint = 3000;
      
      protected var _time:Number = 0;
      
      protected var _metadata:Object;
      
      protected var _originalRect:Rectangle;
      
      protected var _resourceType:String;
      
      protected var _hadError:Boolean;
      
      protected var _hadUsed:Boolean;
      
      private var _timeout:int;
      
      private var _retryTimeout:int;
      
      protected var _hadCompress:String = "0";
      
      public function BaseMedia(param1:int = 0, param2:Object = null)
      {
         super();
         this._index = param1;
         this._data = param2;
         this._url = this._data["url"];
         this._retryMax = this._data["retryMax"];
         this._retryDelayTime = this._data["retryDelayTime"];
         this._firstOutTime = Number(this._data["first"]);
         this._outTime = this._firstOutTime;
         this._gap = Number(this._data["gap"]);
         this._resourceType = this._data["type"];
      }
      
      public function destroy() : void
      {
      }
      
      public function start(param1:String = null) : void
      {
         if((param1) && !(param1 == ""))
         {
            this._url = param1;
         }
         this.destroy();
         this.request();
      }
      
      public function get post() : Object
      {
         if((this._data.hasOwnProperty("post")) && (this._data.post))
         {
            return this._data.post;
         }
         return null;
      }
      
      public function get domain() : ApplicationDomain
      {
         try
         {
            return this.content.content.loaderInfo.applicationDomain;
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      public function get checkPolicy() : Boolean
      {
         try
         {
            return this._data["checkPolicy"];
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function get retry() : int
      {
         return this._retryTimes;
      }
      
      public function get time() : Number
      {
         return this._time;
      }
      
      public function get originalRect() : Rectangle
      {
         return this._originalRect;
      }
      
      public function get metadata() : Object
      {
         return this._metadata;
      }
      
      public function get rect() : Rectangle
      {
         return null;
      }
      
      public function get url() : String
      {
         return this._url;
      }
      
      public function get size() : int
      {
         return this._size;
      }
      
      public function get speed() : int
      {
         return 0;
      }
      
      public function get utime() : int
      {
         if(this._startTime <= 0)
         {
            return 0;
         }
         if(this._stopTime > 0)
         {
            return this._stopTime - this._startTime;
         }
         return getTimer() - this._startTime;
      }
      
      public function get resourceType() : String
      {
         return this._resourceType;
      }
      
      public function get content() : Object
      {
         return null;
      }
      
      public function get hadError() : Boolean
      {
         return this._hadError;
      }
      
      public function get hadUsed() : Boolean
      {
         return this._hadUsed;
      }
      
      public function get hadCompress() : String
      {
         return this._hadCompress;
      }
      
      public function mute(param1:Number = 1) : void
      {
      }
      
      public function pause() : Boolean
      {
         return false;
      }
      
      public function resume() : Boolean
      {
         return false;
      }
      
      public function set visible(param1:Boolean) : void
      {
      }
      
      protected function request(param1:Boolean = false) : void
      {
      }
      
      protected function setDelay(param1:Boolean) : void
      {
         clearTimeout(this._timeout);
         if(param1)
         {
            this._timeout = setTimeout(this.onDelay,this._outTime);
         }
      }
      
      protected function onDelay() : void
      {
      }
      
      protected function setDelayRetry(param1:Boolean, param2:int = -1) : void
      {
         clearTimeout(this._retryTimeout);
         if(param1)
         {
            if(param2 == AIError.TIMEOUT_ERROR)
            {
               this.request(true);
            }
            else
            {
               this._retryTimeout = setTimeout(this.request,this._retryDelayTime,true);
            }
         }
      }
   }
}
