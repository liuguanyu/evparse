package org.puremvc.as3.multicore.utilities.fabrication.utils
{
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IStack;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
   
   public class Stack extends Object implements IStack
   {
      
      protected var elements:Array;
      
      public function Stack()
      {
         super();
         this.elements = new Array();
      }
      
      public function dispose() : void
      {
         this.clear();
         this.elements = null;
      }
      
      public function push(param1:Object) : void
      {
         this.elements.push(param1);
      }
      
      public function peek() : Object
      {
         return this.elements[this.length() - 1];
      }
      
      public function pop() : Object
      {
         var _loc1_:Object = this.peek();
         this.elements.pop();
         return _loc1_;
      }
      
      public function clear() : void
      {
         var _loc2_:Object = null;
         var _loc1_:int = this.elements.length;
         var _loc3_:* = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_ = this.elements[_loc3_];
            if(_loc2_ is IDisposable)
            {
               (_loc2_ as IDisposable).dispose();
            }
            _loc3_++;
         }
         this.elements.splice(0);
      }
      
      public function isEmpty() : Boolean
      {
         return this.length() == 0;
      }
      
      public function length() : int
      {
         return this.elements.length;
      }
      
      public function getElements() : Array
      {
         return this.elements.slice();
      }
   }
}
