package com.alex.rpc.media
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
   import flash.net.URLRequest;
   import com.alex.rpc.type.StateType;
   import com.alex.rpc.errors.AutoError;
   import com.alex.rpc.events.AutoLoaderEvent;
   import flash.utils.getTimer;
   import flash.system.LoaderContext;
   import com.alex.encrypt.ABCSwfEncrypt;
   import flash.system.ApplicationDomain;
   
   public class BinaryMedia extends BaseMedia
   {
      
      private var totalBytes:ByteArray;
      
      private var loader:URLStream;
      
      private var swfloaders:Vector.<Loader>;
      
      private var loadedInstanceCount:int;
      
      public function BinaryMedia(param1:int = 0, param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function get rect() : Rectangle
      {
         try
         {
            if(this.content is Loader)
            {
               return new Rectangle(0,0,this.content.contentLoaderInfo.width,this.content.contentLoaderInfo.height);
            }
            if((this.content is Vector.<Loader>) && (this.content[0]) && (this.content[0]["content"]))
            {
               return new Rectangle(0,0,this.content[0].contentLoaderInfo.width,this.content[0].contentLoaderInfo.height);
            }
         }
         catch(e:Error)
         {
         }
         return new Rectangle(0,0,400,300);
      }
      
      override public function get content() : Object
      {
         if(this.swfloaders != null)
         {
            if(this.swfloaders.length == 1)
            {
               return this.swfloaders[0];
            }
            if(this.swfloaders.length > 1)
            {
               return this.swfloaders;
            }
         }
         return null;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.loaderGc();
         this.swfloadersGc();
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
            this.loader = new URLStream();
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
      
      protected function get instanceCount() : int
      {
         var _loc1_:* = 0;
         if((data) && (data.hasOwnProperty("instanceCount")))
         {
            _loc1_ = int(data["instanceCount"]);
            if(!isNaN(_loc1_) && _loc1_ > 1)
            {
               return _loc1_;
            }
         }
         return 1;
      }
      
      protected function get currentDomain() : Boolean
      {
         if((data) && (data.hasOwnProperty("currentDomain")))
         {
            return Boolean(data["currentDomain"]);
         }
         return false;
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
         var event:Event = param1;
         _size = this.loader.bytesAvailable;
         _utime = getTimer() - _utime;
         try
         {
            if(this.totalBytes != null)
            {
               this.totalBytes.clear();
            }
            this.totalBytes = new ByteArray();
            this.loader.readBytes(this.totalBytes,0,this.loader.bytesAvailable);
            this.loaderGc();
            this.compressCheck();
         }
         catch(e:Error)
         {
            trace("--x Error From FlashMedia.onComplete.compressCheck",e.message);
            sendError(StateType.ERROR_ANALY,AutoError.ANALY_ERROR);
            return;
         }
      }
      
      private function compressCheck() : void
      {
         var _loc3_:LoaderContext = null;
         _hadCompress = this.totalBytes.readUTFBytes(3) == ABCSwfEncrypt.ABC;
         this.totalBytes.position = 0;
         var _loc1_:ByteArray = ABCSwfEncrypt.decode(this.totalBytes);
         if(_loc1_ == null)
         {
            this.sendError(StateType.ERROR_ANALY,AutoError.ANALY_ERROR);
            return;
         }
         this.swfloadersGc();
         this.swfloaders = new Vector.<Loader>();
         var _loc2_:* = 0;
         while(_loc2_ < this.instanceCount)
         {
            this.swfloaders[_loc2_] = new Loader();
            this.swfloaders[_loc2_].contentLoaderInfo.addEventListener(Event.COMPLETE,this.onCompressComplete,false,0,true);
            this.swfloaders[_loc2_].contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onCompressIOError,false,0,true);
            _loc3_ = new LoaderContext();
            if(!this.currentDomain)
            {
               _loc3_.applicationDomain = new ApplicationDomain();
            }
            if(_loc3_.hasOwnProperty("allowCodeImport"))
            {
               _loc3_["allowCodeImport"] = true;
            }
            this.swfloaders[_loc2_].loadBytes(_loc1_,_loc3_);
            _loc2_++;
         }
         if(this.totalBytes != null)
         {
            this.totalBytes.clear();
         }
         this.totalBytes = null;
         this.loader = null;
      }
      
      private function onCompressIOError(param1:IOErrorEvent) : void
      {
         this.loadedInstanceCount++;
         param1.target.removeEventListener(Event.COMPLETE,this.onCompressComplete);
         param1.target.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         if(this.loadedInstanceCount == this.instanceCount)
         {
            _hadUsed = true;
            sendState(AutoLoaderEvent.LOAD_COMPLETE);
         }
      }
      
      private function onCompressComplete(param1:Event) : void
      {
         this.loadedInstanceCount++;
         param1.target.removeEventListener(Event.COMPLETE,this.onCompressComplete);
         param1.target.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         if(_originalRect == null)
         {
            _originalRect = new Rectangle(0,0,param1.target["loader"].width,param1.target["loader"].height);
         }
         if(this.loadedInstanceCount == this.instanceCount)
         {
            _hadUsed = true;
            sendState(AutoLoaderEvent.LOAD_COMPLETE);
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
            this.swfloadersGc();
            sendState(AutoLoaderEvent.LOAD_STATE_CHANGE,param1,param2);
            setDelayRetry(true,param2);
         }
      }
      
      private function swfloadersGc() : void
      {
         var swfloader:Loader = null;
         this.loadedInstanceCount = 0;
         if(this.swfloaders != null)
         {
            while(this.swfloaders.length > 0)
            {
               swfloader = this.swfloaders.shift();
               swfloader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onCompressComplete);
               swfloader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
               try
               {
                  swfloader.close();
               }
               catch(e:Error)
               {
               }
               try
               {
                  swfloader.unloadAndStop();
                  swfloader.unload();
               }
               catch(e:Error)
               {
               }
               swfloader = null;
            }
            this.swfloaders = null;
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
