package com.letv.aiLoader.media
{
   import flash.utils.ByteArray;
   import flash.net.URLStream;
   import flash.display.Loader;
   import flash.geom.Rectangle;
   import flash.errors.IOError;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.Event;
   import flash.utils.getTimer;
   import flash.net.URLRequest;
   import com.letv.aiLoader.errors.AIError;
   import com.letv.aiLoader.events.AILoaderEvent;
   import com.letv.aiLoader.utils.DeCompress;
   import flash.system.LoaderContext;
   import flash.system.ApplicationDomain;
   
   public class BinaryMedia extends BaseMedia
   {
      
      private var totalBytes:ByteArray;
      
      private var loader:URLStream;
      
      private var swfloader:Loader;
      
      public function BinaryMedia(param1:int = 0, param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function get rect() : Rectangle
      {
         try
         {
            return new Rectangle(0,0,this.content.contentLoaderInfo.width,this.content.contentLoaderInfo.height);
         }
         catch(e:Error)
         {
         }
         return new Rectangle(0,0,400,300);
      }
      
      override public function get content() : Object
      {
         return this.swfloader;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.loaderGc(true);
         this.swfloaderGc();
         if(this.swfloader)
         {
            this.swfloader.unloadAndStop();
            this.swfloader.unload();
         }
         this.swfloader = null;
         this.loader = null;
         if(this.totalBytes)
         {
            this.totalBytes.clear();
         }
         this.totalBytes = null;
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
         var newurl:String = null;
         var retryFlag:Boolean = param1;
         super.request(retryFlag);
         newurl = url;
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
         if(this.loader == null)
         {
            this.loader = new URLStream();
         }
         this.loader.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         this.loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
         this.loader.addEventListener(ProgressEvent.PROGRESS,this.onProgress);
         this.loader.addEventListener(Event.COMPLETE,this.onComplete);
         try
         {
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
         this.loaderGc(true);
         this.sendError("timeout",AIError.TIMEOUT_ERROR);
      }
      
      private function onOtherError() : void
      {
         this.loaderGc(true);
         this.sendError("otherError",AIError.OTHER_ERROR);
      }
      
      private function onIOError(param1:IOErrorEvent = null) : void
      {
         this.loaderGc(true);
         this.sendError("ioError",AIError.IO_ERROR);
      }
      
      private function onSecurityError(param1:SecurityErrorEvent = null) : void
      {
         this.loaderGc(true);
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
         var event:Event = param1;
         _size = this.loader.bytesAvailable;
         _stopTime = getTimer();
         try
         {
            if(this.totalBytes)
            {
               this.totalBytes.clear();
            }
            this.totalBytes = new ByteArray();
            this.loader.readBytes(this.totalBytes,0,this.loader.bytesAvailable);
            this.compressCheck();
         }
         catch(e:Error)
         {
            trace("--x Error From FlashMedia.onComplete.compressCheck",e.message);
            sendError("analyError",AIError.ANALY_ERROR);
            return;
         }
         this.loaderGc();
      }
      
      private function compressCheck() : void
      {
         if(!(this.totalBytes[0] == 67) && !(this.totalBytes[1] == 87) && !(this.totalBytes[2] == 83))
         {
            this.sendError("analyError",AIError.ANALY_ERROR);
            return;
         }
         if(!(this.totalBytes[0] == 90) && !(this.totalBytes[1] == 87) && !(this.totalBytes[2] == 83))
         {
            this.sendError("analyError",AIError.ANALY_ERROR);
            return;
         }
         if(this.totalBytes[0] == 90)
         {
            _hadCompress = "1";
            this.totalBytes = DeCompress.decodeSWF(this.totalBytes);
         }
         if(this.swfloader == null)
         {
            this.swfloader = new Loader();
         }
         this.swfloader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onCompressComplete);
         this.swfloader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         var _loc1_:LoaderContext = new LoaderContext();
         _loc1_.applicationDomain = new ApplicationDomain();
         if(_loc1_.hasOwnProperty("allowCodeImport"))
         {
            _loc1_["allowCodeImport"] = true;
         }
         this.swfloader.loadBytes(this.totalBytes,_loc1_);
         this.loader = null;
      }
      
      private function onCompressComplete(param1:Event) : void
      {
         this.swfloader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onCompressComplete);
         this.swfloader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         _originalRect = new Rectangle(0,0,this.swfloader.width,this.swfloader.height);
         _hadUsed = true;
         var _loc2_:AILoaderEvent = new AILoaderEvent(AILoaderEvent.LOAD_COMPLETE,resourceType,index,_retryTimes);
         _loc2_.dataProvider = this;
         this.dispatchEvent(_loc2_);
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
      
      private function swfloaderGc() : void
      {
         if(this.swfloader)
         {
            this.swfloader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onCompressComplete);
            this.swfloader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         }
         try
         {
            this.swfloader.close();
         }
         catch(e:Error)
         {
         }
         try
         {
            this.swfloader.unloadAndStop();
         }
         catch(e:Error)
         {
         }
         try
         {
            this.swfloader.unload();
         }
         catch(e:Error)
         {
         }
      }
      
      private function loaderGc(param1:Boolean = false) : void
      {
         var gc:Boolean = param1;
         setDelay(false);
         setDelayRetry(false);
         if(gc)
         {
            try
            {
               this.loader.close();
            }
            catch(e:Error)
            {
            }
         }
         if(this.loader)
         {
            this.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
            this.loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
            this.loader.removeEventListener(ProgressEvent.PROGRESS,this.onProgress);
            this.loader.removeEventListener(Event.COMPLETE,this.onComplete);
         }
      }
   }
}
