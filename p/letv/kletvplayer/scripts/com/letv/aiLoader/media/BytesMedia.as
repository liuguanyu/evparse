package com.letv.aiLoader.media
{
   import flash.display.Loader;
   import flash.geom.Rectangle;
   import flash.system.ApplicationDomain;
   import flash.utils.ByteArray;
   import flash.system.LoaderContext;
   import flash.errors.IOError;
   import com.letv.aiLoader.errors.AIError;
   import com.letv.aiLoader.utils.DeCompress;
   import flash.events.IOErrorEvent;
   import flash.events.Event;
   import flash.utils.getTimer;
   import com.letv.aiLoader.events.AILoaderEvent;
   
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
         this.loaderGc(true);
         if(this.loader)
         {
            this.loader.unloadAndStop();
            this.loader.unload();
         }
         this.loader = null;
      }
      
      override public function get speed() : int
      {
         if(_stopTime > 0)
         {
            return int(_size / (_stopTime - _startTime));
         }
         return 0;
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
      
      override protected function request(param1:Boolean = false) : void
      {
         var context:LoaderContext = null;
         var retryFlag:Boolean = param1;
         super.request(retryFlag);
         _outTime = _firstOutTime + _gap * _retryTimes;
         _retryTimes++;
         var swfbytes:ByteArray = this.localbytes;
         if(swfbytes == null)
         {
            this.onOtherError();
            return;
         }
         this.loaderGc();
         try
         {
            if(!(swfbytes[0] == 67) && !(swfbytes[1] == 87) && !(swfbytes[2] == 83))
            {
               this.sendError("analyError",AIError.ANALY_ERROR);
               return;
            }
            if(!(swfbytes[0] == 90) && !(swfbytes[1] == 87) && !(swfbytes[2] == 83))
            {
               this.sendError("analyError",AIError.ANALY_ERROR);
               return;
            }
            if(swfbytes[0] == 90)
            {
               _hadCompress = "1";
               swfbytes = DeCompress.decodeSWF(swfbytes);
            }
         }
         catch(e:Error)
         {
            sendError("analyError",AIError.ANALY_ERROR);
            return;
         }
         if(this.loader == null)
         {
            this.loader = new Loader();
         }
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onComplete);
         try
         {
            context = new LoaderContext();
            context.applicationDomain = new ApplicationDomain();
            if(context.hasOwnProperty("allowCodeImport"))
            {
               context["allowCodeImport"] = true;
            }
            setDelay(true);
            _startTime = getTimer();
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
      }
      
      override protected function onDelay() : void
      {
         this.loaderGc(true);
         this.sendError("timeout",AIError.TIMEOUT_ERROR);
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
      
      private function onSecurityError(param1:Event = null) : void
      {
         this.loaderGc(true);
         this.sendError("securityError",AIError.SECURITY_ERROR);
      }
      
      private function onComplete(param1:Event) : void
      {
         var ev:AILoaderEvent = null;
         var event:Event = param1;
         try
         {
            _size = this.loader.contentLoaderInfo.bytesLoaded;
         }
         catch(e:Error)
         {
            _size = 0;
         }
         _stopTime = getTimer();
         try
         {
            _originalRect = new Rectangle(0,0,this.loader.width,this.loader.height);
            _hadUsed = true;
            ev = new AILoaderEvent(AILoaderEvent.LOAD_COMPLETE,resourceType,index,_retryTimes);
            ev.dataProvider = this;
            dispatchEvent(ev);
         }
         catch(e:Error)
         {
            sendError("analyError",AIError.ANALY_ERROR);
            return;
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
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onComplete);
         }
      }
   }
}
