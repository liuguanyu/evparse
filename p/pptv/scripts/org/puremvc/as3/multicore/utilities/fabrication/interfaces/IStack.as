package org.puremvc.as3.multicore.utilities.fabrication.interfaces
{
   public interface IStack extends IDisposable
   {
      
      function push(param1:Object) : void;
      
      function peek() : Object;
      
      function pop() : Object;
      
      function clear() : void;
      
      function isEmpty() : Boolean;
      
      function length() : int;
   }
}
