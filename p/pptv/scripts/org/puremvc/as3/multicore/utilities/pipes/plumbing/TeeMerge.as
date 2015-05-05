package org.puremvc.as3.multicore.utilities.pipes.plumbing
{
   import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
   
   public class TeeMerge extends Pipe
   {
      
      public function TeeMerge(param1:IPipeFitting = null, param2:IPipeFitting = null)
      {
         super();
         if(param1)
         {
            connectInput(param1);
         }
         if(param2)
         {
            connectInput(param2);
         }
      }
      
      public function connectInput(param1:IPipeFitting) : Boolean
      {
         return param1.connect(this);
      }
   }
}
