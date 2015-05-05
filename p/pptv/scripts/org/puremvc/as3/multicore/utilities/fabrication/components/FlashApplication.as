package org.puremvc.as3.multicore.utilities.fabrication.components
{
   import flash.display.MovieClip;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication;
   import org.puremvc.as3.multicore.utilities.fabrication.components.fabricator.FlashApplicationFabricator;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IModuleAddress;
   import org.puremvc.as3.multicore.utilities.fabrication.components.fabricator.ApplicationFabricator;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouter;
   import flash.utils.getDefinitionByName;
   import org.puremvc.as3.multicore.utilities.fabrication.events.FabricatorEvent;
   
   public class FlashApplication extends MovieClip implements IFabrication
   {
      
      protected var _fabricator:FlashApplicationFabricator;
      
      protected var _defaultRouteAddress:IModuleAddress;
      
      protected var _config:Object;
      
      public function FlashApplication()
      {
         super();
         this.initializeFabricator();
      }
      
      public function dispose() : void
      {
         this._fabricator.dispose();
         this._fabricator = null;
      }
      
      public function get fabricator() : ApplicationFabricator
      {
         return this._fabricator;
      }
      
      public function get moduleAddress() : IModuleAddress
      {
         return this.fabricator.moduleAddress;
      }
      
      public function get defaultRoute() : String
      {
         return this.fabricator.defaultRoute;
      }
      
      public function set defaultRoute(param1:String) : void
      {
         this.fabricator.defaultRoute = param1;
      }
      
      public function get defaultRouteAddress() : IModuleAddress
      {
         return this._defaultRouteAddress;
      }
      
      public function set defaultRouteAddress(param1:IModuleAddress) : void
      {
         this._defaultRouteAddress = param1;
         this.defaultRoute = param1.getInputName();
      }
      
      public function set router(param1:IRouter) : void
      {
         this.fabricator.router = param1;
      }
      
      public function get router() : IRouter
      {
         return this.fabricator.router;
      }
      
      public function get moduleGroup() : String
      {
         return this.fabricator.moduleGroup;
      }
      
      public function set moduleGroup(param1:String) : void
      {
         this.fabricator.moduleGroup = param1;
      }
      
      public function get config() : Object
      {
         return this._config;
      }
      
      public function set config(param1:Object) : void
      {
         this._config = param1;
      }
      
      public function initializeFabricator() : void
      {
         this._fabricator = new FlashApplicationFabricator(this);
      }
      
      public function getStartupCommand() : Class
      {
         return null;
      }
      
      public function getClassByName(param1:String) : Class
      {
         return getDefinitionByName(param1) as Class;
      }
      
      public function get id() : String
      {
         return name;
      }
      
      public function notifyFabricationCreated() : void
      {
         dispatchEvent(new FabricatorEvent(FabricatorEvent.FABRICATION_CREATED));
      }
      
      public function notifyFabricationRemoved() : void
      {
         dispatchEvent(new FabricatorEvent(FabricatorEvent.FABRICATION_REMOVED));
      }
      
      public function get fabricationLoggerEnabled() : Boolean
      {
         return false;
      }
   }
}
