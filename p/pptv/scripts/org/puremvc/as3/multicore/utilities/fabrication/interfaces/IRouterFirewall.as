package org.puremvc.as3.multicore.utilities.fabrication.interfaces
{
   public interface IRouterFirewall extends IDisposable
   {
      
      function process(param1:IRouterMessage) : IRouterMessage;
   }
}
