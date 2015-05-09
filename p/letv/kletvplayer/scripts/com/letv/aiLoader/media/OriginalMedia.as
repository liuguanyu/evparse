package com.letv.aiLoader.media
{
   import flash.net.URLLoader;
   import flash.errors.IOError;
   import flash.net.URLLoaderDataFormat;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.Event;
   import flash.utils.getTimer;
   import flash.net.URLRequest;
   import com.letv.aiLoader.errors.AIError;
   import com.letv.aiLoader.events.AILoaderEvent;
   import flash.utils.ByteArray;
   
   public class OriginalMedia extends BaseMedia
   {
      
      private var loader:URLLoader;
      
      private var newContent:Object;
      
      public function OriginalMedia(param1:int = 0, param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function get content() : Object
      {
         return this.newContent;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.loaderGc();
         this.newContent = null;
      }
      
      override public function get speed() : int
      {
         if(_stopTime > 0)
         {
            return int(_size / (_stopTime - _startTime));
         }
         return 0;
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
            this.onOtherError();
            return;
         }
         this.loaderGc();
         try
         {
            this.loader = new URLLoader();
            this.loader.dataFormat = URLLoaderDataFormat.BINARY;
            this.loader.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
            this.loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
            this.loader.addEventListener(ProgressEvent.PROGRESS,this.onProgress);
            this.loader.addEventListener(Event.COMPLETE,this.onComplete);
            setDelay(true);
            _startTime = getTimer();
            this.loader.load(new URLRequest(newurl));
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
      
      override protected function onDelay() : void
      {
         this.loaderGc();
         this.sendError("timeout",AIError.TIMEOUT_ERROR);
      }
      
      private function onOtherError() : void
      {
         this.loaderGc();
         this.sendError("otherError",AIError.OTHER_ERROR);
      }
      
      private function onIOError(param1:IOErrorEvent = null) : void
      {
         this.loaderGc();
         this.sendError("ioError",AIError.IO_ERROR);
      }
      
      private function onSecurityError(param1:SecurityErrorEvent = null) : void
      {
         this.loaderGc();
         this.sendError("securityError",AIError.SECURITY_ERROR);
      }
      
      private function onProgress(param1:ProgressEvent) : void
      {
         var _loc2_:AILoaderEvent = new AILoaderEvent(AILoaderEvent.LOAD_PROGRESS,resourceType,index,_retryTimes);
         _loc2_.infoCode = "progress";
         _loc2_.dataProvider = param1.bytesLoaded / param1.bytesTotal;
         dispatchEvent(_loc2_);
      }
      
      private function onComplete(param1:Event) : void
      {
         var str:String = null;
         var ev:AILoaderEvent = null;
         var arr:Array = null;
         var newStr:String = null;
         var newArr:Array = null;
         var codeStr:String = null;
         var bytes:ByteArray = null;
         var event:Event = param1;
         _stopTime = getTimer();
         _size = this.loader.bytesLoaded;
         try
         {
            str = String(this.loader.data);
            if(str.substr(0,5) == "<?xml")
            {
               arr = str.split(" ");
               newStr = arr[2];
               newArr = newStr.split("\"");
               codeStr = newArr[1];
               bytes = this.loader.data;
               this.newContent = bytes.readMultiByte(bytes.bytesAvailable,codeStr);
            }
            else
            {
               this.newContent = str;
            }
            _hadUsed = true;
            ev = new AILoaderEvent(AILoaderEvent.LOAD_COMPLETE,resourceType,index,_retryTimes);
            ev.dataProvider = this;
            dispatchEvent(ev);
         }
         catch(e:Error)
         {
            trace("--x Error From OriginalMedia.onComplete",e.message);
            sendError("analyError",AIError.ANALY_ERROR);
         }
         this.loaderGc();
      }
      
      protected function sendState(param1:String, param2:int = 0) : void
      {
         var _loc3_:AILoaderEvent = new AILoaderEvent(AILoaderEvent.LOAD_STATE_CHANGE,resourceType,index,_retryTimes);
         _loc3_.dataProvider = this;
         _loc3_.infoCode = param1;
         _loc3_.errorCode = param2;
         this.dispatchEvent(_loc3_);
      }
      
      protected function sendError(param1:String, param2:int = 0) : void
      {
         var _loc3_:AILoaderEvent = null;
         _stopTime = getTimer();
         if(_retryTimes == _retryMax)
         {
            this.destroy();
            this._hadError = true;
            _loc3_ = new AILoaderEvent(AILoaderEvent.LOAD_ERROR,resourceType,index,_retryTimes);
            _loc3_.dataProvider = this;
            _loc3_.infoCode = param1;
            _loc3_.errorCode = param2;
            dispatchEvent(_loc3_);
         }
         else
         {
            this.sendState(param1,param2);
            setDelayRetry(true,param2);
         }
      }
      
      private function loaderGc() : void
      {
         setDelay(false);
         setDelayRetry(false);
         try
         {
            this.loader.close();
         }
         catch(e:Error)
         {
         }
         if(this.loader)
         {
            this.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
            this.loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
            this.loader.removeEventListener(ProgressEvent.PROGRESS,this.onProgress);
            this.loader.removeEventListener(Event.COMPLETE,this.onComplete);
         }
         this.loader = null;
      }
   }
}
