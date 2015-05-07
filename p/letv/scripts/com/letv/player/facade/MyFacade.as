package com.letv.player.facade
{
   import org.puremvc.as3.patterns.facade.Facade;
   import com.letv.player.notify.InitNotify;
   import com.letv.player.controller.init.InitCreationCommand;
   
   public class MyFacade extends Facade
   {
      
      private static var _instance:MyFacade;
      
      public function MyFacade()
      {
         super();
      }
      
      public static function getInstance() : MyFacade
      {
         if(_instance == null)
         {
            _instance = new MyFacade();
         }
         return _instance;
      }
      
      override protected function initializeController() : void
      {
         super.initializeController();
         registerCommand(InitNotify.INIT_CREATION,InitCreationCommand);
      }
      
      public function startup(param1:Object) : void
      {
         sendNotification(InitNotify.INIT_CREATION,{
            "main":param1,
            "info":param1.loaderInfo.parameters
         });
      }
   }
}
