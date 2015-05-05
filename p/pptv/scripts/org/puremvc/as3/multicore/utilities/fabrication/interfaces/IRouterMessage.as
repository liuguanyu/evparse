package org.puremvc.as3.multicore.utilities.fabrication.interfaces
{
   import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.TransportNotification;
   
   public interface IRouterMessage extends IPipeMessage, IDisposable
   {
      
      function getFrom() : String;
      
      function setFrom(param1:String) : void;
      
      function getTo() : String;
      
      function setTo(param1:String) : void;
      
      function setNotification(param1:TransportNotification) : void;
      
      function getNotification() : TransportNotification;
   }
}
