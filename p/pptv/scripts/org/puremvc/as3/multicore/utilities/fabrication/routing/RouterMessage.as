package org.puremvc.as3.multicore.utilities.fabrication.routing
{
   import org.puremvc.as3.multicore.utilities.pipes.messages.Message;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterMessage;
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.TransportNotification;
   
   public class RouterMessage extends Message implements IRouterMessage
   {
      
      private var from:String;
      
      private var to:String;
      
      private var notification:TransportNotification;
      
      public function RouterMessage(param1:String, param2:Object = null, param3:String = null, param4:String = null, param5:TransportNotification = null)
      {
         super(param1,null,param2);
         this.setFrom(param3);
         this.setTo(param4);
         this.setNotification(param5);
      }
      
      public function dispose() : void
      {
         this.setFrom(null);
         this.setTo(null);
         setBody(null);
         setType(null);
         setHeader(null);
      }
      
      public function getFrom() : String
      {
         return this.from;
      }
      
      public function setFrom(param1:String) : void
      {
         this.from = param1;
      }
      
      public function getTo() : String
      {
         return this.to;
      }
      
      public function setTo(param1:String) : void
      {
         this.to = param1;
      }
      
      public function getNotification() : TransportNotification
      {
         return this.notification;
      }
      
      public function setNotification(param1:TransportNotification) : void
      {
         this.notification = param1;
      }
   }
}
