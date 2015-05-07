package org.puremvc.as3.core
{
   import org.puremvc.as3.interfaces.*;
   import org.puremvc.as3.patterns.observer.*;
   
   public class Controller extends Object implements IController
   {
      
      protected static var instance:IController;
      
      protected var view:IView;
      
      protected var commandMap:Array;
      
      protected const SINGLETON_MSG:String = "Controller Singleton already constructed!";
      
      public function Controller()
      {
         super();
         if(instance != null)
         {
            throw Error(this.SINGLETON_MSG);
         }
         else
         {
            instance = this;
            this.commandMap = new Array();
            this.initializeController();
            return;
         }
      }
      
      public static function getInstance() : IController
      {
         if(instance == null)
         {
            instance = new Controller();
         }
         return instance;
      }
      
      protected function initializeController() : void
      {
         this.view = View.getInstance();
      }
      
      public function executeCommand(param1:INotification) : void
      {
         var _loc2_:Class = this.commandMap[param1.getName()];
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:ICommand = new _loc2_();
         _loc3_.execute(param1);
      }
      
      public function registerCommand(param1:String, param2:Class) : void
      {
         if(this.commandMap[param1] == null)
         {
            this.view.registerObserver(param1,new Observer(this.executeCommand,this));
         }
         this.commandMap[param1] = param2;
      }
      
      public function hasCommand(param1:String) : Boolean
      {
         return !(this.commandMap[param1] == null);
      }
      
      public function removeCommand(param1:String) : void
      {
         if(this.hasCommand(param1))
         {
            this.view.removeObserver(param1,this);
            this.commandMap[param1] = null;
         }
      }
   }
}
