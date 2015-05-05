package org.puremvc.as3.multicore.utilities.fabrication.interfaces
{
   import org.puremvc.as3.multicore.interfaces.ICommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public interface IUndoableCommand extends ICommand, IDisposable
   {
      
      function initializeUndoableCommand(param1:INotification) : void;
      
      function getNotification() : INotification;
      
      function unexecute(param1:INotification) : void;
      
      function merge(param1:IUndoableCommand) : Boolean;
      
      function getDescription() : String;
      
      function getPresentationName() : String;
      
      function getUndoPresentationName() : String;
      
      function getRedoPresentationName() : String;
   }
}
