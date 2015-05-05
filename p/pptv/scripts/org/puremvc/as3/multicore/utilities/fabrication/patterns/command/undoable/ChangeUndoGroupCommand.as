package org.puremvc.as3.multicore.utilities.fabrication.patterns.command.undoable
{
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ChangeUndoGroupCommand extends SimpleFabricationCommand
   {
      
      public function ChangeUndoGroupCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         fabFacade.fabricationController.groupID = param1.getBody() as String;
      }
   }
}
