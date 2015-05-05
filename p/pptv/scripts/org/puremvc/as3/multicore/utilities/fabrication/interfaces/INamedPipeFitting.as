package org.puremvc.as3.multicore.utilities.fabrication.interfaces
{
   import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
   
   public interface INamedPipeFitting extends IPipeFitting
   {
      
      function getName() : String;
      
      function setName(param1:String) : void;
      
      function get moduleGroup() : String;
      
      function set moduleGroup(param1:String) : void;
   }
}
