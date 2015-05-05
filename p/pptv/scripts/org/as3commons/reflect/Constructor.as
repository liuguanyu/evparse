package org.as3commons.reflect
{
   public class Constructor extends Object
   {
      
      private var _declaringType:Type;
      
      private var _parameters:Array;
      
      public function Constructor(param1:Type, param2:Array = null)
      {
         _parameters = [];
         super();
         if(param2 != null)
         {
            this._parameters = param2;
         }
         this._declaringType = param1;
      }
      
      public function get declaringType() : Type
      {
         return this._declaringType;
      }
      
      public function get parameters() : Array
      {
         return this._parameters;
      }
      
      public function hasNoArguments() : Boolean
      {
         return this._parameters.length == 0?true:false;
      }
   }
}
