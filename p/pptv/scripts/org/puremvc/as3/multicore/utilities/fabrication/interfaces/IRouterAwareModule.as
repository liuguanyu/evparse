package org.puremvc.as3.multicore.utilities.fabrication.interfaces
{
   public interface IRouterAwareModule extends IRouterAware, IDisposable
   {
      
      function get moduleAddress() : IModuleAddress;
      
      function get defaultRoute() : String;
      
      function set defaultRoute(param1:String) : void;
      
      function get moduleGroup() : String;
      
      function set moduleGroup(param1:String) : void;
   }
}
