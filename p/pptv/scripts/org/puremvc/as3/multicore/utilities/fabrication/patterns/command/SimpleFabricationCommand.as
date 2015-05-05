package org.puremvc.as3.multicore.utilities.fabrication.patterns.command
{
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.ICommandProcessor;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
   import org.puremvc.as3.multicore.interfaces.ICommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.facade.FabricationFacade;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IFabrication;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouter;
   import org.puremvc.as3.multicore.interfaces.IProxy;
   import org.puremvc.as3.multicore.interfaces.IMediator;
   import org.puremvc.as3.multicore.utilities.fabrication.injection.ProxyInjector;
   import org.puremvc.as3.multicore.utilities.fabrication.injection.MediatorInjector;
   
   public class SimpleFabricationCommand extends SimpleCommand implements ICommandProcessor, IDisposable
   {
      
      protected var injectionFieldsNames:Array;
      
      public function SimpleFabricationCommand()
      {
         super();
      }
      
      public function executeCommand(param1:Class, param2:Object = null, param3:INotification = null) : ICommand
      {
         return this.fabFacade.executeCommandClass(param1,param2,param3);
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         this.performInjections();
      }
      
      public function dispose() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:* = 0;
         var _loc3_:String = null;
         if(this.injectionFieldsNames)
         {
            _loc1_ = this.injectionFieldsNames.length;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc3_ = "" + this.injectionFieldsNames[_loc2_];
               this[_loc3_] = null;
               _loc2_++;
            }
            this.injectionFieldsNames = null;
         }
      }
      
      public function get fabFacade() : FabricationFacade
      {
         return facade as FabricationFacade;
      }
      
      public function get fabrication() : IFabrication
      {
         return this.fabFacade.getFabrication();
      }
      
      public function get applicationRouter() : IRouter
      {
         return this.fabrication.router;
      }
      
      public function registerCommand(param1:String, param2:Class) : void
      {
         facade.registerCommand(param1,param2);
      }
      
      public function removeCommand(param1:String) : void
      {
         facade.removeCommand(param1);
      }
      
      public function hasCommand(param1:String) : Boolean
      {
         return facade.hasCommand(param1);
      }
      
      public function registerProxy(param1:IProxy) : IProxy
      {
         facade.registerProxy(param1);
         return param1;
      }
      
      public function retrieveProxy(param1:String) : IProxy
      {
         return facade.retrieveProxy(param1);
      }
      
      public function removeProxy(param1:String) : IProxy
      {
         return facade.removeProxy(param1);
      }
      
      public function hasProxy(param1:String) : Boolean
      {
         return facade.hasProxy(param1);
      }
      
      public function registerMediator(param1:IMediator) : IMediator
      {
         facade.registerMediator(param1);
         return param1;
      }
      
      public function retrieveMediator(param1:String) : IMediator
      {
         return facade.retrieveMediator(param1) as IMediator;
      }
      
      public function removeMediator(param1:String) : IMediator
      {
         return facade.removeMediator(param1);
      }
      
      public function hasMediator(param1:String) : Boolean
      {
         return facade.hasMediator(param1);
      }
      
      public function notifyObservers(param1:INotification) : void
      {
         this.fabFacade.notifyObservers(param1);
      }
      
      public function routeNotification(param1:Object, param2:Object = null, param3:String = null, param4:Object = null) : void
      {
         this.fabFacade.routeNotification(param1,param2,param3,param4);
      }
      
      public function registerInterceptor(param1:String, param2:Class, param3:Object = null) : void
      {
         this.fabFacade.registerInterceptor(param1,param2,param3);
      }
      
      public function removeInterceptor(param1:String, param2:Class = null) : void
      {
         this.fabFacade.removeInterceptor(param1,param2);
      }
      
      protected function performInjections() : void
      {
         this.injectionFieldsNames = [];
         this.injectionFieldsNames = this.injectionFieldsNames.concat(new ProxyInjector(this.fabFacade,this).inject());
         this.injectionFieldsNames = this.injectionFieldsNames.concat(new MediatorInjector(this.fabFacade,this).inject());
      }
   }
}
