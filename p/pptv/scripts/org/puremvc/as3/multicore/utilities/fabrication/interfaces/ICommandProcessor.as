package org.puremvc.as3.multicore.utilities.fabrication.interfaces
{
   import org.puremvc.as3.multicore.interfaces.ICommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public interface ICommandProcessor
   {
      
      function executeCommand(param1:Class, param2:Object = null, param3:INotification = null) : ICommand;
   }
}
