package org.puremvc.as3.multicore.utilities.pipes.plumbing
{
   import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
   import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
   
   public class Pipe extends Object implements IPipeFitting
   {
      
      protected var output:IPipeFitting;
      
      public function Pipe(param1:IPipeFitting = null)
      {
         super();
         if(param1)
         {
            connect(param1);
         }
      }
      
      public function connect(param1:IPipeFitting) : Boolean
      {
         var _loc2_:* = false;
         if(this.output == null)
         {
            this.output = param1;
            _loc2_ = true;
         }
         return _loc2_;
      }
      
      public function disconnect() : IPipeFitting
      {
         var _loc1_:IPipeFitting = this.output;
         this.output = null;
         return _loc1_;
      }
      
      public function write(param1:IPipeMessage) : Boolean
      {
         return output.write(param1);
      }
   }
}
