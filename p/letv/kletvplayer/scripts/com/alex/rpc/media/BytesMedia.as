package com.alex.rpc.media
{
   import flash.display.Loader;
   import flash.geom.Rectangle;
   import flash.system.ApplicationDomain;
   import flash.utils.ByteArray;
   import flash.system.LoaderContext;
   import flash.errors.IOError;
   import com.alex.encrypt.ABCSwfEncrypt;
   import com.alex.rpc.type.StateType;
   import com.alex.rpc.errors.AutoError;
   import flash.events.IOErrorEvent;
   import flash.events.Event;
   import flash.utils.getTimer;
   import com.alex.rpc.events.AutoLoaderEvent;
   
   public class BytesMedia extends BaseMedia
   {
      
      private var loader:Loader;
      
      public function BytesMedia(param1:int = 0, param2:Object = null)
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
         try
         {
            return this.loader.content;
         }
         catch(e:Error)
         {
         }
         return this.loader;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.loaderGc();
      }
      
      override public function get domain() : ApplicationDomain
      {
         try
         {
            return this.content.loaderInfo.applicationDomain;
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      override protected function request(param1:Boolean = false, param2:String = null) : String
      {
         var context:LoaderContext = null;
         var retryFlag:Boolean = param1;
         var useURL:String = param2;
         super.request(retryFlag,useURL);
         var swfbytes:ByteArray = this.localbytes;
         if(swfbytes == null)
         {
            this.onOtherError();
            return null;
         }
         this.loaderGc();
         try
         {
            _hadCompress = swfbytes.readUTFBytes(3) == ABCSwfEncrypt.ABC;
            swfbytes.position = 0;
            swfbytes = ABCSwfEncrypt.decode(swfbytes);
            if(swfbytes == null)
            {
               this.sendError(StateType.ERROR_ANALY,AutoError.ANALY_ERROR);
               return null;
            }
         }
         catch(e:Error)
         {
            sendError(StateType.ERROR_OTHER,AutoError.ANALY_ERROR);
            return null;
         }
         try
         {
            this.loader = new Loader();
            this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
            this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onComplete);
            context = new LoaderContext();
            context.applicationDomain = new ApplicationDomain();
            if(context.hasOwnProperty("allowCodeImport"))
            {
               context["allowCodeImport"] = true;
            }
            setDelay(true);
            this.loader.loadBytes(swfbytes,context);
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
      
      protected function get localbytes() : ByteArray
      {
         try
         {
            return data.bytes as ByteArray;
         }
         catch(e:Error)
         {
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
      
      private function onSecurityError(param1:Event = null) : void
      {
         this.loaderGc();
         this.sendError(StateType.ERROR_SECURITY,AutoError.SECURITY_ERROR);
      }
      
      private function onComplete(param1:Event) : void
      {
         var event:Event = param1;
         try
         {
            _size = this.loader.contentLoaderInfo.bytesLoaded;
         }
         catch(e:Error)
         {
            _size = 0;
         }
         _utime = getTimer() - _utime;
         try
         {
            _originalRect = new Rectangle(0,0,this.loader.width,this.loader.height);
            _hadUsed = true;
            sendState(AutoLoaderEvent.LOAD_COMPLETE);
         }
         catch(e:Error)
         {
            sendError(StateType.ERROR_OTHER,AutoError.ANALY_ERROR);
            return;
         }
         this.loaderGc(false);
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
      
      protected function loaderGc(param1:Boolean = true) : void
      {
         var gc:Boolean = param1;
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
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onComplete);
            if(gc)
            {
               this.loader.unloadAndStop();
               this.loader.unload();
               this.loader = null;
            }
         }
      }
   }
}
