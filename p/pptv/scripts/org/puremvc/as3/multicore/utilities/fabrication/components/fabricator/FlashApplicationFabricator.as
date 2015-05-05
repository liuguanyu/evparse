package org.puremvc.as3.multicore.utilities.fabrication.components.fabricator
{
   import flash.events.Event;
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.observer.FabricationNotification;
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.startup.ApplicationStartupCommand;
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.startup.ModuleStartupCommand;
   import org.puremvc.as3.multicore.utilities.fabrication.components.FlashApplication;
   
   public class FlashApplicationFabricator extends ApplicationFabricator
   {
      
      public function FlashApplicationFabricator(param1:FlashApplication)
      {
         super(param1);
      }
      
      override protected function get readyEventName() : String
      {
         return Event.ADDED_TO_STAGE;
      }
      
      override protected function initializeEnvironment() : void
      {
         if(router == null)
         {
            facade.registerCommand(FabricationNotification.STARTUP,ApplicationStartupCommand);
         }
         else
         {
            facade.registerCommand(FabricationNotification.STARTUP,ModuleStartupCommand);
         }
      }
   }
}
