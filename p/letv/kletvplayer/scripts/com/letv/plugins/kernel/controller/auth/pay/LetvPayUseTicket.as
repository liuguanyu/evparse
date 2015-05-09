package com.letv.plugins.kernel.controller.auth.pay
{
   import flash.events.EventDispatcher;
   import com.alex.rpc.AutoLoader;
   import com.alex.rpc.events.AutoLoaderEvent;
   import com.letv.plugins.kernel.Kernel;
   import com.alex.rpc.type.ResourceType;
   import com.alex.utils.JSONUtil;
   import flash.events.Event;
   
   public class LetvPayUseTicket extends EventDispatcher
   {
      
      private static var _instance:LetvPayUseTicket;
      
      private var _loader:AutoLoader;
      
      private var _successFunction:Function;
      
      private var _failedFunction:Function;
      
      public function LetvPayUseTicket()
      {
         super();
      }
      
      public static function getInstance() : LetvPayUseTicket
      {
         if(_instance == null)
         {
            _instance = new LetvPayUseTicket();
         }
         return _instance;
      }
      
      public function useTicket(param1:String, param2:Function, param3:Function) : void
      {
         this.loaderGc();
         this._successFunction = param2;
         this._failedFunction = param3;
         if(param1 != null)
         {
            this._loader = new AutoLoader();
            this._loader.addEventListener(AutoLoaderEvent.LOAD_ERROR,this.onUseTicketError);
            this._loader.addEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.onUseTicketSuccess);
            Kernel.sendLog(this + " useTicket " + param1);
            this._loader.setup([{
               "type":ResourceType.TEXT,
               "url":param1
            }]);
         }
         else
         {
            this.onUseTicketError();
         }
      }
      
      private function onUseTicketError(param1:AutoLoaderEvent = null) : void
      {
         var event:AutoLoaderEvent = param1;
         Kernel.sendLog(this + " onUseTicketError");
         this.loaderGc();
         try
         {
            this._failedFunction();
         }
         catch(e:Error)
         {
         }
         this._successFunction = null;
         this._failedFunction = null;
      }
      
      private function onUseTicketSuccess(param1:AutoLoaderEvent) : void
      {
         var obj:Object = null;
         var event:AutoLoaderEvent = param1;
         var status:String = "0";
         try
         {
            Kernel.sendLog(this + " onUseTicketSuccess " + event.dataProvider.content);
            obj = JSONUtil.decode(String(event.dataProvider.content));
            if(obj.hasOwnProperty("status"))
            {
               status = String(obj["status"]);
            }
         }
         catch(e:Error)
         {
         }
         if(status == "1")
         {
            this.loaderGc();
            dispatchEvent(new Event(Event.COMPLETE));
            try
            {
               this._successFunction();
            }
            catch(e:Error)
            {
            }
         }
         else
         {
            this.onUseTicketError();
         }
         this._successFunction = null;
         this._failedFunction = null;
      }
      
      private function loaderGc() : void
      {
         if(this._loader != null)
         {
            this._loader.removeEventListener(AutoLoaderEvent.LOAD_ERROR,this.onUseTicketError);
            this._loader.removeEventListener(AutoLoaderEvent.LOAD_COMPLETE,this.onUseTicketSuccess);
            this._loader.destroy();
            this._loader = null;
         }
      }
   }
}
