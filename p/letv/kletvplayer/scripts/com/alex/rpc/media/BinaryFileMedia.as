package com.alex.rpc.media
{
   import flash.net.URLLoader;
   import flash.utils.ByteArray;
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
   import flash.utils.getTimer;
   
   public class BinaryFileMedia extends BaseMedia
   {
      
      private var loader:URLLoader;
      
      private var totalBytes:ByteArray;
      
      public function BinaryFileMedia(param1:int = 0, param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function get content() : Object
      {
         return this.totalBytes;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.loaderGc();
         if(this.totalBytes != null)
         {
            this.totalBytes.clear();
            this.totalBytes = null;
         }
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
            if(this.totalBytes != null)
            {
               this.totalBytes.clear();
            }
            this.totalBytes = new ByteArray();
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
         var result:ByteArray = null;
         var event:Event = param1;
         _utime = getTimer() - _utime;
         _size = this.loader.bytesLoaded;
         try
         {
            result = this.loader.data as ByteArray;
            result.position = 0;
            result.readBytes(this.totalBytes,0,result.bytesAvailable);
            _hadUsed = true;
            this.loaderGc();
            sendState(AutoLoaderEvent.LOAD_COMPLETE);
         }
         catch(e:Error)
         {
            onOtherError();
         }
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
