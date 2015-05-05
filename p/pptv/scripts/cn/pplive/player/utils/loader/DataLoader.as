package cn.pplive.player.utils.loader
{
   import flash.events.EventDispatcher;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.events.Event;
   import flash.events.ProgressEvent;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class DataLoader extends EventDispatcher
   {
      
      private var _loader:URLLoader;
      
      private var _content;
      
      private var _timeout:Number;
      
      private var _request:URLRequest;
      
      private var _timeInter:uint;
      
      private var _errorMsg:String = "";
      
      private var _param;
      
      public function DataLoader(param1:URLRequest, param2:Number = 5, param3:String = "text")
      {
         var request:URLRequest = param1;
         var timeout:Number = param2;
         var dataFormat:String = param3;
         super();
         this._timeout = timeout;
         this._request = request;
         if(!this._request)
         {
            this.sendEvent("_ioerror_");
            return;
         }
         try
         {
            this._loader = new URLLoader();
            this._loader.dataFormat = dataFormat;
            this._loader.load(this._request);
            this.addEvent();
         }
         catch(evt:Error)
         {
            sendEvent("_ioerror_");
         }
         this._timeInter = setTimeout(this.onTimeout,this._timeout * 1000);
      }
      
      public function get param() : *
      {
         return this._param;
      }
      
      public function set param(param1:*) : void
      {
         this._param = param1;
      }
      
      private function addEvent() : void
      {
         this._loader.addEventListener(Event.COMPLETE,this.onCompleteHandler);
         this._loader.addEventListener(ProgressEvent.PROGRESS,this.onProgressHandler);
         this._loader.addEventListener(IOErrorEvent.IO_ERROR,this.onIOErrorHandler);
         this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityErrorHandler);
      }
      
      private function onCompleteHandler(param1:Event) : void
      {
         this._content = param1.target.data;
         this.sendEvent("_complete_");
         this.delEvent();
      }
      
      private function onProgressHandler(param1:ProgressEvent) : void
      {
         this.sendEvent("_progress_");
      }
      
      private function onIOErrorHandler(param1:IOErrorEvent) : void
      {
         this._errorMsg = param1.toString() + "  [ url=" + this._request.url + " ]";
         this.sendEvent("_ioerror_");
      }
      
      private function onSecurityErrorHandler(param1:SecurityErrorEvent) : void
      {
         this._errorMsg = param1.toString() + "  [ url=" + this._request.url + " ]";
         this.sendEvent("_securityerror_");
      }
      
      private function onTimeout() : void
      {
         this._errorMsg = "[type=\"timeout\" timeout=\"" + this._timeout * 1000 + "\" url=\"" + this._request.url + "\" ]";
         this.sendEvent("_timeout_");
         this.clear();
      }
      
      private function delEvent() : void
      {
         if(this._loader)
         {
            this._loader.removeEventListener(Event.COMPLETE,this.onCompleteHandler);
            this._loader.removeEventListener(ProgressEvent.PROGRESS,this.onProgressHandler);
            this._loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onIOErrorHandler);
            this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityErrorHandler);
         }
         if(this._timeInter)
         {
            clearTimeout(this._timeInter);
         }
      }
      
      private function sendEvent(param1:String) : void
      {
         dispatchEvent(new Event(param1));
      }
      
      public function clear() : void
      {
         if(this._loader)
         {
            this.delEvent();
            try
            {
               this._loader["close"]();
            }
            catch(evt:Error)
            {
            }
            this._loader = null;
         }
      }
      
      public function get content() : *
      {
         return this._content;
      }
      
      public function get errorMsg() : String
      {
         return this._errorMsg;
      }
   }
}
