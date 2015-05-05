package org.puremvc.as3.multicore.utilities.fabrication.plumbing
{
   import org.puremvc.as3.multicore.utilities.pipes.plumbing.Pipe;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.INamedPipeFitting;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
   import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
   
   public class NamedPipe extends Pipe implements INamedPipeFitting, IDisposable
   {
      
      protected var name:String;
      
      protected var _moduleGroup:String = null;
      
      public function NamedPipe(param1:String = null, param2:IPipeFitting = null)
      {
         super(param2);
         this.setName(param1);
      }
      
      public function getName() : String
      {
         return this.name;
      }
      
      public function setName(param1:String) : void
      {
         this.name = param1;
      }
      
      public function get moduleGroup() : String
      {
         return this._moduleGroup;
      }
      
      public function set moduleGroup(param1:String) : void
      {
         this._moduleGroup = param1;
      }
      
      public function dispose() : void
      {
         this.name = null;
         this._moduleGroup = null;
         disconnect();
      }
   }
}
