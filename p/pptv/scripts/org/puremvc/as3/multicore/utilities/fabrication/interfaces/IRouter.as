package org.puremvc.as3.multicore.utilities.fabrication.interfaces
{
   public interface IRouter extends IDisposable
   {
      
      function connect(param1:IRouterCable) : void;
      
      function disconnect(param1:IRouterCable) : void;
      
      function route(param1:IRouterMessage) : void;
      
      function install(param1:IRouterFirewall) : void;
   }
}
