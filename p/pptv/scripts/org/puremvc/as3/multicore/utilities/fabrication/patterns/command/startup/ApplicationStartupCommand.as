package org.puremvc.as3.multicore.utilities.fabrication.patterns.command.startup
{
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.RouterNotification;
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.routing.RouteMessageCommand;
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.routing.RouteNotificationCommand;
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.routing.ConfigureRouterShellCommand;
   
   public class ApplicationStartupCommand extends SimpleFabricationCommand
   {
      
      public function ApplicationStartupCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         registerCommand(RouterNotification.RECEIVED_MESSAGE_VIA_ROUTER,RouteMessageCommand);
         registerCommand(RouterNotification.SEND_MESSAGE_VIA_ROUTER,RouteNotificationCommand);
         executeCommand(ConfigureRouterShellCommand,null,param1);
      }
   }
}
