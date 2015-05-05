package org.puremvc.as3.multicore.utilities.fabrication.patterns.observer
{
   import org.puremvc.as3.multicore.patterns.observer.Notification;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterNotification;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterMessageStore;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterMessage;
   
   public class RouterNotification extends Notification implements IRouterNotification, IRouterMessageStore, IDisposable
   {
      
      public static const SEND_MESSAGE_VIA_ROUTER:String = "sendMessageViaRouter";
      
      public static const RECEIVED_MESSAGE_VIA_ROUTER:String = "receivedMessageViaRouter";
      
      protected var message:IRouterMessage;
      
      public function RouterNotification(param1:String, param2:Object = null, param3:String = null, param4:IRouterMessage = null)
      {
         super(param1,param2,param3);
         this.setMessage(param4);
      }
      
      public function getMessage() : IRouterMessage
      {
         return this.message;
      }
      
      public function setMessage(param1:IRouterMessage) : void
      {
         this.message = param1;
      }
      
      public function dispose() : void
      {
         this.setMessage(null);
         setBody(null);
         setType(null);
      }
   }
}
