package com.alex.rpc.media
{
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.errors.IOError;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.HTTPStatusEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLRequestMethod;
   import com.alex.rpc.events.AutoLoaderEvent;
   import com.alex.rpc.type.StateType;
   import com.alex.rpc.errors.AutoError;
   import flash.utils.getTimer;
   
   public class TextMedia extends BaseMedia
   {
      
      private var loadContent:Object;
      
      private var loader:URLLoader;
      
      public function TextMedia(param1:int = 0, param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.loaderGc();
      }
      
      override public function get content() : Object
      {
         try
         {
            return this.loadContent;
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      override protected function request(param1:Boolean = false, param2:String = null) : String
      {
         var request:URLRequest = null;
         var retryFlag:Boolean = param1;
         var useURL:String = param2;
         var resulturl:String = super.request(retryFlag,useURL);
         if(resulturl == null)
         {
            this.onOtherError();
            return null;
         }
         this.loaderGc();
         try
         {
            this.loader = new URLLoader();
            this.loader.addEventListener(Event.OPEN,this.onOpen);
            this.loader.addEventListener(Event.COMPLETE,this.onComplete);
            this.loader.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
            this.loader.addEventListener(ProgressEvent.PROGRESS,this.onProgress);
            this.loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.onHttpStatus);
            this.loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
            request = new URLRequest(resulturl);
            if(post != null)
            {
               request.method = URLRequestMethod.POST;
               request.data = post;
            }
            setDelay(true);
            sendState(AutoLoaderEvent.LOAD_STATE_CHANGE,StateType.INFO_START);
            this.loader.load(request);
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
            onIOError();
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
      
      private function onOpen(param1:Event) : void
      {
         sendState(AutoLoaderEvent.LOAD_STATE_CHANGE,param1.type);
      }
      
      private function onHttpStatus(param1:HTTPStatusEvent) : void
      {
         sendState(AutoLoaderEvent.LOAD_STATE_CHANGE,param1.type,param1.status);
      }
      
      private function onComplete(param1:Event) : void
      {
         var event:Event = param1;
         _utime = getTimer() - _utime;
         _size = this.loader.bytesTotal;
         try
         {
            this.loadContent = event.target.data;
            this.loaderGc();
            _hadUsed = true;
            sendState(AutoLoaderEvent.LOAD_COMPLETE);
         }
         catch(e:Error)
         {
            loaderGc();
            sendError(StateType.ERROR_OTHER,AutoError.ANALY_ERROR);
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
            this.loader.removeEventListener(Event.OPEN,this.onOpen);
            this.loader.removeEventListener(Event.COMPLETE,this.onComplete);
            this.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
            this.loader.removeEventListener(ProgressEvent.PROGRESS,this.onProgress);
            this.loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS,this.onHttpStatus);
            this.loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
            this.loader = null;
         }
      }
   }
}
