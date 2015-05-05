package org.puremvc.as3.multicore.utilities.fabrication.utils
{
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IHashMap;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
   
   public class HashMap extends Object implements IHashMap
   {
      
      protected var elements:Object;
      
      public function HashMap()
      {
         super();
         this.elements = new Object();
      }
      
      public function dispose() : void
      {
         var _loc1_:Object = null;
         var _loc2_:String = null;
         for(_loc2_ in this.elements)
         {
            _loc1_ = this.elements[_loc2_];
            if(_loc1_ is IDisposable)
            {
               (_loc1_ as IDisposable).dispose();
            }
         }
         for(_loc2_ in this.elements)
         {
            _loc1_ = this.elements[_loc2_];
            this.elements[_loc2_] = null;
         }
         this.elements = null;
      }
      
      public function put(param1:String, param2:Object) : Object
      {
         this.elements[param1] = param2;
         return param2;
      }
      
      public function find(param1:String) : Object
      {
         return this.elements[param1];
      }
      
      public function exists(param1:String) : Boolean
      {
         return !(this.find(param1) == null);
      }
      
      public function remove(param1:String) : Object
      {
         var _loc2_:Object = this.find(param1);
         this.elements[param1] = null;
         delete this.elements[param1];
         true;
         return _loc2_;
      }
      
      public function clear() : void
      {
         this.elements = new Object();
      }
   }
}
