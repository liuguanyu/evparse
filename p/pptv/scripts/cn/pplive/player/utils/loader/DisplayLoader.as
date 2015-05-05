package cn.pplive.player.utils.loader
{
   import flash.events.EventDispatcher;
   import flash.display.Loader;
   import flash.system.LoaderContext;
   import flash.system.ApplicationDomain;
   import flash.net.URLRequest;
   import flash.errors.IllegalOperationError;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.display.AVM1Movie;
   import flash.utils.clearTimeout;
   import flash.display.LoaderInfo;
   import flash.display.Bitmap;
   import flash.geom.Rectangle;
   import flash.utils.setTimeout;
   
   public class DisplayLoader extends EventDispatcher
   {
      
      private var _loader:Loader;
      
      private var _content;
      
      private var _url:String;
      
      private var _timeout:Number;
      
      private var _timeInter:uint;
      
      private var context:LoaderContext;
      
      public function DisplayLoader(param1:String, param2:Number = 5)
      {
         super();
         this._url = param1;
         this._timeout = param2;
         if(!this._url)
         {
            this.disPatchEvent("_ioerror_");
            return;
         }
         this._loader = new Loader();
         this.load(this._url);
         this.addEvent();
         this._timeInter = setTimeout(this.contentTimeout,this._timeout * 1000);
      }
      
      private function load(param1:String) : void
      {
         this.context = new LoaderContext();
         this.context.applicationDomain = ApplicationDomain.currentDomain;
         this.context.checkPolicyFile = true;
         this._loader.load(new URLRequest(param1),this.context);
      }
      
      public function getClass(param1:String) : Class
      {
         var className:String = param1;
         try
         {
            return this._loader.contentLoaderInfo.applicationDomain.getDefinition(className) as Class;
         }
         catch(evt:Error)
         {
            throw new IllegalOperationError(className + " definition not found in " + _url);
         }
         return null;
      }
      
      private function addEvent() : void
      {
         this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onCompleteHandler);
         this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIOErrorHandler);
         this._loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityErrorHandler);
      }
      
      private function onCompleteHandler(param1:Event) : void
      {
         var e:Event = param1;
         try
         {
            this._content = e.target.content;
            if(this._content as AVM1Movie)
            {
               this._content = this._loader;
            }
         }
         catch(evt:Error)
         {
            if(evt.errorID == 2123)
            {
               disPatchEvent("_securityerror_");
               return;
            }
            _content = _loader;
         }
         this.disPatchEvent("_complete_");
         this.delEvent();
      }
      
      private function onIOErrorHandler(param1:IOErrorEvent) : void
      {
         this.disPatchEvent("_ioerror_");
      }
      
      private function onSecurityErrorHandler(param1:SecurityErrorEvent) : void
      {
         this.disPatchEvent("_securityerror_");
      }
      
      private function contentTimeout() : void
      {
         this.disPatchEvent("_timeout_");
         this.clear();
      }
      
      private function delEvent() : void
      {
         if(this._loader)
         {
            this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onCompleteHandler);
            this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOErrorHandler);
            this._loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityErrorHandler);
         }
         if(this._timeInter)
         {
            clearTimeout(this._timeInter);
         }
      }
      
      private function disPatchEvent(param1:String) : void
      {
         this.dispatchEvent(new Event(param1));
      }
      
      public function resize(param1:Number, param2:Number, param3:Boolean = false) : void
      {
         var _loc4_:* = NaN;
         var _loc5_:LoaderInfo = null;
         var _loc6_:* = NaN;
         var _loc7_:* = NaN;
         var _loc8_:* = false;
         var _loc9_:* = NaN;
         if(this._content)
         {
            if((this._content is Bitmap || this._content is Loader) && !param3)
            {
               _loc4_ = this._content.width / this._content.height;
               if(param1 / param2 > _loc4_)
               {
                  this._content.height = param2;
                  this._content.width = Math.round(this._content.height * _loc4_);
               }
               else
               {
                  this._content.width = param1;
                  this._content.height = Math.round(this._content.width / _loc4_);
               }
               this._content.x = Math.round((param1 - this._content.width) / 2);
               this._content.y = Math.round((param2 - this._content.height) / 2);
            }
            else if(this._loader)
            {
               _loc5_ = this._loader.contentLoaderInfo as LoaderInfo;
               _loc6_ = _loc5_.width;
               _loc7_ = _loc5_.height;
               _loc4_ = _loc6_ / _loc7_;
               _loc8_ = _loc4_ > param1 / param2;
               _loc9_ = _loc8_?param1 / _loc6_:param2 / _loc7_;
               this._content.scaleX = this._content.scaleY = _loc9_;
               this._content.scrollRect = new Rectangle(0,0,_loc6_,_loc7_);
               this._content.x = 0;
               this._content.y = 0;
               if(_loc8_)
               {
                  this._content.y = (param2 - param1 / _loc4_) / 2;
               }
               else
               {
                  this._content.x = (param1 - _loc4_ * param2) / 2;
               }
            }
            
         }
      }
      
      public function clear() : void
      {
         this.delEvent();
         if(this._loader)
         {
            try
            {
               this._loader["unloadAndStop"]();
            }
            catch(evt:Error)
            {
               _loader["unload"]();
            }
            this._loader = null;
         }
      }
      
      public function get content() : *
      {
         return this._content;
      }
      
      public function get url() : String
      {
         return this._url;
      }
   }
}
