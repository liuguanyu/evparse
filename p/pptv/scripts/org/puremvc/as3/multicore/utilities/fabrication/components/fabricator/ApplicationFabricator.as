package org.puremvc.as3.multicore.utilities.fabrication.components.fabricator
{
   import flash.events.EventDispatcher;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterAwareModule;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication;
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.FabricationFacade;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IModuleAddress;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouter;
   import org.puremvc.as3.multicore.utilities.fabrication.utils.NameUtils;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getDefinitionByName;
   import org.puremvc.as3.multicore.utilities.fabrication.vo.ModuleAddress;
   import flash.events.Event;
   
   public class ApplicationFabricator extends EventDispatcher implements IRouterAwareModule
   {
      
      protected var _fabrication:IFabrication;
      
      protected var _facade:FabricationFacade;
      
      protected var _defaultRoute:String;
      
      protected var _moduleAddress:IModuleAddress;
      
      protected var _startupCommand:Class;
      
      protected var _readyEventName:String;
      
      protected var _applicationClassName:String;
      
      protected var _applicationInstanceName:String;
      
      protected var _multitonKey:String;
      
      protected var _router:IRouter;
      
      protected var _moduleGroup:String = null;
      
      public function ApplicationFabricator(param1:IFabrication)
      {
         super();
         this._fabrication = param1;
         this._startupCommand = param1.getStartupCommand();
         param1.addEventListener(this.readyEventName,this.readyEventListener);
      }
      
      public function dispose() : void
      {
         if(this._facade != null)
         {
            this._facade.dispose();
            this._facade = null;
         }
         this._startupCommand = null;
         this._router = null;
         this.notifyFabricationRemoved();
         if(this._moduleAddress != null)
         {
            this._moduleAddress.dispose();
            this._moduleAddress = null;
         }
         this._moduleGroup = null;
         this._fabrication = null;
      }
      
      public function get id() : String
      {
         return this.fabrication.id;
      }
      
      public function get fabrication() : IFabrication
      {
         return this._fabrication;
      }
      
      public function get facade() : FabricationFacade
      {
         return this._facade;
      }
      
      public function get defaultRoute() : String
      {
         return this._defaultRoute;
      }
      
      public function set defaultRoute(param1:String) : void
      {
         this._defaultRoute = param1;
      }
      
      public function get moduleAddress() : IModuleAddress
      {
         return this._moduleAddress;
      }
      
      public function set moduleAddress(param1:IModuleAddress) : void
      {
         this._moduleAddress = param1;
      }
      
      public function get moduleGroup() : String
      {
         return this._moduleGroup;
      }
      
      public function set moduleGroup(param1:String) : void
      {
         this._moduleGroup = param1;
      }
      
      public function get multitonKey() : String
      {
         if(this._multitonKey == null)
         {
            this._multitonKey = this.applicationClassName + "/" + this.applicationInstanceName;
         }
         return this._multitonKey;
      }
      
      public function get startupCommand() : Class
      {
         return this._startupCommand;
      }
      
      public function get applicationClassName() : String
      {
         if(this._applicationClassName == null && !(this._startupCommand == null))
         {
            this._applicationClassName = FabricationFacade.calcApplicationName(this._startupCommand);
         }
         return this._applicationClassName;
      }
      
      public function get applicationInstanceName() : String
      {
         if(this._applicationInstanceName == null && !(this.applicationClassName == null))
         {
            this._applicationInstanceName = NameUtils.nextName(this.applicationClassName);
         }
         return this._applicationInstanceName;
      }
      
      public function set applicationInstanceName(param1:String) : void
      {
         this._applicationInstanceName = param1;
      }
      
      public function get router() : IRouter
      {
         return this._router;
      }
      
      public function set router(param1:IRouter) : void
      {
         this._router = param1;
      }
      
      protected function get readyEventName() : String
      {
         throw new Error("The readyEventName must be overridden by the concrete fabricator " + getQualifiedClassName(this));
      }
      
      protected function initializeFabricator() : void
      {
         var startupCommandClass:Class = null;
         if(this._startupCommand == null)
         {
            try
            {
               startupCommandClass = getDefinitionByName("org.puremvc.as3.multicore.utilities.fabrication.addons.module.EmptyFlexModuleStartupCommand") as Class;
               if(startupCommandClass != null)
               {
                  this._startupCommand = startupCommandClass;
               }
            }
            finally
            {
               if(this._startupCommand == null)
               {
                  throw new Error("Startup command class not found in getStartupCommand method in the main application class.");
               }
            }
         }
         if(this._startupCommand == null)
         {
            this.initializeModuleAddress();
            this.initializeFacade();
            this.initializeEnvironment();
            this.startApplication();
            return;
         }
         this.initializeModuleAddress();
         this.initializeFacade();
         this.initializeEnvironment();
         this.startApplication();
      }
      
      protected function initializeModuleAddress() : void
      {
         if(this._moduleAddress == null)
         {
            this._moduleAddress = new ModuleAddress(this.applicationClassName,this.applicationInstanceName);
         }
      }
      
      protected function initializeFacade() : void
      {
         this._facade = FabricationFacade.getInstance(this.multitonKey);
         this._facade.fabricationLoggerEnabled = this._fabrication.fabricationLoggerEnabled;
      }
      
      protected function initializeEnvironment() : void
      {
      }
      
      protected function startApplication() : void
      {
         this._facade.startup(this.startupCommand,this.fabrication);
         this.notifyFabricationCreated();
      }
      
      protected function readyEventListener(param1:Event) : void
      {
         this._fabrication.removeEventListener(this.readyEventName,this.readyEventListener);
         this.initializeFabricator();
      }
      
      protected function notifyFabricationCreated() : void
      {
         this.fabrication.notifyFabricationCreated();
      }
      
      protected function notifyFabricationRemoved() : void
      {
         this.fabrication.notifyFabricationRemoved();
      }
   }
}
