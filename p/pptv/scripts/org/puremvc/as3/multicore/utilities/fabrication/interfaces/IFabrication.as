package org.puremvc.as3.multicore.utilities.fabrication.interfaces
{
   import flash.events.IEventDispatcher;
   import org.puremvc.as3.multicore.utilities.fabrication.components.fabricator.ApplicationFabricator;
   
   public interface IFabrication extends IEventDispatcher, IRouterAwareModule
   {
      
      function get fabricator() : ApplicationFabricator;
      
      function get id() : String;
      
      function get config() : Object;
      
      function set config(param1:Object) : void;
      
      function initializeFabricator() : void;
      
      function getStartupCommand() : Class;
      
      function getClassByName(param1:String) : Class;
      
      function notifyFabricationCreated() : void;
      
      function notifyFabricationRemoved() : void;
      
      function get fabricationLoggerEnabled() : Boolean;
   }
}
