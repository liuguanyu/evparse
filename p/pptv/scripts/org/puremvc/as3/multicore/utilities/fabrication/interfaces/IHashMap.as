package org.puremvc.as3.multicore.utilities.fabrication.interfaces
{
   public interface IHashMap extends IDisposable
   {
      
      function put(param1:String, param2:Object) : Object;
      
      function find(param1:String) : Object;
      
      function exists(param1:String) : Boolean;
      
      function remove(param1:String) : Object;
      
      function clear() : void;
   }
}
