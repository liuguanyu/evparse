package org.puremvc.as3.multicore.utilities.fabrication.patterns.command.undoable
{
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class FabricationUndoCommand extends SimpleFabricationCommand
   {
      
      public function FabricationUndoCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:* = 0;
         if(param1.getBody() == null)
         {
            fabFacade.undo();
         }
         else
         {
            _loc2_ = 1;
            if(!(param1.getBody() == null) && !isNaN(param1.getBody() as int))
            {
               _loc2_ = param1.getBody() as int;
            }
            fabFacade.undo(_loc2_);
         }
      }
   }
}
