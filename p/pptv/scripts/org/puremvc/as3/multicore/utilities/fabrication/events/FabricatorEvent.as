package org.puremvc.as3.multicore.utilities.fabrication.events
{
   import flash.events.Event;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
   
   public class FabricatorEvent extends Event implements IDisposable
   {
      
      public static const FABRICATION_CREATED:String = "fabricationCreated";
      
      public static const FABRICATION_REMOVED:String = "fabricationRemoved";
      
      public function FabricatorEvent(param1:String)
      {
         super(param1);
      }
      
      public function dispose() : void
      {
      }
   }
}
