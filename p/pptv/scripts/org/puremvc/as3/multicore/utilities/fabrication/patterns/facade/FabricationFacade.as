package org.puremvc.as3.multicore.utilities.fabrication.patterns.facade
{
   import org.puremvc.as3.multicore.patterns.facade.Facade;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
   import flash.utils.getQualifiedClassName;
   import org.puremvc.as3.multicore.utilities.fabrication.utils.HashMap;
   import org.puremvc.as3.multicore.utilities.fabrication.logging.FabricationLogger;
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.FabricationNotification;
   import org.puremvc.as3.multicore.utilities.fabrication.core.FabricationModel;
   import org.puremvc.as3.multicore.utilities.fabrication.core.FabricationView;
   import org.puremvc.as3.multicore.utilities.fabrication.core.FabricationController;
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.undoable.FabricationUndoCommand;
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.undoable.FabricationRedoCommand;
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.undoable.ChangeUndoGroupCommand;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication;
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.TransportNotification;
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.RouterNotification;
   import org.puremvc.as3.multicore.interfaces.ICommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.interfaces.IProxy;
   import org.puremvc.as3.multicore.interfaces.IMediator;
   
   public class FabricationFacade extends Facade implements IDisposable
   {
      
      protected var application:Object;
      
      protected var startupCommand:Class;
      
      protected var applicationName:String;
      
      protected var singletonInstanceMap:HashMap;
      
      public var logger:FabricationLogger;
      
      private var _fabricationLoggerEnabled:Boolean;
      
      public function FabricationFacade(param1:String)
      {
         this.logger = FabricationLogger.getInstance();
         super(param1);
         this.singletonInstanceMap = new HashMap();
      }
      
      public static function getInstance(param1:String) : FabricationFacade
      {
         if(instanceMap[param1] == null)
         {
            instanceMap[param1] = new FabricationFacade(param1);
         }
         return instanceMap[param1] as FabricationFacade;
      }
      
      public static function calcApplicationName(param1:Class = null) : String
      {
         var _loc2_:String = getQualifiedClassName(param1);
         var _loc3_:Array = _loc2_.split("::");
         var _loc4_:String = _loc3_[_loc3_.length - 1];
         _loc4_ = _loc4_.replace(new RegExp("StartupCommand"),"");
         _loc4_ = _loc4_.replace(new RegExp("Command"),"");
         if(_loc4_ == "")
         {
            throw new Error("StartupCommand must be of the form [ApplicationName]StartupCommand");
         }
         else
         {
            return _loc4_;
         }
      }
      
      public function dispose() : void
      {
         sendNotification(FabricationNotification.SHUTDOWN,this.getApplication());
         this.startupCommand = null;
         if(view is IDisposable)
         {
            (view as IDisposable).dispose();
         }
         if(controller is IDisposable)
         {
            (controller as IDisposable).dispose();
         }
         if(model is IDisposable)
         {
            (model as IDisposable).dispose();
         }
         this.singletonInstanceMap.dispose();
         this.singletonInstanceMap = null;
         removeCore(multitonKey);
      }
      
      override protected function initializeModel() : void
      {
         if(model != null)
         {
            return;
         }
         model = FabricationModel.getInstance(multitonKey);
      }
      
      override protected function initializeView() : void
      {
         if(view != null)
         {
            return;
         }
         view = FabricationView.getInstance(multitonKey);
         (view as FabricationView).controller = controller as FabricationController;
         (view as FabricationView).logger = this.logger;
      }
      
      override protected function initializeController() : void
      {
         if(controller != null)
         {
            return;
         }
         controller = FabricationController.getInstance(multitonKey);
         this.registerCommand(FabricationNotification.UNDO,FabricationUndoCommand);
         this.registerCommand(FabricationNotification.REDO,FabricationRedoCommand);
         this.registerCommand(FabricationNotification.CHANGE_UNDO_GROUP,ChangeUndoGroupCommand);
      }
      
      public function startup(param1:Class, param2:Object) : void
      {
         this.application = param2;
         this.startupCommand = param1;
         this.applicationName = calcApplicationName(param1);
         this.registerCommand(FabricationNotification.STARTUP,param1);
         sendNotification(FabricationNotification.STARTUP,param2);
         sendNotification(FabricationNotification.BOOTSTRAP,param2);
         if(this._fabricationLoggerEnabled)
         {
            this.logger.logFabricatorStart(this.getFabrication(),calcApplicationName(param1));
         }
      }
      
      public function get fabricationController() : FabricationController
      {
         return controller as FabricationController;
      }
      
      public function undo(param1:int = 1) : void
      {
         this.fabricationController.undo(param1);
      }
      
      public function redo(param1:int = 1) : void
      {
         this.fabricationController.redo(param1);
      }
      
      public function getApplication() : Object
      {
         return this.application;
      }
      
      public function getFabrication() : IFabrication
      {
         return this.application as IFabrication;
      }
      
      public function getApplicationName() : String
      {
         return this.applicationName;
      }
      
      public function getMultitonKey() : String
      {
         return multitonKey;
      }
      
      public function routeNotification(param1:Object, param2:Object = null, param3:String = null, param4:Object = null) : void
      {
         var _loc5_:TransportNotification = new TransportNotification(param1,param2,param3,param4);
         sendNotification(RouterNotification.SEND_MESSAGE_VIA_ROUTER,_loc5_);
      }
      
      public function executeCommandClass(param1:Class, param2:Object = null, param3:INotification = null) : ICommand
      {
         return this.fabricationController.executeCommandClass(param1,param2,param3);
      }
      
      public function saveInstance(param1:String, param2:Object) : Object
      {
         return this.singletonInstanceMap.put(param1,param2);
      }
      
      public function findInstance(param1:String) : Object
      {
         return this.singletonInstanceMap.find(param1);
      }
      
      public function hasInstance(param1:String) : Object
      {
         return this.singletonInstanceMap.exists(param1);
      }
      
      public function removeInstance(param1:String) : Object
      {
         return this.singletonInstanceMap.remove(param1);
      }
      
      public function registerInterceptor(param1:String, param2:Class, param3:Object = null) : void
      {
         this.fabricationController.registerInterceptor(param1,param2,param3);
         if(this._fabricationLoggerEnabled)
         {
            this.logger.logInterceptorRegistration(param2,param1,param3);
         }
      }
      
      public function removeInterceptor(param1:String, param2:Class = null) : void
      {
         this.fabricationController.removeInterceptor(param1,param2);
      }
      
      override public function registerProxy(param1:IProxy) : void
      {
         super.registerProxy(param1);
         if(this._fabricationLoggerEnabled)
         {
            this.logger.logProxyRegistration(param1);
         }
      }
      
      override public function registerMediator(param1:IMediator) : void
      {
         super.registerMediator(param1);
         if(this._fabricationLoggerEnabled)
         {
            this.logger.logMediatorRegistration(param1);
         }
      }
      
      override public function registerCommand(param1:String, param2:Class) : void
      {
         super.registerCommand(param1,param2);
         if(this._fabricationLoggerEnabled)
         {
            if(param1 != FabricationNotification.STARTUP)
            {
               this.logger.logCommandRegistration(param2,param1);
            }
         }
      }
      
      public function set fabricationLoggerEnabled(param1:Boolean) : void
      {
         this._fabricationLoggerEnabled = param1;
      }
   }
}
