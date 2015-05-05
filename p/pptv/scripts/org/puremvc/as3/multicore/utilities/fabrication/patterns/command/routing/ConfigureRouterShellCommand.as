package org.puremvc.as3.multicore.utilities.fabrication.patterns.command.routing
{
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.utilities.fabrication.routing.firewall.MultiRuleFirewall;
   import org.puremvc.as3.multicore.utilities.fabrication.routing.firewall.ReservedNotificationRule;
   import org.puremvc.as3.multicore.utilities.fabrication.routing.Router;
   
   public class ConfigureRouterShellCommand extends SimpleFabricationCommand
   {
      
      public function ConfigureRouterShellCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:MultiRuleFirewall = new MultiRuleFirewall();
         var _loc3_:ReservedNotificationRule = new ReservedNotificationRule();
         _loc2_.addRule(_loc3_);
         fabrication.router = new Router();
         executeCommand(ConfigureRouterCommand,fabrication.router);
         fabrication.router.install(_loc2_);
         fabrication.defaultRoute = "*";
      }
   }
}
