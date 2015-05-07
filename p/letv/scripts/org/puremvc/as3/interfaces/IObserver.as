package org.puremvc.as3.interfaces
{
   public interface IObserver
   {
      
      function setNotifyMethod(param1:Function) : void;
      
      function setNotifyContext(param1:Object) : void;
      
      function notifyObserver(param1:INotification) : void;
      
      function compareNotifyContext(param1:Object) : Boolean;
   }
}
