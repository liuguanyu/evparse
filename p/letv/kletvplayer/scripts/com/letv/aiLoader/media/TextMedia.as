package com.letv.aiLoader.media
{
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.errors.IOError;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLRequestMethod;
   import flash.utils.getTimer;
   import com.letv.aiLoader.errors.AIError;
   import com.letv.aiLoader.events.AILoaderEvent;
   
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
         this.gc();
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
         var r:URLRequest = null;
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
            this.onIOError();
            return;
         }
         this.gc();
         this.loader = new URLLoader();
         this.loader.addEventListener(Event.COMPLETE,this.onComplete);
         this.loader.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         this.loader.addEventListener(ProgressEvent.PROGRESS,this.onProgress);
         this.loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
         try
         {
            r = new URLRequest(newurl);
            if(post)
            {
               r.method = URLRequestMethod.POST;
               r.data = post;
            }
            setDelay(true);
            _startTime = getTimer();
            this.loader.load(r);
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
      }
      
      override protected function onDelay() : void
      {
         this.gc();
         this.sendError("timeout",AIError.TIMEOUT_ERROR);
      }
      
      private function onIOError(param1:IOErrorEvent = null) : void
      {
         this.gc();
         this.sendError("ioError",AIError.IO_ERROR);
      }
      
      private function onSecurityError(param1:SecurityErrorEvent = null) : void
      {
         this.gc();
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
         var ev:AILoaderEvent = null;
         var event:Event = param1;
         _stopTime = getTimer();
         _size = this.loader.bytesTotal;
         try
         {
            this.loadContent = event.target.data;
            this.gc();
            _hadUsed = true;
            ev = new AILoaderEvent(AILoaderEvent.LOAD_COMPLETE,resourceType,index,_retryTimes);
            ev.dataProvider = this;
            dispatchEvent(ev);
         }
         catch(e:Error)
         {
            gc();
            sendError("otherError",AIError.ANALY_ERROR);
         }
      }
      
      protected function sendState(param1:String, param2:int = 0) : void
      {
         var _loc3_:AILoaderEvent = new AILoaderEvent(AILoaderEvent.LOAD_STATE_CHANGE,resourceType,index,_retryTimes);
         _loc3_.dataProvider = this;
         _loc3_.infoCode = param1;
         _loc3_.errorCode = param2;
         dispatchEvent(_loc3_);
      }
      
      protected function sendError(param1:String, param2:int = 0) : void
      {
         var _loc3_:AILoaderEvent = null;
         _stopTime = getTimer();
         if(_retryTimes == _retryMax)
         {
            this.destroy();
            _hadError = true;
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
      
      private function gc() : void
      {
         try
         {
            setDelay(false);
            setDelayRetry(false);
            this.loader.removeEventListener(Event.COMPLETE,this.onComplete);
            this.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
            this.loader.removeEventListener(ProgressEvent.PROGRESS,this.onProgress);
            this.loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
            this.loader.close();
         }
         catch(e:Error)
         {
         }
         this.loader = null;
      }
   }
}
