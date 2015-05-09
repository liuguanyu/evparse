package com.alex.rpc.media
{
   import flash.display.Loader;
   import flash.geom.Rectangle;
   import flash.display.MovieClip;
   import flash.media.SoundTransform;
   import flash.system.LoaderContext;
   import flash.errors.IOError;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.Event;
   import flash.system.ApplicationDomain;
   import flash.net.URLRequest;
   import com.alex.rpc.type.StateType;
   import com.alex.rpc.errors.AutoError;
   import com.alex.rpc.events.AutoLoaderEvent;
   import flash.utils.getTimer;
   
   public class FlashMedia extends BaseMedia
   {
      
      private var loader:Loader;
      
      public function FlashMedia(param1:int = 0, param2:Object = null)
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
      
      override public function pause() : Boolean
      {
         try
         {
            MovieClip(this.loader.content).stop();
            return true;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      override public function resume() : Boolean
      {
         try
         {
            MovieClip(this.loader.content).play();
            return true;
         }
         catch(e:Error)
         {
         }
         return false;
      }
      
      override public function get content() : Object
      {
         return this.loader;
      }
      
      override public function set visible(param1:Boolean) : void
      {
         var value:Boolean = param1;
         try
         {
            this.loader.visible = value;
         }
         catch(e:Error)
         {
         }
      }
      
      override public function mute(param1:Number = 1) : void
      {
         var value:Number = param1;
         try
         {
            if(!(this.loader == null) && !(this.loader.content == null))
            {
               this.content.soundTransform = new SoundTransform(value);
            }
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
      
      override protected function request(param1:Boolean = false, param2:String = null) : String
      {
         var context:LoaderContext = null;
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
            this.loader = new Loader();
            this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
            this.loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
            this.loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onProgress);
            this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onComplete);
            context = new LoaderContext(checkPolicy);
            context.applicationDomain = applicationDomain?applicationDomain:new ApplicationDomain();
            setDelay(true);
            this.loader.load(new URLRequest(requesturl),context);
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
         if(_size == 0 && param1.bytesTotal > 0)
         {
            _size = param1.bytesTotal;
         }
         sendState(AutoLoaderEvent.LOAD_PROGRESS,"progress",-1,param1.bytesLoaded / param1.bytesTotal);
      }
      
      private function onComplete(param1:Event) : void
      {
         var event:Event = param1;
         _utime = getTimer() - _utime;
         this.loaderGc(false);
         try
         {
            _originalRect = new Rectangle(0,0,this.loader.width,this.loader.height);
            _hadUsed = true;
            sendState(AutoLoaderEvent.LOAD_COMPLETE);
         }
         catch(e:Error)
         {
            trace("--x Error From FlashMedia.onComplete.compressCheck",e.message);
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
      
      private function loaderGc(param1:Boolean = true) : void
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
            this.loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
            this.loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.onProgress);
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
