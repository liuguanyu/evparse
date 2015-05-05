package org.puremvc.as3.multicore.utilities.pipes.plumbing
{
   import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
   import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
   
   public class PipeListener extends Object implements IPipeFitting
   {
      
      private var listener:Function;
      
      private var context:Object;
      
      public function PipeListener(param1:Object, param2:Function)
      {
         super();
         this.context = param1;
         this.listener = param2;
      }
      
      public function write(param1:IPipeMessage) : Boolean
      {
         listener.apply(context,[param1]);
         return true;
      }
      
      public function connect(param1:IPipeFitting) : Boolean
      {
         return false;
      }
      
      public function disconnect() : IPipeFitting
      {
         return null;
      }
   }
}
