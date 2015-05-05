package org.puremvc.as3.multicore.utilities.pipes.interfaces
{
   public interface IPipeFitting
   {
      
      function connect(param1:IPipeFitting) : Boolean;
      
      function disconnect() : IPipeFitting;
      
      function write(param1:IPipeMessage) : Boolean;
   }
}
