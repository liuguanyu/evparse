package com.alex.media.net.filehandler
{
   import flash.utils.ByteArray;
   import com.alex.rpc.AutoLoader;
   import com.alex.rpc.events.AutoLoaderEvent;
   import com.alex.rpc.type.ResourceType;
   import flash.events.IOErrorEvent;
   import com.alex.rpc.type.StateType;
   import com.alex.media.net.items.HTTPDataIndexItem;
   import com.alex.utils.JSONUtil;
   import flash.events.Event;
   
   public class HTTPMetaFileHandler extends HTTPFileHandlerBase
   {
      
      private var _metadata:Object = null;
      
      private var _queue:Array = null;
      
      private var _retry:int = 0;
      
      private var _url:String;
      
      private var _header:ByteArray;
      
      private var _headerReady:Boolean;
      
      private var _loader:AutoLoader;
      
      private var _stack:Vector.<HTTPDataIndexItem>;
      
      private var _stackMinSize:uint = 5242880;
      
      public function HTTPMetaFileHandler()
      {
         super();
      }
      
      public function get duration() : Number
      {
         if(this._metadata != null)
         {
            return this._metadata.duration;
         }
         return 0;
      }
      
      public function get width() : Number
      {
         if(this._metadata != null)
         {
            return this._metadata.width;
         }
         return 320;
      }
      
      public function get height() : Number
      {
         if(this._metadata != null)
         {
            return this._metadata.height;
         }
         return 240;
      }
      
      public function get header() : ByteArray
      {
         return this._header;
      }
      
      public function get url() : String
      {
         return this._url;
      }
      
      public function get canRetry() : Boolean
      {
         if(this._queue == null)
         {
            return false;
         }
         return this._retry < this._queue.length - 1;
      }
      
      override public function get result() : Object
      {
         return this._stack;
      }
      
      override public function destroy() : void
      {
         this._retry = 0;
         this._queue = null;
         this._metadata = null;
         this.loaderGc();
         clearCode();
         this._headerReady = false;
         if(this._header != null)
         {
            this._header.clear();
            this._header = null;
         }
         if(this._stack != null)
         {
            while(this._stack.length > 0)
            {
               this._stack.shift();
            }
            this._stack = null;
         }
      }
      
      override public function setQueue(param1:Array) : void
      {
         if(!(param1 == null) && param1.length > 0)
         {
            this._retry = 0;
            this._url = param1[0];
            this._queue = param1 as Array;
         }
      }
      
      override public function start(param1:Object) : void
      {
         this.destroy();
         if(param1 == null || !(param1 is Array))
         {
            this.onMetaError(3);
            return;
         }
         if(param1.hasOwnProperty("retry"))
         {
            this._retry = int(param1["retry"]);
         }
         else
         {
            this._retry = 0;
         }
         if((isNaN(this._retry)) || this._retry < 0)
         {
            this._retry = 0;
         }
         this._queue = param1 as Array;
         this.request();
      }
      
      public function retryNext() : void
      {
         log(this + " retryNext " + this._retry + "/" + this._queue.length);
         this._headerReady = false;
         this.onMetaError(3);
      }
      
      private function request(param1:String = "videoData") : void
      {
         var metaURL:String = null;
         var resourceType:String = param1;
         this.loaderGc();
         try
         {
            this._url = this._queue[this._retry];
            metaURL = this._url + (this._url.indexOf("?") != -1?"&begin=1&stop=1":"?begin=1&stop=1");
            this._loader = new AutoLoader();
            this._loader.addEventListener(AutoLoaderEvent.LOAD_ERROR,this.onMetaError);
            this._loader.addEventListener(AutoLoaderEvent.LOAD_STATE_CHANGE,this.onMetaStateChange);
            this._loader.addEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.onMetaLoadComplete);
            log(this + " Load (" + this._retry + "/" + this._queue.length + ")" + "ResourceType: " + resourceType + " URL: " + metaURL);
            this._loader.setup([{
               "type":resourceType,
               "url":metaURL,
               "first":8000,
               "retryMax":2
            }]);
         }
         catch(e:Error)
         {
            onMetaError(9);
         }
      }
      
      private function onMetaError(param1:* = null) : void
      {
         var event:* = param1;
         if(event != null)
         {
            _errorCode = event is AutoLoaderEvent?event.errorCode:event;
            log(this + " onMetaError (" + this._retry + "/" + this._queue.length + ") errorCode: " + _errorCode);
         }
         else
         {
            _errorCode = -1;
         }
         this.loaderGc();
         if(this._stack != null)
         {
            while(this._stack.length > 0)
            {
               this._stack.shift();
            }
            this._stack = null;
         }
         try
         {
            if(!(event == null) && event.sourceType == ResourceType.VIDEO_DATA && (this._headerReady))
            {
               this.request(ResourceType.VIDEO);
               return;
            }
         }
         catch(e:Error)
         {
         }
         if(this._retry >= this._queue.length - 1)
         {
            dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
         }
         else
         {
            this._retry++;
            this.request();
         }
      }
      
      private function onMetaStateChange(param1:AutoLoaderEvent) : void
      {
         switch(param1.infoCode)
         {
            case StateType.INFO_METADATA:
               log(this + " MetaData Type: " + param1.sourceType);
               this.analy(param1.dataProvider.metadata);
               break;
            case StateType.INFO_OPEN:
               _httpCode = 100;
               break;
            case StateType.INFO_HTTP_STATUS:
               _httpCode = param1.errorCode;
               break;
         }
      }
      
      private function onMetaLoadComplete(param1:AutoLoaderEvent) : void
      {
         var result:ByteArray = null;
         var event:AutoLoaderEvent = param1;
         try
         {
            if(!this._headerReady && event.sourceType == ResourceType.VIDEO_DATA)
            {
               if(this._header != null)
               {
                  this._header.clear();
               }
               this._header = new ByteArray();
               result = event.dataProvider.bytes;
               result.readBytes(this._header,this._header.length,result.bytesAvailable);
               this._headerReady = true;
               this.checkState();
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function analy(param1:Object) : void
      {
         var times:Array = null;
         var filepositions:Array = null;
         var len:int = 0;
         var item:HTTPDataIndexItem = null;
         var itemObject:Object = null;
         var i:int = 0;
         var creatorInfo:Object = null;
         var value:Object = param1;
         try
         {
            this._metadata = {};
            if(!value.hasOwnProperty("width") || !value.hasOwnProperty("height"))
            {
               if(value.hasOwnProperty("creator"))
               {
                  try
                  {
                     creatorInfo = JSONUtil.decode(value.creator);
                     this._metadata.width = Number(creatorInfo.width);
                     this._metadata.height = Number(creatorInfo.height);
                  }
                  catch(e:Error)
                  {
                  }
               }
            }
            else
            {
               this._metadata.width = value.width;
               this._metadata.height = value.height;
            }
            this._metadata.duration = Number(value.duration);
            this._stack = new Vector.<HTTPDataIndexItem>();
            times = value.keyframes.times as Array;
            times.shift();
            filepositions = value.keyframes.filepositions as Array;
            filepositions.shift();
            len = filepositions.length;
            i = 0;
            while(i < len)
            {
               itemObject = {
                  "url":this._url,
                  "startOffset":filepositions[i],
                  "startTime":times[i]
               };
               if(i >= len - 1)
               {
                  itemObject["stopOffset"] = -1;
                  itemObject["stopTime"] = this.duration;
               }
               else
               {
                  itemObject["stopOffset"] = filepositions[i + 1] - 1;
                  itemObject["stopTime"] = times[i + 1];
               }
               item = new HTTPDataIndexItem(itemObject,i);
               this._stack.push(item);
               i++;
            }
            this.checkState();
         }
         catch(e:Error)
         {
            onMetaError(3);
         }
      }
      
      private function checkState() : void
      {
         log(this + " checkState headerReady: " + this._headerReady + " stackReady: " + String(!(this._stack == null)));
         if((this._headerReady) && !(this._stack == null))
         {
            this.loaderGc();
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      private function loaderGc() : void
      {
         if(this._loader != null)
         {
            this._loader.removeEventListener(AutoLoaderEvent.LOAD_ERROR,this.onMetaError);
            this._loader.removeEventListener(AutoLoaderEvent.LOAD_STATE_CHANGE,this.onMetaStateChange);
            this._loader.removeEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.onMetaLoadComplete);
            this._loader.destroy();
            this._loader = null;
         }
      }
   }
}
