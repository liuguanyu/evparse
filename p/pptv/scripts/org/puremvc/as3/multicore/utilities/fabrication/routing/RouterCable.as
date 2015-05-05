package org.puremvc.as3.multicore.utilities.fabrication.routing
{
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterCable;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.INamedPipeFitting;
   
   public class RouterCable extends Object implements IRouterCable
   {
      
      private var input:INamedPipeFitting;
      
      private var output:INamedPipeFitting;
      
      public function RouterCable(param1:INamedPipeFitting, param2:INamedPipeFitting)
      {
         super();
         this.input = param1;
         this.output = param2;
      }
      
      public function dispose() : void
      {
         this.input = null;
         this.output = null;
      }
      
      public function getInput() : INamedPipeFitting
      {
         return this.input;
      }
      
      public function getOutput() : INamedPipeFitting
      {
         return this.output;
      }
   }
}
