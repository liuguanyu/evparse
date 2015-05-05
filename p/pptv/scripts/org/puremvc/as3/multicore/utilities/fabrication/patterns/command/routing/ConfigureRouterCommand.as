package org.puremvc.as3.multicore.utilities.fabrication.patterns.command.routing
{
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouter;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IModuleAddress;
   import org.puremvc.as3.multicore.utilities.fabrication.plumbing.NamedPipe;
   import org.puremvc.as3.multicore.utilities.fabrication.routing.RouterCableListener;
   import org.puremvc.as3.multicore.utilities.fabrication.routing.RouterCable;
   
   public class ConfigureRouterCommand extends SimpleFabricationCommand
   {
      
      public static var routerCableListenerKey:String = "routerCableListener";
      
      public function ConfigureRouterCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:IRouter = param1.getBody() as IRouter;
         var _loc3_:IModuleAddress = fabrication.moduleAddress;
         var _loc4_:NamedPipe = new NamedPipe(_loc3_.getInputName());
         var _loc5_:NamedPipe = new NamedPipe(_loc3_.getOutputName());
         var _loc6_:RouterCableListener = new RouterCableListener(facade);
         var _loc7_:RouterCable = new RouterCable(_loc4_,_loc5_);
         _loc4_.moduleGroup = fabrication.moduleGroup;
         _loc5_.moduleGroup = fabrication.moduleGroup;
         _loc4_.connect(_loc6_);
         _loc2_.connect(_loc7_);
         fabFacade.saveInstance(routerCableListenerKey,_loc6_);
      }
   }
}
