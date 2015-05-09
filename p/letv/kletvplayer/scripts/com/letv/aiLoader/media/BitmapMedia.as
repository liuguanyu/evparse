package com.letv.aiLoader.media
{
   import flash.display.Loader;
   import flash.geom.Rectangle;
   import flash.errors.IOError;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.Event;
   import flash.utils.getTimer;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   import com.letv.aiLoader.errors.AIError;
   import com.letv.aiLoader.events.AILoaderEvent;
   
   public class BitmapMedia extends BaseMedia
   {
      
      private var loader:Loader;
      
      public function BitmapMedia(param1:int = 0, param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function get rect() : Rectangle
      {
         try
         {
            return new Rectangle(0,0,this.content.width,this.content.height);
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
      
      override public function set visible(param1:Boolean) : void
      {
         var value:Boolean = param1;
         try
         {
            this.content.visible = value;
         }
         catch(e:Error)
         {
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.loaderGc();
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
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         this.loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
         this.loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onProgress);
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onComplete);
         try
         {
            setDelay(true);
            _startTime = getTimer();
            this.loader.load(new URLRequest(newurl),new LoaderContext(checkPolicy));
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
         if(_size == 0 && (param1.bytesTotal))
         {
            _size = param1.bytesTotal;
         }
         var _loc2_:AILoaderEvent = new AILoaderEvent(AILoaderEvent.LOAD_PROGRESS,resourceType,index,_retryTimes);
         _loc2_.infoCode = "progress";
         _loc2_.dataProvider = param1.bytesLoaded / param1.bytesTotal;
         dispatchEvent(_loc2_);
      }
      
      private function onComplete(param1:Event) : void
      {
         var ev:AILoaderEvent = null;
         var event:Event = param1;
         _stopTime = getTimer();
         this.loaderGc(false);
         try
         {
            _originalRect = new Rectangle(0,0,this.loader.width,this.loader.height);
            _hadUsed = true;
            ev = new AILoaderEvent(AILoaderEvent.LOAD_COMPLETE,resourceType,index,_retryTimes);
            ev.dataProvider = this;
            this.dispatchEvent(ev);
         }
         catch(e:Error)
         {
         }
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
      
      private function loaderGc(param1:Boolean = true) : void
      {
         var gc:Boolean = param1;
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
            this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
            this.loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
            this.loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.onProgress);
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onComplete);
         }
         if((gc) && (this.loader))
         {
            this.loader.unloadAndStop();
            this.loader.unload();
            this.loader = null;
         }
      }
   }
}
