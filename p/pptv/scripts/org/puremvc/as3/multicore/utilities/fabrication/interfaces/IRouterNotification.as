package org.puremvc.as3.multicore.utilities.fabrication.interfaces
{
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public interface IRouterNotification extends INotification
   {
      
      function getMessage() : IRouterMessage;
      
      function setMessage(param1:IRouterMessage) : void;
   }
}
