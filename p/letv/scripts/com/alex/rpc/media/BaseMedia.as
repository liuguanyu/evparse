package com.alex.rpc.media
{
   import flash.events.EventDispatcher;
   import com.alex.rpc.interfaces.IMedia;
   import flash.geom.Rectangle;
   import flash.system.ApplicationDomain;
   import flash.net.SharedObject;
   import flash.utils.getTimer;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import com.alex.rpc.errors.AutoError;
   import com.alex.rpc.events.AutoLoaderEvent;
   
   public class BaseMedia extends EventDispatcher implements IMedia
   {
      
      protected var usebak:Boolean = false;
      
      protected var _index:int = 0;
      
      protected var _data:Object;
      
      protected var _url:String;
      
      protected var _bakurl:String;
      
      protected var _size:int;
      
      protected var _utime:int = 0;
      
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
      
      protected var _hadCompress:Boolean;
      
      public function BaseMedia(param1:int = 0, param2:Object = null)
      {
         super();
         this._index = param1;
         this._data = param2;
         this._url = this._data["url"];
         this._bakurl = this._data["bakurl"];
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
      
      public function get cacheControl() : int
      {
         if((this._data.hasOwnProperty("cacheControl")) && !(this._data.cacheControl == null))
         {
            return int(this._data.cacheControl);
         }
         return 0;
      }
      
      public function get post() : Object
      {
         if((this._data.hasOwnProperty("post")) && !(this._data.post == null))
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
         var MAX_LENGTH:uint = 0;
         var so:SharedObject = null;
         var nowTime:Number = NaN;
         var list:Array = null;
         var i:int = 0;
         var time:Number = NaN;
         var cachetime:int = this.cacheControl;
         var recordtime:Number = 0;
         if(cachetime > 0)
         {
            try
            {
               MAX_LENGTH = 10;
               so = SharedObject.getLocal("com.letv.cachecontrol.v1","/");
               nowTime = int(new Date().getTime() * 0.001);
               if((so.data.hasOwnProperty("list")) && !(so.data.list == null) && so.data.list is Array)
               {
                  list = so.data.list;
                  i = 0;
                  while(i < list.length)
                  {
                     if(!(list[i] == null) && list[i]["url"] == this._url)
                     {
                        time = list[i]["time"];
                        if(nowTime - time >= cachetime)
                        {
                           recordtime = nowTime;
                        }
                        else
                        {
                           recordtime = time;
                        }
                        list.splice(i,1);
                        break;
                     }
                     i++;
                  }
                  if(list.length >= MAX_LENGTH)
                  {
                     list.shift();
                  }
                  list.push({
                     "time":recordtime,
                     "url":this._url
                  });
               }
               else
               {
                  so.data.list = [];
                  so.data.list.push({
                     "time":nowTime,
                     "url":this._url
                  });
               }
               so.flush();
            }
            catch(e:Error)
            {
            }
            if(recordtime > 0 && (this._url))
            {
               return this._url + (this._url.indexOf("?") != -1?"&tn=":"?tn=") + recordtime;
            }
         }
         if(cachetime > 0)
         {
            return this._url;
         }
         return this._url;
      }
      
      public function get bakurl() : String
      {
         return this._bakurl;
      }
      
      public function get size() : int
      {
         return this._size;
      }
      
      public function get utime() : int
      {
         return this._utime;
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
      
      public function get hadCompress() : Boolean
      {
         return this._hadCompress;
      }
      
      public function get speed() : int
      {
         if(this.utime > 0)
         {
            return int(this._size / this.utime);
         }
         return 0;
      }
      
      public function get applicationDomain() : ApplicationDomain
      {
         if(this._data.hasOwnProperty("applicationDomain"))
         {
            return this._data["applicationDomain"];
         }
         return null;
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
      
      protected function request(param1:Boolean = false, param2:String = null) : String
      {
         this._utime = getTimer();
         if(param2 == null)
         {
            var param2:String = this.url;
         }
         if(!(param2 == null) && this._retryTimes > 0)
         {
            param2 = param2 + (param2.indexOf("?") == -1?"?retry=" + this._retryTimes:"&retry=" + this._retryTimes);
         }
         this._outTime = this._firstOutTime + this._gap * this._retryTimes;
         this._retryTimes++;
         if(!(param2 == null) && !(param2 == ""))
         {
            return param2;
         }
         return null;
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
            if(param2 == AutoError.TIMEOUT_ERROR)
            {
               this.request(true);
            }
            else
            {
               this._retryTimeout = setTimeout(this.request,this._retryDelayTime,true);
            }
         }
      }
      
      protected function sendState(param1:String, param2:String = null, param3:int = -1, param4:Object = null) : void
      {
         var _loc5_:AutoLoaderEvent = new AutoLoaderEvent(param1,this.resourceType,this.index,this._retryTimes);
         if(param4 != null)
         {
            _loc5_.dataProvider = param4;
         }
         else
         {
            _loc5_.dataProvider = this;
         }
         _loc5_.infoCode = param2;
         _loc5_.errorCode = param3;
         dispatchEvent(_loc5_);
      }
   }
}
