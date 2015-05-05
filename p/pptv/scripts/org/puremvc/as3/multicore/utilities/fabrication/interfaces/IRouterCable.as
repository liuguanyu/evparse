package org.puremvc.as3.multicore.utilities.fabrication.interfaces
{
   public interface IRouterCable extends IDisposable
   {
      
      function getInput() : INamedPipeFitting;
      
      function getOutput() : INamedPipeFitting;
   }
}
