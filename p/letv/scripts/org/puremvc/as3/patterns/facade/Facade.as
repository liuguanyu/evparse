package org.puremvc.as3.patterns.facade
{
   import org.puremvc.as3.interfaces.IFacade;
   import org.puremvc.as3.core.Controller;
   import org.puremvc.as3.core.Model;
   import org.puremvc.as3.core.View;
   import org.puremvc.as3.interfaces.IProxy;
   import org.puremvc.as3.interfaces.IMediator;
   import org.puremvc.as3.patterns.observer.Notification;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.interfaces.IController;
   import org.puremvc.as3.interfaces.IModel;
   import org.puremvc.as3.interfaces.IView;
   
   public class Facade extends Object implements IFacade
   {
      
      protected static var instance:IFacade;
      
      protected var controller:IController;
      
      protected var model:IModel;
      
      protected var view:IView;
      
      protected const SINGLETON_MSG:String = "Facade Singleton already constructed!";
      
      public function Facade()
      {
         super();
         if(instance != null)
         {
            throw Error(this.SINGLETON_MSG);
         }
         else
         {
            instance = this;
            this.initializeFacade();
            return;
         }
      }
      
      public static function getInstance() : IFacade
      {
         if(instance == null)
         {
            instance = new Facade();
         }
         return instance;
      }
      
      protected function initializeFacade() : void
      {
         this.initializeModel();
         this.initializeController();
         this.initializeView();
      }
      
      protected function initializeController() : void
      {
         if(this.controller != null)
         {
            return;
         }
         this.controller = Controller.getInstance();
      }
      
      protected function initializeModel() : void
      {
         if(this.model != null)
         {
            return;
         }
         this.model = Model.getInstance();
      }
      
      protected function initializeView() : void
      {
         if(this.view != null)
         {
            return;
         }
         this.view = View.getInstance();
      }
      
      public function registerCommand(param1:String, param2:Class) : void
      {
         this.controller.registerCommand(param1,param2);
      }
      
      public function removeCommand(param1:String) : void
      {
         this.controller.removeCommand(param1);
      }
      
      public function hasCommand(param1:String) : Boolean
      {
         return this.controller.hasCommand(param1);
      }
      
      public function registerProxy(param1:IProxy) : void
      {
         this.model.registerProxy(param1);
      }
      
      public function retrieveProxy(param1:String) : IProxy
      {
         return this.model.retrieveProxy(param1);
      }
      
      public function removeProxy(param1:String) : IProxy
      {
         var _loc2_:IProxy = null;
         if(this.model != null)
         {
            _loc2_ = this.model.removeProxy(param1);
         }
         return _loc2_;
      }
      
      public function hasProxy(param1:String) : Boolean
      {
         return this.model.hasProxy(param1);
      }
      
      public function registerMediator(param1:IMediator) : void
      {
         if(this.view != null)
         {
            this.view.registerMediator(param1);
         }
      }
      
      public function retrieveMediator(param1:String) : IMediator
      {
         return this.view.retrieveMediator(param1) as IMediator;
      }
      
      public function removeMediator(param1:String) : IMediator
      {
         var _loc2_:IMediator = null;
         if(this.view != null)
         {
            _loc2_ = this.view.removeMediator(param1);
         }
         return _loc2_;
      }
      
      public function hasMediator(param1:String) : Boolean
      {
         return this.view.hasMediator(param1);
      }
      
      public function sendNotification(param1:String, param2:Object = null, param3:String = null) : void
      {
         this.notifyObservers(new Notification(param1,param2,param3));
      }
      
      public function notifyObservers(param1:INotification) : void
      {
         if(this.view != null)
         {
            this.view.notifyObservers(param1);
         }
      }
   }
}
