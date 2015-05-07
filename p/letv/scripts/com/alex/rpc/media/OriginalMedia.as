package com.alex.rpc.media
{
   import flash.net.URLLoader;
   import flash.errors.IOError;
   import flash.net.URLLoaderDataFormat;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.Event;
   import flash.net.URLRequest;
   import com.alex.rpc.type.StateType;
   import com.alex.rpc.errors.AutoError;
   import com.alex.rpc.events.AutoLoaderEvent;
   import flash.utils.ByteArray;
   import flash.utils.getTimer;
   
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
      
      override protected function request(param1:Boolean = false, param2:String = null) : String
      {
         var retryFlag:Boolean = param1;
         var useURL:String = param2;
         var requesturl:String = super.request(retryFlag,useURL);
         if(requesturl == null)
         {
            this.onOtherError();
            return null;
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
            this.loader.load(new URLRequest(requesturl));
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
      
      override protected function onDelay() : void
      {
         this.loaderGc();
         this.sendError(StateType.ERROR_TIMEOUT,AutoError.TIMEOUT_ERROR);
      }
      
      private function onOtherError() : void
      {
         this.loaderGc();
         this.sendError(StateType.ERROR_OTHER,AutoError.OTHER_ERROR);
      }
      
      private function onIOError(param1:IOErrorEvent = null) : void
      {
         this.loaderGc();
         this.sendError(StateType.ERROR_IO,AutoError.IO_ERROR);
      }
      
      private function onSecurityError(param1:SecurityErrorEvent = null) : void
      {
         this.loaderGc();
         this.sendError(StateType.ERROR_SECURITY,AutoError.SECURITY_ERROR);
      }
      
      private function onProgress(param1:ProgressEvent) : void
      {
         sendState(AutoLoaderEvent.LOAD_PROGRESS,"progress",-1,param1.bytesLoaded / param1.bytesTotal);
      }
      
      private function onComplete(param1:Event) : void
      {
         var str:String = null;
         var arr:Array = null;
         var newStr:String = null;
         var newArr:Array = null;
         var codeStr:String = null;
         var bytes:ByteArray = null;
         var event:Event = param1;
         _utime = getTimer() - _utime;
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
            sendState(AutoLoaderEvent.LOAD_COMPLETE);
         }
         catch(e:Error)
         {
            trace("--x Error From OriginalMedia.onComplete",e.message);
            sendError(StateType.ERROR_OTHER,AutoError.ANALY_ERROR);
         }
         this.loaderGc();
      }
      
      protected function sendError(param1:String, param2:int = 0) : void
      {
         _utime = getTimer() - _utime;
         if(_retryTimes == _retryMax)
         {
            this.destroy();
            _hadError = true;
            sendState(AutoLoaderEvent.LOAD_ERROR,param1,param2);
         }
         else
         {
            this.loaderGc();
            sendState(AutoLoaderEvent.LOAD_STATE_CHANGE,param1,param2);
            setDelayRetry(true,param2);
         }
      }
      
      private function loaderGc() : void
      {
         setDelay(false);
         setDelayRetry(false);
         if(this.loader != null)
         {
            try
            {
               this.loader.close();
            }
            catch(e:Error)
            {
            }
            this.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
            this.loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
            this.loader.removeEventListener(ProgressEvent.PROGRESS,this.onProgress);
            this.loader.removeEventListener(Event.COMPLETE,this.onComplete);
            this.loader = null;
         }
      }
   }
}
