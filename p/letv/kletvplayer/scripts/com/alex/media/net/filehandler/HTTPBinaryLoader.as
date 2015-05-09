package com.alex.media.net.filehandler
{
   import com.alex.media.log.BaseLog;
   import flash.errors.IOError;
   import flash.net.URLStream;
   import flash.events.Event;
   import flash.events.HTTPStatusEvent;
   import flash.events.ProgressEvent;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.utils.getTimer;
   import flash.net.URLRequest;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class HTTPBinaryLoader extends BaseLog
   {
      
      private var _callback:Function;
      
      private var _timeout:int;
      
      private var _fragment:HTTPBinaryFragment;
      
      private var _httpCode:int = -1;
      
      private var _speedTimeRecord:Number = 0;
      
      private var _loader:URLStream;
      
      private var _errorCode:int = -1;
      
      private var _bytesLoaded:Number = 0;
      
      public function HTTPBinaryLoader(param1:Function)
      {
         super();
         this._callback = param1;
      }
      
      public function close() : void
      {
         this._fragment = null;
         this._httpCode = -1;
         this.setDelay(false);
         this.loaderGC();
      }
      
      public function interrupt(param1:int) : void
      {
         if(!(this._fragment == null) && !(param1 == this._fragment.index))
         {
            this.loaderGC();
            this._fragment.interrupt();
         }
      }
      
      public function get index() : int
      {
         if(this._fragment != null)
         {
            return this._fragment.index;
         }
         return -1;
      }
      
      public function get percent() : Number
      {
         if(this._fragment != null)
         {
            return this._fragment.percent;
         }
         return 0;
      }
      
      public function get url() : String
      {
         if(this._fragment != null)
         {
            return this._fragment.url;
         }
         return null;
      }
      
      public function open(param1:HTTPBinaryFragment) : void
      {
         var target:HTTPBinaryFragment = param1;
         if(target == null)
         {
            throw new Error("HTTPBinaryRegister Is Null");
         }
         else
         {
            if(!(this._fragment == null) && !(target.index == this._fragment.index))
            {
               this._fragment.interrupt();
            }
            if((target.isComplete) || (target.isLoading))
            {
               return;
            }
            try
            {
               this.close();
               this.setDelay(true);
               this._fragment = target;
               this._loader = new URLStream();
               this._loader.addEventListener(Event.OPEN,this.onOpen);
               this._loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.onHttpStatus);
               this._loader.addEventListener(ProgressEvent.PROGRESS,this.onProgress);
               this._loader.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
               this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
               this._loader.addEventListener(Event.COMPLETE,this.onComplete);
               this._fragment.flush(null,0);
               this._speedTimeRecord = getTimer();
               trace("--->",this,"open",this._fragment.url);
               this._loader.load(new URLRequest(this._fragment.url));
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
               onOtherError(e.message);
            }
            return;
         }
      }
      
      private function onOpen(param1:Event) : void
      {
         this._httpCode = 100;
      }
      
      private function onHttpStatus(param1:HTTPStatusEvent) : void
      {
         this._httpCode = param1.status;
      }
      
      private function onProgress(param1:ProgressEvent) : void
      {
         if(this._loader.bytesAvailable > 0)
         {
            this._bytesLoaded = param1.bytesLoaded / 1024;
            this._fragment.flush(this._loader,param1.bytesLoaded / param1.bytesTotal);
            this.setDelay(true);
         }
      }
      
      private function onOtherError(param1:*) : void
      {
         this._errorCode = 4;
         if(this._httpCode < 0)
         {
            this._httpCode = 1004;
         }
         this._fragment.flush(null,0,this._errorCode,this._httpCode);
         this.close();
         this._callback({
            "type":"error",
            "index":this.index,
            "errorCode":this._errorCode
         });
      }
      
      private function onIOError(param1:Event = null) : void
      {
         this._errorCode = 0;
         if(this._httpCode < 0)
         {
            this._httpCode = 1000;
         }
         this._fragment.flush(null,0,this._errorCode,this._httpCode);
         this.close();
         this._callback({
            "type":"error",
            "index":this.index,
            "errorCode":this._errorCode
         });
      }
      
      private function onSecurityError(param1:Event = null) : void
      {
         this._errorCode = 2;
         if(this._httpCode < 0)
         {
            this._httpCode = 1002;
         }
         this._fragment.flush(null,0,this._errorCode,this._httpCode);
         this.close();
         this._callback({
            "type":"error",
            "index":this.index,
            "errorCode":this._errorCode
         });
      }
      
      private function onComplete(param1:Event = null) : void
      {
         var value:int = 0;
         var event:Event = param1;
         try
         {
            value = 0;
            if(this._bytesLoaded > 0)
            {
               value = int(this._bytesLoaded / ((getTimer() - this._speedTimeRecord) * 0.001));
            }
            this._callback({
               "type":"speed",
               "index":this.index,
               "value":value
            });
         }
         catch(e:Error)
         {
         }
         this.close();
      }
      
      private function setDelay(param1:Boolean) : void
      {
         clearTimeout(this._timeout);
         if(param1)
         {
            this._timeout = setTimeout(this.onDelay,15000);
         }
      }
      
      private function onDelay() : void
      {
         this._errorCode = 1;
         this._fragment.flush(null,0,this._errorCode,this._httpCode);
         this.close();
      }
      
      private function loaderGC() : void
      {
         if(this._loader != null)
         {
            try
            {
               this._loader.close();
            }
            catch(e:Error)
            {
            }
            this._loader.removeEventListener(Event.OPEN,this.onOpen);
            this._loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS,this.onHttpStatus);
            this._loader.removeEventListener(ProgressEvent.PROGRESS,this.onProgress);
            this._loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
            this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
            this._loader.removeEventListener(Event.COMPLETE,this.onComplete);
            this._loader = null;
         }
      }
   }
}
