package com.letv.plugins.kernel.model.special
{
   import flash.utils.describeType;
   
   public class BaseClone extends Object
   {
      
      private var classStructure:XMLList;
      
      public function BaseClone()
      {
         super();
      }
      
      protected function cloneByClass(param1:Class, param2:Object) : Object
      {
         var _loc4_:XML = null;
         var _loc5_:String = null;
         if(this.classStructure == null)
         {
            this.classStructure = describeType(param1).factory[0].variable;
         }
         var _loc3_:Object = {};
         for each(_loc4_ in this.classStructure)
         {
            _loc5_ = _loc4_.@name;
            if(_loc5_ != "classStructure")
            {
               _loc3_[_loc5_] = param2[_loc5_];
            }
         }
         return _loc3_;
      }
   }
}
