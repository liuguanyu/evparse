package org.puremvc.as3.interfaces
{
   public interface IModel
   {
      
      function registerProxy(param1:IProxy) : void;
      
      function retrieveProxy(param1:String) : IProxy;
      
      function removeProxy(param1:String) : IProxy;
      
      function hasProxy(param1:String) : Boolean;
   }
}
