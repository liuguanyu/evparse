package org.puremvc.as3.multicore.utilities.fabrication.patterns.command.startup
{
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.FabricationNotification;
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.shutdown.ApplicationShutdownCommand;
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.RouterNotification;
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.routing.RouteMessageCommand;
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.routing.RouteNotificationCommand;
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.routing.ConfigureRouterCommand;
   
   public class ModuleStartupCommand extends SimpleFabricationCommand
   {
      
      public function ModuleStartupCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         registerCommand(FabricationNotification.SHUTDOWN,ApplicationShutdownCommand);
         registerCommand(RouterNotification.RECEIVED_MESSAGE_VIA_ROUTER,RouteMessageCommand);
         registerCommand(RouterNotification.SEND_MESSAGE_VIA_ROUTER,RouteNotificationCommand);
         executeCommand(ConfigureRouterCommand,fabrication.router);
      }
   }
}
