package org.puremvc.as3.multicore.utilities.fabrication.patterns.command.shutdown
{
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IModuleAddress;
   import org.puremvc.as3.multicore.utilities.fabrication.plumbing.NamedPipe;
   import org.puremvc.as3.multicore.utilities.fabrication.routing.RouterCable;
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.routing.ConfigureRouterCommand;
   import org.puremvc.as3.multicore.utilities.fabrication.routing.RouterCableListener;
   
   public class ApplicationShutdownCommand extends SimpleFabricationCommand
   {
      
      public function ApplicationShutdownCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:IModuleAddress = fabrication.moduleAddress;
         var _loc3_:NamedPipe = new NamedPipe(_loc2_.getInputName());
         var _loc4_:NamedPipe = new NamedPipe(_loc2_.getOutputName());
         var _loc5_:RouterCable = new RouterCable(_loc3_,_loc4_);
         var _loc6_:RouterCableListener = fabFacade.removeInstance(ConfigureRouterCommand.routerCableListenerKey) as RouterCableListener;
         _loc6_.dispose();
         applicationRouter.disconnect(_loc5_);
      }
   }
}
