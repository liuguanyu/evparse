package org.puremvc.as3.interfaces
{
   public interface IMediator
   {
      
      function getMediatorName() : String;
      
      function getViewComponent() : Object;
      
      function setViewComponent(param1:Object) : void;
      
      function listNotificationInterests() : Array;
      
      function handleNotification(param1:INotification) : void;
      
      function onRegister() : void;
      
      function onRemove() : void;
   }
}
