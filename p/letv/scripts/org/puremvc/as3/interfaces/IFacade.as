package org.puremvc.as3.interfaces
{
   public interface IFacade extends INotifier
   {
      
      function registerProxy(param1:IProxy) : void;
      
      function retrieveProxy(param1:String) : IProxy;
      
      function removeProxy(param1:String) : IProxy;
      
      function hasProxy(param1:String) : Boolean;
      
      function registerCommand(param1:String, param2:Class) : void;
      
      function removeCommand(param1:String) : void;
      
      function hasCommand(param1:String) : Boolean;
      
      function registerMediator(param1:IMediator) : void;
      
      function retrieveMediator(param1:String) : IMediator;
      
      function removeMediator(param1:String) : IMediator;
      
      function hasMediator(param1:String) : Boolean;
      
      function notifyObservers(param1:INotification) : void;
   }
}
