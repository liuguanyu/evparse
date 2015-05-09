package com.alex.media.net.filehandler
{
   import com.alex.rpc.AutoLoader;
   import com.alex.rpc.events.AutoLoaderEvent;
   import com.alex.rpc.type.ResourceType;
   import com.alex.media.events.HTTPNetStreamingEvent;
   import com.alex.rpc.type.StateType;
   import flash.utils.ByteArray;
   import com.alex.media.net.items.HTTPIndexItem;
   import flash.events.Event;
   
   public class HTTPM3U8FileHandler extends HTTPFileHandlerBase
   {
      
      private var _metadata:Object;
      
      private var _queue:Array = null;
      
      private var _retry:int = 0;
      
      private var _url:String;
      
      private var _m3u8Loader:AutoLoader;
      
      private var _stack:Vector.<HTTPIndexItem>;
      
      public function HTTPM3U8FileHandler()
      {
         super();
      }
      
      public function get duration() : Number
      {
         if(this.metadata != null)
         {
            return this.metadata.duration;
         }
         return 0;
      }
      
      public function get metadata() : Object
      {
         return this._metadata;
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
         this.m3u8LoaderGC();
         if(this._stack != null)
         {
            while(this._stack.length > 0)
            {
               this._stack.shift();
            }
            this._stack = null;
         }
      }
      
      override public function start(param1:Object) : void
      {
         this.destroy();
         if(param1 == null || !(param1 is Array))
         {
            log(this + "error:109");
            this.onM3U8LoadError(null,4);
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
         trace(this,"retryNext",this._retry + "/" + this._queue.length);
         log(this + "error:130");
         this.onM3U8LoadError();
      }
      
      private function request() : void
      {
         this.m3u8LoaderGC();
         try
         {
            this._url = this._queue[this._retry];
            trace(this,"[M3U8 AILoad] (" + this._retry + "/" + this._queue.length + ") URL: " + this._url);
            this._m3u8Loader = new AutoLoader();
            this._m3u8Loader.addEventListener(AutoLoaderEvent.LOAD_ERROR,this.onM3U8LoadError);
            this._m3u8Loader.addEventListener(AutoLoaderEvent.LOAD_STATE_CHANGE,this.onM3U8LoadState);
            this._m3u8Loader.addEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.onM3U8LoadComplete);
            this._m3u8Loader.setup([{
               "type":ResourceType.BINARY_FILE,
               "url":this._url,
               "first":8000,
               "retryMax":2
            }]);
         }
         catch(e:Error)
         {
            log(this + "error:146" + e.message);
            onM3U8LoadError(null,4);
         }
      }
      
      private function onM3U8LoadError(param1:AutoLoaderEvent = null, param2:int = 0) : void
      {
         var _loc3_:HTTPNetStreamingEvent = null;
         this.m3u8LoaderGC();
         if(this._retry >= this._queue.length - 1)
         {
            _loc3_ = new HTTPNetStreamingEvent(HTTPNetStreamingEvent.M3U8_ERROR,"");
            _loc3_.errorCode = param1 == null?param2:param1.errorCode;
            log(this + "error:160" + "  code:" + _loc3_.errorCode + "  total:" + this._queue.length);
            dispatchEvent(_loc3_);
         }
         else
         {
            this._retry++;
            this.request();
         }
      }
      
      private function onM3U8LoadState(param1:AutoLoaderEvent) : void
      {
         switch(param1.infoCode)
         {
            case StateType.INFO_OPEN:
               _httpCode = 100;
               break;
            case StateType.INFO_HTTP_STATUS:
               _httpCode = param1.errorCode;
               break;
         }
      }
      
      private function onM3U8LoadComplete(param1:AutoLoaderEvent) : void
      {
         log(this + "m3u8Complete" + param1.index);
         var _loc2_:ByteArray = param1.dataProvider.content as ByteArray;
         var _loc3_:String = M3U8Encryption.getInstance().decodeB2T(_loc2_);
         this.analy(_loc3_);
      }
      
      private function m3u8LoaderGC() : void
      {
         if(this._m3u8Loader != null)
         {
            this._m3u8Loader.removeEventListener(AutoLoaderEvent.LOAD_ERROR,this.onM3U8LoadError);
            this._m3u8Loader.removeEventListener(AutoLoaderEvent.LOAD_STATE_CHANGE,this.onM3U8LoadState);
            this._m3u8Loader.removeEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.onM3U8LoadComplete);
            this._m3u8Loader.destroy();
            this._m3u8Loader = null;
         }
      }
      
      private function analy(param1:String) : void
      {
         var arr:Array = null;
         var len:int = 0;
         var dt:Number = NaN;
         var count:int = 0;
         var item:HTTPIndexItem = null;
         var i:int = 0;
         var value:String = param1;
         this.m3u8LoaderGC();
         try
         {
            this._metadata = {};
            this._stack = new Vector.<HTTPIndexItem>();
            arr = value.split("#");
            len = arr.length;
            dt = 0;
            while(i < len)
            {
               if(arr[i].indexOf("EXTINF:") > -1)
               {
                  item = new HTTPIndexItem(arr[i],count);
                  item.startTime = dt;
                  dt = dt + item.duration;
                  count++;
                  this._stack.push(item);
               }
               else if(arr[i].indexOf("EXT-LETV-PIC-WIDTH:") > -1)
               {
                  this._metadata.width = Number(String(arr[i]).split(":")[1]);
               }
               else if(arr[i].indexOf("EXT-LETV-PIC-HEIGHT:") > -1)
               {
                  this._metadata.height = Number(String(arr[i]).split(":")[1]);
               }
               else if(arr[i].indexOf("EXT-LETV-TOTAL-MEDIADURATION:") > -1)
               {
                  this._metadata.mediaDuration = Number(arr[i].split(":")[1]);
               }
               
               
               
               i++;
            }
            this._metadata.duration = dt;
            if((isNaN(this._metadata.width)) || this._metadata.width <= 0)
            {
               this._metadata.width = 640;
            }
            if((isNaN(this._metadata.height)) || this._metadata.height <= 0)
            {
               this._metadata.height = 360;
            }
            if(this._stack.length > 0)
            {
               dispatchEvent(new Event(Event.COMPLETE));
            }
            else
            {
               this.onM3U8LoadError(null,3);
            }
         }
         catch(e:Error)
         {
            onM3U8LoadError(null,3);
         }
      }
   }
}
